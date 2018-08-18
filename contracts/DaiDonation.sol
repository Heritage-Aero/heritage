pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";


contract Token {
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
}


// TODO pattern off this to accept/define other tokens
contract DaiDonation is Ownable {
  Token public dai;
  mapping(uint256 => bool) public isDai;
  uint256 totalDAIRaised;

  constructor() public payable {
    require(msg.value == 0);
    dai = Token(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359); // Mainnet Dai Address
  }

  function changeDaiAddress(address _daiContract) public onlyOwner {
    dai = Token(_daiContract);
  }

  function _trackDaiDonation(uint256 _id) internal {
    isDai[_id] = true;
  }

  function _transferDai(address _from, address _to, uint256 _amount) internal {
    require(dai.transferFrom(_from, _to, _amount));
  }
}