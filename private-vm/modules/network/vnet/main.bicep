// define parameters and variables

// create route table


// create virtual network and subnet
resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  
}

module natgateway '../nat/main.bicep' = {
  name: 'nat-test'
  
}
