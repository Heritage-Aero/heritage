pragma solidity 0.4.24;

import '../Managed.sol';

contract ManagedMock is Managed {
  constructor() public { }

  function managersOnly()
    onlyManagers
    public
    returns (bool)
    {
      return true;
    }
}