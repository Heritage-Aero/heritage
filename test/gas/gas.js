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
  const taxId = '46-0192831';
  let notary = null
  const donationsToCreate = 5;
  const zeroAddress = "0x0000000000000000000000000000000000000000";
  const genesisDonationName = "Genesis Donation";
  const oneEther = 10e17;

  beforeEach(async () => {
    notary = await Notarizer.new()
    await notary.createDonation(`Campaign-2`, 10e18, charity, taxId)
  })

  describe('Tests', () => {
    describe('Notary', async () => {
      it('Cost for creating a donation', async() => {
        let receipt = await notary.createDonation(`Campaign-2`, 10e18, charity, taxId);
        receipt = await web3.eth.getTransactionReceipt(receipt.tx);
        console.log(receipt.gasUsed)
      })
      it('Cost for making a donation', async() => {
        let receipt = await notary.makeDonation(1, { value: 10e18, from: creator });

        receipt = await web3.eth.getTransactionReceipt(receipt.tx);
        console.log(receipt.gasUsed)
      })
    })
  })
})

