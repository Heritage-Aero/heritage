pragma solidity ^0.4.24;

import "./Heritage.sol";


contract Factory {
  address[] public contracts;
  event CreateContract(address indexed contractAddress);

  function createContract(bool enableIssueDonation) public {
    Heritage newContract = new Heritage(enableIssueDonation);
    newContract.transferOwnership(msg.sender);
    contracts.push(newContract);
    emit CreateContract(newContract);
  }

  function totalContracts() public view returns(uint256) {
    return contracts.length;
  }
}