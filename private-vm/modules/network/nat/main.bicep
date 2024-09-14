@description('Azureリソースのリージョン。リソースグループのリージョンとする')
param location string = resourceGroup().location

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
