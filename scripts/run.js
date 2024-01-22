const hre = require('hardhat');

const getAddress = async (signer) => {
    console.log(":::: tester/deploer address ::::",signer.address);
}

const getBalance = async (signer) => {
    const signerAddress = signer.address;
    const balance = await hre.ethers.provider.getBalance(signerAddress);
    const balanceInEth = hre.ethers.formatEther(balance);
    console.log(":::: tester/deployer Balance ::::", balanceInEth);
}


const main = async () => {

    const [deployer, tester1, tester2, tester3] = await hre.ethers.getSigners();

    getAddress(deployer);
    getBalance(deployer);

    const getContract = await hre.ethers.getContractFactory('Web3rsvp');
    const contract = await getContract.deploy();
    console.log('contract address -> ',contract.target);

    getAddress(deployer);
    //used await as due to txn deployemnt time 
    await getBalance(deployer);

    let deposit = hre.ethers.parseEther('1');
    let maxCapacity = 3;
    let timestamp = 1718926200;
    let eventDataCID = "bafybeibhwfzx6oo5rymsxmkdxpmkfwyvbjrrwcl7cekmbzlupmp5ypkyfi"; 

    let txn = await contract.createNewEvent(timestamp, deposit, maxCapacity, eventDataCID);
    const rec = await txn.wait(1);
    //console.log(rec);

    console.log('Event has been created with eventId ::::', rec.logs);
    const eventId = rec.logs[0].args[0];
    console.log(':::: eventId ::::',eventId);


    //connecting with the tester1 as a person
    const txn_1 = await contract.connect(tester1).createNewRsvps(eventId,{value: deposit});
    const rec_1 = await txn_1.wait(1);
    //console.log(rec_1);

    console.log('Event has been created on rsvp creation ::::', rec_1.logs);
    const addressOfPerson = rec_1.logs[0].args[1];
    console.log(':::: address of person ::::',addressOfPerson);
    

    //connecting with the tester2 as a person
    const txn_2 = await contract.connect(tester2).createNewRsvps(eventId, {value: deposit});
    const rec_2 = await txn_2.wait(1);
    //console.log(rec_2);

    console.log('Event has been created on rsvp creation ::::', rec_2.logs);
    const addressOfPerson_1 = rec_2.logs[0].args[1];
    console.log(':::: address of another person ::::',addressOfPerson_1);


    // wait 10 years
    await hre.network.provider.send("evm_increaseTime", [15778800000000]);

    //confirming the attendees
    const txn_3 = await contract.connect(deployer).attendPersonList(eventId, addressOfPerson_1);
    const rec_3 = await txn_3.wait(1);
    //console.log(rec_3);

    console.log('attendes of event ::::', rec_3.logs);
    const personsList = rec_2.logs[0].args[1];
    console.log(':::: address of persons list ::::',personsList);



    await getBalance(tester2);
    await getAddress(tester2);
    await getBalance(tester1);
    await getAddress(tester1);
    const txn_4 = await contract.connect(deployer).confirmAttendee(eventId);
    const rec_4 = await txn_4.wait(1);
    //console.log(rec_4);

    //console.log(':::: attendess ::::',rec_4.logs);
    const personsInfo = rec_4.logs[0].args;
    console.log(`::: eventid ${personsInfo[0]} while the address of attendee ${personsInfo[1]} and person's deposit ${hre.ethers.formatEther(personsInfo[2])}`);
    await getBalance(tester2)
    await getBalance(tester1);

    getBalance(deployer);
    const txn_5 = await contract.withdrawUnclaimedDeposits(eventId);
    const rec_5 = await txn_5.wait(1);
    //console.log(rec_5);
    await getBalance(deployer);
    await getBalance(tester1);
    await getBalance(tester2);

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