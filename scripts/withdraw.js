const { getNamedAccounts, ethers } = require("hardhat")

async function main() {
    const { deployer } = await getNamedAccounts()
    const fundMe = await ethers.getContract("FundMe", deployer)
    let balance = await fundMe.provider.getBalance(fundMe.address)
    console.log(`Contract value before withdraw: ${balance}`)
    console.log(`Withdrawing from contract: ${fundMe.address}...`)
    const fndTxResponse = await fundMe.withdraw()
    await fndTxResponse.wait(1)
    console.log("withdrawed!")
    balance = await fundMe.provider.getBalance(fundMe.address)
    console.log(`Contract value after withdraw: ${balance}`)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
