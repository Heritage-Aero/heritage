pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol";
import "./DaiDonation.sol";


contract DonationCore is ERC721BasicToken, DaiDonation {
  // Soft cap of 4,294,967,295 (2^32-1)
  // E.g. Fill every block for ~50 years
  Donation[] public donations;

  // Tracking variables
  uint256 public totalDonationsCreated;
  uint256 public totalDonationsMade;
  uint256 public totalDonationsIssued;

  // Donation data mapping
  mapping (uint256 => string) public donationDescription;
  mapping (uint256 => string) public donationTaxId;
  mapping (uint256 => address) public donationBeneficiary;
  mapping (uint256 => uint256) public donationGoal;
  mapping (uint256 => uint256) public donationRaised;
  mapping (uint256 => bool) public donationClaimable;

  // Event logging
  event CreateDonation(string description, uint256 goal, address beneficiary, string taxId, address creator, bool claimable);
  event MakeDonation(uint256 donationId, uint256 amount, address donor, address sender);
  event IssueDonation(uint256 donationId, uint256 amount, address donor, address issuer);
  event DeleteDonation(uint256 donationId);

  // Donation struct
  struct Donation {
    uint32 donationId;  // 4 bytes
    uint128 amount;     // 16 bytes
    address donor;      // 20 bytes
  }

  // Returns the donation information
  function getDonation(uint256 _id) external view
    returns (
      uint256 _originalDonationId,
      uint256 _donationId,
      string _description,
      uint256 _goal,
      uint256 _raised,
      uint256 _amount,
      address _beneficiary,
      address _donor,
      string _taxId,
      bool _claimable
      ) {
        uint256 origId = donations[_id].donationId;

        _originalDonationId = origId;
        _donationId = _id;
        _description = donationDescription[origId];
        _goal = donationGoal[origId];
        _raised = donationRaised[origId];
        _amount = donations[_id].amount;
        _beneficiary = donationBeneficiary[origId];
        _donor = donations[_id].donor;
        _taxId = donationTaxId[origId];
        _claimable = donationClaimable[_id];
  }

  function _createDAIDonation(
    string _description,
    uint256 _goal,
    address _beneficiary,
    string _taxId,
    bool _claimable
  ) internal
    returns (uint256)
  {
    uint newDonationId = _createDonation(_description, _goal, _beneficiary, _taxId, _claimable);
    _trackDaiDonation(newDonationId);
    return newDonationId;
  }

  function _createDonation(
    string _description,
    uint256 _goal,
    address _beneficiary,
    string _taxId,
    bool _claimable
  )
    internal
    returns (uint256)
  {
    Donation memory _donation = Donation({
      donationId: uint32(donations.length),
      amount: 0,
      donor: address(0)
    });

    uint256 newDonationId = donations.push(_donation) - 1;
    _mint(msg.sender, newDonationId);

    donationDescription[newDonationId] = _description;
    donationBeneficiary[newDonationId] = _beneficiary;
    donationGoal[newDonationId] = _goal;
    donationTaxId[newDonationId] = _taxId;
    donationClaimable[newDonationId] = _claimable;

    totalDonationsCreated++;

    emit CreateDonation(_description, _goal, _beneficiary, _taxId, msg.sender, _claimable);
    return newDonationId;
  }

  function _makeDonation(uint256 _donationId, uint256 _amount, address _donor, bool mintToken)
    internal
    returns (uint256)
  {
    Donation memory _donation;
    // If the donation is marked as claimable, a future owner
    // may assign their address later.
    if (donationClaimable[_donationId]) {
       _donation = Donation({
        donationId: uint32(_donationId),
        amount: uint128(_amount),
        donor: address(0)
      });
    } else {
      _donation = Donation({
        donationId: uint32(_donationId),
        amount: uint128(_amount),
        donor: _donor
      });
    }

    uint256 newDonationId = donations.push(_donation) - 1;

    // Mark the new donation id claimable by the owner
    if (donationClaimable[_donationId]) {
      donationClaimable[newDonationId] = true;
    }

    // Minting an ERC-721 asset is optional
    if (mintToken) {
      _mint(_donor, newDonationId);
      totalDonationsMade++;
      emit MakeDonation(newDonationId, _amount, _donor, msg.sender);
    } else {
      totalDonationsIssued++;
      emit IssueDonation(_donationId, _amount, _donor, msg.sender);
    }

    return newDonationId;
  }

  function _claimDonation(address _donor, uint256 _donationId)
    internal
  {
    require(donationClaimable[_donationId] == true);
    require(donations[_donationId].donor == address(0));

    donations[_donationId].donor = _donor;

    donationClaimable[_donationId] = false;
  }

  function _deleteDonation(uint256 _donationId)
    internal
  {
    delete donations[_donationId];
    donationDescription[_donationId] = "";
    donationTaxId[_donationId] = "";
    donationBeneficiary[_donationId] = address(0);
    donationGoal[_donationId] = 0;
    donationRaised[_donationId] = 0;

    _burn(ownerOf(_donationId), _donationId);

    emit DeleteDonation(_donationId);
  }
}