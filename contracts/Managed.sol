pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";


contract Managed is Ownable {

  mapping(address => bool) public managers;

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

  function addManager(address _manager) public onlyOwner {
    managers[_manager] = true;
    emit AddManager(_manager);
  }

  function removeManager(address _manager) public onlyOwner {
    managers[_manager] = false;
    emit RemoveManager(_manager);
  }

  function isManager(address _manager) public view returns (bool) {
    return managers[_manager];
  }
}