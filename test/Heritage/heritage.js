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
      it('Has getFundraiser', async() => {
        const genesisFundraiser = await heritage.getFundraiser(0);
      })
      it('Has a Genesis Fundraiser.', async () => {
        const genesisFundraiser = await heritage.getFundraiser(0);

        genesisFundraiser[0].should.be.equal("Genesis Fundraiser");
        genesisFundraiser[1].should.be.equal("");
        genesisFundraiser[2].should.be.equal(zeroAddress);
        genesisFundraiser[3].should.be.bignumber.equal(0);

      });
      it('Creates a Fundraiser.', async () => {
        await heritage.createFundraiser("10 Laptops", charity, taxId);
        const genesisFundraiser = await heritage.getFundraiser(1);

        genesisFundraiser[0].should.be.equal("10 Laptops");
        genesisFundraiser[1].should.be.equal(taxId);
        genesisFundraiser[2].should.be.equal(charity);
        genesisFundraiser[3].should.be.bignumber.equal(0);

      });
      it('Issues a Donation', async() => {
        await heritage.createFundraiser("10 Laptops", charity, taxId);
        await heritage.issueDonation(1, 0, zeroAddress);

        const donation = await heritage.getDonation(1);

        donation[0].should.be.bignumber.equal(1);
        donation[1].should.be.bignumber.equal(1);
        donation[2].should.be.equal("10 Laptops");
        donation[3].should.be.bignumber.equal(0);
        donation[4].should.be.bignumber.equal(0);
        donation[5].should.be.equal(charity);
        donation[6].should.be.equal(zeroAddress);
        donation[7].should.be.equal(taxId);

      })
      it('Makes a donation', async () => {
        await heritage.createFundraiser("10 Laptops", charity, taxId);
        await heritage.makeDonation(1, {value: 10e17});

        const donation = await heritage.getDonation(1);

        donation[0].should.be.bignumber.equal(1);
        donation[1].should.be.bignumber.equal(1);
        donation[2].should.be.equal("10 Laptops");
        donation[3].should.be.bignumber.equal(10e17);
        donation[4].should.be.bignumber.equal(10e17);
        donation[5].should.be.equal(charity);
        donation[6].should.be.equal(creator);
        donation[7].should.be.equal(taxId);

        (await heritage.ownerOf(1)).should.be.equal(creator);
        (await heritage.fundraiserRaised(1)).should.be.bignumber.equal(10e17);

      });

      it('Deletes a donation', async() => {
        await heritage.createFundraiser("10 Laptops", charity, taxId);
        await heritage.makeDonation(1, { value: 10e17 });

        await heritage.deleteDonation(1);

        const donation = await heritage.getDonation(1);

        donation[0].should.be.bignumber.equal(0);
        donation[1].should.be.bignumber.equal(1);
        donation[2].should.be.equal("Genesis Fundraiser");
        donation[3].should.be.bignumber.equal(0);
        donation[4].should.be.bignumber.equal(0);
        donation[5].should.be.equal(zeroAddress);
        donation[6].should.be.equal(zeroAddress);
        donation[7].should.be.equal('');

      })

      context('Constants', async () => {
        beforeEach(async () => {
          heritage = await Heritage.new(true);
          await heritage.createFundraiser("10 Laptops", charity, taxId);
          await heritage.makeDonation(1, { value: 10e17, from: donor1 });
          await heritage.issueDonation(1, 1000, zeroAddress);
        })
        it('Has 2 created', async () => {
          const created = await heritage.totalFundraisers();

          created.should.be.bignumber.equal(2); // Genesis
        })
        it('Has 1 made', async () => {
          const made = await heritage.totalDonationsMade();

          made.should.be.bignumber.equal(1);
        })
        it('Has 2 issued', async () => {
          const issued = await heritage.totalDonationsIssued();

          issued.should.be.bignumber.equal(2); // Genesis Donation
        })
        it('Increments created, made and issued', async () => {
          await heritage.createFundraiser("10 Laptops", charity, taxId);
          await heritage.makeDonation(1, { value: 10e17, from: donor1 });
          await heritage.issueDonation(1, 1000, zeroAddress);
          await heritage.createFundraiser("10 Laptops", charity, taxId);
          await heritage.makeDonation(1, { value: 10e17, from: donor1 });
          await heritage.issueDonation(1, 1000, zeroAddress);

          const created = await heritage.totalFundraisers();
          const made = await heritage.totalDonationsMade();
          const issued = await heritage.totalDonationsIssued();

          created.should.be.bignumber.equal(4); // Genesis
          made.should.be.bignumber.equal(3);
          issued.should.be.bignumber.equal(4); // Genesis
        })
      })
      it('Tracks new fundraisers', async () => {
        await heritage.createFundraiser("1 Laptops", charity, taxId);
        await heritage.createFundraiser("2 Laptops", charity, taxId);
        await heritage.createFundraiser("3 Laptops", charity, taxId);
        await heritage.createFundraiser("4 Laptops", charity, taxId);

        const totalFundraisers = await heritage.totalFundraisers();
        totalFundraisers.should.be.bignumber.equal(5);
      })

      context('User Fail Cases', async () => {
        beforeEach(async () => {
          heritage = await Heritage.new(true)
          await heritage.createFundraiser("10 Laptops", charity, taxId);
        })
        it('Fails if the donation amount is zero', async () => {
          await assertRevert(heritage.makeDonation(1, { value: 0, from: creator }));
        })
        it('Fails if the donation is for the Genesis Donation', async () => {
          await assertRevert(heritage.makeDonation(0, { value: 10e17, from: creator }));
        })
        it('Fails if the donation does not exist', async () => {
          await assertRevert(heritage.makeDonation(10, { value: 10e17, from: creator }));
        })
        it("Fails to issue a donation if issueDonationEnabled is false", async() => {
          heritageNoFiat.createFundraiser("10 Laptops", charity, taxId);

          await assertRevert(heritageNoFiat.issueDonation(1, 1000, zeroAddress));
        })
        it('Fails to donate if the fundraiser has been deleted', async() => {
          await heritage.makeDonation(1, { value: 10e17, from: creator });
          await heritage.makeDonation(1, { value: 10e17, from: donor1 })

          await heritage.deleteFundraiser(1);

          await assertRevert(heritage.makeDonation(1, { value: 10e17, from: creator }));
          await assertRevert(heritage.makeDonation(1, { value: 10e17, from: donor1 }));
        })
      })
    })
  })
})

