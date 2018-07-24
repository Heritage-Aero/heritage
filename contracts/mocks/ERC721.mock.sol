pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol';

/**
 * @title ERC721TokenMock
 * This mock just provides public mint and burn functions for testing purposes.
 */
contract ERC721TokenMock is ERC721BasicToken {
  constructor() public { }

  function mint(address _to, uint256 _tokenId) public {
    super._mint(_to, _tokenId);
  }

  function burn(address _owner, uint256 _tokenId) public {
    super._burn(_owner, _tokenId);
  }
}