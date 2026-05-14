// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

abstract contract ERC20_Interface {
// abstract contract is a template that guarantees certain functions will exist in any contract that uses it, without defining how those functions work.
//E.g Manager writing a job description for a cook, writing that the cook must be able to makeburgers(); without specifying how to make a burger.
//abstract function ha to virtual lgaya ha
//abstract function ka matlab hai: "Is function ka implementation nahi diya gaya hai, ye sirf ek declaration hai"
//virtual lagane ka matlab hai: "Ye function future me override ho sakta hai"
    function name() public view virtual returns (string memory);
    function symbol() public view virtual returns (string memory);
    function decimals() public view virtual returns (uint8);
    function totalSupply() public view virtual returns (uint256);
    function balanceOf(address _owner) public view virtual returns (uint256 balance);
    function transfer(address _to, uint256 _value) public virtual returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
    function approve(address _spender, uint256 _value) public virtual returns (bool success);
    function allowance(address _owner, address _spender) public view virtual returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract Atnam is ERC20_Interface {
    string public _name;
    string public _symbol;
    uint8 public _decimals;
    uint256 public _totalSupply;

    //koi b address kisi b address ko allowance de skta ha
    mapping(address => uint)  balances;
    mapping(address => mapping(address => uint)) allowances;

    constructor(){
        _name="Atnam Token";
        _symbol="ATN";
        _decimals=18;   //18 standard ha
        _totalSupply=10000 * (10 ** _decimals); //meri minimum value 10^18 tk jaegi
        balances[msg.sender]=_totalSupply; //owner ya jo bna rha ha ye smart contract usk ps sary coins ha
        emit Transfer(address(0), msg.sender, _totalSupply); //jab b coin bnta ha to Transfer event address(0) sy hota ha
    }
    //Returns the name of the token
    function name() public view override returns (string memory){
        return _name;
    }
    //Returns the symbol of the token
    function symbol() public view override returns (string memory){
        return _symbol;
    }
    //Returns the number of decimals the token uses
    function decimals() public view override returns (uint8){
        return _decimals;
    }
    //Returns the total token supply
    function totalSupply() public view override returns (uint256){
        return _totalSupply;
    }
    //Returns the account balance of another account with address _owner
    //owner ka balance dega
    function balanceOf(address _owner) public view override returns (uint256 balance){
        return balances[_owner];
    }
    
    function transfer(address _to, uint256 _value) public override returns (bool success){
        require(balances[msg.sender] >= _value, "Insufficient balance");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    //Transfers _value amount of tokens from address _from to address _to,
    //The transferFrom method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf
    //Kisi aur ki taraf se uske paise transfer karna
    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success){
        require(balances[_from] >= _value, "Insufficient balance");
        require(allowances[_from][msg.sender] >= _value, "Allowance exceeded");
        balances[_from] -= _value;
        balances[_to] += _value;
        allowances[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
    //If this function is called again it overwrites the current allowance with _value
    //Main(owner) isko apne paise kharch karne ki ijazat deta hoon
    function approve(address _spender, uint256 _value) public override returns (bool success){
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); //event emit krengy approval ka
        return true;
    }
    //Returns the amount which _spender is still allowed to withdraw from _owner
    //Yeh batata hai ki abhi tak kitna paisa kharch kar sakta ha
    function allowance(address _owner, address _spender) public view override returns (uint256 remaining){
        return allowances[_owner][_spender];
    }
}


//Youtube channel: Pepcoding
//ERC-20 Token Standard : https://ethereum.org/developers/docs/standards/tokens/erc-20/
//Mint nft with erc20 tokens: Shobhit youtube channel
//Functions details: https://eips.ethereum.org/EIPS/eip-20