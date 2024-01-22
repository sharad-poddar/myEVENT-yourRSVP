const hre = require('hardhat');

const main = async () => {

    const getContract = await hre.ethers.getContractFactory('Web3rsvp');
    const contract = await getContract.deploy();
    await contract.wait;

    console.log(':::: deployed contract address ::::',contract.target);

    //verifying contract on etherscan
    // await hre.run("verify:verify", {
    //     address: contract.target,
    //     constructorArguments: [],
    //     contract: "contracts/web3rsvp.sol:Web3rsvp",
    // });
    
}


const runMain = async () => {
    try{
        await main();
        process.exit(0);
    }catch(error){
        console.log(error);
        process.exit(1);
    }
}

runMain();


// deployed contract address -> 0xf979DDAa680DFE05Ca9D76ffD4d7B6501d2D84eC
//  npx hardhat verify 0xf979DDAa680DFE05Ca9D76ffD4d7B6501d2D84eC --network mumbai 
// https://mumbai.polygonscan.com/address/0xf979DDAa680DFE05Ca9D76ffD4d7B6501d2D84eC#code
