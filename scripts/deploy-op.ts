import { network } from "hardhat";

async function main() {
  console.log("🚀 Starting deployment using network.connect...");

  // ✅ OP network use karnga (apny config ke hisaab se)
  const { ethers } = await network.connect({
    network: "hardhatOp",
    chainType: "op",
  });

  const [deployer] = await ethers.getSigners();
  console.log("Deployer address:", deployer.address);

  // Step 1: Deploy Atnam (ERC20)
  console.log("📦 Deploying Atnam ERC20 Token...");
  const Atnam = await ethers.getContractFactory("Atnam");
  const atnam = await Atnam.deploy();
  await atnam.waitForDeployment();
  const atnamAddress = await atnam.getAddress();
  console.log("✅ Atnam deployed to:", atnamAddress);

  // Step 2: Deploy MyNFT (ERC721) - Atnam address pass karo
  console.log("🎨 Deploying MyNFT ERC721 Contract...");
  const MyNFT = await ethers.getContractFactory("MyNFT");
  const myNFT = await MyNFT.deploy(atnamAddress);
  await myNFT.waitForDeployment();
  const myNFTAddress = await myNFT.getAddress();
  console.log("✅ MyNFT deployed to:", myNFTAddress);

  // Step 3: Deploy MyERC1155 (ERC1155) - MyNFT address pass karo
  console.log("🛒 Deploying MyERC1155 ERC1155 Contract...");
  const MyERC1155 = await ethers.getContractFactory("MyERC1155");
  const myERC1155 = await MyERC1155.deploy(myNFTAddress);
  await myERC1155.waitForDeployment();
  const myERC1155Address = await myERC1155.getAddress();
  console.log("✅ MyERC1155 deployed to:", myERC1155Address);

  console.log("\n🎉 ALL CONTRACTS DEPLOYED SUCCESSFULLY ON OPTIMISM!");
  console.log("===================================================");
  console.log("Atnam (ERC20):    ", atnamAddress);
  console.log("MyNFT (ERC721):   ", myNFTAddress);
  console.log("MyERC1155 (ERC1155):", myERC1155Address);

  return {
    atnam: atnamAddress,
    myNFT: myNFTAddress,
    myERC1155: myERC1155Address
  };
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});