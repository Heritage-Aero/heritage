pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol';

contract DonationCore is ERC721BasicToken {
  // Soft cap of 4,294,967,295 (2^32-1)
  Donation[] public donations;
  uint128 public totalRaised;
  uint128 public totalDonations;

  mapping (uint32 => string) public donationDescription;
  mapping (uint32 => address) public donationBeneficiary;
  mapping (uint32 => uint128) public donationGoal;
  mapping (uint32 => uint128) public donationRaised;

  struct Donation {
    uint32 donationId;  // 4 bytes
    uint128 amount;     // 16 bytes
    address beneficiary;// 20 bytes
    string description; // <= 24 bytes (n bytes)
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
      donationId: uint32(donations.length),
      amount: 0,
      beneficiary: _beneficiary,
      description: _description
    });

    uint256 newDonationId = donations.push(_donation) - 1;
    _mint(_beneficiary, newDonationId);
    donationGoal[newDonationId] = _goal;

    return newDonationId;
  }

  function _makeDonation(uint32 _donationId, uint128 _amount)
    internal
    returns (uint256)
  {
    Donation memory _donation = Donation({
      donationId: _donationId,
      description: donations[_donationId].description,
      amount: _amount,
      beneficiary: donations[_donationId].beneficiary
    });

    uint256 newDonationId = donations.push(_donation) - 1;
    _mint(msg.sender, newDonationId);
    totalDonations++;
    return newDonationId;
  }


  function name() external pure returns (string _name) {
    _name = "Heritage";
  }

  function symbol() external pure returns (string _symbol) {
    _symbol = "A^3";
  }

  function totalDonationsMade() external view returns (uint256 _totalDonations) {
    _totalDonations = totalDonations;
  }
  function totalDonationsCreated() external view returns (uint256 _totalDonations) {
    _totalDonations = donations.length - totalDonations;
  }
}