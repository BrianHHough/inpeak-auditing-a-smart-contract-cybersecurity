# InPeak: Auditing a Smart Contract
![](./assets/Auditing_a_Smart_Contract-Twitter.png)

Presented by: Brian H. Hough ([@BrianHHough](https://twitter.com/brianhhough))

Date: Thursday, February 23, 2023

# 🔍 In this Session:

With a global market cap of just under $1T USD, crypto has become the centre of attention for investors, entrepreneurs, institutions, and of course developers, but with the explosion of web3 adoption, a swarm of problems has come as well.

Certik's annual "State of DeFi Security" research report found that $1.3B was lost due to DeFi hacks in 2021, and $500 million was drained from Web3 platforms and users in this past quarter. Because smart contracts are open-sourced, anyone, with good or bad intentions, can access them.

﻿In this talk, Brian Hough is going to explain how several of these vulnerabilities have happened so far and share strategies and techniques for securing smart contracts that you can look out for. 

IMPORTANT: This is not a replacement for an audit or having your smart contracts reviewed by a professional — this is only for educational purposes and should not be considered as advice or advisement.
<br></br>
# 🪧 Slides:

https://user-images.githubusercontent.com/56947075/221074334-e16b7d33-4f42-4b2f-9241-4e1b0c583ab2.mp4

[![Vimeo Video](https://img.shields.io/badge/<SUBJECT>-VIMEO.com-<COLOR>.svg?color=15307B&label=View%20A%20Hi-Res%20Version%20On%20Vimeo%20Here&style=for-the-badge)](https://vimeo.com/801738054)

<br></br>

# **🔒 Cybersecurity Primer:**

## OWASP Top 10
1. **A01:2021—Broken Access Control:** 
Attackers exploit flaws in an application's access control mechanisms to access functionality or data they should not be able to.
    - *<ins>Example</ins>: an attacker exploits weak passwords, session management, keys, or credentials*
2. **A02:2021—Cryptographic Failures (i.e. Insecure Cryptographic Storage):** 
A flaw in an application's use of encryption, such as storing sensitive data without proper encryption or using weak encryption algorithms, can result in the disclosure of sensitive information.
    * *<ins>Example</ins>: an attacker can decrypt (read) information that was thought to have been encrypted/hashed.*
3. **A03:2021—Injection (i.e. Cross-Site Scripts (XSS)):** Attackers send malicious input to an application in an attempt to execute unintended commands or access unauthorized data.
    - Example: an attacker runs a SQL injection or injects JS into a website viewed by other users, allowing the attacker to execute arbitrary code in victims' browsers.
4. **A04:2021—Insecure Design:** 
An application may have security flaws that arise from its design, such as allowing users to submit unvalidated data that can later be executed on the server-side, resulting in a code injection attack.
    * *<ins>Example</ins>: an attacker exploits a lack of proper authentication or authorization to gain access.*
5. **A05:2021—Security Misconfiguration:** 
Attackers exploit configuration weaknesses in an application or its supporting infrastructure to gain unauthorized access or disrupt service.
    * *<ins>Example</ins>: an attacker exploits default unchanged credentials or unsecure servers to gain access.*
6. **A06:2021—Vulnerable and Outdated Components:** 
Using outdated or vulnerable components in an application can leave it exposed to known security vulnerabilities, such as the use of outdated libraries or frameworks that have known security flaws.
    * *<ins>Example</ins>: an attacker exploits a vulnerability in a third-party component, such as an outdated version of a library, to gain access.*
7. **A07:2021—Identification & Authentication Failures (i.e. Broken Sesh Mgmt):** 
Attackers exploit weaknesses in the way an application manages user authentication and session information to gain unauthorized access.
    * *<ins>Example</ins>: An attacker exploits weaknesses in an application's identification and authentication mechanisms (i.e. guessing weak passwords or stealing authentication tokens).*
8. **A08:2021—Software & Data Integrity Failures (i.e. Insecure Deserialization):**
An application's assumptions about the integrity of software updates or critical data can lead to security vulnerabilities, such as a malicious actor modifying a critical file or executing arbitrary code through an insecure deserialization vulnerability. 
    * *<ins>Example</ins>: An attacker exploits a flaw in an application's software or data integrity checks to modify or delete sensitive data (i.e. changing the price of a product on an e-commerce site).*
9. **A09:2021—Security Logging & Monitoring Failures:** Insufficient logging and monitoring can make it difficult for organizations to detect and respond to security incidents, such as failing to log all relevant events or not having a process in place to review logs for potential threats.
    * *<ins>Example</ins>: An attacker is able to carry out a prolonged attack on an application because it lacks adequate logging and monitoring, allowing the attacker to remain undetected, such as not logging failed login attempts or not monitoring network traffic for signs of an attack.*
10. **A10:2021—Server-Side Request Forgery (SSRF):** Attackers can exploit flaws in an application's handling of requests to send requests from the server-side to other internal or external systems, potentially leading to unauthorized access or data leakage.
    * *<ins>Example</ins>: An attacker is able to access sensitive information or systems by exploiting a vulnerability in an application that allows them to send requests from the server to other internal or external systems.*



Learn More: [OWASP Top 10 (Updated 2021)](https://owasp.org/www-project-top-ten/ )


<br></br>
# **⛓ Smart Contract Examples:**
These are the contracts referenced in the workshop, and are also linked in the [contracts](./contracts) folder.
<br></br>

## 👨‍💻 Example 1: `ChangeStateInput.sol`

* **Vulnerabilities:** <span style="color:red">Improper Access Control →</span> A01:2021–Broken Access Control
* **Definition:** Unlimited or unrestricted access to a given function in a
 contract, as well as sensitive functionality or data.
* **Example:** The set() function used to change the number value of the 
given variable can be called by any wallet, meaning anyone 
has access to this specific function in the contract.

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

A01:2021—Broken Access Control: We fix this with:
* Broken Access Control: Implementing an allowlist will ensure in production, not everyone can access the set functionality.
* Gas Efficiency: By adding the “view” solidity modifier to the get function, it’s a read-only operation, allowing us to make sure our contract is as efficient as possible.
    * We already did this, but hey, it’s good to feel validated by our AI overlords sometimes 🙃

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

* **Vulnerabilities:** <span style="color:red">Reentrancy Attack →</span> A01:2021–Broken Access Control
* **Definition:** There is a lack of access control where the contract can call another contract’s function before the prior function reaches finality.
* **Example:** The `withdraw()` function can be called to transfer funds to another contract (i.e. one controlled by the attacker), and then that contract can call the `withdraw()` function again, to transfer more funds in a loop…thus draining the bank eventually.

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

A01:2021—Broken Access Control: We fix this with:
* (1.) updating the wallet’s balance in the contract
    * 🔒 This ensures the balance is always current (updated) before moving funds externally.
* (2.) transfering funds to the user 
* (3.) pushing an event to record the transfer of funds


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

* **Vulnerabilities:** <span style="color:red">Integer Overflow →</span> A03:2021—Injection (XSS)
* **Definition:** Similar to Cross-Site-Scripts (XSS) which are vulnerabilities in web apps, this is an exploit around input validation of a smart contract.
* **Example:** The `buyTokens()` function can be exploited where if the attacker sends a large integer value into the `_numTokens` value, the addition of `_numTokens` and `totalTokens` together could lead to an integer overflow… thereby making `totalTokens` very small.


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

A03:2021—Injection (XSS): We fix this with:
* (1.) importing the SafeMath library for secure comp.
    * 🔒 The addition of SafeMath is an OpenZeppelin library utility to do math calculations in a secure manner.
* (2.) update _numTokens to use safe multiply (.mul) by checking for overflow/underflow conditions.
* (3.) update the totalTokens value with _numTokens with safe add (.add) to check for overflow/underflow.

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

# 🔍 Intro to Audits:
What does an audit look like?

Uniswap's [v3-periphery audit by ABDK Consulting](https://github.com/Uniswap/v3-periphery/blob/main/audits/abdk/audit.pdf)
<br></br>
# 👨‍💻 Looking to get into web3 development?

## 📸 The Tech Stack Playbook YouTube Channel
Check out my **3-Hour Intro to Solidity and Web3 Development Course** on my YouTube channel, the Tech Stack Playbook, here:

<a href="https://youtu.be/il9s98lPGqY"><img src="https://img.shields.io/badge/-YouTube:%20Intro%20To%20Solidity%20And%20Web3%20Course-red?&style=for-the-badge&logo=youtube&logoColor=white"></a>
<br></br>

## 📚 My Kajabi Course Portal
Looking for a more module-by-module, online course format? Sign up for my free **3-Hour Intro to Solidity and Web3 Development Course** course on Kajabi here:

[![Intro to Solidity & Web3 Development Course (3 HOURS) Course Signup](https://img.shields.io/badge/<SUBJECT>-kajabi.com-<COLOR>.svg?color=15307B&label=Intro%20to%20Solidity%20Web3%20Course%20(3%20HOURS)&style=for-the-badge)](https://brianhhough.mykajabi.com/offers/UHUgQLhS/checkout)
<br></br>

## 📩 Email Newsletter
Sign up for my Tech Stack Playbook newsletter here:

[![Tech Stack Playbook Newsletter Form](https://img.shields.io/badge/<SUBJECT>-kajabi.com-<COLOR>.svg?color=15307B&label=Sign%20Up%20For%20My%20Free%20Newsletter&style=for-the-badge)](https://brianhhough.mykajabi.com/newsletter-signup)
<br></br>

## 👋 Say Hi
* Instagram: [@brianhhough](https://instagram.com/brianhhough)
* LinkedIn: [brianhhough](https://linkedin.com/in/brianhhough)
* TikTok: [@brianhhough](https://www.tiktok.com/@brianhhough)
