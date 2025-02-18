// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BaseERC20WithHook.sol";

contract TokenBankV2 is ITokenReceiver {
    BaseERC20WithHook public token;
    mapping(address => uint256) private balances;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    constructor(BaseERC20WithHook _token) {
        token = _token;
    }

    function tokensReceived(address from, uint256 amount) external override {
        require(msg.sender == address(token), "Unauthorized token");

        balances[from] += amount;
        emit Deposit(from, amount);
    }

    function deposit(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(token.transferFrom(msg.sender, address(this), amount), "Token transfer failed");

        balances[msg.sender] += amount;
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        require(token.transfer(msg.sender, amount), "Token transfer failed");

        emit Withdrawal(msg.sender, amount);
    }

    function balanceOf(address user) public view returns (uint256) {
        return balances[user];
    }
}