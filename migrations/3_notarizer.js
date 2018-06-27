const Notarizer = artifacts.require('./Notarizer.sol');

module.exports = async function (deployer) {
  try {
    await deployer.deploy(Notarizer);
  } catch (e) {
    console.log(e);
  }
};
