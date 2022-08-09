// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
    

contract AMUTransfer is ERC20("Amarachi Marycynthia Ugwu", "AMU")  {
    
    address owner;
    uint amount = 10000e18;

    constructor() {
        owner = msg.sender;
        _mint(address(this), amount);
    }

    // AMU token amount to send to buyer

    function send(address _address, uint _amount) external {
        require(msg.sender == owner, "Not owner");

        uint balance = balanceOf(address(this));
        require(balance >= _amount, "Insufficient funds in contract");

        _transfer(address(this), _address, _amount);
    }
    
}