const main = async () => {
    const [deployer] = await hre.ethers.getSigners();
    const accountBalance = await deployer.getBalance();
  
    console.log("Deploying contracts with account: ", deployer.address);
    console.log("Account balance: ", accountBalance.toString());
  
    const claimContractFactory = await hre.ethers.getContractFactory("multiCall");
    const claimContract = await claimContractFactory.deploy();
    await claimContract.deployed();
  
    console.log("The contract address is ", claimContract.address);
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