---
title: Overview
category: Architecture
order: 1
---

![Diagram](https://raw.githubusercontent.com/Heritage-Aero/heritage/master/imgs/HeritageContractArchitecture.jpg?token=AF_omn3ZUYxFagxISShefFdpMOuvccyqks5bcFjOwA%3D%3D)

## Contracts

1. Heritage.sol
* Provides the public interface to create, donate to and issue donations. Issue donations feature defaults to disabled and the enableIssueDonation flag is set at deployment.
2. Managed.sol
* Provides the contract owner with the means to add/remove addresses from a list of managers. Provides the onlyManagers function modifier.
3. DonationCore.sol
* Provides the business logic for creating, issuing and making donations. Tracks donation ownership using OpenZeppelin’s
ERC721BasicToken.sol.

## ERC-721 Donation
Mappings in DonationCore track each donation’s description, tax identifier, beneficiary, goal, and amount raised. A Donation struct containing the donation id, donation amount and original donor address is tracked as an ERC-721 asset.

```
  struct Donation {
    uint32 donationId;  // 4 bytes
    uint128 amount;     // 16 bytes
    address donor;      // 20 bytes
  }
```
