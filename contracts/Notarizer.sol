pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import './Managed.sol';
import './Asset.sol';

// Needs gas opti
contract Notarizer is Ownable, Managed, Asset {

Template[] public templates;
Donation[] public donations;

uint256 public totalTemplates;
uint256 public totalDonations;

  struct Template {
    string description;
    address beneficiary;
  }

  struct Donation {
    uint256 templateId;
    uint256 amount;
    address donor;
  }

  constructor() public {
    _createDonation("Genesis Template", address(0));
    _makeDonation(0, 0, address(0));
  }

  function createDonation(
    string _description,
    address _beneficiary
  )
    onlyManagers
    public
    returns (uint256)
  {
    return _createDonation(_description, _beneficiary);
  }

  function _createDonation(
    string _description,
    address _beneficiary
  )
    internal
    returns (uint256)
  {
    Template memory _template = Template({
      description: _description,
      beneficiary: _beneficiary
    });

    uint256 newTemplateId = templates.push(_template);
    totalTemplates++;
    return newTemplateId;
  }

  function makeDonation(uint256 _templateId)
    public
    payable
    returns (uint256)
  {
    require(msg.value > 0);

    return _makeDonation(_templateId, msg.value, msg.sender);
  }

  function _makeDonation(uint256 _templateId, uint256 _amount, address _donor)
    internal
    returns (uint256)
  {
    Donation memory _donation = Donation({
      templateId: _templateId,
      amount: _amount,
      donor: _donor
    });

    uint256 newDonationId = donations.push(_donation);

    _mint(msg.sender, newDonationId);
    totalDonations++;
    return newDonationId;
  }
}