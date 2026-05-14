import { network } from "hardhat";

async function main() {
  console.log("🔗 Starting contract interactions using network.connect...");

  const { ethers } = await network.connect({
    network: "hardhatOp",
    chainType: "op",
  });

  const [deployer] = await ethers.getSigners();
  console.log("Using account:", deployer.address);

  // Deploy contracts
  console.log("📦 Deploying contracts first...");
  const Atnam = await ethers.getContractFactory("Atnam");
  const atnam = await Atnam.deploy();
  
  const MyNFT = await ethers.getContractFactory("MyNFT");
  const myNFT = await MyNFT.deploy(await atnam.getAddress());
  
  const MyERC1155 = await ethers.getContractFactory("MyERC1155");
  const myERC1155 = await MyERC1155.deploy(await myNFT.getAddress());

  console.log("✅ Contracts deployed on Optimism");

  // Interactions
  console.log("\n💰 STEP 1: Checking initial balances...");
  const initialATNBalance = await atnam.balanceOf(deployer.address);
  const initialNFTBalance = await myNFT.balanceOf(deployer.address);
  console.log("Initial ATN Balance:", initialATNBalance.toString());
  console.log("Initial NFT Balance:", initialNFTBalance.toString());

  console.log("\n🔄 STEP 2: Approving MyNFT to spend ATN tokens...");
  await atnam.approve(await myNFT.getAddress(), ethers.parseEther("100"));
  console.log("✅ Approved 100 ATN for MyNFT contract");

  console.log("\n🎨 STEP 3: Minting NFT with ATN tokens...");
  await myNFT.mint();
  console.log("✅ NFT minted successfully");

  console.log("\n📊 STEP 4: Checking balances after mint...");
  const afterMintATN = await atnam.balanceOf(deployer.address);
  const afterMintNFT = await myNFT.balanceOf(deployer.address);
  console.log("ATN Balance after mint:", afterMintATN.toString());
  console.log("NFT Balance after mint:", afterMintNFT.toString());

  console.log("\n🔐 STEP 4.5: Setting approval for ALL NFTs...");
  await myNFT.setApprovalForAll(await myERC1155.getAddress(), true);
  console.log("✅ Approved ERC1155 for ALL current and future NFTs");

  console.log("\n🛒 STEP 5: Buying ERC1155 item with NFT...");
  await myERC1155.buyItem(1);
  console.log("✅ ERC1155 item purchased successfully");

  console.log("\n📈 STEP 6: Checking final balances...");
  const finalATNBalance = await atnam.balanceOf(deployer.address);
  const finalNFTBalance = await myNFT.balanceOf(deployer.address);
  const finalItemBalance = await myERC1155.balanceOf(deployer.address, 1);

  console.log("\n🎯 FINAL BALANCE SUMMARY:");
  console.log("💰 ATN Tokens:", finalATNBalance.toString());
  console.log("🖼️ NFTs:", finalNFTBalance.toString());
  console.log("🎮 Game Items:", finalItemBalance.toString());

  console.log("\n✅ ALL INTERACTIONS COMPLETED SUCCESSFULLY ON OPTIMISM!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});