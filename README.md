# InPeak: Auditing a Smart Contract
![](./assets/hero-image-auditing-a-smart-contract.png)

Presented by: Brian H. Hough ([@BrianHHough](https://twitter.com/brianhhough))

Date: Thursday, February 23, 2023

# 🔍 In this Session:

With a global market cap of just under $1T USD, crypto has become the centre of attention for investors, entrepreneurs, institutions, and of course developers, but with the explosion of web3 adoption, a swarm of problems has come as well.

Certik's annual "State of DeFi Security" research report found that $1.3B was lost due to DeFi hacks in 2021, and $500 million was drained from Web3 platforms and users in this past quarter. Because smart contracts are open-sourced, anyone, with good or bad intentions, can access them.

﻿In this talk, Brian Hough is going to explain how several of these vulnerabilities have happened so far and share strategies and techniques for securing smart contracts that you can look out for. IMPORTANT: This is not a replacement for an audit or having your smart contracts reviewed by a professional — this is only for educational purposes and should not be considered as advice or advisement.
<br></br>
# 🪧 Slides:

https://user-images.githubusercontent.com/56947075/221074334-e16b7d33-4f42-4b2f-9241-4e1b0c583ab2.mp4

[![Vimeo Video](https://img.shields.io/badge/<SUBJECT>-VIMEO.com-<COLOR>.svg?color=15307B&label=View%20A%20Hi-Res%20Version%20On%20Vimeo%20Here&style=for-the-badge)](https://vimeo.com/801738054)

<br></br>

## **⛓ Smart Contract Examples:**
These are the contracts referenced in the workshop, and are also linked in the [contracts](./contracts) folder.
<br></br>

## 👨‍💻 Example 1: `ChangeStateInput.sol`

**❌ VULNERABLE**

```solidity
// SPDX-License-Identifier: MIT

// declare the version of solidity for the contract
pragma solidity >=0.4.26 <0.9.0;

// initialize a smart contract named "ChangeStateInput"
contract ChangeStateInput {
   // declare an unsigned integer variable "stateInput"
   uint256 stateInput;
 
   // function #1: public setter function to change 
   // variable "v" with what we input
   function set(uint256 v) public {
       stateInput = v;
   }
 
   // function #2: public getter function to return
   // value of "v" that was set or has yet to be set
   function get() public view returns (uint256) {
       return stateInput;
   }
}
```

**✅ UPDATED**
```solidity
// SPDX-License-Identifier: MIT

// declare the version of solidity for the contract
pragma solidity ^0.8.0;

// initialize a smart contract named "ChangeStateInput"
contract ChangeStateInputUpdated {
    // declare an unsigned integer variable "stateInput"
    uint256 stateInput;

    // declare an array of addresses for allowed users
    address[] allowed = [
        0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,
        0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c,
        0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
    ];

    // modifier to restrict function access to allowed addresses
    modifier onlyAllowed() {
        bool isAllowed = false;
        for (uint i = 0; i < allowed.length; i++) {
            if (allowed[i] == msg.sender) {
                isAllowed = true;
                break;
            }
        }
        require(isAllowed, "Only allowed addresses can access this function");
        _;
    }

    // function to add an address to the allowlist
    function addAllowed(address _address) public onlyAllowed {
        allowed.push(_address);
    }

    // function to remove an address from the allowlist
    function removeAllowed(address _address) public onlyAllowed {
        for (uint i = 0; i < allowed.length; i++) {
            if (allowed[i] == _address) {
                allowed[i] = allowed[allowed.length - 1];
                allowed.pop();
                break;
            }
        }
    } 

    // function #1: public setter function to change 
    // variable "v" with what we input
    function set(uint256 v) public onlyAllowed {
        stateInput = v;
    }

    // function #2: public getter function to return
    // value of "v" that was set or has yet to be set
    function get() public view returns (uint256) {
        return stateInput;
    }
}
```
<br></br>
## 👨‍💻 Example 2: `BankContract.sol` 

**❌ VULNERABLE**
```solidity
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
```

**✅ UPDATED**
```solidity
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
```

<br></br>
## 👨‍💻 Example 3: `TokenSaleContract.sol`

**❌ VULNERABLE**
```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TokenSaleContract {
  uint public totalTokens;

  function buyTokens(uint _numTokens) public payable {  
    require(msg.value == _numTokens * 1 ether, 
    	"Incorrect amount of ether sent");

    // Vulnerable code
    totalTokens += _numTokens;
  }
}
```

**✅ UPDATED**

```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TokenSaleContractUpdated {
  using SafeMath for uint256;

  uint256 public totalTokens;

  function buyTokens(uint256 _numTokens) public payable {
    require(msg.value == _numTokens.mul(1 ether), 
    	"Incorrect amount of ether sent");
 
    totalTokens = totalTokens.add(_numTokens);
  }
}
```

