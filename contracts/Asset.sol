pragma solidity ^0.4.19;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';

contract Asset is ERC721Token {
  function name() external pure returns (string _name) {
    _name = "Heritage";
  }

  function symbol() external pure returns (string _symbol) {
    _symbol = "A^3";
  }
}