//Hr Nft k ps aik unique id hota ha jo usko identify krta ha
//Hr nft apny owner k address sy associated hota ha
//Hr nft k ps kuch metadata hota ha jo uski properties ko define krta ha jisko hum tokenuri b kehty hen
//Jb hum nft transfer krty hen to owner change hojata simple

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Atnam.sol";  // Apna ERC20 token ka contract import kia

abstract contract ERC721_Interface {
    //standard functions of ERC-721
    function balanceOf(address owner) public view virtual returns (uint256 balance);
    function ownerOf(uint256 tokenId) public view virtual returns (address owner);
    function transferFrom(address from, address to, uint256 tokenId) public virtual;
    function approve(address to, uint256 tokenId) public virtual;
    function setApprovalForAll(address operator, bool approved) public virtual;
    function isApprovedForAll(address owner, address operator) public view virtual returns (bool);
    
    function mint() external virtual returns (uint256);
    
    //standard events of ERC-721
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
}

contract MyNFT is ERC721_Interface {
    string public name;
    string public symbol;
    
    uint256 private _nextTokenId;
    uint256 public mintPrice;
    Atnam public atnamToken;
    address public owner;
    
    // ERC-721 Standard mappings
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals; // ✅ ADDED FOR SETAPPROVEFORALL
    
    constructor(address _atnamTokenAddress) {
        name = "MyNFT Collection";
        symbol = "MNFT";
        mintPrice = 100 * 10**18;
        atnamToken = Atnam(_atnamTokenAddress);
        owner = msg.sender;
        _nextTokenId = 1;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    // Buy/Mint NFT using ATN tokens
    function mint() external override returns (uint256) {
        uint256 allowed = atnamToken.allowance(msg.sender, address(this));
        require(allowed >= mintPrice, "Not enough allowance for NFT purchase");
        
        uint256 userBalance = atnamToken.balanceOf(msg.sender);
        require(userBalance >= mintPrice, "Not enough ATN tokens");
        
        bool success = atnamToken.transferFrom(msg.sender, address(this), mintPrice);
        require(success, "Token transfer failed");
        
        uint256 tokenId = _nextTokenId;
        _owners[tokenId] = msg.sender;
        _balances[msg.sender]++;
        _nextTokenId++;
        
        emit Transfer(address(0), msg.sender, tokenId);
        return tokenId;
    }

    // ERC-721 Standard functions
    function balanceOf(address _owner) public view override returns (uint256) {
        require(_owner != address(0), "ERC721: balance query for the zero address");
        return _balances[_owner];
    }

    function ownerOf(uint256 tokenId) public view override returns (address) {
        address tokenOwner = _owners[tokenId];
        require(tokenOwner != address(0), "ERC721: owner query for nonexistent token");
        return tokenOwner;
    }

    function transferFrom(address from, address to, uint256 tokenId) public override {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
        _transfer(from, to, tokenId);
    }

    function approve(address to, uint256 tokenId) public override {
        address tokenOwner = ownerOf(tokenId);
        require(to != tokenOwner, "ERC721: approval to current owner");
        _tokenApprovals[tokenId] = to;
        emit Approval(tokenOwner, to, tokenId);
    }

    // ✅ ADDED SETAPPROVEFORALL FUNCTION
    function setApprovalForAll(address operator, bool approved) public override {
        require(operator != msg.sender, "ERC721: approve to caller");
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    // ✅ ADDED ISAPPROVEDFORALL FUNCTION
    function isApprovedForAll(address _owner, address operator) public view override returns (bool) {
        return _operatorApprovals[_owner][operator];
    }

    // Internal functions for ERC-721 - ✅ UPDATED WITH OPERATOR SUPPORT
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_owners[tokenId] != address(0), "This token does not exist");
        address tokenOwner = _owners[tokenId];
        return (spender == tokenOwner || 
                _tokenApprovals[tokenId] == spender || 
                _operatorApprovals[tokenOwner][spender]); // ✅ ADDED OPERATOR CHECK
    }

    function _transfer(address from, address to, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");
        _approve(address(0), tokenId);
        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }

    function _approve(address to, uint256 tokenId) internal {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    function setMintPrice(uint256 _newPrice) external onlyOwner {
        mintPrice = _newPrice;
    }
}
// Reference:
// https://ethereum.org/en/developers/docs/standards/tokens/erc-721/
// Write an ERC-721 NFT token from SCRATCH - Solidity Smart Contract Tutorial! : Atharva Deosthale
//Function details: https://eips.ethereum.org/EIPS/eip-721