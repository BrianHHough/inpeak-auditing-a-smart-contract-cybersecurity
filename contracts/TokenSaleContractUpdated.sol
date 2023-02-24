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