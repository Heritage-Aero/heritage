pragma solidity 0.4.24;


import "zeppelin-solidity/contracts/lifecycle/Destructible.sol";
import "./Managed.sol";
import "./DonationCore.sol";


// Todo
// Destroy Proxy once goal is met
contract Proxy {
  Heritage heritage;
  uint256 donationId;

  constructor(uint256 _donationId) public payable {
    require(msg.value == 0);

    donationId = _donationId;
    heritage = Heritage(msg.sender);
  }

  function() public payable {
    heritage.proxyDonation.value(msg.value)(donationId, msg.sender);
  }
}


contract Heritage is Destructible, Managed, DonationCore {
  uint256 constant MAX_DONATIONS = 4294967295; //2^64 - 1
  bool public issueDonationEnabled = false;
  mapping (address => bool) public isProxy;
  mapping (uint256 => bool) public isFiat;

  modifier issueDonationIsEnabled() {
    require(issueDonationEnabled);
    _;
  }

  modifier donationIdIsValid(uint256 _donationId) {
    uint256 totalDonations = donations.length;
    // Cannot debelete Genesis
    require(_donationId > 0);
    // Must be an existing donation
    require(_donationId < totalDonations);
    // 2^32-1
    require(totalDonations < MAX_DONATIONS);
    _;
  }

  modifier onlyTokenOwner(uint256 _donationId) {
    require(msg.sender == ownerOf(_donationId));
    _;
  }

  modifier onlyProxy() {
    require(isProxy[msg.sender]);
    _;
  }

  event ReclaimEther(uint256 balance);

  constructor(bool enableIssueDonation) public payable {
    require(msg.value == 0);

    issueDonationEnabled = enableIssueDonation;

    _createDonation("Genesis Donation", 0, this, "", false);
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

  function createDonation(
    string _description,
    uint256 _goal,
    address _beneficiary,
    string _taxId,
    bool _claimable
  )
    public
    onlyManagers
    whenNotPaused
    returns (uint256)
  {
    require(donations.length < MAX_DONATIONS);
    return _createDonation(_description, _goal, _beneficiary, _taxId, _claimable);
  }

  function createDAIDonation(
    string _description,
    uint256 _goal,
    address _beneficiary,
    string _taxId,
    bool _claimable
  )
    public
    onlyManagers
    whenNotPaused
    returns (uint256)
  {
    require(donations.length < MAX_DONATIONS);
    return _createDAIDonation(_description, _goal, _beneficiary, _taxId, _claimable);
  }

  function proxyDonation(
    uint256 _donationId,
    address _donor
  )
    public
    payable
    onlyProxy
    whenNotPaused
  {
    _makeDonation(_donationId, msg.value, _donor, true);
  }

  function createDonationProxy(uint256 _donationId)
    public
    donationIdIsValid(_donationId)
    whenNotPaused
    returns (address proxyAddress)
  {
    require(!isFiat[_donationId]);
    Proxy p = new Proxy(_donationId);
    isProxy[p] = true;
    return p;
  }

  // Make a donation based on Id.
  // Donate directly or proxy through another donation.
  function makeDonation(uint256 _donationId)
    public
    payable
    whenNotPaused
    donationIdIsValid(_donationId)
    returns (uint256)
  {
    require(msg.value > 0);
    // Lookup the original donation
    uint256 donationId = donations[_donationId].donationId;
    // Is not a token donation
    require(!isDai[donationId]);
    // Cannot donate to deleted token/null address
    require(donationBeneficiary[donationId] != address(0));
    // A goal of 0 is uncapped
    if (donationGoal[donationId] > 0) {
      // It must not have reached it's goal
      require(donationRaised[donationId] < donationGoal[donationId]);
    }

    // Send the tx value to the charity
    donationBeneficiary[donationId].transfer(msg.value);
    donationRaised[_donationId] += msg.value;
    return _makeDonation(donationId, msg.value, msg.sender, true);
  }

  // Make a DAI donation based on Id.
  // Donate directly or proxy through another donation.
  function makeDAIDonation(uint256 _donationId, uint256 _amount)
    public
    whenNotPaused
    donationIdIsValid(_donationId)
    returns (uint256)
  {
    require(_amount > 0);
    // Lookup the original donation
    uint256 donationId = donations[_donationId].donationId;
    // Must be a DAI donation token
    require(isDai[donationId]);
    // Cannot donate to deleted token/null address
    require(donationBeneficiary[donationId] != address(0));
    // A goal of 0 is uncapped
    if (donationGoal[donationId] > 0) {
      // It must not have reached it's goal
      require(donationRaised[donationId] < donationGoal[donationId]);
    }

    // Send the tx value to the charity
    _transferDai(msg.sender, donationBeneficiary[donationId], _amount);
    donationRaised[_donationId] += _amount;
    return _makeDonation(donationId, _amount, msg.sender, true);
  }

  // Managers may issue donations directly. A way to accept fiat donations
  // and credit an address. Optional -- disable/enable at deployment.
  // Does not effect contract totals. Must issue to a created donation.
  function issueDonation(uint256 _donationId, uint256 _amount, address _donor)
    public
    onlyManagers
    issueDonationIsEnabled
    whenNotPaused
    donationIdIsValid(_donationId)
    returns (uint256)
  {
    // Lookup the original donation
    uint256 donationId = donations[_donationId].donationId;

    uint256 id = _makeDonation(donationId, _amount, _donor, false);
    isFiat[id];
    return id;
  }

  function claimDonation(uint256 _donationId)
    public
    whenNotPaused
    onlyTokenOwner(_donationId)
  {
    _claimDonation(msg.sender, _donationId);
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