// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IBank.sol";

contract Bank is IBank {
    address public admin;
    mapping(address => uint) public deposits;

    struct Rank {
        uint8 ranking;
        address user;
        uint256 amount;
    }

    Rank[3] public top3;

    constructor() {
        admin = msg.sender;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable virtual override {
        deposits[msg.sender] += msg.value;
        updateTop3(msg.sender, deposits[msg.sender]);
    }

    function withdraw(uint amount) public virtual override {
        require(msg.sender == admin, "You are not the Admin!");
        require(amount <= address(this).balance, "Insufficient balance in contract");
        payable(admin).transfer(amount);
    }

    function getDeposit(address user) public view virtual override returns (uint) {
        return deposits[user];
    }

    function updateTop3(address _user, uint _amount) internal {
        bool isInTop3 = false;
        for (uint i = 0; i < 3; i++) {
            if (top3[i].user == _user) {
                top3[i].amount = _amount;
                isInTop3 = true;
                break;
            }
        }

        if (!isInTop3) {
            for (uint i = 0; i < 3; i++) {
                if (_amount > top3[i].amount) {
                    for (uint j = 2; j > i; j--) {
                        top3[j] = top3[j - 1];
                    }
                    top3[i] = Rank(uint8(i + 1), _user, _amount);
                    break;
                }
            }
        }

        sortTop3();
    }

    function sortTop3() internal {
        for (uint i = 0; i < 2; i++) {
            for (uint j = i + 1; j < 3; j++) {
                if (top3[i].amount < top3[j].amount) {
                    Rank memory temp = top3[i];
                    top3[i] = top3[j];
                    top3[j] = temp;
                }
            }
        }

        for (uint i = 0; i < 3; i++) {
            top3[i].ranking = uint8(i + 1);
        }
    }

    function getTop3() public view returns (Rank[3] memory) {
        return top3;
    }
}