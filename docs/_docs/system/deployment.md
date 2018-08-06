---
title: Deployment
category: Heritage
order: 2
---

The contract deployer is set as contract owner and the first manager. The owner may add or remove managers or create a donation.

The contract creates a "Genesis Donation" at index 0. It is an invalid donation and will revert transactions that reference it.
```
_createDonation("Genesis Donation", 0, this, "");
```


## Prelaunch Variables

The optional name and symbol for the ER721 standard reside in pure functions in DonationCore.

```
  function name() external pure returns (string _name) {
    _name = "Heritage";
  }

  function symbol() external pure returns (string _symbol) {
    _symbol = "A^3";
  }
```

## Gas Costs

The size of the contract sits around 22kb. We're trying for less than five USD to deploy.