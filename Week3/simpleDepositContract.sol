// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract simpleDepositContract {

    // emit an event when an end users deposits
    event depositEvent(address user, uint amount);
    

    // track individual balances
    mapping(address => uint) balances;

    // Collect funds here like deposit
    function Deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // returns the balance of a user in the pool
    function userBalance(address _user) external view returns(uint) {
        return balances[_user];
    }

    //  special receive function that receives eth and calls deposit()
    receive() external payable {
        Deposit();
        emit depositEvent(msg.sender, msg.value);
    }
    
    // allows a user to withdral only when the deadline is passed
    function withdraw() public {
        require(balances[msg.sender] > 0, "No deposit");
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(balances[msg.sender]);
    }


}