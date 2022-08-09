// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract increamentDecreament {

    // counter
    uint count = 1;

    uint256 deadline = block.timestamp + 30 seconds;

    modifier timer () {
        require (block.timestamp < deadline,  "deadline reached");
        _;
    }

    // increament
    function Add() public timer {
        count++;
    }

    // decreament
    function subtract() public timer {
        count--;
    }

    // return count
    function getCount() public timer view returns(uint) {
        return count;
    }
    
}
