import assertRevert, { assertError } from '../helpers/assertRevert'

const BigNumber = web3.BigNumber

const Heritage = artifacts.require('Heritage')

require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(BigNumber))
  .should()

const expect = require('chai').expect

contract('Heritage', accounts => {
  const [creator, donor1, donor2, donor3, donor4] = accounts
  const charity = "0x4f403d6dc030eb171f60d990840de3ac4527215f";
  const taxId = '46-0192831';
  let heritage = null
  let heritageNoFiat = null
  const donationsToCreate = 5;
  const zeroAddress = "0x0000000000000000000000000000000000000000";
  const genesisDonationName = "Genesis Donation";
  const oneEther = 10e17;

  beforeEach(async () => {
    heritage = await Heritage.new(true)
    heritageNoFiat = await Heritage.new(false)
  })

  describe('Tests', () => {

    describe('Notary', async () => {
      it('Has a contract owner.', async () => {
        const owner = await heritage.owner();

        owner.should.be.equal(creator);
      });
      it('Has issueDonationEnabled set to true.', async() => {
        const enabled = await heritage.issueDonationEnabled();

        enabled.should.be.equal(true);
      })
      it('Has getDonation', async() => {
        const genesisDonation = await heritage.getDonation(0);
      })
      it('Has a Genesis Donation.', async () => {
        const genesisDonation = await heritage.getDonation(0);

        genesisDonation[0].should.be.bignumber.equal(0);
        genesisDonation[1].should.be.bignumber.equal(0);
        genesisDonation[2].should.be.equal("Genesis Donation");
        genesisDonation[3].should.be.bignumber.equal(0);
        genesisDonation[4].should.be.bignumber.equal(0);
        genesisDonation[5].should.be.bignumber.equal(0);
        genesisDonation[6].should.be.equal((await heritage.address));
        genesisDonation[7].should.be.equal(zeroAddress);
        genesisDonation[8].should.be.equal("");
      });
      it('Creates a Donation.', async () => {
        const { logs } = await heritage.createFundraiser("10 Laptops", 10*10e18, charity, taxId, false);
        const donation = await heritage.getDonation(1);

        donation[0].should.be.bignumber.equal(1);
        donation[1].should.be.bignumber.equal(1);
        donation[2].should.be.equal("10 Laptops");
        donation[3].should.be.bignumber.equal(10*10e18);
        donation[4].should.be.bignumber.equal(0);
        donation[5].should.be.bignumber.equal(0);
        donation[6].should.be.equal(charity);
        donation[7].should.be.equal(zeroAddress);
        donation[8].should.be.equal(taxId);

        logs[1].event.should.be.equal('CreateFundraiser');
      });
      it('Issues a Donation', async() => {
        await heritage.createFundraiser("10 Laptops", 10 * 10e18, charity, taxId, false);
        const { logs } = await heritage.issueDonation(1, 1000, zeroAddress);

        const donation = await heritage.getDonation(2);

        donation[0].should.be.bignumber.equal(1);
        donation[1].should.be.bignumber.equal(2);
        donation[2].should.be.equal("10 Laptops");
        donation[3].should.be.bignumber.equal(10 * 10e18);
        donation[4].should.be.bignumber.equal(0);
        donation[5].should.be.bignumber.equal(1000);
        donation[6].should.be.equal(charity);
        donation[7].should.be.equal(zeroAddress);
        donation[8].should.be.equal(taxId);

        logs[0].event.should.be.equal('IssueDonation');
      })
      it('Makes a donation', async () => {
        await heritage.createFundraiser("10 Laptops", 10 * 10e18, charity, taxId, false);
        const { logs } = await heritage.makeDonation(1, {value: 10e18, from: creator});
        const donation = await heritage.getDonation(2);

        donation[0].should.be.bignumber.equal(1);
        donation[1].should.be.bignumber.equal(2);
        donation[2].should.be.equal("10 Laptops");
        donation[3].should.be.bignumber.equal(10 * 10e18);
        donation[4].should.be.bignumber.equal(10e18);
        donation[5].should.be.bignumber.equal(10e18);
        donation[6].should.be.equal(charity);
        donation[7].should.be.equal(creator);
        donation[8].should.be.equal(taxId);

        (await heritage.ownerOf(2)).should.be.equal(creator);
        (await heritage.donationRaised(2)).should.be.bignumber.equal(0);
        (await heritage.donationRaised(1)).should.be.bignumber.equal(10e18);

        logs[1].event.should.be.equal('MakeDonation');
      });
      it('Deletes a donation', async() => {
        await heritage.createFundraiser("10 Laptops", 10 * 10e18, charity, taxId, false);
        const { logs } = await heritage.deleteDonation(1);

        const d = await heritage.donations(1);

        d[0].should.be.bignumber.equal(0);
        d[1].should.be.bignumber.equal(0);
        d[2].should.be.equal(zeroAddress);

        logs[1].event.should.be.equal('DeleteDonation');
      })
      it('Makes a donation through a previous donation', async () => {
        await heritage.createFundraiser("10 Laptops", 10 * 10e18, charity, taxId, false);
        await heritage.makeDonation(1, { value: 10e18, from: creator });
        await heritage.makeDonation(2, { value: 10e18, from: donor1 });

        const donation = await heritage.getDonation(3);

        donation[0].should.be.bignumber.equal(1);
        donation[1].should.be.bignumber.equal(3);
        donation[2].should.be.equal("10 Laptops");
        donation[3].should.be.bignumber.equal(10 * 10e18);
        donation[4].should.be.bignumber.equal(10e18);
        donation[5].should.be.bignumber.equal(10e18);
        donation[6].should.be.equal(charity);
        donation[7].should.be.equal(donor1);
        donation[8].should.be.equal(taxId);

        (await heritage.ownerOf(3)).should.be.equal(donor1);

        (await heritage.ownerOf(2)).should.be.equal(creator);
        (await heritage.donationRaised(1)).should.be.bignumber.equal(10e18);
        (await heritage.donationRaised(2)).should.be.bignumber.equal(10e18);
      });
      it('Creates uncapped donation', async() => {
        await heritage.createFundraiser("10 Laptops", 0, charity, taxId, false);

        await heritage.makeDonation(1, { value: 10e18, from: donor1 });
        await heritage.makeDonation(1, { value: 10e18, from: donor1 });

        const donation1Raised = (await heritage.donationRaised(1)).toNumber();
        const donation1Goal = (await heritage.donationGoal(1)).toNumber();

        donation1Raised.should.be.equal(2 * 10e18);
        donation1Goal.should.be.equal(0);
      })
      context('Constants', async () => {
        beforeEach(async () => {
          heritage = await Heritage.new(true);
          await heritage.createFundraiser("10 Laptops", 0, charity, taxId, false);
          await heritage.makeDonation(1, { value: 10e18, from: donor1 });
          await heritage.issueDonation(1, 1000, zeroAddress);
        })
        it('Has 2 created', async () => {
          const created = await heritage.totalDonationsCreated();

          created.should.be.bignumber.equal(2); // Genesis
        })
        it('Has 1 made', async () => {
          const made = await heritage.totalDonationsMade();

          made.should.be.bignumber.equal(1);
        })
        it('Has 1 issued', async () => {
          const issued = await heritage.totalDonationsIssued();

          issued.should.be.bignumber.equal(1);
        })
        it('Increments created, made and issued', async () => {
          await heritage.createFundraiser("10 Laptops", 0, charity, taxId, false);
          await heritage.makeDonation(1, { value: 10e18, from: donor1 });
          await heritage.issueDonation(1, 1000, zeroAddress);
          await heritage.createFundraiser("10 Laptops", 0, charity, taxId, false);
          await heritage.makeDonation(1, { value: 10e18, from: donor1 });
          await heritage.issueDonation(1, 1000, zeroAddress);

          const created = await heritage.totalDonationsCreated();
          const made = await heritage.totalDonationsMade();
          const issued = await heritage.totalDonationsIssued();

          created.should.be.bignumber.equal(4); // Genesis
          made.should.be.bignumber.equal(3);
          issued.should.be.bignumber.equal(3);
        })
      })
      context('User Fail Cases', async () => {
        beforeEach(async () => {
          heritage = await Heritage.new(true)
          await heritage.createFundraiser("10 Laptops", 10 * 10e18, charity, taxId, false);
        })
        it('Fails if the donation amount is zero', async () => {
          await assertRevert(heritage.makeDonation(1, { value: 0, from: creator }));
        })
        it('Fails if the donation is for the Genesis Donation', async () => {
          await assertRevert(heritage.makeDonation(0, { value: 10e18, from: creator }));
        })
        it('Fails if the donation does not exist', async () => {
          await assertRevert(heritage.makeDonation(10, { value: 10e18, from: creator }));
        })
        it('Fails if the donation has reached its goal', async () => {
          await heritage.createFundraiser("10 Laptops", 10 * 10e18, charity, taxId, false);
          await heritage.makeDonation(1, { value: 10*10e18, from: creator });
          await assertRevert(heritage.makeDonation(1, { value: 10e18, from: creator }));
        })
        it("Fails to issue a donation if issueDonationEnabled is false", async() => {
          heritageNoFiat.createFundraiser("10 Laptops", 10 * 10e18, charity, taxId, false);

          await assertRevert(heritageNoFiat.issueDonation(1, 1000, zeroAddress));
        })
        it('Fails to donate if the donation has been deleted', async() => {
          await heritage.makeDonation(1, { value: 10e18, from: creator });
          await heritage.makeDonation(2, { value: 10e18, from: donor1 })

          await heritage.deleteDonation(1);

          await assertRevert(heritage.makeDonation(1, { value: 10e18, from: creator }));
          await assertRevert(heritage.makeDonation(2, { value: 10e18, from: donor1 }));
        })
      })
    })
  })
})

