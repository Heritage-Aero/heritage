const Factory = artifacts.require('./Factory.sol');

module.exports = async function (deployer) {
  try {
    await deployer.deploy(Factory, true);
  } catch (e) {
    console.log(e);
  }
};
