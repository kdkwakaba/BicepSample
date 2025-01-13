
module vnet 'br/public:avm/res/network/virtual-network:0.5.2' = {
  name: 'vnet-avmtest'
  params: {
    name: 'vnet-avmtest'
    addressPrefixes: ['10.0.0.0/16']
    subnets: [
      {
        name: 'sub-avmtest1'
        addressPrefix: '10.0.0.0/24'
      }
      {
        name: 'sub-avmtest2'
        addressPrefix: '10.0.1.0/24'
      }
    ]
  }
}

module nic 'br/public:avm/res/network/network-interface:0.4.0' = {
  name: 'nic-avmtest'
  params: {
    name: 'nic-avmtest'
    ipConfigurations: [
      {
        name: 'ipconfig01'
        subnetResourceId: vnet.outputs.subnetResourceIds[0]
      }
    ]
  }
}
