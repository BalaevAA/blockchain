pragma solidity >= 0.4 .22 < 0.9 .0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Rent.sol";

contract RentTest {
    Rent public rent;
    RentCoin public coin;

    function beforeEach() public {
        coin = new RentCoin();
        rent = new Rent(address(coin));
        coin.mint(address(this), 100);
        coin.approve(address(rent), 100);
    }

    function testRent1() public {
        uint month = 1;
        uint beforeop = coin.balanceOf(address(this));
        rent.rent(month);
        uint afterop = coin.balanceOf(address(this));
        bool result = rent.costForUser(address(this)) == rent.currentCost();
        bool result2 = beforeop == (afterop + rent.currentCost());
        assert(result);
        assert(result2);
    }

    function testRent2() public {
        uint first_month = 1;
        uint last_month = 2;
        rent.rent(first_month, last_month);
        bool result = rent.costForUser(address(this)) == rent.currentCost()*(last_month - first_month + 1);
        assert(result);
    }

    // function testRent3() public {
    //     uint month = 1;
    //     uint beforeop = coin.balanceOf(address(this));
    //     rent.rent(month);
    //     uint afterop = coin.balanceOf(address(this));
    //     bool result = beforeop == (afterop + rent.currentCost());
    //     assert(result);
    // }

    function testUnrent1() public {
        uint month = 1;
        uint beforeop = coin.balanceOf(address(this));
        rent.rent(month);
        rent.unrent();
        uint afterop = coin.balanceOf(address(this));
        bool result = afterop == beforeop;
        assert(result);
    }

    function testUnrent2() public {
        uint first_month = 1;
        uint last_month = 3;
        uint beforeop = coin.balanceOf(address(this));
        rent.rent(first_month, last_month);
        rent.unrent();
        uint afterop = coin.balanceOf(address(this));
        bool result = afterop == beforeop;
        assert(result);
    }
    
}