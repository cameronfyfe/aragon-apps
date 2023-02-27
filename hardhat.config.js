require("@nomiclabs/hardhat-etherscan")
require("@nomiclabs/hardhat-ethers")
require("@eqty/hardhat-aragon")

const EVM_PRIVATE_KEY = process.env.EVM_PRIVATE_KEY || '0x0000000000000000000000000000000000000000';

const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL || '';
const HYPERSPACE_RPC_URL = process.env.HYPERSPACE_RPC_URL || '';
const MUMBAI_RPC_URL = process.env.MUMBAI_RPC_URL || '';

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
    localhost: {
      accounts: [EVM_PRIVATE_KEY]
    },
    goerli: {
      url: GOERLI_RPC_URL,
      accounts: [EVM_PRIVATE_KEY]
    },
    mumbai: {
      url: MUMBAI_RPC_URL,
      accounts: [EVM_PRIVATE_KEY],
    },
    hyperspace: {
      chainId: 3141,
      url: HYPERSPACE_RPC_URL,
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
