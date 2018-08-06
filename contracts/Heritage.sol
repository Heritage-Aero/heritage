pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "zeppelin-solidity/contracts/lifecycle/Destructible.sol";
import "zeppelin-solidity/contracts/ownership/NoOwner.sol";
import "./Managed.sol";
import "./DonationCore.sol";


contract Heritage is Ownable, NoOwner, Pausable, Destructible, Managed, DonationCore {
  bool public issueDonationEnabled = false;

  modifier issueDonationIsEnabled() {
    require(issueDonationEnabled);
    _;
  }

  constructor(bool enableIssueDonation) public payable {
    require(msg.value == 0);

    issueDonationEnabled = enableIssueDonation;

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

  // Make a donation based on Id.
  // Donate directly or proxy through another donation.
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

    // Cannot donate to deleted token/null address
    require(donationBeneficiary[donationId] != address(0));
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

    return _makeDonation(donationId, amount, msg.sender);
  }

  // Managers may issue donations directly. A way to accept fiat donations
  // and credit an address. Optional -- disable/enable at deployment.
  // Does not effect contract totals. Must issue to a created donation.
  function issueDonation(uint32 _donationId, uint128 _amount, address _donor)
    public
    onlyManagers
    issueDonationIsEnabled
    whenNotPaused
    returns (uint256)
  {
    // Cannot donate to Genesis
    require(_donationId > 0);
    // Must donate to an existing donation
    require(_donationId < donations.length);
    // 2^32-1
    require(donations.length < 4294967296 - 1);
    // Lookup the original donation
    uint32 donationId = donations[_donationId].donationId;

    return _issueDonation(donationId, _amount, _donor);
  }

  function deleteDonation(uint32 _donationId)
    public
    onlyOwner
  {
    // Cannot delete Genesis
    require(_donationId > 0);
    // Must delete an existing donation
    require(_donationId < donations.length);

    _deleteDonation(_donationId);
  }
}