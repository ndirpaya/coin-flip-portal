const main = async () => {
    const coinFlipContractFactory = await hre.ethers.getContractFactory('CoinFlipPortal');
    const coinFlipContract = await coinFlipContractFactory.deploy({
        value: hre.ethers.utils.parseEther('1.0'),
    });
    await coinFlipContract.deployed();

    const [owner, randomPerson] = await hre.ethers.getSigners();

    console.log("Contract Address:", coinFlipContract.address);
    console.log("Contract deployed by:", owner.address);

    /**
     *  Get contract balance
     **/
    let contractBalance = await hre.ethers.provider.getBalance(coinFlipContract.address);
    console.log('Contract balance', hre.ethers.utils.formatEther(contractBalance));    

    let flipTxn = await coinFlipContract.flipCoin('A WISH!!!');
    await flipTxn.wait(); // wait for the transaction to be mined.

    contractBalance = await hre.ethers.provider.getBalance(coinFlipContract.address);
    console.log('Contract balance', hre.ethers.utils.formatEther(contractBalance));  

    flipTxn = await coinFlipContract.connect(randomPerson).flipCoin('Another Wish!!!');
    await flipTxn.wait();

    contractBalance = await hre.ethers.provider.getBalance(coinFlipContract.address);
    console.log('Contract balance', hre.ethers.utils.formatEther(contractBalance));    

    let flipCount = await coinFlipContract.getTotalFlips();
    console.log(flipCount.toNumber());

    let allFlips = await coinFlipContract.getAllFlips();
    console.log(allFlips);
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();