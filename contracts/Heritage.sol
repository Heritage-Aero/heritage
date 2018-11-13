pragma solidity 0.4.24;


import "zeppelin-solidity/contracts/lifecycle/Destructible.sol";
import "./Managed.sol";
import "./DonationCore.sol";


contract Heritage is Destructible, Managed, DonationCore {
  uint256 constant MAX_DONATIONS = 2**128 - 1;
  bool public issueDonationEnabled = false;

  mapping (uint256 => bool) public isFiat;

  modifier issueDonationIsEnabled() {
    require(issueDonationEnabled);
    _;
  }

  modifier donationIdIsValid(uint256 _fundraiserId) {
    uint256 totalDonations = donations.length;
    // Cannot debelete Genesis
    require(_fundraiserId > 0);
    // Must be an existing donation
    require(_fundraiserId <= totalFundraisers);
    // 2^128-1
    require(totalDonations < MAX_DONATIONS);
    _;
  }

  modifier onlyTokenOwner(uint256 _donationId) {
    require(msg.sender == ownerOf(_donationId));
    _;
  }

  event ReclaimEther(uint256 balance);

  constructor(bool enableIssueDonation) public payable {
    require(msg.value == 0);

    issueDonationEnabled = enableIssueDonation;

    _createFundraiser("Genesis Fundraiser", address(0), "");
    _makeDonation(0, 0, 0, false);

  }

  // Do not accept any transactions that send Ether.
  function() external {
  }

  // Cannot prevent Ether from being mined/self-destructed to this contract
  // reclaim lost Ether.
  function reclaimEther() external onlyOwner {
    uint256 _balance = address(this).balance;

    owner.transfer(_balance);
    emit ReclaimEther(_balance);
  }

  function createFundraiser(
    string _description,
    address _beneficiary,
    string _taxId
  )
    public
    onlyManagers
    whenNotPaused
    returns (uint256)
  {
    require(donations.length < MAX_DONATIONS);
    return _createFundraiser(_description, _beneficiary, _taxId);
  }

  // Make a donation based on Id.
  // Donate directly.
  function makeDonation(uint256 _fundraiserId)
    public
    payable
    whenNotPaused
    donationIdIsValid(_fundraiserId)
    returns (uint256)
  {
    require(msg.value > 0);
    // Cannot donate to deleted token/null address
    require(fundraiserBeneficiary[_fundraiserId] != address(0));

    // Send the tx value to the charity
    fundraiserBeneficiary[_fundraiserId].transfer(msg.value);
    fundraiserRaised[_fundraiserId] += msg.value;
    return _makeDonation(_fundraiserId, msg.value, msg.sender, true);
  }

  // Make a DAI donation based on Id.
  function makeDAIDonation(uint256 _fundraiserId, uint256 _amount)
    public
    whenNotPaused
    donationIdIsValid(_fundraiserId)
    returns (uint256)
  {
    require(_amount > 0);
    // Cannot donate to deleted token/null address
    require(fundraiserBeneficiary[_fundraiserId] != address(0));

    // Send the tx value to the charity
    _transferDai(msg.sender, fundraiserBeneficiary[_fundraiserId], _amount);

    fundraiserDAIRaised[_fundraiserId] += _amount;
    totalDAIRaised += _amount;

    return _makeDonation(_fundraiserId, _amount, msg.sender, true);
  }

  // Managers may issue donations directly. A way to accept fiat donations
  // and credit an address. Optional -- disable/enable at deployment.
  // Does not effect contract totals. Must issue to a created donation.
  function issueDonation(uint256 _fundraiserId, uint256 _amount, address _donor)
    public
    onlyManagers
    issueDonationIsEnabled
    whenNotPaused
    donationIdIsValid(_fundraiserId)
    returns (uint256)
  {
    uint256 id = _makeDonation(_fundraiserId, _amount, _donor, false);
    isFiat[id];
    return id;
  }

  function deleteFundraiser(uint256 _fundraiserId)
    public
    onlyOwner
    whenNotPaused
    donationIdIsValid(_fundraiserId)
  {
    _deleteFundraiser(_fundraiserId);
  }

  function deleteDonation(uint256 _donationId)
    public
    onlyOwner
    whenNotPaused
    donationIdIsValid(_donationId)
  {
    _deleteDonation(_donationId);
  }
}