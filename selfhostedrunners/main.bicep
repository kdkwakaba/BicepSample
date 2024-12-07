targetScope = 'subscription'

// リソースグループの作成
module rg 'br/public:avm/res/resources/resource-group:0.4.0' = {
  scope: subscription()
  name: 'rg-test'
  params: {
    name: 'rg-test'
    location: 'japanwest'
    tags: {
      hoge: 'fuga'
    }
  }
}

// NSGの作成
module nsg 'br/public:avm/res/network/network-security-group:0.5.0' = {
  scope: resourceGroup('rg-test')
  name: 'nsg-test'
  params: {
    name: 'nsg-test'
  }
}

// 仮想ネットワークの作成
module vnet 'br/public:avm/res/network/virtual-network:0.4.0' = {
  scope: resourceGroup('rg-test')
  name: 'vnet-test'
  params: {
    name: 'vnet-test2'
    addressPrefixes: [
      '10.0.0.0/16'
    ]
  }
}

// サブネットの作成
module subnet 'br/public:avm/res/network/virtual-network/subnet:0.5.0' = {
  
}

// パブリックIPアドレス、NAT Gatewayの作成


// GitHub Actions self-hosted runners用仮想マシンの作成


// ジョブ実行用仮想マシンの作成


