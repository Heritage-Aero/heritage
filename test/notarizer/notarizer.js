import assertRevert, { assertError } from '../helpers/assertRevert'

const BigNumber = web3.BigNumber

const Notarizer = artifacts.require('Notarizer')

require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(BigNumber))
  .should()

const expect = require('chai').expect

contract('Notarizer', accounts => {
  const [creator, charity, donor1, donor2, donor3] = accounts
  let notary = null
  const templatesToCreate = 5;
  const zeroAddress = "0x0000000000000000000000000000000000000000";
  const genesisTemplateName = "Genesis Donation";
  beforeEach(async () => {
    notary = await Notarizer.new()
  })

  describe('Tests', () => {
    beforeEach(async () => {
      for(let i=0; i<templatesToCreate; i++) {
        await notary.createDonation(`Campaign-${i}`, 0, charity);
      }
    })
    describe('Notary', async () => {
      it('Has a contract owner.', async () => {
        const owner = await notary.owner();

        owner.should.be.equal(creator);
      });
      it('Has a Genesis Template.', async () => {
        const genesisTemplate = await notary.templates(0);

        genesisTemplate[0].should.be.equal(genesisTemplateName);
        genesisTemplate[1].should.be.bignumber.equal(0);
        genesisTemplate[2].should.be.equal(zeroAddress);
      });
      it('Has a Genesis Donation.', async () => {
        const genesisTemplate = await notary.templates(0);

        genesisTemplate[0].should.be.equal(genesisTemplateName);
        genesisTemplate[1].should.be.bignumber.equal(0);
        genesisTemplate[2].should.be.equal(zeroAddress);
      });
      it('Creates a template for donations.', async () => {
        await notary.createDonation("Campaign Name For Issue Test6", charity, 0);
        const totalTemplates = await notary.totalTemplates();
        const template = await notary.templates(totalTemplates-1);

        template[0].should.be.equal('Campaign Name For Issue Test6');
      });
      it('Has totalTemplates', async () => {
        const totalTemplates = await notary.totalTemplates();
        totalTemplates.should.be.bignumber.equal(templatesToCreate+1);
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

