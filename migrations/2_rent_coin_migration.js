const RentCoin = artifacts.require("./RentCoin.sol");
const Rent = artifacts.require("./Rent.sol")


module.exports = async function(deployer) {
    await deployer.deploy(RentCoin);
    const token = await RentCoin.deployed();
    await deployer.deploy(Rent, token.address);
};