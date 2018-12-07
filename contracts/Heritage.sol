pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/lifecycle/Destructible.sol";
import "./Managed.sol";
import "./DonationCore.sol";

// Todo
// Destroy Proxy once goal is met
/**
 * @title Proxy contract
**/
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

/**
 * @title Heritage
**/
contract Heritage is Destructible, Managed, DonationCore {
  uint256 constant MAX_DONATIONS = 2**128 - 1;
  bool public issueDonationEnabled = false;
  mapping (address => bool) public isProxy;
  mapping (uint256 => bool) public isFiat;

  /**
   * @dev modifier to check if issuing donations is enabled
  **/
  modifier issueDonationIsEnabled() {
    require(issueDonationEnabled);
    _;
  }

  /**
   * @dev if a donation id is valid or not
   * @param _donationId id of the donation
  **/
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

  /**
  * @dev modifier that throws if sender is not the owner of the donation
  * @param _donationId id of the donation
  **/
  modifier onlyTokenOwner(uint256 _donationId) {
    require(msg.sender == ownerOf(_donationId));
    _;
  }

  /**
   * @dev throws if not a proxy
  **/
  modifier onlyProxy() {
    require(isProxy[msg.sender]);
    _;
  }

  event ReclaimEther(uint256 balance);
  /**
   * @dev creates a genesis donation. Sets a bool for enabling issuing donations
  **/
  constructor(bool enableIssueDonation) public payable {
    require(msg.value == 0);

    issueDonationEnabled = enableIssueDonation;

    _createFundraiser("Genesis Donation", 0, this, "", false);
  }

  // Do not accept any transactions that send Ether.
  function() external {
  }

  /**
   * @dev Cannot prevent Ether from being mined/self-destructed to this contract. reclaim lost Ether.
  **/
  function reclaimEther() external onlyOwner {
    uint256 _balance = address(this).balance;

    owner.transfer(_balance);
    emit ReclaimEther(_balance);
  }

  /**
   * @dev creates a new fundraiser
   * @param _description of the fundraiser being created
   * @param _goal goal set for the fundraiser
   * @param _beneficiary address who receives funds
   * @param _taxId id for taxes
   * @param _claimable bool if fundraiser is claimable or not
  **/
  function createFundraiser(
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
    return _createFundraiser(_description, _goal, _beneficiary, _taxId, _claimable);
  }

  /**
   * @dev function to create a DAI fundraiser
   * @param _description of the fundraiser
   * @param _goal goal set for the fundraiser
   * @param _beneficiary address who receives funds
   * @param _taxId taxId of the beneficary
   * @param _claimable bool if claimable or not
  **/
  function createDAIFundraiser(
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
    return _createDAIFundraiser(_description, _goal, _beneficiary, _taxId, _claimable);
  }

  /**
   * @dev creates a proxy donation
   * @param _donationId id of the donation
   * @param _donor address of the donor
  **/
  function proxyDonation(
    uint256 _donationId,
    address _donor
  )
    public
    payable
    onlyProxy
    whenNotPaused
  {
    uint256 donationId = donations[_donationId].donationId;

    // Is not a token/fiat donation
    require(!isFiat[donationId]);
    require(!isDai[donationId]);
    // Cannot donate to deleted token/null address
    require(donationBeneficiary[donationId] != address(0));
    // A goal of 0 is uncapped
    if (donationGoal[donationId] > 0) {
      // It must not have reached it's goal
      require(donationRaised[donationId] < donationGoal[donationId]);
    }
    _makeDonation(_donationId, msg.value, _donor, true);
  }

  /**
   * @dev creates the proxy for a fundraiser
   * @param _donationId id of the donation
   * @return returns the address for the proxy
  **/
  function createFundraiserProxy(uint256 _donationId)
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

  /**
   * @dev make a donation based on id. Donate directly or proxy through another donation.
   * @param _donationId id of the donation
  **/
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

  /**
   * @dev Make a DAI donation based on Id.
   * @param _donationId the id of the donation
   * @param _amount the amount to donate
  **/
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

  /**
   * @dev managers may issue donations directly as a way to accept fiat donations and credit an address. Optional at deployment/
   * @param _donationId id of the donation
   * @param _amount donation amount
   * @param _donor the donor
  **/
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

  /**
   * @dev claims the donation by a token owner
   * @param _donationId id of the donation
  **/
  function claimDonation(uint256 _donationId)
    public
    whenNotPaused
    onlyTokenOwner(_donationId)
  {
    _claimDonation(msg.sender, _donationId);
  }

  /**
   * @dev function to delete a donation
   * @param _donationId id of the donation
  **/
  function deleteDonation(uint256 _donationId)
    public
    onlyOwner
    whenNotPaused
    donationIdIsValid(_donationId)
  {
    _deleteDonation(_donationId);
  }
}
