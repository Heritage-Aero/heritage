import assertRevert, { assertError } from '../helpers/assertRevert'

const BigNumber = web3.BigNumber

const Managed = artifacts.require('ManagedMock')

require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(BigNumber))
  .should()

const expect = require('chai').expect

contract('Managed', accounts => {
  const [creator, mgr1, mgr2, mgr3, user] = accounts
  let managed = null
  const zeroAddress = "0x0000000000000000000000000000000000000000";

  beforeEach(async () => {
    managed = await Managed.new()
  })

  describe('Tests', () => {
    beforeEach(async () => {
      await managed.addManager(mgr1);
    })

    describe('Mock', async () => {
      it('Has a contract owner.', async () => {
        const owner = await managed.owner();

        owner.should.be.equal(creator);
      });
      it('Contract owner is the default manager.', async () => {
        const isManager = await managed.isManager(creator);
        isManager.should.be.equal(true);
      });
      it('User is not a manager.', async () => {
        const isManager = await managed.isManager(user);
        isManager.should.be.equal(false);
      });
      it('Contract owner adds a new manager', async () => {
        let receipt = await managed.addManager(mgr2);
        receipt = await web3.eth.getTransactionReceipt(receipt.tx);
        // console.log(receipt.gasUsed)
        const isManager = await managed.isManager(mgr2);
        isManager.should.be.equal(true);
      });
      it('Contract owner removes a manager', async () => {
        let receipt = await managed.removeManager(mgr1);
        receipt = await web3.eth.getTransactionReceipt(receipt.tx);
        // console.log(receipt.gasUsed)
        const isManager = await managed.isManager(mgr1);
        isManager.should.be.equal(false);
      });
      it('Manager calls a managersOnly function', async () => {
        await managed.managersOnly({from: mgr1});
      });

      context('Owner Fail Cases', async () => {
        it('User cannot add a new manager', async () => {
          await assertRevert(managed.addManager(mgr2, {from: user}));
        });
      })

      context('Non-Manager Fail Cases', async () => {
        it('Non-Manager calls a managersOnly function and fails', async () => {
          await assertRevert(managed.managersOnly({ from: user }))
        })
      })

    })
  })
})

