// function deployFunc() {
//     console.log("hi")
// }
// module.exports.default = deployFunc
//hre.getNamedAccounts
//hre.deployments
//hre object is the hardhat object
const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { network } = require("hardhat")
const { verify } = require("../utils/verify")
module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    const chanId = network.config.chainId
    let ethUsdPriceFeedAddress
    if (developmentChains.includes(network.name)) {
        const ethUsdAggregator = await deployments.get("MockV3Aggregator")
        ethUsdPriceFeedAddress = ethUsdAggregator.address
    } else {
        ethUsdPriceFeedAddress = networkConfig[chanId]["ethUsdPriceFeed"]
    }

    //if a contract doenst exist we deploy a version of it a
    //when working for localhost orhardhat we use mocking
    const args = [ethUsdPriceFeedAddress]
    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: args, //put pricefeed address
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    if (
        !developmentChains.includes(network.name) &&
        process.env.GOERLI_ETHERSCAN_APIKET
    ) {
        await verify(fundMe.address, args)
    }
    log("_____________________________________________")
}
module.exports.tags = ["all", "fundme"]
