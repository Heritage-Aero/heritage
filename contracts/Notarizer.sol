pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/lifecycle/Pausable.sol';
import 'zeppelin-solidity/contracts/lifecycle/Destructible.sol';
import 'zeppelin-solidity/contracts/ownership/NoOwner.sol';
import './Managed.sol';
import './DonationCore.sol';

// Needs gas opti
contract Notarizer is Ownable, NoOwner, Pausable, Destructible, Managed, DonationCore {

  constructor() public payable {
    require(msg.value == 0);

    _createDonation("Genesis Donation", 0, this, "");
  }

  function createDonation(
    string _description,
    uint128 _goal,
    address _beneficiary,
    string _taxId
  )
    public
    onlyManagers
    whenNotPaused
    returns (uint256)
  {
    require(donations.length < 4294967296 - 1); // 2^32-1
    return _createDonation(_description, _goal, _beneficiary, _taxId);
  }

  function makeDonation(uint32 _donationId)
    public
    payable
    whenNotPaused
    returns (uint256)
  {
    // Must make a donation
    require(msg.value > 0);
    // Cannot donate to Genesis
    require(_donationId > 0);
    // Must donate to an existing donation
    require(_donationId < donations.length);
    // 2^32-1
    require(donations.length < 4294967296 - 1);
    // Lookup the original donation
    uint32 donationId = donations[_donationId].donationId;

    // A goal of 0 is uncapped
    if (donationGoal[donationId] > 0) {
      // It must not have reached it's goal
      require(donationRaised[donationId] < donationGoal[donationId]);
    }

    uint128 amount = uint128(msg.value);
    // Donate through another person's donation
    if (donationId != _donationId) {
      donationRaised[_donationId] += amount;
    }
    // Send the tx value to the charity
    donationBeneficiary[donationId].transfer(amount);
    // Update the amount raised for the donation
    donationRaised[donationId] += amount;
    // Update the total amount the contract has raised
    totalRaised += amount;

    return _makeDonation(donationId, amount);
  }
}