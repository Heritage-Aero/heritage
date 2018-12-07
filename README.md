# Heritage <img align="right" src="https://raw.githubusercontent.com/Heritage-Aero/heritage/master/imgs/HeritageHighRes.png" height="80px" />

The Heritage smart contracts facilitate the creation, donation, and issuance of an asset based on the ERC-721 standard. Managers set by the contract owner define donations for a cause. Donors receive an ERC-721 receipt of donation to serve as a certificate or badge for their social impact. Managers may issue donations directly to an address to notarize fiat donations that occur off the blockchain.

## Quick start
Clone the repo and run:
```
$ npm install
$ bash scripts/test.sh
```

## Tests
Tests are in the `test/` folder and written in JavaScript.

### To run the tests:
Download this repository and run:
```
$ truffle develop
$ test
```

## Contributing to Heritage
### Contribution Guidelines
See the issues tab and submit an issue if one is found.
Follow the style, workflow, and testing guidelines documented below.

### Workflow
1. Fork the repository
2. Create a feature branch (git checkout -b feature/your-feature)
3. Make sure your tests pass.
3. Commit your changes. Include a clear and detailed commit message that documents why you made the change and what you did.
4. Push to the branch (git push origin feature/your-feature)
5. Verify that the pull request meets the guidelines documented in style and tests.
6. Create a new pull request with a descriptive title.

#### Style
1. Follow: https://solidity.readthedocs.io/en/latest/style-guide.html.
2. Adhere to the [Ethereum Natural Specification Format Guidelines](https://github.com/ethereum/wiki/wiki/Ethereum-Natural-Specification-Format).  

#### Tests
We suggest using test driven development.
1. Tests should be added for any feature or change.
2. Tests should be written concisely and clearly. Have clear test names.
3. Use helper functions or create them.
4. Use good variable names.
5. Run the tests when making a pull request and verify they pass.

## Security
Report any issues you find in Github issues.
