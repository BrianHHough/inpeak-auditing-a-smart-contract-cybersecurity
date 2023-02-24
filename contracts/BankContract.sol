// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract BankContract {
  mapping(address => uint) public balances;

  function deposit() public payable {
    balances[msg.sender] += msg.value;
  }

  function withdraw(uint _amount) public {
    require(balances[msg.sender] >= _amount, "Insufficient balance");

    // Vulnerable code
    (bool success,) = msg.sender.call{value: _amount}("");
    require(success, "Transfer failed");

    balances[msg.sender] -= _amount;
  }
}