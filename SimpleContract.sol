// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleContract {
    address public owner;
    uint256 private storedData;
    
    event DataUpdated(address indexed updater, uint256 oldValue, uint256 newValue);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor(uint256 initialValue) {
        owner = msg.sender;
        storedData = initialValue;
    }

    function setData(uint256 newValue) public onlyOwner {
        uint256 oldValue = storedData;
        storedData = newValue;
        emit DataUpdated(msg.sender, oldValue, newValue);
    }

    function getData() public view returns (uint256) {
        return storedData;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }
}
