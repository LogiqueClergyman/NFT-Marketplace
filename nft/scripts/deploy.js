const hre = require("hardhat");

async function main() {
  const Collection = await hre.ethers.deployContract(
    "contracts/Collection.sol:Collection"
  );
  const collection = await Collection.waitForDeployment();
  console.log("Deploying Contract...");
  console.log("Greeter deployed to:", await collection.getAddress()); //0x1a66D9e91A59d62ED9f5A6e43e4B019403c10d0d
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
