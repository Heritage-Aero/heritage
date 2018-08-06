---
title: Getting Started
---

Welcome to the Heritage documentation. Heritage is a collection of Ethereum smart contracts and Javascript libraries for managing charitable donations as ERC-721-based assets.

### Installation

Heritage uses the [truffle development framework](https://truffleframework.com/).

[Clone the repository](https://github.com/Heritage-Aero/heritage)

```
$ git@github.com:Heritage-Aero/heritage.git
$ cd heritage
$ npm install
```

> Unit Tests: `$ bash scripts/test.sh`

```
$ truffle compile
$ truffle develop
truffle(develop)> migrate
```

```
Using network 'develop'.

Running migration: 1_initial_migration.js
  Deploying Migrations...
  ... 0x4c6754c9724ec7a7a33ee7bfbc24382ffd99fb873296a0e92b727ee0b2448170
  Migrations: 0x8cdaf0cd259887258bc13a92c0a6da92698644c0
Saving successful migration to network...
  ... 0xd7bc86d31bee32fa3988f1c1eabce403a1b5d570340a3a9cdba53a472ee8c956
Saving artifacts...
Running migration: 7_fundraiser.js
  Deploying DAPP...
  ... 0x2d67550d5adc126a700d7d1fe6bf126f7b18c6a42a3edf90e869576047128b08
  DAPP: 0x345ca3e014aaf5dca488057592ee47305d9b3e10
Saving successful migration to network...
  ... 0xf18335112e9022e9c111f93658adbe1fb69fc318df1dc93a9a9aeaaca1032173
Saving artifacts...
```
