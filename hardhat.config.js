require("@nomicfoundation/hardhat-toolbox")
require("dotenv").config()
require("@nomiclabs/hardhat-etherscan")
require("hardhat-gas-reporter")
require("solidity-coverage")
require("hardhat-deploy")

/** @type import('hardhat/config').HardhatUserConfig */
const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL || ""
const GOERLI_RPC_PK = process.env.GOERLI_PRIVATE_KEY || ""
const GOERLI_ETHERSCAN_APIKET = process.env.GOERLI_ETHERSCAN_APIKET || ""
const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || ""

module.exports = {
    defaultNetwork: "hardhat",
    networks: {
        localhost: {
            url: "http://127.0.0.1:8545/",
            chainId: 31337,
        },
        goerli: {
            url: GOERLI_RPC_URL,
            accounts: [GOERLI_RPC_PK],
            chainId: 5,
            blockConfirmations: 6,
        },
    },
    etherscan: {
        // Your API key for Etherscan
        // Obtain one at https://etherscan.io/
        apiKey: GOERLI_ETHERSCAN_APIKET,
    },
    gasReporter: {
        enabled: true,
        outputFile: "gas-report.txt",
        noColors: true,
        currency: "USD",
        coinmarketcap: COINMARKETCAP_API_KEY,
        token: "MATIC",
    },
    solidity: {
        compilers: [{ version: "0.8.8" }, { version: "0.7.0" }],
    },
    namedAccounts: {
        deployer: {
            default: 0,
        },
        users: {
            defualt: 1,
        },
    },
}
