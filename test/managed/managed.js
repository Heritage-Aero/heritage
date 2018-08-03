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
        const txReceipt = await managed.addManager(mgr2);
        const receipt = await web3.eth.getTransactionReceipt(txReceipt.tx);

        const isManager = await managed.isManager(mgr2);
        isManager.should.be.equal(true);

        const logs = txReceipt.logs[0];

        logs.event.should.be.equal('AddManager');
        logs.args.manager.should.be.equal(mgr2);
      });
      it('Contract owner removes a manager', async () => {
        const txReceipt = await managed.removeManager(mgr1);
        const receipt = await web3.eth.getTransactionReceipt(txReceipt.tx);

        const isManager = await managed.isManager(mgr1);
        isManager.should.be.equal(false);

        const logs = txReceipt.logs[0];

        logs.event.should.be.equal('RemoveManager');
        logs.args.manager.should.be.equal(mgr1);
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

