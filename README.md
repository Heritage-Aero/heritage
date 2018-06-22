# Megalithic Heritage Demo App

Don't do this with Node or run this in production. This is a minimal fundraiser application to test the functionality of the Heritage smart contracts.

## Getting Started

```
$ npm install
$ export NODE_ENV="dev"
$ export EXPSECRET="keyboard cat"
$ export ADMINPASS="123"
$ export FAUCETPW="123"
$ node index.js
listening on 4k
```

Browse to localhost:4000/demo

Google Authentication requires the following ENV variables:

```
$ export GOOGLE_CLIENT_ID="YOUR ID"
$ export GOOGLE_SECRET="YOUR SECRET"
```

Mailgun requires the following ENV variables:

```
export MAILGUN_KEY="YOUR KEY"
```
### Prerequisites

Node 8.9+
MongoDB running on default port @ localhost

## Running the tests

This is not a production application. We are only interested in smart contract tests.

```
$ bash scripts/test.sh
```

## License

This project is licensed under the BSD 3 License - see the [LICENSE.md](LICENSE.md) file for details

