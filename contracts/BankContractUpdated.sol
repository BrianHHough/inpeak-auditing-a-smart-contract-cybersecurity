// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BankContractUpdated {

    // Create a mapping of addresses to balances
    mapping(address => uint) public balances;

    // Create an event for the Withdrawl action
    event Withdrawal(address indexed _from, uint _amount);

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // Fix: update balance first
        balances[msg.sender] -= _amount;

        // Fix: transfer funds second
        (bool success,) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");

        // Fix: emit event last
        emit Withdrawal(msg.sender, _amount);
    }
}