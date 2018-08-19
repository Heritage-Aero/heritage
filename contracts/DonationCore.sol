pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol";


// Todo
// Destroy Proxy once goal is met
contract Proxy {
  DonationCore donationCore;
  uint32 donationId;

  constructor(uint32 _donationId) public payable {
    require(msg.value == 0);

    donationId = _donationId;
    donationCore = DonationCore(msg.sender);
  }

  function() public payable {
    donationCore.proxyDonation.value(msg.value)(donationId, msg.sender);
  }
}


contract DonationCore is ERC721BasicToken {
  // Soft cap of 4,294,967,295 (2^32-1)
  // E.g. Fill every block for ~50 years
  Donation[] public donations;

  uint256 public totalRaised;
  uint256 public totalDonations;
  uint256 public totalIssued;

  mapping (uint256 => string) public donationDescription;
  mapping (uint256 => string) public donationTaxId;
  mapping (uint256 => address) public donationBeneficiary;
  mapping (uint256 => uint128) public donationGoal;
  mapping (uint256 => uint128) public donationRaised;

  mapping (address => bool) public isProxy;

  event CreateDonation(string description, uint256 goal, address beneficiary, string taxId, address creator);
  event MakeDonation(uint256 donationId, uint256 amount, address donor, address sender);
  event IssueDonation(uint256 donationId, uint256 amount, address donor, address issuer);
  event DeleteDonation(uint256 donationId);

  modifier onlyProxy() {
    require(isProxy[msg.sender]);
    _;
  }

  struct Donation {
    uint32 donationId;  // 4 bytes
    uint128 amount;     // 16 bytes
    address donor;      // 20 bytes
  }

  function name() external pure returns (string _name) {
    _name = "Heritage";
  }

  function symbol() external pure returns (string _symbol) {
    _symbol = "A^3";
  }

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
      string _taxId
      ) {
        Donation memory _donation = donations[_id];

        _originalDonationId = _donation.donationId;
        _donationId = _id;
        _description = donationDescription[_donation.donationId];
        _goal = donationGoal[_donation.donationId];
        _raised = donationRaised[_donation.donationId];
        _amount = donations[_id].amount;
        _beneficiary = donationBeneficiary[_donation.donationId];
        _donor = donations[_id].donor;
        _taxId = donationTaxId[_donation.donationId];
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

  function proxyDonation(
    uint256 _donationId,
    address _donor
  )
    public
    payable
    onlyProxy
  {
    _makeDonation(_donationId, uint128(msg.value), _donor);
  }

  function createDonationProxy(uint32 _donationId)
    public
    returns (address proxyAddress)
  {
    Proxy p = new Proxy(_donationId);
    isProxy[p] = true;
    return p;
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

    uint256 newDonationId = donations.push(_donation) - 1;
    _mint(msg.sender, newDonationId);

    donationDescription[newDonationId] = _description;
    donationBeneficiary[newDonationId] = _beneficiary;
    donationGoal[newDonationId] = _goal;
    donationTaxId[newDonationId] = _taxId;

    emit CreateDonation(_description, _goal, _beneficiary, _taxId, msg.sender);
    return newDonationId;
  }

  function _makeDonation(uint256 _donationId, uint256 _amount, address _donor)
    internal
    returns (uint256)
  {
    Donation memory _donation = Donation({
      donationId: uint32(_donationId),
      amount: uint128(_amount),
      donor: _donor
    });

    uint256 newDonationId = donations.push(_donation) - 1;
    _mint(_donor, newDonationId);
    totalDonations++;

    emit MakeDonation(newDonationId, _amount, _donor, msg.sender);
    return newDonationId;
  }

  function _issueDonation(uint256 _donationId, uint256 _amount, address _donor)
    internal
    returns (uint256)
  {
    Donation memory _donation = Donation({
      donationId: uint32(_donationId),
      amount: uint128(_amount),
      donor: _donor
    });

    uint256 newDonationId = donations.push(_donation) - 1;
    totalIssued++;

    emit IssueDonation(_donationId, _amount, _donor, msg.sender);
    return newDonationId;
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

    emit DeleteDonation(_donationId);
  }
}