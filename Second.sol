
// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

interface IPointManager {

    function addPoints(address, uint256) external ;


    function computePoints(uint256) external pure returns(uint256) ;
}


contract PointManager {



    address owner;
    mapping(address => uint256) public userPoints;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function addPoints(address user, uint256 points) external  {
        userPoints[user] += points;
    }

    //function changeOwner(address newOwner) external onlyOwner {
    //    owner = newOwner;
    //}
    
    function computePoint(uint256 deposit) external pure returns(uint256) {
        return deposit / 10;
    }
    /*
    
      other functions
    
    */
}




struct Account {

    address user;
    uint256 creationDate;
    uint256 balance;


}

error AccountAlreadyExists(address account);
error AccountNotAvailable(address account);
error DepositToLow(uint256 minimumDeposit, uint256 deposit);
error BalanceToLow(uint256 requestedBalance, uint256 balance);

event AccountCreated(address accountAddress);
event Deposited(address accountAddress, uint256 deposit);
event Withdrawn(address accountAddress, uint256 withdraw);

contract Bank {


    mapping(address => bool) accounts;
    mapping(address => uint256) balances;

    IPointManager private pointManager;

    constructor(address _pointManager) {
        pointManager = IPointManager(_pointManager);
    }

    function createAccount() external  {
        if(accounts[msg.sender]) {
            revert AccountAlreadyExists(msg.sender);
        }

        accounts[msg.sender] = true;

        emit AccountCreated(msg.sender);

    }

    function deposit() external payable {
        if(!accounts[msg.sender]) {
            revert AccountNotAvailable(msg.sender);
        }


        // 1000000000000000 wey is 0.01 ETH
        if(msg.value < 1000000000000000) {
            revert DepositToLow(1000000000000000, msg.value);

        }

        balances[msg.sender] += msg.value;

        pointManager.addPoints(msg.sender, pointManager.computePoints(100));
        //pointManager.addPoints(msg.sender, 5);
        emit Deposited(msg.sender, msg.value);




    }


    function withdraw(uint256 amount) external {    

        if(amount > balances[msg.sender]) {
            revert BalanceToLow(amount, balances[msg.sender]);
        }

        balances[msg.sender] -= amount;

        (bool success, ) = msg.sender.call{value: amount}("");


        require(success, "Error while transfering data");

        emit Withdrawn(msg.sender, amount);
    } 


}
