const BigNumber = web3.BigNumber

const Notarizer = artifacts.require('Notarizer')

require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(BigNumber))
  .should()

const expect = require('chai').expect

contract('Notarizer', accounts => {
  const [creator, user, anotherUser, operator, mallory] = accounts
  let notary = null

  beforeEach(async () => {
    notary = await Notarizer.new()
  })

  describe('Tests', () => {
    beforeEach(async () => {
      await notary.issue("Campaign Name", 10e17, "Alex", "Go Rob0");
      await notary.issue("Campaign Name", 10e17, "Alex", "Go Rob1");
      await notary.issue("Campaign Name", 10e17, "Alex", "Go Rob2");
      await notary.issue("Campaign Name", 10e17, "Alex", "Go Rob3");
      await notary.issue("Campaign Name", 10e17, "Alex", "Go Rob4");
    })
    describe('Notary', async () => {
      it('Has an owner', async () => {
        const owner = await notary.owner();

        owner.should.be.equal(creator);
      });
      it('Issues a certificate', async () => {
        await notary.issue("Campaign Name For Issue Test", 10e17, "Alex", "Go Rob");
        const totalTokens = await notary.totalTokens();
        const token = await notary.tokens(totalTokens-1);

        token[0].should.be.equal('Campaign Name For Issue Test');
      });
      it('Has totalTokens', async () => {
        const totalTokens = (await notary.totalTokens()).toNumber();
        totalTokens.should.be.equal(5);
      })
    })
  })
})

