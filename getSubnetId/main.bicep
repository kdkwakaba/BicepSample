@description('Parameters for virtual network and subnets.')
param virtualNetworkParam object

@description('Parameters for network interface.')
param networkInterfaceParam object

// Create virtual network and three subnets
module vnet 'br/public:avm/res/network/virtual-network:0.5.2' = {
  name: virtualNetworkParam.name
  params: {
    name: virtualNetworkParam.name
    addressPrefixes: virtualNetworkParam.addressPrefixes
    subnets: virtualNetworkParam.subnets
  }
}

// Create a network interface for the virtual machine
module vmnic 'br/public:avm/res/network/network-interface:0.4.0' = {
  name: networkInterfaceParam.name
  params: {
    name: networkInterfaceParam.name
    ipConfigurations: [
      {
        name: networkInterfaceParam.ipConfigurations[0].name
        subnetResourceId: vnet.outputs.subnetResourceIds[indexOf(vnet.outputs.subnetNames, virtualNetworkParam.subnets[0].name)]
      }
    ]
  }
}
