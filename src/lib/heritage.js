require('babel-core/register');
require('babel-polyfill');

import TruffleContract from 'truffle-contract';
import abi from '../../build/contracts/Heritage';

export class HeritageJS {
    constructor(config) {
        if (typeof web3 !== 'undefined') {
            // Use MetaMask's provider
            this.web3 = new window.Web3(window.web3.currentProvider);
        } else {
            // End the script
            return;
        }

        this.defaultConfig = {
            provider: this.web3.currentProvider,
            contractAddress: abi.networks[4447].address,
            donationId: 'donationid',
            amount: 'amount',
            btnClass: 'btn-heritage',
            className: 'heritage-dapp',
            wireHtml: true,
            abi
        };

        this.config = Object.assign({}, this.defaultConfig, config);
    }

    async init() {
        const contract = TruffleContract(this.config.abi);
        const provider = this.web3.currentProvider;

        contract.setProvider(provider);
        this.heritage = await contract.deployed();

        this.config.wireHtml ? await this.wireHtml() : null;

        return this;
    }

    async wireHtml() {
        this.buttons = [].slice.call(document.getElementsByClassName(this.config.btnClass));

        const self = this;
        this.buttons.forEach(btn => {
            console.log(btn.dataset[this.config.donationId])
            const donationId = btn.dataset[this.config.donationId];
            const amount = btn.dataset[this.config.amount];

            btn.addEventListener('click', async () => {
                await self._makeDonation(donationId, amount*10e17);
            })
        })
    }

    approve(to, tokenId, cb) {
        this._approve(to, tokenId).then((success) => {
            return cb(null, true);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _approve(to, tokenId) {
        return await this.heritage.approve(to, tokenId, {from: this.web3.eth.accounts[0]});
    }

    approvedFor(tokenId, cb) {
        this._approvedFor(tokenId).then((success) => {
            return cb(null, true);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _approvedFor(tokenId) {
        return await this.heritage.approvedFor(tokenId, {from: this.web3.eth.accounts[0]});
    }

    createFundraiser(description, goal, beneficiary, taxid, claimable, cb) {
        this._createFundraiser(description, goal, beneficiary, taxid, claimable).then((txid) => {
            return cb(null, txid);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _createFundraiser(description, goal, beneficiary, taxid, claimable) {
        return await this.heritage.createFundraiser(description, goal, beneficiary, taxid, claimable, {
            from: this.web3.eth.accounts[0]
        });
    }

    createDAIFundraiser(description, goal, beneficiary, taxid, claimable, cb) {
        this._createDAIFundraiser(description, goal, beneficiary, taxid, claimable).then((txid) => {
            return cb(null, txid);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _createDAIFundraiser(description, goal, beneficiary, taxid, claimable) {
        return await this.heritage.createDAIFundraiser(description, goal, beneficiary, taxid, claimable, {
            from: this.web3.eth.accounts[0]
        });
    }

    createFundraiserProxy(donationId, cb) {
        this._createFundraiserProxy(donationId).then((txid) => {
            return cb(null, txid);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _createFundraiserProxy(donationId) {
        return await this.heritage.createFundraiserProxy(donationId, {
            from: this.web3.eth.accounts[0]
        });
    }

    makeDonation(donationId, amount, cb) {
        this._makeDonation(donationId, amount).then((txid) => {
            return cb(null, txid);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _makeDonation(donationId, amount) {
        console.log(donationId)
        console.log(amount)
        return await this.heritage.makeDonation(donationId, {
            from: this.web3.eth.accounts[0],
            value: amount
        });
    }

    makeDAIDonation(donationId, amount, cb) {
        this._makeDAIDonation(donationId, amount).then((txid) => {
            return cb(null, txid);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _makeDAIDonation(donationId, amount) {
        return await this.heritage.makeDAIDonation(donationId, amount, {
            from: this.web3.eth.accounts[0]
        });
    }


    issueDonation(donationId, amount, donor, cb) {
        this._issueDonation(donationId, amount, donor).then((txid) => {
            return cb(null, txid);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _issueDonation(donationId, amount, donor) {
        return await this.heritage.issueDonation(donationId, amount, donor, {
            from: this.web3.eth.accounts[0]
        });
    }

    claimDonation(donationId, cb) {
        this._claimDonation(donationId).then((txid) => {
            return cb(null, txid);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _claimDonation(donationId) {
        return await this.heritage.claimDonation(donationId, {
            from: this.web3.eth.accounts[0]
        });
    }

    deleteDonation(donationId, cb) {
        this._deleteDonation(donationId).then((txid) => {
            return cb(null, txid);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _deleteDonation(donationId) {
        return await this.heritage.deleteDonation(donationId, {
            from: this.web3.eth.accounts[0]
        });
    }

    getDonation(donationId, cb) {
        this._getDonation(donationId).then((donation) => {
            return cb(null, donation);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _getDonation(donationId) {
        return await this.heritage.getDonation(donationId);
    }

    getToken(tokenId, cb) {
        this._getToken(tokenId).then((token) => {
            return cb(null, token);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _getToken(tokenId) {
        return await this.heritage.getToken(tokenId);
    }

    getCertificate(campaignId, tokenId, cb) {
        this._getCertificate(campaignId, tokenId).then((token) => {
            return cb(null, token);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _getCertificate(campaignId, tokenId) {
        return await this.heritage.getCertificate(campaignId, tokenId);
    }

    readyCampaign(campaignId, cb) {
        this._readyCampaign(campaignId).then((token) => {
            return cb(null, token);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _readyCampaign() {
        return await this.heritage.readyCampaign();
    }

    activateCampaign(campaignId, cb) {
        this._activateCampaign(campaignId).then((token) => {
            return cb(null, token);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _activateCampaign(campaignId) {
        return await this.heritage.activateCampaign();
    }

    vetoCampaign(campaignId, cb) {
        this._vetoCampaign(campaignId).then((token) => {
            return cb(null, token);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _vetoCampaign(campaignId) {
        return await this.heritage.vetoCampaign(campaignId);
    }

    changeEscrowAmount(newAmount, cb) {
        this._changeEscrowAmount(newAmount).then((token) => {
            return cb(null, token);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _changeEscrowAmount(newAmount) {
        return await this.heritage.vetoCampaign(newAmount);
    }

    pause(cb) {
        this._pause().then((token) => {
            return cb(null, token);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _pause() {
        return await this.heritage.pause();
    }

    owner(cb) {
        this._owner().then((owner) => {
            return cb(null, owner);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _owner() {
        return await this.heritage.owner();
    }



    isManager(address, cb) {
        this._isManager(address).then((isMan) => {
            return cb(null, isMan);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _isManager(address) {
        return await this.heritage.isManager(address);
    }


    addManager(address, cb) {
        this._addManager(address).then((receipt) => {
            return cb(null, receipt);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _addManager(address) {
        return await this.heritage.addManager(address);
    }




    unpause(cb) {
        this._unpause().then((token) => {
            return cb(null, token);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _unpause() {
        return await this.heritage.unpause();
    }

    totalCampaigns(cb) {
        this._totalCampaigns().then((total) => {
            return cb(null, total);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _totalCampaigns() {
        return await this.heritage.totalCampaigns();
    }

    withdrawCampaignBalance(cb) {
        this._withdrawCampaignBalance().then((total) => {
            return cb(null, total);
        }).catch((e) => {
            return cb(e);
        });
    }

    async _withdrawCampaignBalance() {
        return await this.heritage.withdrawCampaignBalance();
    }
}
