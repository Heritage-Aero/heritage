import assertRevert, { assertError } from '../helpers/assertRevert'

const BigNumber = web3.BigNumber

const Notarizer = artifacts.require('Notarizer')

require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(BigNumber))
  .should()

const expect = require('chai').expect

contract('Notarizer', accounts => {
  const [creator, donor1, donor2, donor3, donor4] = accounts
  const charity = "0x4f403d6dc030eb171f60d990840de3ac4527215f";
  let notary = null
  const donationsToCreate = 5;
  const zeroAddress = "0x0000000000000000000000000000000000000000";
  const genesisDonationName = "Genesis Donation";
  const oneEther = 10e17;

  beforeEach(async () => {
    notary = await Notarizer.new()
  })

  describe('Tests', () => {
    beforeEach(async () => {
      for(let i=0; i<donationsToCreate; i++) {
        await notary.createDonation(`Campaign-${i}`, 10e18, charity);
      }
    })
    describe('Notary', async () => {
      it('Has a name.', async () => {
        const name = await notary.name();

        name.should.be.equal("Heritage");
      });
      it('Has a symbol.', async () => {
        const name = await notary.symbol();

        name.should.be.equal("A^3");
      });
      it('Has a contract owner.', async () => {
        const owner = await notary.owner();

        owner.should.be.equal(creator);
      });
      it('Has a Genesis Donation.', async () => {
        const genesisDonation = await notary.donations(0);

        genesisDonation[0].should.be.equal(genesisDonationName);
        genesisDonation[1].should.be.bignumber.equal(0);
        genesisDonation[2].should.be.bignumber.equal(0);
        genesisDonation[3].should.be.equal(zeroAddress);
      });
      it('Has a Genesis Badge.', async () => {
        const genesisBadge = await notary.badges(0);

        genesisBadge[0].should.be.bignumber.equal(0);
        genesisBadge[1].should.be.bignumber.equal(0);
        genesisBadge[2].should.be.bignumber.equal(zeroAddress);
      });
      it('Creates a Donation.', async () => {
        await notary.createDonation("Campaign Name For Issue Test6", oneEther, charity);
        const totalDonations = await notary.totalDonations();
        const donation = await notary.donations(totalDonations-1);

        donation[0].should.be.equal('Campaign Name For Issue Test6');
        donation[1].should.be.bignumber.equal(oneEther);
        donation[2].should.be.bignumber.equal(0);
        donation[3].should.be.equal(charity);
      });
      it('Has totalDonations', async () => {
        const totalDonations = await notary.totalDonations();
        totalDonations.should.be.bignumber.equal(donationsToCreate+1);
      })
      it('Has totalRaised', async () => {
        const totalRaised = await notary.totalRaised();
        totalRaised.should.be.bignumber.equal(0);
      })
      it('Makes a donation, creates a badge and amount raised increases', async () => {
        await notary.makeDonation(1, {from: creator, value: oneEther});
        const totalBadges = await notary.totalBadges();
        const badge = await notary.badges(totalBadges - 1);

        badge[0].should.be.bignumber.equal(1);
        badge[1].should.be.bignumber.equal(oneEther);
        badge[2].should.be.bignumber.equal(creator);
        // Amount Raised increases
        const donation = await notary.donations(1);
        donation[2].should.be.bignumber.equal(oneEther);

        const totalRaised = await notary.totalRaised();
        totalRaised.should.be.bignumber.equal(oneEther);
      });

      it('Makes many donations', async () => {
        const startingBadges = (await notary.totalBadges()).toNumber();
        const testDonations = 10;

        for (let i = 0; i < testDonations; i++) {
          await notary.makeDonation(1, { from: creator, value: oneEther });
        }
        const totalBadges = await notary.totalBadges();

        totalBadges.should.be.bignumber.equals(startingBadges+testDonations);

        const donation = await notary.donations(1);
        donation[2].should.be.bignumber.equal(oneEther*testDonations);

        const totalRaised = await notary.totalRaised();
        totalRaised.should.be.bignumber.equal(oneEther*testDonations);
      });

      it('Creates multiple donations, donates to some of them and tracks totalRaised', async() => {
        const charityStartingBalance = await web3.eth.getBalance(charity).toNumber();

        await notary.createDonation("2 - Donation Campaign", oneEther, charity);
        await notary.createDonation("3 - Uncapped Donation Campaign", 0, charity);

        await notary.makeDonation(1, { from: creator, value: oneEther });
        const balance = await web3.eth.getBalance(charity).toNumber();

        await notary.makeDonation(2, { from: creator, value: oneEther });
        await notary.makeDonation(3, { from: creator, value: oneEther });
        await notary.makeDonation(3, { from: creator, value: oneEther });
        await notary.makeDonation(3, { from: creator, value: oneEther * 10 });

        // Amount Raised increases
        const donation1 = await notary.donations(1);
        const donation2 = await notary.donations(2);
        const donation3 = await notary.donations(3);

        donation1[2].should.be.bignumber.equal(oneEther);
        donation2[2].should.be.bignumber.equal(oneEther);
        donation3[2].should.be.bignumber.equal(oneEther * 12);

        const totalRaised = await notary.totalRaised();
        totalRaised.should.be.bignumber.equal(oneEther * 14);

        const charityEndBalance = await web3.eth.getBalance(charity).toNumber();
        const charityBalanceChange = charityEndBalance - charityStartingBalance;
        charityBalanceChange.should.be.equal(oneEther * 14);
      });


      context('Manager Fail Cases', async () => {

      })

      context('User Fail Cases', async () => {
        it('Fails if the donation amount is zero', async () => {
          await assertRevert(notary.makeDonation(1, { value: 0 }));
        })
        it('Fails if the donation goal is met', async () => {
          await notary.makeDonation(1, { value: oneEther*10 });
          await assertRevert(notary.makeDonation(1, { value: oneEther }));
        })
      })
    })
  })
})

