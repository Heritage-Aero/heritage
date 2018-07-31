pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/ownership/NoOwner.sol';
import './Managed.sol';
import './Badge.sol';

// Needs gas opti
contract Notarizer is Ownable, Managed, Badge, NoOwner {

  constructor() public payable {
    require(msg.value == 0);

    _createDonation("Genesis Donation", 0, address(0));
    _makeDonation(0, 0, address(0));
  }

  function createDonation(
    string _description,
    uint128 _goal,
    address _beneficiary
  )
    onlyManagers
    public
    returns (uint256)
  {
    return _createDonation(_description, _goal, _beneficiary);
  }

  function makeDonation(uint64 _donationId)
    public
    payable
    returns (uint256)
  {
    require(msg.value > 0);
    // If the goal is 0 then donations are uncapped
    if (donations[_donationId].goal != 0) {
      require(donations[_donationId].raised < donations[_donationId].goal);
    }

    return _makeDonation(_donationId, uint128(msg.value), msg.sender);
  }
}