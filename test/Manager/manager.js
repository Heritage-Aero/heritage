import assertRevert, { assertError } from '../helpers/assertRevert'

const BigNumber = web3.BigNumber

const Heritage = artifacts.require('Heritage')
const Manager = artifacts.require('Manager')

require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(BigNumber))
  .should()

const expect = require('chai').expect

contract('Manager', accounts => {
  const [creator, donor1, donor2, donor3, donor4] = accounts
  const charity = "0x4f403d6dc030eb171f60d990840de3ac4527215f";
  const taxId = '46-0192831';
  let heritage = null
  let manager = null


  let heritageNoFiat = null
  const donationsToCreate = 5;
  const zeroAddress = "0x0000000000000000000000000000000000000000";
  const genesisDonationName = "Genesis Donation";
  const oneEther = 10e17;

  beforeEach(async () => {
    heritage = await Heritage.new(true)
    manager = await Manager.new(heritage.address);
    heritage.addManager(manager.address);
    await manager.batchOne();
  })

  describe('Launch Fundraisers', () => {
    it('Launched the first batch of fundraisers successfully.', async () => {
      let donation = await heritage.getDonation(50);

      donation[2].should.be.equal('50');
    });
    it('Launches the next batch of fundraisers.', async () => {
      await manager.batchTwo();
      let donation = await heritage.getDonation(60);
      donation[2].should.be.equal("60 Batch 2");
    })
  })
})

