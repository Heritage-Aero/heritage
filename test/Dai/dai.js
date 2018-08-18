import assertRevert, { assertError } from '../helpers/assertRevert'

const BigNumber = web3.BigNumber

const StandardTokenMock = artifacts.require('StandardTokenMock')
const Heritage = artifacts.require('Heritage')

require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(BigNumber))
  .should()

const expect = require('chai').expect

contract('Heritage', accounts => {
  const [creator, donor1, donor2, donor3, charity1] = accounts;
  let heritage = null;
  let erc20 =null;
  const DAIAddr = "0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359";
  const tokenSupply = 1000;
  const zeroAddress = "0x0000000000000000000000000000000000000000";
  const oneEther = 10e17;

  beforeEach(async () => {
    erc20 = await StandardTokenMock.new(creator, tokenSupply);
    heritage = await Heritage.new(false);

    await heritage.createDAIDonation("Donation Description", 1000, charity1, "14-123412");
  })

  describe('Tests', () => {
    it('Creator has an ERC20 balance', async () => {
      const balance = await erc20.balanceOf(creator);
      balance.should.be.bignumber.equal(tokenSupply);
    });
    it('Has an ERC20 donation', async () => {
      const donation = await heritage.getDonation(1);
      const isDai = await heritage.isDai(1);

      isDai.should.be.equal(true);
    });
    it('Changes the ERC20 token address', async () => {
      let daiAddr = await heritage.dai();
      daiAddr.toUpperCase().should.be.equal(DAIAddr.toUpperCase());

      await heritage.changeDaiAddress(erc20.address);
      daiAddr = await heritage.dai();
      daiAddr.should.be.equal(erc20.address);
    })
    it('Makes an ERC20 donation', async () => {
      await heritage.changeDaiAddress(erc20.address);
      // Approve the heritage contract to transfer the DAI.
      await erc20.approve(heritage.address, 10);
      await heritage.makeDAIDonation(1, 10);
    })
    it('Fails to donate Eth to the DAI donation', async () => {
      await assertRevert(heritage.makeDonation(1, { value: 10e18 }));
    });
  })
})

