const Heritage = artifacts.require('./Heritage.sol');

module.exports = async function (deployer) {
  try {
    await deployer.deploy(Heritage, true);
  } catch (e) {
    console.log(e);
  }
};
