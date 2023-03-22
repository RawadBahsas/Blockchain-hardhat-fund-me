const { getNamedAccounts, ethers } = require("hardhat")

async function main() {
    const { deployer } = await getNamedAccounts()
    const fundMe = await ethers.getContract("FundMe", deployer)
    console.log("funding the contract...")
    const fndTxResponse = await fundMe.fund({
        value: ethers.utils.parseEther("60"),
    })
    await fndTxResponse.wait(1)
    console.log("funded!")
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
