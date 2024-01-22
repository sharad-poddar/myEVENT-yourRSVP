require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers:[{version: '0.8.20'}],
  },
  networks:{
    mumbai:{
      url: process.env.RPC_URL,
      accounts: [process.env.PRIVATE_KEY],
      gas: 2100000,
      gasPrice: 8000000000,
    },
  },
  etherscan: {
    apiKey: '5FGUSMNJJKMPAE44DBHDEPZYWXQ2AKJ4GZ',
  },
  sourcify: {
    enabled: true,
  }
};
