pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/lifecycle/Pausable.sol";

/**
 * @title Managed
 * @dev contract to set Managers for fundraisers and provides basic authorization control
**/
contract Managed is Ownable, Pausable {

  mapping(address => bool) private managers;

  event AddManager(address manager);
  event RemoveManager(address manager);

  /**
   * @dev requires the sender be in the managers mapping.
  **/
  modifier onlyManagers() {
    require(managers[msg.sender]);
    _;
  }

  /**
   * sets the sender of the message in the managers mapping
  **/
  constructor() public payable {
    require(msg.value == 0);

    managers[msg.sender] = true;
  }

  /**
   * @dev adds a manager to the mapping
   * @param _manager address of the manager to be added
  **/
  function addManager(address _manager) public whenNotPaused onlyOwner {
    managers[_manager] = true;
    emit AddManager(_manager);
  }

  /**
   * @dev allows the current owner to remove a manager
   * @param _manager address of the manager to be removed
  **/
  function removeManager(address _manager) public whenNotPaused onlyOwner {
    managers[_manager] = false;
    emit RemoveManager(_manager);
  }

  /**
   * @param _manager address to check
  **/
  function isManager(address _manager) public view returns (bool) {
    return managers[_manager];
  }
}
