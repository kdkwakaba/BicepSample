using '../service.bicep'

@description('Azureリソースのリージョン')
param location = 'japaneast'

@description('リソースグループ名')
param resourceGroupName = 'rg-production'

@description('環境名')
param environemtName = 'production'

@description('サービスのネットワークセキュリティグループ名')
param networkSecurityGroupName = 'nsg-production'

@description('サービスのセキュリティルール')
param serviceNetworkSecurityRules = [
  {
    name: 'AllowHTTPInbound'
    properties: {
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '80'
      sourceAddressPrefix: '*'
      destinationAddressPrefix: '*'
      access: 'Allow'
      priority: 200
      direction: 'Inbound'
      destinationAddressPrefixes: []
    }
  }
  {
    name: 'AllowSSHInbound'
    properties: {
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '22'
      sourceAddressPrefix: '*'
      destinationAddressPrefix: '172.16.0.4'
      access: 'Allow'
      priority: 300
      direction: 'Inbound'
      destinationAddressPrefixes: []
    }
  }
]

@description('仮想ネットワーク名')
param virtualNetworkName = 'vnet-production'

@description('仮想ネットワークのアドレス空間')
param virtualNetworkAddressPrefix = '10.0.0.0/16'

@description('サービスのサブネット名')
param serviceSubnetName = 'sub-service'

@description('サービスのサブネットのアドレス空間')
param serviceSubnetAddressPrefix = '10.0.0.0/24'

@description('仮想ネットワークピアリング名')
param serviceVirtualNetworkPeeringName = 'ServiceToRunner'

@description('仮想ネットワークピアリングの仮想ネットワーク')
param serviceVirtualNetworkPeeringDestination = '<仮想ネットワークのリソースID>'

@description('パブリックIPアドレス名')
param servicePublicIpAddressName = 'pip-production'

@description('仮想マシン名')
param virtualMachineName = 'vm-production'

@description('仮想マシンの管理者ユーザー名')
param adminUserName = 'azureuser'

@secure()
@description('仮想マシンの管理者パスワード')
param adminUserPassword = '<任意のパスワード>'

@description('仮想マシンのネットワークインターフェース')
param virtualNetworkInterfaceName = 'nic-production'

@description('仮想マシンのネットワークインターフェースのプライベートIPアドレス')
param virtualNetworkInterfacePrivateIpAddress = '10.0.0.4'

@description('仮想マシンのSSH公開鍵')
param virtualMachineSSHPublicKey = '<SSH公開鍵の文字列>'
