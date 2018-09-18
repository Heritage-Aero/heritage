import assertRevert, { assertError } from '../helpers/assertRevert'

const BigNumber = web3.BigNumber

const StandardTokenMock = artifacts.require('StandardTokenMock')
const Heritage = artifacts.require('Heritage')

require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(BigNumber))
  .should()

const expect = require('chai').expect

contract('DAI Transactions', accounts => {
  const [creator, donor1, donor2, donor3, charity1] = accounts;
  let heritage = null;
  let erc20 = null;
  const tokenSupply = 1000;
  const zeroAddress = "0x0000000000000000000000000000000000000000";
  const oneEther = 10e17;

  beforeEach(async () => {
    erc20 = await StandardTokenMock.new(creator, tokenSupply);
    heritage = await Heritage.new(false);
  })

  context('Claimable ERC20', async () => {
    beforeEach(async () => {
      await heritage.createDAIFundraiser("Claimable DAI Donation Description", 1000, charity1, "14-123412", true);
      await heritage.changeDaiAddress(erc20.address);
    })
    it('Makes a DAI donation, then claims the token', async () => {
      // Approve the heritage contract to transfer the DAI.
      await erc20.approve(heritage.address, 10);
      await heritage.makeDAIDonation(1, 10);
      await heritage.claimDonation(2);
    })
    it('Makes a DAI donation, then trades the token, then the new owner claims the token, trades back, fails to claim', async () => {
      // Approve the heritage contract to transfer the DAI.
      await erc20.approve(heritage.address, 10);
      await heritage.makeDAIDonation(1, 10);

      await heritage.transferFrom(creator, donor1, 2);
      await heritage.claimDonation(2, {from: donor1});

      await heritage.transferFrom(donor1, creator, 2, {from: donor1});
      await assertRevert(heritage.claimDonation(2));
    })
  })

  context('Claimable ETH', async () => {
    beforeEach(async () => {
      await heritage.createFundraiser("Claimable Donation Description", 1000, charity1, "14-123412", true);
    })
    it('Makes a donation, then claims the token', async () => {
      await heritage.makeDonation(1, {value: 100});
      await heritage.claimDonation(2);
    })
    it('Makes a donation, then trades the token, then the new owner claims the token, trades back, fails to claim', async () => {
      await heritage.makeDonation(1, { value: 100 });
      await heritage.transferFrom(creator, donor1, 2);
      await heritage.claimDonation(2, { from: donor1 });

      await heritage.transferFrom(donor1, creator, 2, { from: donor1 });
      await assertRevert(heritage.claimDonation(2));
    })
  })
})

