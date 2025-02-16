// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Bank.sol";

contract BigBank is Bank {
    modifier onlyValidDeposit() {
        require(msg.value > 0.001 ether, "Deposit must be greater than 0.001 ether");
        _;
    }

    function deposit() public payable override onlyValidDeposit {
        super.deposit();
    }

    function transferAdmin(address newAdmin) public {
        require(msg.sender == admin, "Only admin can transfer admin rights");
        admin = newAdmin;
    }
}