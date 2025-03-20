## **Solidity Beginner Notes**

### **1. What is Solidity?**

- Solidity is a programming language used to write **smart contracts** on the Ethereum blockchain.
- Smart contracts are like self-executing programs that run on the blockchain.

---

### **2. Basic Structure of a Solidity Contract**

A Solidity contract is like a class in other programming languages. It contains:

- **State Variables**: Store data on the blockchain.
- **Functions**: Define the behavior of the contract.
- **Events**: Log important actions.

Example:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyContract {
    // State variable
    uint256 public number;

    // Function to set the number
    function setNumber(uint256 _number) public {
        number = _number;
    }

    // Function to get the number
    function getNumber() public view returns (uint256) {
        return number;
    }
}
```

---

### **3. Data Types**

Solidity has several data types:

- **`uint`**: Positive whole numbers (e.g., `uint256`).
- **`int`**: Positive or negative whole numbers (e.g., `int256`).
- **`bool`**: `true` or `false`.
- **`address`**: Stores Ethereum addresses (e.g., `0x123...`).
- **`string`**: Text data (e.g., `"Hello"`).
- **`bytes`**: Binary data (e.g., `0x1234`).

---

### **4. State Variables**

- State variables store data permanently on the blockchain.
- They can be accessed by functions in the contract.

Example:

```solidity
uint256 public count; // State variable
```

---

### **5. Functions**

Functions define the behavior of the contract. They can:

- Read data (`view` or `pure` functions).
- Modify data (regular functions).

Example:

```solidity
function increment() public {
    count += 1; // Modify state
}

function getCount() public view returns (uint256) {
    return count; // Read state
}
```

---

### **6. Function Visibility**

- **`public`**: Can be called from anywhere.
- **`private`**: Can only be called within the contract.
- **`internal`**: Can be called within the contract and by derived contracts.
- **`external`**: Can only be called from outside the contract.

Example:

```solidity
function publicFunction() public {}
function privateFunction() private {}
function internalFunction() internal {}
function externalFunction() external {}
```

---

### **7. Events**

- Events are used to log important actions on the blockchain.
- They are cheap to use and can be listened to by external applications.

Example:

```solidity
event NumberUpdated(uint256 newNumber);

function updateNumber(uint256 _number) public {
    number = _number;
    emit NumberUpdated(_number); // Log the event
}
```

---

### **8. Modifiers**

- Modifiers are used to add conditions to functions.
- Example: Restrict access to only the owner.

Example:

```solidity
address public owner;

modifier onlyOwner() {
    require(msg.sender == owner, "Not the owner");
    _;
}

function changeOwner(address _newOwner) public onlyOwner {
    owner = _newOwner;
}
```

---

### **9. Constructor**

- A constructor is a special function that runs only once when the contract is deployed.
- It is used to initialize state variables.

Example:

```solidity
constructor() {
    owner = msg.sender; // Set the owner to the deployer
}
```

---

### **10. Payable Functions**

- Payable functions can receive Ether (ETH) along with a function call.

Example:

```solidity
function receiveEther() public payable {
    // msg.value contains the amount of Ether sent
}
```

---

### **11. Sending Ether**

- Use `transfer` or `call` to send Ether from the contract.

Example:

```solidity
function sendEther(address payable _to) public {
    _to.transfer(1 ether); // Send 1 ETH
}
```

---

### **12. Mappings**

- Mappings are like dictionaries or hash tables.
- They store key-value pairs.

Example:

```solidity
mapping(address => uint256) public balances;

function updateBalance(uint256 _amount) public {
    balances[msg.sender] = _amount;
}
```

---

### **13. Arrays**

- Arrays store multiple values of the same type.
- Can be fixed-size or dynamic.

Example:

```solidity
uint256[] public numbers; // Dynamic array
uint256[5] public fixedNumbers; // Fixed-size array
```

---

### **14. Structs**

- Structs are used to define custom data types.
- They group related data together.

Example:

```solidity
struct User {
    string name;
    uint256 age;
}

User public user;

function createUser(string memory _name, uint256 _age) public {
    user = User(_name, _age);
}
```

---

### **15. Inheritance**

- Contracts can inherit properties and functions from other contracts.

Example:

```solidity
contract Parent {
    function foo() public pure returns (string memory) {
        return "Parent";
    }
}

contract Child is Parent {
    function bar() public pure returns (string memory) {
        return "Child";
    }
}
```

---

### **16. Error Handling**

- Use `require`, `assert`, and `revert` to handle errors.

Example:

```solidity
function divide(uint256 a, uint256 b) public pure returns (uint256) {
    require(b != 0, "Cannot divide by zero");
    return a / b;
}
```

---

### **17. Importing Other Contracts**

- Use `import` to include other Solidity files.

Example:

```solidity
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
```

---

### **18. Basic Token Example**

Here’s a simple ERC20-like token contract:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyToken {
    string public name = "MyToken";
    string public symbol = "MTK";
    uint256 public totalSupply;

    mapping(address => uint256) public balances;

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply;
        balances[msg.sender] = _initialSupply;
    }

    function transfer(address _to, uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Not enough balance");
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
```

---

### **19. Gas and Optimization**

- Gas is the fee paid to run transactions on Ethereum.
- Optimize your code to use less gas:
  - Use `uint256` instead of smaller types.
  - Avoid unnecessary computations.

---

### **20. Tools for Solidity Development**

- **Remix**: Online IDE for Solidity.
- **Hardhat**: Development framework for Ethereum.
- **Metamask**: Wallet for interacting with Ethereum.

---

### **Summary**

- Solidity is used to write smart contracts on Ethereum.
- Key concepts: state variables, functions, events, mappings, structs, inheritance, and error handling.
- Practice by writing simple contracts like a token, voting system, or storage contract.

