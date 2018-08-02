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

        genesisDonation[0].should.be.bignumber.equal(0);
        genesisDonation[1].should.be.bignumber.equal(0);
        genesisDonation[2].should.be.equal((await notary.address));
        genesisDonation[3].should.be.equal(genesisDonationName);
      });
      it('Creates a Donation.', async () => {
        await notary.createDonation("10 Laptops", 10*10e18, charity);
        const donation = await notary.donations(1);

        donation[0].should.be.bignumber.equal(1);
        donation[1].should.be.bignumber.equal(0);
        donation[2].should.be.equal(charity);
        donation[3].should.be.equal("10 Laptops");
        (await notary.donationGoal(1)).should.be.bignumber.equal(10 * 10e18);
        (await notary.donationRaised(1)).should.be.bignumber.equal(0);
      });
      it('Has totalDonationsCreated', async () => {
        const created = await notary.totalDonationsCreated();
        created.should.be.bignumber.equal(1);
      })
      it('Has totalDonationsMade', async () => {
        const created = await notary.totalDonationsMade();
        created.should.be.bignumber.equal(0);
      })
      it('Makes a donation', async () => {
        await notary.createDonation("10 Laptops", 10 * 10e18, charity);
        await notary.makeDonation(1, {value: 10e18, from: creator});
        const donation = await notary.donations(2);

        donation[0].should.be.bignumber.equal(1);
        donation[1].should.be.bignumber.equal(10e18);
        donation[2].should.be.equal(charity);
        donation[3].should.be.equal("10 Laptops");

        (await notary.ownerOf(2)).should.be.equal(creator);
        (await notary.totalRaised()).should.be.bignumber.equal(10e18);
        (await notary.donationRaised(1)).should.be.bignumber.equal(10e18);
      });
      it('Makes a donation through a previous donation', async () => {
        await notary.createDonation("10 Laptops", 10 * 10e18, charity);
        await notary.makeDonation(1, { value: 10e18, from: creator });
        await notary.makeDonation(2, { value: 10e18, from: donor1 });

        const donation = await notary.donations(3);

        donation[0].should.be.bignumber.equal(1);
        donation[1].should.be.bignumber.equal(10e18);
        donation[2].should.be.equal(charity);
        donation[3].should.be.equal("10 Laptops");

        (await notary.ownerOf(3)).should.be.equal(donor1);

        (await notary.ownerOf(2)).should.be.equal(creator);
        (await notary.totalRaised()).should.be.bignumber.equal(2*10e18);

        const donation1Raised = (await notary.donationRaised(1)).toNumber();
        const donation2Raised = (await notary.donationRaised(2)).toNumber();

        donation1Raised.should.be.equal(2*10e18);
        donation2Raised.should.be.equal(10e18);
      });


      context('User Fail Cases', async () => {
        it('Fails if the donation amount is zero', async () => {
          await assertRevert(notary.makeDonation(1, { value: 0, from: creator }));
        })
        it('Fails if the donation is for the Genesis Donation', async () => {
          await assertRevert(notary.makeDonation(0, { value: 10e18, from: creator }));
        })
        it('Fails if the donation does not exist', async () => {
          await assertRevert(notary.makeDonation(10, { value: 10e18, from: creator }));
        })
        it('Fails if the donation has reached its goal', async () => {
          await notary.createDonation("10 Laptops", 10 * 10e18, charity);
          await notary.makeDonation(1, { value: 10*10e18, from: creator });
          await assertRevert(notary.makeDonation(1, { value: 10e18, from: creator }));
          await assertRevert(notary.makeDonation(2, { value: 10e18, from: creator }));
        })
      })
    })
  })
})

