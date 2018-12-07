pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/lifecycle/Pausable.sol";

/**
 * Token
**/
contract Token {
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
}


// TODO Abstract to ERC-20, manage multple addresses/tokens, default to DAI
/**
 * @title DaiDonation
**/
contract DaiDonation is Ownable, Pausable {
  Token public dai;
  mapping(uint256 => bool) public isDai;
  uint256 totalDAIRaised;

  event ChangeDAIAddress(address newAddress);

  constructor() public payable {
    require(msg.value == 0);
    changeDaiAddress(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359); // Mainnet Dai Address
  }

  /**
   * @dev function to change the dai address
   * @param _daiContract address of the dai contract
  **/
  function changeDaiAddress(address _daiContract) public onlyOwner whenNotPaused {
    dai = Token(_daiContract);
    emit ChangeDAIAddress(_daiContract);
  }

  /**
   * @dev tracks a dai donation
   * @param _id id to check
  **/
  function _trackDaiDonation(uint256 _id) internal {
    isDai[_id] = true;
  }

  /**
   * @dev function to transfer dai
   * @param _from address of the sender
   * @param _to address to send funds to
   * @param _amount to be sent
  **/
  function _transferDai(address _from, address _to, uint256 _amount) internal {
    require(dai.transferFrom(_from, _to, _amount));
  }
}
