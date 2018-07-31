pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/ownership/NoOwner.sol';
import './Managed.sol';
import './Asset.sol';

// Needs gas opti
contract Notarizer is Ownable, Managed, Asset, NoOwner {

Donation[] public donations;
Badge[] public badges;

  struct Donation {
    string description;
    uint128 goal;
    uint128 raised;
    address beneficiary;
  }

  struct Badge {
    uint64 donationId;
    uint128 amount;
    address donor;
  }

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

  function _createDonation(
    string _description,
    uint128 _goal,
    address _beneficiary
  )
    internal
    returns (uint256)
  {
    Donation memory _donation = Donation({
      description: _description,
      goal: _goal,
      raised: 0,
      beneficiary: _beneficiary
    });

    uint256 newDonationId = donations.push(_donation);
    return newDonationId;
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

  function _makeDonation(uint64 _donationId, uint128 _amount, address _donor)
    internal
    returns (uint256)
  {
    Badge memory _badge = Badge({
      donationId: _donationId,
      amount: _amount,
      donor: _donor
    });

    uint256 newBadgeId = badges.push(_badge);

    _mint(msg.sender, newBadgeId);

    donations[_donationId].raised += _amount;
    donations[_donationId].beneficiary.transfer(_amount);
    return newBadgeId;
  }
}