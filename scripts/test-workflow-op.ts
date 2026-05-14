import { network } from "hardhat";

async function main() {
  console.log("🧪 Testing complete workflow using network.connect...");

  const { ethers } = await network.connect({
    network: "hardhatOp",
    chainType: "op",
  });

  const [deployer] = await ethers.getSigners();

  // Deploy contracts
  console.log("📦 Deploying all contracts on Optimism...");
  const Atnam = await ethers.getContractFactory("Atnam");
  const atnam = await Atnam.deploy();
  const MyNFT = await ethers.getContractFactory("MyNFT");
  const myNFT = await MyNFT.deploy(await atnam.getAddress());
  const MyERC1155 = await ethers.getContractFactory("MyERC1155");
  const myERC1155 = await MyERC1155.deploy(await myNFT.getAddress());

  console.log("✅ Contracts deployed on Optimism");

  // Test complete workflow WITH SETAPPROVEFORALL
  console.log("🔄 Testing token approval...");
  await atnam.approve(await myNFT.getAddress(), ethers.parseEther("100"));

  console.log("🎨 Testing NFT mint...");
  await myNFT.mint();


  console.log("🔐 Setting approval for ALL NFTs...");
  await myNFT.setApprovalForAll(await myERC1155.getAddress(), true);

  console.log("🛒 Testing item purchase...");
  await myERC1155.buyItem(1);

  console.log("🎉 COMPLETE WORKFLOW TEST SUCCESSFUL ON OPTIMISM!");
  console.log("Using setApprovalForAll - Industry Standard Approach ✅");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});