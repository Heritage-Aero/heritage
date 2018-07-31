pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol';
import './Donation.sol';

contract Badge is ERC721BasicToken, Donation {
  Badge[] public badges;
  uint256 public totalRaised;

  struct Badge {
    uint64 donationId;
    uint128 amount;
    address donor;
  }

  function _makeDonation(uint64 _donationId, uint128 _amount, address _donor)
    internal
    returns (uint256)
  {
    Badge memory _badge = Badge({
      donationId: _donationId,
      amount: _amount,
      donor: _donor
    });

    uint256 newBadgeId = badges.push(_badge);

    _mint(msg.sender, newBadgeId);

    donations[_donationId].raised += _amount;
    donations[_donationId].beneficiary.transfer(_amount);
    totalRaised += _amount;
    return newBadgeId;
  }

  function totalBadges() external view returns (uint256 _totalBadges) {
    _totalBadges = badges.length;
  }
}