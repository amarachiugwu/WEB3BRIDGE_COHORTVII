// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Vault {
    // a contract where the owner creat grant for a beneficiary;
    // allow beneficiary to withdrawl only when time elapse
    // allow owner to withdrawl before elapse time
    // get information of a beneficiary
    // amount of ethers in the smart contract

    // ********** state variables **********/

    address public owner; // owner of our smart contract assigned in constructor()
    uint ID = 1; // unique id for creating beneficiaries increamented after every createGrant()

    // struct of details to be stored for our beneficiaries
    struct BeneficiaryProperties {
        uint amountAllocated;
        address beneficiary;
        uint time;
        bool status;
    }

    // container for our created beneficiaries
    mapping(uint => BeneficiaryProperties) public _beneficiaryProperties;

    // access control modifier 
    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    uint[] id; // array of ID of our beneficiaries 
    BeneficiaryProperties[] public bp; // array of struct BeneficiaryProperties ie our beneficiary details

    // this modifier ensures a beneficiary can only withdraw the grant when the time specified has passed
    modifier hasTimeElapsed(uint _id) {
        BeneficiaryProperties memory BP = _beneficiaryProperties[_id];
        require(block.timestamp >= BP.time, "time not elapsed");
        _;
    }


    // set the owner to the address that deploys the smart contract
    constructor() {
        owner = msg.sender;
    }

    // create beneficiaries to recieve grant from this contract
    // the amount a beneficiaries will recieve is the amount the owner of this contract calls this function with
    // msg.value cannot be zero
    function createGrant(address _beneficiary, uint _time) external payable onlyOwner returns(uint){
        require(msg.value > 0, "Zero deposit is not enough");
        BeneficiaryProperties storage BP = _beneficiaryProperties[ID];
        BP.amountAllocated = msg.value;
        BP.beneficiary = _beneficiary;
        BP.time = _time;
        uint _id = ID;
        id.push(_id);
        bp.push(BP);
        ID++;
        return _id;
    }


    // allows a user to withdraw the grant after time has elapsed
    // a user can withdraw all or part of his grant
    // reverts if a users withdrawal status is true
    function withdraw (uint _id, uint _amt) external hasTimeElapsed(_id){

        BeneficiaryProperties storage BP = _beneficiaryProperties[_id];
        address user = BP.beneficiary;
        require(user == msg.sender, "you are not a beneficiary for a grant");
        uint _amount = BP.amountAllocated;

        require(_amt > 0, "your withdrawal amount should be more than zero!");
        require(BP.status == false, "You don't have any money left in this vault");
        require(_amount > 0, "you  have no money!");
        require(_amt <= _amount, "Not enough balance");
        uint balance = BP.amountAllocated -= _amt;
        BP.amountAllocated = balance;

        if(balance == 0){
            BP.status = true;
        }

        uint getBal = getBalance();
        require(getBal > _amt);
        payable(msg.sender).transfer(_amt);
    }

    // gives an admin the pridviledge to reclaim or revert a bneficiaries grant
    // even before the elapse time
    function RevertGrant(uint _id) external onlyOwner {
        BeneficiaryProperties storage BP = _beneficiaryProperties[_id];
        uint _amount = BP.amountAllocated;
        BP.amountAllocated = 0;
        payable(owner).transfer(_amount);
    }

    // returns a particular beneficiaries record
    function returnBeneficiaryInfo(uint _id) external view returns(BeneficiaryProperties memory BP) {
        BP = _beneficiaryProperties[_id];
    }

    // get the balance of our contract or vault
    function getBalance() public view returns (uint256 bal){
        bal = address(this).balance;
    }

    // returns the whole records of all our beneficiaries for out grant
    function getAllBeneficiary() external view returns (BeneficiaryProperties[] memory _bp) {
        uint[] memory all = id;
        _bp = new BeneficiaryProperties[](all.length);

        for(uint i = 0; i < all.length; i++){
            _bp[i] = _beneficiaryProperties[all[i]];
        }
    }

}