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
