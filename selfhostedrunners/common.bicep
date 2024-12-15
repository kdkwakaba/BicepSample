targetScope = 'subscription'

@description('Azureリソースのリージョン')
param location string

@description('リソースグループ名')
param resourceGroupName string

@description('環境名')
param environemtName string

@description('GitHub Actions self-hosted runnersのネットワークセキュリティグループ名')
param networkSecurityGroupName string

@description('GitHub Actions self-hosted runnersのセキュリティルール')
param runnersNetworkSecurityRules array

@description('仮想ネットワーク名')
param virtualNetworkName string

@description('仮想ネットワークのアドレス空間')
param virtualNetworkAddressPrefix string

@description('GitHub Actions self-hosted runnersのサブネット名')
param runnersSubnetName string

@description('GitHub Actions self-hosted runnersのサブネットのアドレス空間')
param runnersSubnetAddressPrefix string

@description('Azure Bastionのサブネットのアドレス空間')
param bastionSubnetAddressPrefix string

@description('Azure Bastion名')
param bastionName string

@description('Azure BastionのSKU名')
param bastionSkuName string

//@description('Azure BastionのパブリックIPアドレス名')
//param bastionPublicIpAddresName string

@description('仮想マシン名')
param virtualMachineName string

@description('仮想マシンの管理者ユーザー名')
param adminUserName string

@secure()
@description('仮想マシンの管理者パスワード。Bicep実行時に設定する')
param adminUserPassword string

@description('仮想マシンのネットワークインターフェース')
param virtualNetworkInterfaceName string

@description('仮想マシンのネットワークインターフェースのプライベートIPアドレス')
param virtualNetworkInterfacePrivateIpAddress string

@description('初期設定用のcloud-init')
var virtualMachineCustomData = loadTextContent('cloud-init/common.txt')

// リソースグループの作成
module rg 'br/public:avm/res/resources/resource-group:0.4.0' = {

  name: resourceGroupName
  params: {
    name: resourceGroupName
    location: location
    tags: {
      environment: environemtName
    }
  }
}

// NSGの作成
module nsg 'br/public:avm/res/network/network-security-group:0.5.0' = {
  scope: resourceGroup(resourceGroupName)
  name: networkSecurityGroupName
  dependsOn: [
    rg
  ]
  params: {
    name: networkSecurityGroupName
    securityRules: runnersNetworkSecurityRules
    tags: {
      environment: environemtName
    }
  }
}

// 仮想ネットワークの作成
module vnet 'br/public:avm/res/network/virtual-network:0.5.1' = {
  scope: resourceGroup(resourceGroupName)
  name: virtualNetworkName
  dependsOn: [
    rg
  ]
  params: {
    name: virtualNetworkName
    addressPrefixes: [
      virtualNetworkAddressPrefix
    ]
    subnets: [
      {
        name: runnersSubnetName
        addressPrefix: runnersSubnetAddressPrefix
      }
      {
        name: 'AzureBastionSubnet'
        addressPrefix: bastionSubnetAddressPrefix
      }
    ]
    tags: {
      environment: environemtName
    }
  }
}

resource existingVirtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  scope: resourceGroup(resourceGroupName)
  name: virtualNetworkName

  resource subnet 'subnets@2024-05-01' existing = {
    name: runnersSubnetName
  }
}

// Azure Bastionの作成
module bastion 'br/public:avm/res/network/bastion-host:0.5.0' = {
  scope: resourceGroup(resourceGroupName)
  name: bastionName
  dependsOn: [
    rg
  ]
  params: {
    name: bastionName
    skuName: bastionSkuName
    virtualNetworkResourceId: vnet.outputs.resourceId
    tags: {
      environment: environemtName
    }

  }
}

// GitHub Actions self-hosted runners用仮想マシンの作成
module selfhostedrunnersvm 'br/public:avm/res/compute/virtual-machine:0.10.1' = {
  scope: resourceGroup(resourceGroupName)
  name: virtualMachineName
  dependsOn: [
    rg
    vnet
  ]
  params: {
    name: virtualMachineName
    adminUsername: adminUserName
    adminPassword: adminUserPassword
    customData: virtualMachineCustomData
    imageReference: {
      offer: 'ubuntu-24_04-lts'
      publisher: 'canonical'
      sku: 'server'
      version: 'latest'
    }
    nicConfigurations: [
      {
        name: virtualNetworkInterfaceName
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: existingVirtualNetwork::subnet.id
            privateIPAddress: virtualNetworkInterfacePrivateIpAddress
          }
        ]
        nicSuffix: ''
      }
    ]
    osDisk: {
      caching: 'ReadWrite'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType:'Standard_LRS'
      }
    }
    osType: 'Linux'
    vmSize: 'Standard_D2s_v3'
    securityType: ''
    encryptionAtHost: false
    zone: 0
    tags: {
      environment: environemtName
    }
  }
}
