pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol";
import "./DaiDonation.sol";


contract DonationCore is ERC721BasicToken, DaiDonation {
  // Soft cap of 4,294,967,295 (2^32-1)
  // E.g. Fill every block for ~50 years
  Donation[] public donations;
  // Convenience array tracking fundraisers

  // Tracking variables
  uint256 public totalFundraisers;
  uint256 public totalDonationsMade;
  uint256 public totalDonationsIssued;

  // Donation data mapping
  mapping (uint256 => string) public fundraiserDescription;
  mapping (uint256 => string) public fundraiserTaxId;
  mapping (uint256 => address) public fundraiserBeneficiary;
  mapping (uint256 => uint256) public fundraiserRaised;

  // Event logging
  event CreateFundraiser(string description, address beneficiary, string taxId, address creator);
  event MakeDonation(uint256 donationId, uint256 amount, address donor, address sender);
  event IssueDonation(uint256 donationId, uint256 amount, address donor, address issuer);
  event DeleteFundraiser(uint256 fundraiserId);
  event DeleteDonation(uint256 donationId);

  // Donation struct
  struct Donation {
    uint128 fundraiserId;  // 16 bytes
    uint128 amount;     // 16 bytes
    address donor;      // 20 bytes
  }

  function getFundraiser(uint256 _id) external view
    returns (
      string _description,
      string _taxId,
      address _beneficiary,
      uint256 _raised
    ) {
      _description = fundraiserDescription[_id];
      _taxId = fundraiserTaxId[_id];
      _beneficiary = fundraiserBeneficiary[_id];
      _raised = fundraiserRaised[_id];
    }

  // Returns the donation information
  function getDonation(uint256 _id) external view
    returns (
      uint256 _fundraiserId,
      uint256 _donationId,
      string _description,
      uint256 _raised,
      uint256 _amount,
      address _beneficiary,
      address _donor,
      string _taxId
    ) {
      uint256 fundraiserId = donations[_id].fundraiserId;

      _fundraiserId = fundraiserId;
      _donationId = _id;
      _description = fundraiserDescription[fundraiserId];
      _raised = fundraiserRaised[fundraiserId];
      _amount = donations[_id].amount;
      _beneficiary = fundraiserBeneficiary[fundraiserId];
      _donor = donations[_id].donor;
      _taxId = fundraiserTaxId[fundraiserId];
  }

  function _createFundraiser(
    string _description,
    address _beneficiary,
    string _taxId
  )
    internal
    returns (uint256)
  {
    uint256 newFundraiserId = totalFundraisers;

    fundraiserDescription[newFundraiserId] = _description;
    fundraiserBeneficiary[newFundraiserId] = _beneficiary;
    fundraiserTaxId[newFundraiserId] = _taxId;


    totalFundraisers++;
    emit CreateFundraiser(_description, _beneficiary, _taxId, msg.sender);
    return newFundraiserId--;
  }

  function _makeDonation(uint256 _fundraiserId, uint256 _amount, address _donor, bool mintToken)
    internal
    returns (uint256)
  {
    Donation memory _donation;

    _donation = Donation({
      fundraiserId: uint128(_fundraiserId),
      amount: uint128(_amount),
      donor: _donor
    });

    uint256 newDonationId = donations.push(_donation) - 1;

    // Minting an ERC-721 asset is optional
    if (mintToken) {
      _mint(_donor, newDonationId);
      totalDonationsMade++;
      emit MakeDonation(newDonationId, _amount, _donor, msg.sender);
    } else {
      totalDonationsIssued++;
      emit IssueDonation(newDonationId, _amount, _donor, msg.sender);
    }

    return newDonationId;
  }

  function _deleteFundraiser(uint256 _fundraiserId)
    internal
  {
    fundraiserDescription[_fundraiserId] = "";
    fundraiserTaxId[_fundraiserId] = "";
    fundraiserBeneficiary[_fundraiserId] = address(0);
    fundraiserRaised[_fundraiserId] = 0;

    emit DeleteFundraiser(_fundraiserId);
  }

  function _deleteDonation(uint256 _donationId)
    internal
  {
    delete donations[_donationId];

    _burn(ownerOf(_donationId), _donationId);

    emit DeleteDonation(_donationId);
  }
}