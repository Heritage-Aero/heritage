require('babel-register');
require('babel-polyfill');

module.exports = {
  solc: {
    optimizer: {
      enabled: true,
      runs: 2500
    }
  },
  networks: {
    livenet: {
      host: 'localhost',
      port: 8545,
      gas: 8003929,
      network_id: '*' // Match any network id
    },
    development: {
      host: 'localhost',
      port: 18545,
      gas: 8003929,
      network_id: '*' // Match any network id
    },
    ropsten: {
      host: 'localhost',
      port: 18545,
      network_id: 3, // official id of the ropsten network
      gas: 8003929
    },
    testnet: {
      host: '144.202.123.40',
      port: 9546,
      network_id: 313, // official id of the A^3 network
      gas: 8003929
    }
  },
  rpc: {
    host: "8.9.4.146",
    port: 9546
  }
};
