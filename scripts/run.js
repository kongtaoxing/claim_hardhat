const main = async () => {
    const [deployer] = await hre.ethers.getSigners();
    const accountBalance = await deployer.getBalance();

    console.log("Deploying contracts with account: ", deployer.address);
    console.log("Account balance: ", accountBalance.toString());
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const claimContractFactory = await hre.ethers.getContractFactory("multiCall");
    const claimContract = await claimContractFactory.deploy();
    await claimContract.deployed();
    console.log("Contract deployed to:", claimContract.address);
    console.log("Contract deployed by:", owner.address);

    await claimContract.getOwner();

    // const claimTxn = await claimContract.changeOwner('0x1F14c2F40400471FB4a3AEf1390F6BbBf2AD8F99');
    // await claimTxn.wait();

    await claimContract.getOwner();

    const secondClaimTxn = await claimContract.changeOwner(randomPerson.address);
    await secondClaimTxn.wait();

    await claimContract.getOwner();
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0); // exit Node process without error
    } catch (error) {
      console.log(error);
      process.exit(1); // exit Node process while indicating 'Uncaught Fatal Exception' error
    }
    // Read more about Node exit ('process.exit(num)') status codes here: https://stackoverflow.com/a/47163396/7974948
  };
  
  runMain();