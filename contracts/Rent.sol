// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./RentCoin.sol";

contract Rent {
    
    address private owner;
    uint private cost;
    bool[] private reserved_months;
    address[] private tenants;
    RentCoin private token;
    mapping (address => uint256) public costForUser;


    constructor(address _token) public{
        cost = 1;
        owner = msg.sender;
        reserved_months = new bool[](12);
        tenants = new address[](12);
        token = RentCoin(_token);
    }

    modifier isOwner() {
        require(
            msg.sender == owner,
            "Only owner can do it!"
        );
        _;
    }

    modifier isCorrect(uint _startMonth, uint _lastMonth) {
        require(
           _lastMonth - _startMonth >= 0,
           'Not correct months'
        );
        _;
    }

    modifier isReservedBy() {
        bool isReserved = false;
        for(uint i = 0; i < tenants.length; i++) {
            if(tenants[i] == msg.sender) {
                isReserved = true;
                break;
            }
        }
        require(isReserved, 'Is not reserved by sender');
        _;
    }

    event Rented(address tenant, uint start_month, uint last_month); 
    event RentDenied(address tenant, uint start_month, uint last_month);
    event OwnerChanged(address new_owner);
    event Unrented(address tenant);

    function isNotReserved(uint _startMonth, uint _lastMonth) private view returns(bool){
        for(uint i = _startMonth; i <= _lastMonth; i++) {
            if(reserved_months[i - 1]) {
                return false;
            } 
        }
        return true;
    }

    function rent(uint _month) external payable returns(uint price) {
        require( cost <= token.getAllowed(msg.sender, address(this)), "Allow withdraw first");
        if(isNotReserved(_month, _month)) {
            token.burnFrom(msg.sender, cost);
            reserved_months[_month - 1] = true;
            costForUser[msg.sender] = cost;
            tenants[_month - 1] = msg.sender;
            emit Rented(msg.sender, _month, _month);
            return cost;
        }
        emit RentDenied((msg.sender), _month, _month);
        return 0;
    }

    function rent(uint _startMonth, uint _lastMonth) external payable isCorrect(_startMonth, _lastMonth) returns(uint) {
        //require( cost*(_lastMonth - _startMonth) <= token.getAllowed(msg.sender, address(this)), "Allow withdraw first");
        if(isNotReserved(_startMonth, _lastMonth)) {
            uint price = cost * uint(_lastMonth - _startMonth + 1);
            token.burnFrom(msg.sender, price);
            for (uint i = _startMonth; i <= _lastMonth; i++) {
                reserved_months[i - 1] = true;
                tenants[i - 1] = msg.sender;
            }
            costForUser[msg.sender] = price;
            emit Rented(msg.sender, _startMonth, _lastMonth);
            return price;
        } else {
            emit RentDenied(msg.sender, _startMonth, _lastMonth);
            return 0;
        }
    }

    function unrent() public isReservedBy(){
        for(uint i = 0; i < tenants.length; i++) {
            if(tenants[i] == msg.sender) {
                tenants[i] = address(0);
                reserved_months[i] = false;
            }
        }
        token.mint(msg.sender, costForUser[msg.sender]);
        costForUser[msg.sender] = 0;
        emit Unrented(msg.sender);
    }

    function changeCost(uint _new_cost) public isOwner {
        cost = _new_cost;
    }

    function currentCost() public view returns(uint) {
        return cost;
    }

    function changeOwner(address _new_owner) public isOwner() {
        owner = _new_owner;
        emit OwnerChanged(_new_owner);
    }
    
    function reset() public isOwner() {
        cost = 100;
        reserved_months = new bool[](12);
        tenants = new address[](12);
    }
}