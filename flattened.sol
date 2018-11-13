pragma solidity 0.4.24;

// File: zeppelin-solidity/contracts/ownership/Ownable.sol

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

// File: zeppelin-solidity/contracts/lifecycle/Destructible.sol

/**
 * @title Destructible
 * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
 */
contract Destructible is Ownable {

  constructor() public payable { }

  /**
   * @dev Transfers the current balance to the owner and terminates the contract.
   */
  function destroy() onlyOwner public {
    selfdestruct(owner);
  }

  function destroyAndSend(address _recipient) onlyOwner public {
    selfdestruct(_recipient);
  }
}

// File: zeppelin-solidity/contracts/lifecycle/Pausable.sol

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    emit Unpause();
  }
}

// File: contracts/Managed.sol

contract Managed is Ownable, Pausable {

  mapping(address => bool) private managers;

  event AddManager(address manager);
  event RemoveManager(address manager);

  modifier onlyManagers() {
    require(managers[msg.sender]);
    _;
  }

  constructor() public payable {
    require(msg.value == 0);

    managers[msg.sender] = true;
  }

  function addManager(address _manager) public whenNotPaused onlyOwner {
    managers[_manager] = true;
    emit AddManager(_manager);
  }

  function removeManager(address _manager) public whenNotPaused onlyOwner {
    managers[_manager] = false;
    emit RemoveManager(_manager);
  }

  function isManager(address _manager) public view returns (bool) {
    return managers[_manager];
  }
}

// File: zeppelin-solidity/contracts/introspection/ERC165.sol

/**
 * @title ERC165
 * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
 */
interface ERC165 {

  /**
   * @notice Query if a contract implements an interface
   * @param _interfaceId The interface identifier, as specified in ERC-165
   * @dev Interface identification is specified in ERC-165. This function
   * uses less than 30,000 gas.
   */
  function supportsInterface(bytes4 _interfaceId)
    external
    view
    returns (bool);
}

// File: zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol

/**
 * @title ERC721 Non-Fungible Token Standard basic interface
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721Basic is ERC165 {
  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 indexed _tokenId
  );
  event Approval(
    address indexed _owner,
    address indexed _approved,
    uint256 indexed _tokenId
  );
  event ApprovalForAll(
    address indexed _owner,
    address indexed _operator,
    bool _approved
  );

  function balanceOf(address _owner) public view returns (uint256 _balance);
  function ownerOf(uint256 _tokenId) public view returns (address _owner);
  function exists(uint256 _tokenId) public view returns (bool _exists);

  function approve(address _to, uint256 _tokenId) public;
  function getApproved(uint256 _tokenId)
    public view returns (address _operator);

  function setApprovalForAll(address _operator, bool _approved) public;
  function isApprovedForAll(address _owner, address _operator)
    public view returns (bool);

  function transferFrom(address _from, address _to, uint256 _tokenId) public;
  function safeTransferFrom(address _from, address _to, uint256 _tokenId)
    public;

  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes _data
  )
    public;
}

// File: zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
contract ERC721Receiver {
  /**
   * @dev Magic value to be returned upon successful reception of an NFT
   *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
   *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
   */
  bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;

  /**
   * @notice Handle the receipt of an NFT
   * @dev The ERC721 smart contract calls this function on the recipient
   * after a `safetransfer`. This function MAY throw to revert and reject the
   * transfer. Return of other than the magic value MUST result in the 
   * transaction being reverted.
   * Note: the contract address is always the message sender.
   * @param _operator The address which called `safeTransferFrom` function
   * @param _from The address which previously owned the token
   * @param _tokenId The NFT identifier which is being transfered
   * @param _data Additional data with no specified format
   * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
   */
  function onERC721Received(
    address _operator,
    address _from,
    uint256 _tokenId,
    bytes _data
  )
    public
    returns(bytes4);
}

// File: zeppelin-solidity/contracts/math/SafeMath.sol

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

// File: zeppelin-solidity/contracts/AddressUtils.sol

/**
 * Utility library of inline functions on addresses
 */
library AddressUtils {

  /**
   * Returns whether the target address is a contract
   * @dev This function will return false if invoked during the constructor of a contract,
   * as the code is not actually created until after the constructor finishes.
   * @param addr address to check
   * @return whether the target address is a contract
   */
  function isContract(address addr) internal view returns (bool) {
    uint256 size;
    // XXX Currently there is no better way to check if there is a contract in an address
    // than to check the size of the code at that address.
    // See https://ethereum.stackexchange.com/a/14016/36603
    // for more details about how this works.
    // TODO Check this again before the Serenity release, because all addresses will be
    // contracts then.
    // solium-disable-next-line security/no-inline-assembly
    assembly { size := extcodesize(addr) }
    return size > 0;
  }

}

// File: zeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol

/**
 * @title SupportsInterfaceWithLookup
 * @author Matt Condon (@shrugs)
 * @dev Implements ERC165 using a lookup table.
 */
contract SupportsInterfaceWithLookup is ERC165 {
  bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
  /**
   * 0x01ffc9a7 ===
   *   bytes4(keccak256('supportsInterface(bytes4)'))
   */

  /**
   * @dev a mapping of interface id to whether or not it's supported
   */
  mapping(bytes4 => bool) internal supportedInterfaces;

  /**
   * @dev A contract implementing SupportsInterfaceWithLookup
   * implement ERC165 itself
   */
  constructor()
    public
  {
    _registerInterface(InterfaceId_ERC165);
  }

  /**
   * @dev implement supportsInterface(bytes4) using a lookup table
   */
  function supportsInterface(bytes4 _interfaceId)
    external
    view
    returns (bool)
  {
    return supportedInterfaces[_interfaceId];
  }

  /**
   * @dev private method for registering an interface
   */
  function _registerInterface(bytes4 _interfaceId)
    internal
  {
    require(_interfaceId != 0xffffffff);
    supportedInterfaces[_interfaceId] = true;
  }
}

// File: zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol

/**
 * @title ERC721 Non-Fungible Token Standard basic implementation
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {

  bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
  /*
   * 0x80ac58cd ===
   *   bytes4(keccak256('balanceOf(address)')) ^
   *   bytes4(keccak256('ownerOf(uint256)')) ^
   *   bytes4(keccak256('approve(address,uint256)')) ^
   *   bytes4(keccak256('getApproved(uint256)')) ^
   *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
   *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
   *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
   *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
   *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
   */

  bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
  /*
   * 0x4f558e79 ===
   *   bytes4(keccak256('exists(uint256)'))
   */

  using SafeMath for uint256;
  using AddressUtils for address;

  // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
  // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
  bytes4 private constant ERC721_RECEIVED = 0x150b7a02;

  // Mapping from token ID to owner
  mapping (uint256 => address) internal tokenOwner;

  // Mapping from token ID to approved address
  mapping (uint256 => address) internal tokenApprovals;

  // Mapping from owner to number of owned token
  mapping (address => uint256) internal ownedTokensCount;

  // Mapping from owner to operator approvals
  mapping (address => mapping (address => bool)) internal operatorApprovals;

  /**
   * @dev Guarantees msg.sender is owner of the given token
   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
   */
  modifier onlyOwnerOf(uint256 _tokenId) {
    require(ownerOf(_tokenId) == msg.sender);
    _;
  }

  /**
   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
   * @param _tokenId uint256 ID of the token to validate
   */
  modifier canTransfer(uint256 _tokenId) {
    require(isApprovedOrOwner(msg.sender, _tokenId));
    _;
  }

  constructor()
    public
  {
    // register the supported interfaces to conform to ERC721 via ERC165
    _registerInterface(InterfaceId_ERC721);
    _registerInterface(InterfaceId_ERC721Exists);
  }

  /**
   * @dev Gets the balance of the specified address
   * @param _owner address to query the balance of
   * @return uint256 representing the amount owned by the passed address
   */
  function balanceOf(address _owner) public view returns (uint256) {
    require(_owner != address(0));
    return ownedTokensCount[_owner];
  }

  /**
   * @dev Gets the owner of the specified token ID
   * @param _tokenId uint256 ID of the token to query the owner of
   * @return owner address currently marked as the owner of the given token ID
   */
  function ownerOf(uint256 _tokenId) public view returns (address) {
    address owner = tokenOwner[_tokenId];
    require(owner != address(0));
    return owner;
  }

  /**
   * @dev Returns whether the specified token exists
   * @param _tokenId uint256 ID of the token to query the existence of
   * @return whether the token exists
   */
  function exists(uint256 _tokenId) public view returns (bool) {
    address owner = tokenOwner[_tokenId];
    return owner != address(0);
  }

  /**
   * @dev Approves another address to transfer the given token ID
   * The zero address indicates there is no approved address.
   * There can only be one approved address per token at a given time.
   * Can only be called by the token owner or an approved operator.
   * @param _to address to be approved for the given token ID
   * @param _tokenId uint256 ID of the token to be approved
   */
  function approve(address _to, uint256 _tokenId) public {
    address owner = ownerOf(_tokenId);
    require(_to != owner);
    require(msg.sender == owner || isApprovedForAll(owner, msg.sender));

    tokenApprovals[_tokenId] = _to;
    emit Approval(owner, _to, _tokenId);
  }

  /**
   * @dev Gets the approved address for a token ID, or zero if no address set
   * @param _tokenId uint256 ID of the token to query the approval of
   * @return address currently approved for the given token ID
   */
  function getApproved(uint256 _tokenId) public view returns (address) {
    return tokenApprovals[_tokenId];
  }

  /**
   * @dev Sets or unsets the approval of a given operator
   * An operator is allowed to transfer all tokens of the sender on their behalf
   * @param _to operator address to set the approval
   * @param _approved representing the status of the approval to be set
   */
  function setApprovalForAll(address _to, bool _approved) public {
    require(_to != msg.sender);
    operatorApprovals[msg.sender][_to] = _approved;
    emit ApprovalForAll(msg.sender, _to, _approved);
  }

  /**
   * @dev Tells whether an operator is approved by a given owner
   * @param _owner owner address which you want to query the approval of
   * @param _operator operator address which you want to query the approval of
   * @return bool whether the given operator is approved by the given owner
   */
  function isApprovedForAll(
    address _owner,
    address _operator
  )
    public
    view
    returns (bool)
  {
    return operatorApprovals[_owner][_operator];
  }

  /**
   * @dev Transfers the ownership of a given token ID to another address
   * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
   * Requires the msg sender to be the owner, approved, or operator
   * @param _from current owner of the token
   * @param _to address to receive the ownership of the given token ID
   * @param _tokenId uint256 ID of the token to be transferred
  */
  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    public
    canTransfer(_tokenId)
  {
    require(_from != address(0));
    require(_to != address(0));

    clearApproval(_from, _tokenId);
    removeTokenFrom(_from, _tokenId);
    addTokenTo(_to, _tokenId);

    emit Transfer(_from, _to, _tokenId);
  }

  /**
   * @dev Safely transfers the ownership of a given token ID to another address
   * If the target address is a contract, it must implement `onERC721Received`,
   * which is called upon a safe transfer, and return the magic value
   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
   * the transfer is reverted.
   *
   * Requires the msg sender to be the owner, approved, or operator
   * @param _from current owner of the token
   * @param _to address to receive the ownership of the given token ID
   * @param _tokenId uint256 ID of the token to be transferred
  */
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    public
    canTransfer(_tokenId)
  {
    // solium-disable-next-line arg-overflow
    safeTransferFrom(_from, _to, _tokenId, "");
  }

  /**
   * @dev Safely transfers the ownership of a given token ID to another address
   * If the target address is a contract, it must implement `onERC721Received`,
   * which is called upon a safe transfer, and return the magic value
   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
   * the transfer is reverted.
   * Requires the msg sender to be the owner, approved, or operator
   * @param _from current owner of the token
   * @param _to address to receive the ownership of the given token ID
   * @param _tokenId uint256 ID of the token to be transferred
   * @param _data bytes data to send along with a safe transfer check
   */
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes _data
  )
    public
    canTransfer(_tokenId)
  {
    transferFrom(_from, _to, _tokenId);
    // solium-disable-next-line arg-overflow
    require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
  }

  /**
   * @dev Returns whether the given spender can transfer a given token ID
   * @param _spender address of the spender to query
   * @param _tokenId uint256 ID of the token to be transferred
   * @return bool whether the msg.sender is approved for the given token ID,
   *  is an operator of the owner, or is the owner of the token
   */
  function isApprovedOrOwner(
    address _spender,
    uint256 _tokenId
  )
    internal
    view
    returns (bool)
  {
    address owner = ownerOf(_tokenId);
    // Disable solium check because of
    // https://github.com/duaraghav8/Solium/issues/175
    // solium-disable-next-line operator-whitespace
    return (
      _spender == owner ||
      getApproved(_tokenId) == _spender ||
      isApprovedForAll(owner, _spender)
    );
  }

  /**
   * @dev Internal function to mint a new token
   * Reverts if the given token ID already exists
   * @param _to The address that will own the minted token
   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
   */
  function _mint(address _to, uint256 _tokenId) internal {
    require(_to != address(0));
    addTokenTo(_to, _tokenId);
    emit Transfer(address(0), _to, _tokenId);
  }

  /**
   * @dev Internal function to burn a specific token
   * Reverts if the token does not exist
   * @param _tokenId uint256 ID of the token being burned by the msg.sender
   */
  function _burn(address _owner, uint256 _tokenId) internal {
    clearApproval(_owner, _tokenId);
    removeTokenFrom(_owner, _tokenId);
    emit Transfer(_owner, address(0), _tokenId);
  }

  /**
   * @dev Internal function to clear current approval of a given token ID
   * Reverts if the given address is not indeed the owner of the token
   * @param _owner owner of the token
   * @param _tokenId uint256 ID of the token to be transferred
   */
  function clearApproval(address _owner, uint256 _tokenId) internal {
    require(ownerOf(_tokenId) == _owner);
    if (tokenApprovals[_tokenId] != address(0)) {
      tokenApprovals[_tokenId] = address(0);
    }
  }

  /**
   * @dev Internal function to add a token ID to the list of a given address
   * @param _to address representing the new owner of the given token ID
   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
   */
  function addTokenTo(address _to, uint256 _tokenId) internal {
    require(tokenOwner[_tokenId] == address(0));
    tokenOwner[_tokenId] = _to;
    ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
  }

  /**
   * @dev Internal function to remove a token ID from the list of a given address
   * @param _from address representing the previous owner of the given token ID
   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
   */
  function removeTokenFrom(address _from, uint256 _tokenId) internal {
    require(ownerOf(_tokenId) == _from);
    ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
    tokenOwner[_tokenId] = address(0);
  }

  /**
   * @dev Internal function to invoke `onERC721Received` on a target address
   * The call is not executed if the target address is not a contract
   * @param _from address representing the previous owner of the given token ID
   * @param _to target address that will receive the tokens
   * @param _tokenId uint256 ID of the token to be transferred
   * @param _data bytes optional data to send along with the call
   * @return whether the call correctly returned the expected magic value
   */
  function checkAndCallSafeTransfer(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes _data
  )
    internal
    returns (bool)
  {
    if (!_to.isContract()) {
      return true;
    }
    bytes4 retval = ERC721Receiver(_to).onERC721Received(
      msg.sender, _from, _tokenId, _data);
    return (retval == ERC721_RECEIVED);
  }
}

// File: contracts/DaiDonation.sol

contract Token {
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
}


// TODO Abstract to ERC-20, manage multple addresses/tokens, default to DAI
contract DaiDonation is Ownable, Pausable {
  Token public dai;
  mapping(uint256 => bool) public isDai;
  uint256 totalDAIRaised;

  event ChangeDAIAddress(address newAddress);

  constructor() public payable {
    require(msg.value == 0);
    changeDaiAddress(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359); // Mainnet Dai Address
  }

  function changeDaiAddress(address _daiContract) public onlyOwner whenNotPaused {
    dai = Token(_daiContract);
    emit ChangeDAIAddress(_daiContract);
  }

  function _trackDaiDonation(uint256 _id) internal {
    isDai[_id] = true;
  }

  function _transferDai(address _from, address _to, uint256 _amount) internal {
    require(dai.transferFrom(_from, _to, _amount));
  }
}

// File: contracts/DonationCore.sol

contract DonationCore is ERC721BasicToken, DaiDonation {
  // Soft cap of 4,294,967,295 (2^32-1)
  // E.g. Fill every block for ~50 years
  Donation[] public donations;
  // Convenience array tracking fundraisers
  uint256[] public fundraisers;

  // Tracking variables
  uint256 public totalFundraisersCreated;
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
  event CreateFundraiser(string description, uint256 goal, address beneficiary, string taxId, address creator, bool claimable);
  event MakeDonation(uint256 donationId, uint256 amount, address donor, address sender);
  event ClaimDonation(address donor, uint256 donationId);
  event IssueDonation(uint256 donationId, uint256 amount, address donor, address issuer);
  event DeleteDonation(uint256 donationId);

  // Donation struct
  struct Donation {
    uint128 donationId;  // 4 bytes
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

  function _createDAIFundraiser(
    string _description,
    uint256 _goal,
    address _beneficiary,
    string _taxId,
    bool _claimable
  ) internal
    returns (uint256)
  {
    uint256 newDonationId = _createFundraiser(_description, _goal, _beneficiary, _taxId, _claimable);
    _trackDaiDonation(newDonationId);
    return newDonationId;
  }

  function _createFundraiser(
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

    totalFundraisersCreated++;

    fundraisers.push(newDonationId);
    emit CreateFundraiser(_description, _goal, _beneficiary, _taxId, msg.sender, _claimable);
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
    emit ClaimDonation(_donor, _donationId);
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

// File: contracts/Heritage.sol

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
  uint256 constant MAX_DONATIONS = 2**128 - 1;
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

    _createFundraiser("Genesis Donation", 0, this, "", false);
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
