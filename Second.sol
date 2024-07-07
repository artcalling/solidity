
// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

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

    function addPoints(address user, uint256 points) external onlyOwner {
        userPoints[user] += points;
    }

    function changeOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }
    
    /*
    
      other functions
    
    */
}
