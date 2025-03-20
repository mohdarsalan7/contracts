## **Solidity Expert Notes**

### **1. Advanced Data Types**

#### **1.1. Fixed-Point Numbers**

- Solidity does not natively support fixed-point numbers, but you can simulate them using libraries like `ABDKMath64x64`.

#### **1.2. Bytes and Byte Manipulation**

- Use `bytes` for low-level byte manipulation.
- Example:
  ```solidity
  bytes32 public data = "Hello";
  function getFirstByte() public view returns (bytes1) {
      return data[0];
  }
  ```

---

### **2. Advanced Function Types**

#### **2.1. Function Selectors**

- Function selectors are the first 4 bytes of the Keccak-256 hash of the function signature.
- Example:
  ```solidity
  function getSelector() public pure returns (bytes4) {
      return bytes4(keccak256("transfer(address,uint256)"));
  }
  ```

#### **2.2. Fallback and Receive Functions**

- **`fallback`**: Executed when a non-existent function is called or Ether is sent with no data.
- **`receive`**: Executed when Ether is sent with no data.
- Example:

  ```solidity
  fallback() external payable {
      // Handle fallback calls
  }

  receive() external payable {
      // Handle plain Ether transfers
  }
  ```

---

### **3. Advanced Modifiers**

#### **3.1. Parameterized Modifiers**

- Modifiers can accept parameters for more flexibility.
- Example:

  ```solidity
  modifier onlyIf(bool condition) {
      require(condition, "Condition not met");
      _;
  }

  function doSomething(bool _condition) public onlyIf(_condition) {
      // Function logic
  }
  ```

#### **3.2. Modifier Order**

- Modifiers are executed in the order they are applied.
- Example:
  ```solidity
  function example() public modifier1 modifier2 {
      // Function logic
  }
  ```

---

### **4. Gas Optimization Techniques**

#### **4.1. Use `uint256` and `int256`**

- Smaller types like `uint8` or `uint16` can increase gas costs due to packing and unpacking.

#### **4.2. Minimize Storage Writes**

- Storage operations are expensive. Use memory or stack variables whenever possible.

#### **4.3. Batch Operations**

- Combine multiple operations into a single transaction to save gas.

#### **4.4. Use `external` for Public Functions**

- `external` functions are cheaper than `public` functions when called externally.

---

### **5. Advanced Error Handling**

#### **5.1. Custom Errors**

- Use custom errors for gas-efficient reverts.
- Example:

  ```solidity
  error InsufficientBalance(uint256 available, uint256 required);

  function withdraw(uint256 _amount) public {
      if (balances[msg.sender] < _amount) {
          revert InsufficientBalance(balances[msg.sender], _amount);
      }
      // Withdraw logic
  }
  ```

#### **5.2. `try`/`catch` for External Calls**

- Handle failures in external calls using `try`/`catch`.
- Example:
  ```solidity
  function callExternal(address _contract) public {
      try IExternalContract(_contract).someFunction() {
          // Success
      } catch Error(string memory reason) {
          // Handle revert with a reason string
      } catch (bytes memory) {
          // Handle other reverts
      }
  }
  ```

---

### **6. Advanced Contract Interactions**

#### **6.1. Delegatecall**

- `delegatecall` allows a contract to execute code from another contract in its own context.
- Example:

  ```solidity
  contract Library {
      function setNumber(uint256 _number) public {
          // Logic to set number
      }
  }

  contract Main {
      uint256 public number;
      function delegateCall(address _library, uint256 _number) public {
          (bool success, ) = _library.delegatecall(
              abi.encodeWithSignature("setNumber(uint256)", _number)
          );
          require(success, "Delegatecall failed");
      }
  }
  ```

#### **6.2. Proxy Patterns**

- Use proxy patterns for upgradeable contracts.
- Example: Transparent Proxy or UUPS Proxy.

---

### **7. Advanced Events**

#### **7.1. Indexed Event Parameters**

- Use `indexed` for event parameters to make them searchable in logs.
- Example:
  ```solidity
  event Transfer(address indexed from, address indexed to, uint256 value);
  ```

#### **7.2. Low-Level Logs**

- Use `assembly` to emit low-level logs.
- Example:
  ```solidity
  function emitLog(bytes32 data) public {
      assembly {
          log1(0, 0, data)
      }
  }
  ```

---

### **8. Advanced Inheritance**

#### **8.1. Multiple Inheritance**

- Solidity supports multiple inheritance. Use `super` to call functions from parent contracts.
- Example:

  ```solidity
  contract A {
      function foo() public pure returns (string memory) {
          return "A";
      }
  }

  contract B {
      function foo() public pure returns (string memory) {
          return "B";
      }
  }

  contract C is A, B {
      function callFoo() public pure returns (string memory) {
          return super.foo(); // Calls B.foo()
      }
  }
  ```

#### **8.2. Abstract Contracts**

- Abstract contracts cannot be deployed and must be inherited.
- Example:
  ```solidity
  abstract contract Token {
      function transfer(address to, uint256 amount) public virtual;
  }
  ```

---

### **9. Advanced Security Practices**

#### **9.1. Reentrancy Guard**

- Use `ReentrancyGuard` to prevent reentrancy attacks.
- Example:

  ```solidity
  import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

  contract MyContract is ReentrancyGuard {
      function withdraw() public nonReentrant {
          // Withdraw logic
      }
  }
  ```

#### **9.2. Checks-Effects-Interactions Pattern**

- Always follow the Checks-Effects-Interactions pattern to avoid vulnerabilities.
- Example:
  ```solidity
  function withdraw(uint256 _amount) public {
      require(balances[msg.sender] >= _amount, "Insufficient balance");
      balances[msg.sender] -= _amount; // Effects
      payable(msg.sender).transfer(_amount); // Interactions
  }
  ```

---

### **10. Advanced Tools and Libraries**

#### **10.1. OpenZeppelin**

- Use OpenZeppelin for secure and gas-optimized implementations of common patterns (e.g., ERC20, ERC721).

#### **10.2. Hardhat**

- Use Hardhat for advanced development, testing, and deployment.

#### **10.3. Foundry**

- Foundry is a fast and flexible toolkit for Ethereum development, including testing with Solidity.

---

### **11. Advanced Testing**

#### **11.1. Fuzz Testing**

- Use fuzz testing to test edge cases.
- Example (Foundry):
  ```solidity
  function testFuzz(uint256 x) public {
      assert(x + 1 > x);
  }
  ```

#### **11.2. Property-Based Testing**

- Test invariants and properties of your contract.
- Example:
  ```solidity
  function testInvariant() public {
      assert(totalSupply == balances[owner]);
  }
  ```

---

### **12. Advanced Gas Optimization**

#### **12.1. Inline Assembly**

- Use `assembly` for low-level optimizations.
- Example:
  ```solidity
  function add(uint256 x, uint256 y) public pure returns (uint256) {
      assembly {
          let result := add(x, y)
          mstore(0x0, result)
          return(0x0, 32)
      }
  }
  ```

#### **12.2. Storage Packing**

- Pack multiple variables into a single storage slot to save gas.
- Example:
  ```solidity
  struct Packed {
      uint64 a;
      uint64 b;
      uint128 c;
  }
  Packed public packed;
  ```

---

### **13. Advanced Patterns**

#### **13.1. Factory Pattern**

- Use factory contracts to deploy other contracts.
- Example:
  ```solidity
  contract Factory {
      function createContract() public returns (address) {
          MyContract newContract = new MyContract();
          return address(newContract);
      }
  }
  ```

#### **13.2. Diamond Pattern**

- Use the Diamond Pattern for modular and upgradeable contracts.

---

### **14. Advanced Debugging**

#### **14.1. Console Logging**

- Use `console.log` in Hardhat for debugging.
- Example:

  ```solidity
  import "hardhat/console.sol";

  function debug() public {
      console.log("Debugging...");
  }
  ```

#### **14.2. Tenderly**

- Use Tenderly for advanced debugging and monitoring.

---

### **Summary**

- Master advanced data types, function types, and modifiers.
- Optimize gas usage and follow security best practices.
- Use advanced tools like OpenZeppelin, Hardhat, and Foundry.
- Implement advanced patterns like Factory and Diamond.
