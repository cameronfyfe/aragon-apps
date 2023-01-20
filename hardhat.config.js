require("@nomiclabs/hardhat-etherscan")
require("@nomiclabs/hardhat-ethers")
require("@aragon/hardhat-aragon")

const EVM_PRIVATE_KEY = process.env.EVM_PRIVATE_KEY || '';
const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY || '';

module.exports = {
  solidity: {
    version: "0.4.24",
    settings: {
      optimizer: {
        enabled: true,
        runs: 20000,
      },
    },
  },
  namedAccounts: {
    deployer: 0,
  },
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [EVM_PRIVATE_KEY]
    },
    wallaby: {
      url: "https://wallaby.node.glif.io/rpc/v0",
      accounts: [EVM_PRIVATE_KEY],
    },
    hyperspace: {
      chainId: 3141,
      url: "https://api.hyperspace.node.glif.io/rpc/v0",
      accounts: [EVM_PRIVATE_KEY],
    }
  },
  mocha: {
    timeout: 30000,
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  }
};
