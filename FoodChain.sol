// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FoodSupplyChain {
    struct Product {
        uint256 id;
        string name;
        string originFarm;
        string manufacturer;
        string distributor;
        string retailer;
        uint256 timestamp;
    }

    mapping(uint256 => Product) public products;
    uint256 public productCount;

    event ProductAdded(
        uint256 id,
        string name,
        string originFarm,
        string manufacturer,
        string distributor,
        string retailer,
        uint256 timestamp
    );

    function addProduct(
        uint256 _id,
        string memory _name,
        string memory _originFarm,
        string memory _manufacturer,
        string memory _distributor,
        string memory _retailer
    ) public {
        productCount++;
        products[_id] = Product(
            _id,
            _name,
            _originFarm,
            _manufacturer,
            _distributor,
            _retailer,
            block.timestamp
        );
        emit ProductAdded(
            _id,
            _name,
            _originFarm,
            _manufacturer,
            _distributor,
            _retailer,
            block.timestamp
        );
    }

    function getProduct(uint256 _id) public view returns (
        uint256,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        uint256
    ) {
        Product memory product = products[_id];
        return (
            product.id,
            product.name,
            product.originFarm,
            product.manufacturer,
            product.distributor,
            product.retailer,
            product.timestamp
        );
    }
}