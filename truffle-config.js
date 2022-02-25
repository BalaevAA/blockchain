const HDWalletProvider = require('truffle-hdwallet-provider');
const privateKey = '3ce1bf799d3466a7543c480aac3487b71e5f99025c10e4ecd02fd76edd586b1e'; // 
const endPoint = 'wss://ropsten.infura.io/ws/v3/2ff48d6057a440d398e3ffaf90d78a1f'; // infura

module.exports = {
    // Uncommenting the defaults below 
    // provides for an easier quick-start with Ganache.
    // You can also follow this format for other networks;
    // see <http://truffleframework.com/docs/advanced/configuration>
    // for more details on how to specify configuration options!
    //
    networks: {
        development: {
            host: "127.0.0.1",
            port: 7545,
            network_id: "*"
        },

        test: {
            host: "127.0.0.1",
            port: 8545,
            network_id: "*"
        }
        ,
        ropsten: {
            provider: function() {
                return new HDWalletProvider(
                    [privateKey],
                    endPoint
                )
            },
            gas: 5000000,
            gasPrice: 25000000000,
            network_id: 3        
        }
    },
    compilers: {
        solc: {
            version: "^0.6.0"
        }
    }
};