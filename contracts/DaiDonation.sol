pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/lifecycle/Pausable.sol";


contract Token {
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
}


contract DaiDonation is Ownable, Pausable {
  Token public dai;
  uint256 totalDAIRaised;

  mapping (uint256 => uint256) public fundraiserDAIRaised;

  event ChangeDAIAddress(address newAddress);

  constructor() public payable {
    require(msg.value == 0);
    changeDaiAddress(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359); // Mainnet Dai Address
  }

  function changeDaiAddress(address _daiContract) public onlyOwner whenNotPaused {
    dai = Token(_daiContract);
    emit ChangeDAIAddress(_daiContract);
  }

  function _transferDai(address _from, address _to, uint256 _amount) internal {
    require(dai.transferFrom(_from, _to, _amount));
  }
}