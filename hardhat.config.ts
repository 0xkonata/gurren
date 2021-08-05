require('dotenv').config();

import 'tsconfig-paths/register';

import { task } from "hardhat/config";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-web3";
import "hardhat-tracer";
import "@nomiclabs/hardhat-solhint";
import "hardhat-deploy";
import "hardhat-deploy-ethers";
import "@eth-optimism/hardhat-ovm"
import "@nomiclabs/hardhat-etherscan";


task("foo")
.addParam("bar")
.setAction(async({ bar })=>{
});



/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.7.6",
        settings: {
          outputSelection: {
            "*": {
              "*": ["storageLayout"],
            },
          },
        },
      },
      {
        version: "0.8.0",
        settings: {
          outputSelection: {
            "*": {
              "*": ["storageLayout"],
            },
          },
        },
      },
      {
        version: "0.8.3",
        settings: {
          outputSelection: {
            "*": {
              "*": ["storageLayout"],
            },
          },
        },
      },
      {
        version: "0.8.4",
        settings: {
          outputSelection: {
            "*": {
              "*": ["storageLayout"],
            },
          },
        },
      }
    ]
  },
  networks: {
    kovan: {
      url: process.env.ALCHEMY_URL,
      accounts: [process.env.KOVAN_DEPLOYER_PRIVATE_KEY],
      live: true,
      saveDeployments: true,
      tags: ["staging"]
    },
    "optimistic-kovan": {
      url: process.env.KOVAN_OPTIMISTIC_URL,
      accounts: [process.env.KOVAN_DEPLOYER_PRIVATE_KEY],
      live: true,
      saveDeployments: true,
      tags: ["op-staging"],
      ovm: true
    }
  },
  ovm: {
    solcVersion: '0.7.6'
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  },
  namedAccounts: { deployer: 0 }
};