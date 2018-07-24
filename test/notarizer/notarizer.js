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
      await notary.createDonation("Campaign Name1", mallory);
      await notary.createDonation("Campaign Name2", mallory);
      await notary.createDonation("Campaign Name3", mallory);
      await notary.createDonation("Campaign Name4", mallory);
      await notary.createDonation("Campaign Name5", mallory);
    })
    describe('Notary', async () => {
      it('Has an owner', async () => {
        const owner = await notary.owner();

        owner.should.be.equal(creator);
      });
      it('Issues a certificate', async () => {
        await notary.createDonation("Campaign Name For Issue Test6", mallory);
        const totalTemplates = await notary.totalTemplates();
        const template = await notary.templates(totalTemplates-1);

        template[0].should.be.equal('Campaign Name For Issue Test6');
      });
      it('Has totalTemplates', async () => {
        const totalTemplates = await notary.totalTemplates();
        totalTemplates.should.be.bignumber.equal(6);
      })
      it('Makes a donation', async () => {
        await notary.makeDonation(1, {from: creator, value: 10e17});
        const totalDonations = await notary.totalDonations();
        const donation = await notary.donations(totalDonations - 1);
        donation[0].should.be.bignumber.equal(1);
        donation[1].should.be.bignumber.equal(10e17);
        donation[2].should.be.equal(creator);
      });
      it('Makes many donations', async () => {
        const startingDonations = (await notary.totalDonations()).toNumber();
        const testDonations = 20;
        for (let i = 0; i < testDonations; i++) {
          await notary.makeDonation(1, { from: creator, value: 10e17 });
        }
        const totalDonations = await notary.totalDonations();

        totalDonations.should.be.bignumber.equals(startingDonations+testDonations);
      });
    })
  })
})

