---
title: Donation Management
category: Heritage
order: 3
---

## Creating Donations
The `createDonation` function mints an ERC-721 donation for 0 ETH for the zero address (0x0000…). The index of this token is the donation id. All donations made to this token will reference this donation id.
```
  struct Donation {
    uint32 donationId;  // 4 bytes
    uint128 amount;     // 16 bytes
    address donor;      // 20 bytes
  }
```
Because the Donation struct stores the donation id as a 32-bit number the contracts impose a soft cap of 4,294,967,295 (2^32-1) donations.

This allows for others to raise funds on behalf of the beneficiary and receive a recognition.

## Issuing Donations
At deployment, the `enableIssueDonation` bool is set for the contract. If true, managers will have the ability to call the `issueDonation` function to create a symbolic donation. The symbolic donation can represent fiat, or other off-chain, donations.

Symbolic donations may mint to a specific address. In the case of KYC’d fiat donations, the donor may provide an Ethereum address to attach to the symbolic donation. Symbolic donations are not minted and thus not tracked as ERC-721 assets.

## Deleting Donations
At any time the owner may `deleteDonation` to zero-out the donation data in the smart contract.

