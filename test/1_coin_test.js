const Rent = artifacts.require("Rent");
const RentCoin = artifacts.require("RentCoin");

var BN = web3.utils.BN;
var Hex = web3.utils.toHex;
var Decimal = web3.utils.toDecimal;

contract("RentCoin test", async(accounts) => {

    it(`Тест exchangeEth, покупка 6 rc за 6 Eth c ${accounts[2]}`, async() => {
        const coin = await RentCoin.deployed();
        await coin.exchangeEth({ value: web3.utils.toWei('6', 'ether'), from: accounts[2] });
        let balance = await coin.getBalance(accounts[2]);
        assert.equal(Decimal(balance), 6);
    });

    it(`Удалим(сожжем) 4 коина с  ${accounts[2]}`, async() => {
        const coin = await RentCoin.deployed();
        await coin.burn(4, { from: accounts[2] });
        let balance = await coin.getBalance(accounts[2]);
        assert.equal(Decimal(balance), 2);
    });

    it(`Тест transfer, перевод 2 rc с ${accounts[2]} на ${accounts[1]}`, async() => {
        const coin = await RentCoin.deployed();
        await coin.transfer(accounts[1], 2, { from: accounts[2] })
        let balance = await coin.getBalance(accounts[1]);
        assert.equal(Decimal(balance), 2);
    });

    it(`Тест exchangeRentCoin, 1 eth за 1 rc`, async() => {
        const coin = await RentCoin.deployed();
        await coin.exchangeRentCoin(1, { from: accounts[1] });
        let balance = await coin.getBalance(accounts[1]);
        assert.equal(Decimal(balance), 1);
    });

    it(`Тест mint, выпустим 10 RentCoin на ${accounts[4]}`, async() => {
        const coin = await RentCoin.deployed();
        await coin.mint(accounts[4], 10);
        let balance = await coin.getBalance(accounts[4]);
        assert.equal(Decimal(balance), 10);
    });

});