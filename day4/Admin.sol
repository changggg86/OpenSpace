// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IBank.sol";

contract Admin {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function adminWithdraw(IBank bank) public onlyOwner {
        uint balance = address(bank).balance;
        bank.withdraw(balance-100000);
        payable(owner).transfer(balance-100000);
    }
}