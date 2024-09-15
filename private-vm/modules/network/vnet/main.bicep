// define parameters and variables
@description('仮想ネットワークのリージョン')
param location string = resourceGroup().location

@description('仮想ネットワーク名')
param vnetName string

@description('アドレス空間')
param vnetAddressSpace array


@description('パブリックIPアドレス名')
param publicIpName string

@description('タグのキーと値')
param tagValue object

@description('パブリックIPアドレスのアイドルタイムアウト値')
@minValue(4)
@maxValue(100)
param idleTimeoutNumber int

@description('NAT Gateway名')
param natGatewayName string

// create route table

// create public ip address
resource publicIp 'Microsoft.Network/publicIPAddresses@2024-01-01' = {
  name: publicIpName
  location: location
  tags: tagValue
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: idleTimeoutNumber
  }
}



// create virtual network and subnet
resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressSpace
    }
    subnets: [
      {
        name: subnetname
        properties: {
          addressPrefix: vnetsubnetprefix
          natGateway: {
            id: natgateway.id
          }
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    enableDdosProtection: false
    enableVmProtection: false
  }
}

// create nat gateway
resource natgateway 'Microsoft.Network/natGateways@2024-01-01' = {
  parent: vnet
  name: natGatewayName
  location: location
  tags: tagValue
  sku: {
    name: 'Standard'
  }
  properties: {
    idleTimeoutInMinutes: idleTimeoutNumber
    publicIpAddresses: [
      {
        id: publicIp.id
      }
    ]
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  parent: vnet
  name: 'subnet-1'
  properties: {
    addressPrefix: vnetsubnetprefix
    natGateway: {
      id: natgateway.id
    }
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}



