pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol';

contract DonationCore is ERC721BasicToken {
  // Soft cap of 4,294,967,295 (2^32-1)
  Donation[] public donations;
  uint128 public totalRaised;
  uint128 public totalDonations;
  uint128 public totalIssued;

  mapping (uint32 => string) public donationDescription;
  mapping (uint32 => string) public donationTaxId;
  mapping (uint32 => address) public donationBeneficiary;
  mapping (uint32 => uint128) public donationGoal;
  mapping (uint32 => uint128) public donationRaised;

  struct Donation {
    uint32 donationId;  // 4 bytes
    uint128 amount;     // 16 bytes
    address donor;      // 20 bytes
  }

  function _createDonation(
    string _description,
    uint128 _goal,
    address _beneficiary,
    string _taxId
  )
    internal
    returns (uint256)
  {
    Donation memory _donation = Donation({
      donationId: uint32(donations.length),
      amount: 0,
      donor: address(0)
    });

    uint32 newDonationId = uint32(donations.push(_donation) - 1);
    _mint(msg.sender, newDonationId);

    donationDescription[newDonationId] = _description;
    donationBeneficiary[newDonationId] = _beneficiary;
    donationGoal[newDonationId] = _goal;
    donationTaxId[newDonationId] = _taxId;

    return newDonationId;
  }

  function _makeDonation(uint32 _donationId, uint128 _amount, address _donor)
    internal
    returns (uint256)
  {
    Donation memory _donation = Donation({
      donationId: _donationId,
      amount: _amount,
      donor: _donor
    });

    uint32 newDonationId = uint32(donations.push(_donation) - 1);
    _mint(_donor, newDonationId);
    totalDonations++;
    return newDonationId;
  }

  function _issueDonation(uint32 _donationId, uint128 _amount, address _donor)
    internal
    returns (uint256)
  {
    Donation memory _donation = Donation({
      donationId: _donationId,
      amount: _amount,
      donor: _donor
    });

    uint32 newDonationId = uint32(donations.push(_donation) - 1);
    totalIssued++;
    return newDonationId;
  }


  function name() external pure returns (string _name) {
    _name = "Heritage";
  }

  function symbol() external pure returns (string _symbol) {
    _symbol = "A^3";
  }

  function getDonation(uint32 _id) external view
    returns (
      uint32 _originalDonationId,
      uint32 _donationId,
      string _description,
      uint128 _goal,
      uint128 _raised,
      uint128 _amount,
      address _beneficiary,
      address _donor,
      string _taxId
      ) {

        uint32 donationId = donations[_id].donationId;

        _originalDonationId = donationId;
        _donationId = _id;
        _description = donationDescription[donationId];
        _goal = donationGoal[donationId];
        _raised = donationRaised[donationId];
        _amount = donations[_id].amount;
        _beneficiary = donationBeneficiary[donationId];
        _donor = donations[_id].donor;
        _taxId = donationTaxId[donationId];
  }

  function totalDonationsCreated() external view returns (uint256 _totalDonations) {
    _totalDonations = donations.length - totalDonations;
  }

  function totalDonationsMade() external view returns (uint256 _totalDonations) {
    _totalDonations = totalDonations;
  }

  function totalDonationsIssued() external view returns (uint256 _totalDonations) {
    _totalDonations = totalIssued;
  }
}