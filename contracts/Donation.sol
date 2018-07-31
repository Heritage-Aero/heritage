pragma solidity ^0.4.19;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol';

contract Donation is ERC721BasicToken {
  Donation[] public donations;

    struct Donation {
    string description;
    uint128 goal;
    uint128 raised;
    address beneficiary;
  }

  function _createDonation(
    string _description,
    uint128 _goal,
    address _beneficiary
  )
    internal
    returns (uint256)
  {
    Donation memory _donation = Donation({
      description: _description,
      goal: _goal,
      raised: 0,
      beneficiary: _beneficiary
    });

    uint256 newDonationId = donations.push(_donation);
    return newDonationId;
  }

  function name() external pure returns (string _name) {
    _name = "Heritage";
  }

  function symbol() external pure returns (string _symbol) {
    _symbol = "A^3";
  }

  function totalDonations() external view returns (uint256 _totalDonations) {
    _totalDonations = donations.length;
  }
}