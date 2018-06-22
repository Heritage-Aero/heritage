pragma solidity ^0.4.19;

import './Asset.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract Notarizer is Asset, Ownable {

Token[] public tokens;
uint256 public totalTokens;

struct Token {
    string campaignName;
    uint256 value;
    string purchaser;
    string message;
  }

  function issue(
    string _campaignName,
    uint256 _value,
    string _purchaser,
    string _message
  )
    onlyOwner
    returns (uint256)
  {
    Token memory _token = Token({
      campaignName: _campaignName,
      value: _value,
      purchaser: _purchaser,
      message: _message
    });

    uint256 newTokenId = tokens.push(_token);

    _mint(msg.sender, newTokenId);
    totalTokens++;
    return newTokenId;
  }
}