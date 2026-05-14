# Smart Contract Interaction Basics

## Project Overview

This project demonstrates a complete token ecosystem with three interconnected smart contracts:

1. **ERC-20 Token (Atnam)** — Custom cryptocurrency
2. **ERC-721 NFT Collection (MyNFT)** — Digital collectibles
3. **ERC-1155 Game Items (MyERC1155)** — In-game assets

---

## Contract Details

### 1. ATNAM (ERC-20 Token)
- **Name:** Atnam Token
- **Symbol:** ATN
- **Decimals:** 18
- **Total Supply:** 10,000 ATN
- **Features:** Standard ERC-20 implementation with transfers, approvals, and allowances

### 2. MYNFT (ERC-721 NFT Collection)
- **Name:** MyNFT Collection
- **Symbol:** MNFT
- **Mint Price:** 100 ATN tokens
- **Features:** ERC-721 compliant NFTs with ownership tracking and approvals

### 3. MYERC1155 (ERC-1155 Game Items)
- **Name:** Game Items
- **Symbol:** GITM
- **Item Price:** 1 ERC-721 NFT
- **Features:** Multi-token standard supporting both fungible and non-fungible assets

---

## Workflow Demonstrated

1. **Token Creation** — Mint ERC-20 tokens (Atnam)
2. **Cross-Contract Purchase** — Buy ERC-721 NFTs using ERC-20 tokens
3. **Advanced Interaction** — Buy ERC-1155 items using ERC-721 NFTs
4. **Contract-to-Contract Calls** — Multiple contracts interacting seamlessly
5. **Approval Mechanisms** — Both ERC-20 and ERC-721 approval systems

---

## Key Functions

### ERC-20 — `Atnam.sol`
| Function | Description |
|---|---|
| `approve(spender, amount)` | Grant token spending permission |
| `transferFrom(from, to, amount)` | Transfer tokens on behalf |
| `balanceOf(account)` | Check token balance |

### ERC-721 — `MyNFT.sol`
| Function | Description |
|---|---|
| `mint()` | Purchase NFT with ATN tokens |
| `setApprovalForAll(operator, approved)` | Grant NFT management rights |
| `transferFrom(from, to, tokenId)` | Transfer NFT ownership |

### ERC-1155 — `MyERC1155.sol`
| Function | Description |
|---|---|
| `buyItem(itemId)` | Purchase item with ERC-721 NFT |
| `balanceOf(account, id)` | Check item balance |
| `transferFrom(from, to, id, amount)` | Transfer items |

---

## Deployment Instructions

1. Deploy `Atnam.sol` (ERC-20 Token)
2. Deploy `MyNFT.sol` with Atnam contract address
3. Deploy `MyERC1155.sol` with MyNFT contract address

---

## Usage Sequence

1. User approves MyNFT contract to spend ATN tokens
2. User calls `mint()` on MyNFT to purchase NFT
3. User approves MyERC1155 contract to manage NFTs
4. User calls `buyItem()` on MyERC1155 to purchase items

---

## Technical Features

- Solidity `^0.8.0`
- Standard compliant implementations
- Event emissions for all transactions
- Proper error handling with `require` statements
- Inheritance-based architecture

---

## Testing

All contracts tested on **Remix IDE** with JavaScript VM:
- Successful token transfers
- Cross-contract interactions
- Approval workflows
- Error condition handling

---

## References

- [ERC-20 Token Standard](https://ethereum.org/developers/docs/standards/tokens/erc-20/)
- [ERC-20 Standard (EIP-20)](https://eips.ethereum.org/EIPS/eip-20)
- [ERC-721 Standard (EIP-721)](https://eips.ethereum.org/EIPS/eip-721)
- [ERC-1155 Standard (EIP-1155)](https://eips.ethereum.org/EIPS/eip-1155)
- How to create ERC-20 Smart Contracts — *Pepcoding (YouTube)*
- Mint NFT with ERC-20 tokens — *Shobhit (YouTube)*
- Write an ERC-721 NFT token from SCRATCH — *Atharva Deosthale*

---

## Files Included

| File | Description |
|---|---|
| `Atnam.sol` | ERC-20 Token Contract |
| `MyNFT.sol` | ERC-721 NFT Contract |
| `MyERC1155.sol` | ERC-1155 Items Contract |
| `README.md` | This file |

### Running Tests

To run all the tests in the project, execute the following command:

```shell
npx hardhat test
```

You can also selectively run the Solidity or `mocha` tests:

```shell
npx hardhat test solidity
npx hardhat test mocha
```

### Make a deployment to Sepolia

This project includes an example Ignition module to deploy the contract. You can deploy this module to a locally simulated chain or to Sepolia.

To run the deployment to a local chain:

```shell
npx hardhat ignition deploy ignition/modules/Counter.ts
```

To run the deployment to Sepolia, you need an account with funds to send the transaction. The provided Hardhat configuration includes a Configuration Variable called `SEPOLIA_PRIVATE_KEY`, which you can use to set the private key of the account you want to use.

You can set the `SEPOLIA_PRIVATE_KEY` variable using the `hardhat-keystore` plugin or by setting it as an environment variable.

To set the `SEPOLIA_PRIVATE_KEY` config variable using `hardhat-keystore`:

```shell
npx hardhat keystore set SEPOLIA_PRIVATE_KEY
```

After setting the variable, you can run the deployment with the Sepolia network:

```shell
npx hardhat ignition deploy --network sepolia ignition/modules/Counter.ts
```
