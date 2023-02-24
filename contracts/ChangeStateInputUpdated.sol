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