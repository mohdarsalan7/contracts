// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BankContract {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lastWithdrawalTime;
    mapping(address => uint256) public lastDepositTime;
    uint256 public totalFees;
    address public owner;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount, uint256 fee);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function deposit() public payable {
        require(msg.value >= 0 ether  , "Minimum deposit is 0.01 Ether");

        if (balances[msg.sender] > 0) {
            uint256 timeElapsed = block.timestamp - lastDepositTime[msg.sender];
            uint256 interest = (balances[msg.sender] * timeElapsed * 1) / (100 * 86400);
            balances[msg.sender] += interest;
        }

        balances[msg.sender] += msg.value;
        lastDepositTime[msg.sender] = block.timestamp;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) public {
        require(_amount > 0, "Withdrawal amount must be greater than 0");
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        require(block.timestamp >= lastWithdrawalTime[msg.sender] + 1 days, "You can only withdraw once per day");

        uint256 fee = _amount / 100; // 1% fee
        uint256 amountAfterFee = _amount - fee;

        balances[msg.sender] -= _amount;
        totalFees += fee;
        lastWithdrawalTime[msg.sender] = block.timestamp;

        payable(msg.sender).transfer(amountAfterFee);
        emit Withdrawal(msg.sender, amountAfterFee);
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function withdrawFees() public onlyOwner {
        uint256 fees = totalFees;
        totalFees = 0;
        payable(owner).transfer(fees);
    }

    function transfer(address payable _to, uint256 _amount) public {
        require(_amount > 0 ether, "Transfer amount must be greater than 0");
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        uint256 fee = _amount / 100; 
        uint256 amountAfterFee = _amount - fee;
        balances[msg.sender] -= _amount;
        balances[_to] += amountAfterFee;
        totalFees += fee;
        emit Transfer(msg.sender, _to, amountAfterFee, fee);
    }
}