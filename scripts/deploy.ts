
import { ethers } from "hardhat";

const token_address = "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC";
const rate = 10;
const duration = 120;

async function main() {

  const deploy_contract = await ethers.deployContract("SimpleDeFiLending", [token_address, rate, duration]);

  await deploy_contract.waitForDeployment();

  console.log("SimpleDeFiLending is deployed to : ",await deploy_contract.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
