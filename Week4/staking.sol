// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract Staking {

    // emit an event when an end users stakes
    event Stake(address user, uint amount);
    
    // a deadline when passed allows end users to stake
    uint256 deadline = block.timestamp + 30 seconds;

    // track individual balances
    mapping(address => uint) balances;

    // Collect funds here like deposit
    function stake() public payable {
        balances[msg.sender] += msg.value;
    }

    // returns the balance of a user in the pool
    function userBalance(address _user) external view returns(uint) {
        return balances[_user];
    }

    //  special receive function that receives eth and calls stake()
    receive() external payable {
        stake();
        emit Stake(msg.sender, msg.value);
    }
    
    // allows a user to withdral only when the deadline is passed
    function withdraw() public {
        require(deadline < block.timestamp, "Deadline not exceeded"); 
        require(balances[msg.sender] > 0, "No stake");
        payable(msg.sender).transfer(balances[msg.sender]);
    }

    // function that returns the time left before the deadline
    function timeLeft () public view returns(uint t) {
        // t is automaticall returned
        // because it is initialized in the return block
        t = deadline - block.timestamp;
    }

}