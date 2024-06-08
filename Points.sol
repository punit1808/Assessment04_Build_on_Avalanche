// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2;

contract MY_ERC_Token {

    string public tokenName = "DEGEN";
    string public tokenSymbol = "DGN";
    uint private  tokenSupply = 10000;
    address private Owner;

    mapping(address => uint) private balance_atAddress;
    mapping(address => bool)  private isExist;

    event Transfer(address indexed from, address indexed to, uint value);
    event Mint(address indexed to, uint value);
    event Burn(address indexed from, uint value);
    event ValidateAccount(address indexed account);
    event Redeem(address indexed from, uint value);

    constructor(){
        Owner = msg.sender;
        balance_atAddress[Owner] += tokenSupply;
        isExist[Owner] = true;
    }

    modifier ownerAccess {
        require(Owner == msg.sender, "Only Owner can Access this Function.");
        _;
    }

    function validateAccount(address validAcc) public {
        isExist[validAcc] = true;
        emit ValidateAccount(validAcc);  // Emit event
    }

    function mint(address mintAt, uint mintValue) public ownerAccess {
        balance_atAddress[mintAt] += mintValue;
        tokenSupply += mintValue;
        emit Mint(mintAt, mintValue);  // Emit event
    }

    function burn(address burnFrom) public {
        require(isExist[burnFrom], "Account doesn't exist.");
        uint burnAmount = balance_atAddress[burnFrom];
        tokenSupply -= burnAmount;
        balance_atAddress[burnFrom] = 0;
        emit Burn(burnFrom, burnAmount);  // Emit event
    }

    function redeem(address redeemFrom, uint redeemValue) public {
        require(isExist[redeemFrom], "Account doesn't exist.");
        require(balance_atAddress[redeemFrom] >= redeemValue, "Insufficient Balance Balance");
        tokenSupply -= redeemValue;
        balance_atAddress[redeemFrom] -= redeemValue;
        emit Redeem(redeemFrom, redeemValue); // Emit event

    }

    function totalSupply() public view returns (uint) {
        return tokenSupply;
    }

    function balanceOf(address checkAt) public view returns (uint) {
        require(isExist[checkAt], "Account doesn't exist.");
        return balance_atAddress[checkAt];
    }

    function transfer(address transferAt, uint transferValue) public {
        require(isExist[transferAt], "Receiver Account doesn't exist.");
        require(balance_atAddress[msg.sender] >= transferValue, "Insufficient Account Balance");
        
        balance_atAddress[msg.sender] -= transferValue;
        balance_atAddress[transferAt] += transferValue;
        emit Transfer(msg.sender, transferAt, transferValue);  // Emit event
    }
}

