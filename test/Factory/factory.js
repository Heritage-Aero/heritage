import assertRevert, { assertError } from '../helpers/assertRevert'

const BigNumber = web3.BigNumber

const Factory = artifacts.require('Factory')
const Heritage = artifacts.require('Heritage')

require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(BigNumber))
  .should()

const expect = require('chai').expect

contract('Factory Tests', accounts => {
  const [creator, donor1, donor2, donor3, donor4] = accounts
  let factory = null

  const zeroAddress = "0x0000000000000000000000000000000000000000";
  const oneEther = 10e17;

  beforeEach(async () => {
    factory = await Factory.new()
  })

  describe('Tests', () => {
    it('Exist and has no contracts', async() => {
      const totalContracts = await factory.totalContracts();

      totalContracts.should.be.bignumber.equal(0);
    })
    it('Launches a new contract, sets the owner', async() => {
      await factory.createContract(false, {from: donor4});
      const totalContracts = await factory.totalContracts();

      totalContracts.should.be.bignumber.equal(1);
      (await Heritage.at(await factory.contracts(0)).owner()).should.be.equal(donor4);
    })

  })
})

