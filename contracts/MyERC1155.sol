// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyNft.sol";  // Apna ERC-721 NFT contract import kia - takay hum ERC-721 NFTs ko use kar saken payment ke liye

abstract contract ERC1155_Interface {
    // Yeh sab functions hain jo har ERC-1155 contract mein honay chahiye - jaise ek blueprint ya template
    function balanceOf(address account, uint256 id) public view virtual returns (uint256); // Kisi specific item ki quantity check karne ke liye

    // Yeh events hain jo transaction ki history track karte hain - jaise receipts
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value); // Jab ek item transfer ho
    event ApprovalForAll(address indexed account, address indexed operator, bool approved); // Jab kisi ko permission di jaye
}

contract MyERC1155 is ERC1155_Interface {
    string public name;  // Contract ka naam - jaise "Game Items"
    string public symbol;  // Contract ka symbol - jaise "GITM"
    
    // ERC-721 NFT contract ka instance (payment ke liye) - yeh woh contract hai jissey hum NFTs as payment accept karenge
    MyNFT public erc721Token;
    
    // Contract owner - jo is contract ko deploy karega woh owner ban jayega
    address public owner;
    
    // ERC-1155 item ki price (kitne ERC-721 NFTs required) - ek item ke liye kitne NFTs chahiye
    uint256 public itemPrice;
    
    mapping(uint256 => mapping(address => uint256)) private _balances; 
    mapping(address => mapping(address => bool)) private _operatorApprovals; // Kis user ne kisko permission di hai
    
    constructor(address _erc721TokenAddress) {
        name = "Game Items";  // Contract ka naam set kiya
        symbol = "GITM";  // Contract ka symbol set kiya
        erc721Token = MyNFT(_erc721TokenAddress);  // ERC-721 token contract se connect kiya
        owner = msg.sender;  // Jo deploy karega woh owner ban jayega
        itemPrice = 1;  // 1 ERC-721 NFT required for 1 ERC-1155 item - ek item ke liye ek NFT chahiye
    }
    
    // Modifier to check if caller is owner - yeh ensure karta hai ke sirf owner hi certain functions call kar sake
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this"); // Agar caller owner nahi hai to error
        _; // Original function continue karo
    }
    
    // Buy ERC-1155 item using ERC-721 NFT - ERC-721 NFT dekar ERC-1155 item khareedne ka function
    function buyItem(uint256 itemId) external returns (bool) {
        // Check if user ke pass ERC-721 NFT hai - user ke pass kitne NFTs hain
        uint256 nftBalance = erc721Token.balanceOf(msg.sender);
        require(nftBalance >= itemPrice, "Not enough ERC-721 NFTs for purchase"); // Agar enough NFTs nahi hain to error
        
        // Agr ha to user ka pehla NFT find karo - user ke pass jo pehla NFT hai uska ID find karo
        uint256 userNFTId = _findUserNFT(msg.sender);
        require(userNFTId != 0, "No ERC-721 NFT found"); // Agar koi NFT nahi mila to error
        
        // ERC-721 NFT user se contract mein transfer karo - user ka NFT contract ke pass transfer karo
        erc721Token.transferFrom(msg.sender, address(this), userNFTId);
        
        // ERC-1155 item user ko do - user ko naya item do
        _balances[itemId][msg.sender] += 1;
        
        // Event emit karo takay sabko pata chaley ke naya item ban gaya
        emit TransferSingle(msg.sender, address(0), msg.sender, itemId, 1);
        return true; // Success return karo
    }
    
    // User ka pehla NFT find karne ka internal function - yeh function sirf contract ke andar use ho sakta hai
    function _findUserNFT(address user) internal view returns (uint256) {
        // Simple implementation - first owned NFT return karta hai - user ke pass jo pehla NFT milega usko return karega
        for (uint256 i = 1; i <= 1000; i++) { // 1 se 1000 tak check karega
            try erc721Token.ownerOf(i) returns (address nftOwner) { // NFT owner check karo
                if (nftOwner == user) { // Agar yeh NFT user ke pass hai
                    return i; // To is NFT ka ID return karo
                }
            } catch { // Agar error aaye (jaise NFT exist nahi karta)
                continue; // To agla NFT check karo
            }
        }
        return 0; // Agar koi NFT nahi mila to 0 return karo
    }
        
    // Kisi user ke pass specific item kitna hai check karne ka function
    function balanceOf(address account, uint256 id) public view override returns (uint256) {
        require(account != address(0), "ERC1155: balance query for the zero address"); // Zero address check
        return _balances[id][account]; // Balance return karo
    }
    
    
    // Item ki price change karne ka function - owner function
    function setItemPrice(uint256 newPrice) external onlyOwner {
        itemPrice = newPrice; // Nayi price set karo
    }
}