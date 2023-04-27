//SPDX-License-Identifier: UNLICENSED

///@notice A basic burger shop that show cases the different solidity design patterns.

// The contract assumes that there is only one seller, and can only process one burger at 
// a time.

pragma solidity >=0.8.0 <0.9.0;

contract BurgerShop{
    uint256 public normalCost = 0.2 ether;
    uint256 public deluxCost = 0.4 ether;
    address owner;
    uint256 started = block.timestamp + 30 seconds;
    event burgerBought(address indexed _from, uint256 _cost);
    mapping(address => uint256) userRefunds;

    constructor(){
        owner = msg.sender;
    }

    //The enum here helps us to set different state, representing the state machine design
    //pattern. The state machine helps ensure that certain functions and actions are
    //executed at different stages.
    enum Stages{
        readyToOrder,
        makeBurger,
        deliverBurger
    }

    Stages public burgerShopStage = Stages.readyToOrder;
    //Modifier is used for code reusability. It helps implement guard checks.
    modifier isAtStage(Stages _stage){
        require(burgerShopStage == _stage, "Process is at wrong stage!");
        _;
    }
    modifier shouldPay(uint256 _cost){
        require(msg.value >= _cost, "Burger costs more!");
        _;
    }
    //The below modifiers are used to implement the access restriction design pattern.
    //Basically, it means that certain actions can be done only on access.
    modifier isOwner{
        require(owner == msg.sender, "You are not the owner!");
        _;
    }
    modifier shopOpen(){
        require(block.timestamp > started, "Burger shop has not opened yet!");
        _;
    }

    function buyNormalBurger() public payable shouldPay(normalCost) isAtStage(Stages.readyToOrder) shopOpen{
        updateStage(Stages.makeBurger);
        emit burgerBought(msg.sender, normalCost);
    }

    function buyDeluxBurger() public payable shouldPay(deluxCost) isAtStage(Stages.readyToOrder) shopOpen{
        updateStage(Stages.makeBurger);
        emit burgerBought(msg.sender, deluxCost);
    }


    function refund(address _to, uint256 _cost) public payable isOwner{
        require(_cost == normalCost || _cost == deluxCost, "Trying to refund wrong amount");
        require(address(this).balance >= _cost, "Not enough funds!");
        userRefunds[_to] = _cost;
    }

    function claimRefunds() public payable{
        uint256 value = userRefunds[msg.sender];
        userRefunds[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: value}("");
        require(success);
    }

    function getFunds() public view returns (uint256){
        return address(this).balance; //returns balance in the contract.
    }

    function updateStage(Stages _stage) public{
        burgerShopStage = _stage;
    }

    function madeBurger() public isAtStage(Stages.makeBurger) shopOpen{
        updateStage(Stages.deliverBurger);
    }

    function pickUpBurger() public isAtStage(Stages.deliverBurger) shopOpen{
        updateStage(Stages.readyToOrder);
    }

}