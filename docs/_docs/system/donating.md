---
title: Donating
category: Heritage
order: 3
---

## Making Donations

Donors interacting with Heritage will call a makeDonation function and provide the donation id as a parameter. Heritage will mint an ERC-721 donation for the amount of ETH sent by the sender’s address. The donor’s token will reference the donation id of the original donation token.

## Donation Chaining
If a donation is sent to a donor token, or token that was not created by a manager, the donation is treated as if sent to the original donation token. However, the child token is recorded as having raised some ETH for the original donation token.

This allows for others to raise funds on behalf of the beneficiary and receive a recognition.

## Proxy Donations
To facilitate donations without requiring MetaMask we can launch a proxy contract for a donation. In the proxy contract payable fallback we call a function similar to makeDonation that credits the original sender address. Anyone may launch a proxy for any donation that does not already have a proxy.

> *Proxy Donation Cons*
1. Exchange addresses credit exchange, not user (Exchange holds keys)
2. Additional deployment gas/cost (Small)
3. Additional gas cost to create a donation
