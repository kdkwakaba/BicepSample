using '../main.bicep'

param virtualNetworkParam = {
  name: 'vnet-test'
  addressPrefixes: ['10.0.0.0/16']
  subnets: [
    {
      name: 'sub-vm'
      addressPrefix: '10.0.0.0/24'
    }
    {
      name: 'sub-db'
      addressPrefix: '10.0.1.0/24'
    }
    {
      name: 'sub-priv'
      addressPrefix: '10.0.2.0/24'
    }
  ]
}

param networkInterfaceParam = {
  name: 'nic-vm'
  ipConfigurations: [
      {
        name: 'ipconfig01'
      }
    ]
}
