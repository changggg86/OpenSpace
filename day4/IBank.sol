// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
    function getDeposit(address user) external view returns (uint);
}