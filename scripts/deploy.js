const main = async () => {
    const coinFlipContractFactory = await hre.ethers.getContractFactory('CoinFlipPortal');
    const coinFlipContract = await coinFlipContractFactory.deploy({
        value: hre.ethers.utils.parseEther('1.0'),
    });
    
    await coinFlipContract.deployed();

    console.log('CoinFlipPortal address: ', coinFlipContract.address);
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.error(error);
        process.exit(1);
    }
};

runMain();