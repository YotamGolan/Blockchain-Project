// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Storage {
    mapping(address => string) private keys;

    function updateKeys(string memory new_key) public{
        keys[msg.sender] = new_key;
    }

    function retrieveMyKey() public view returns (string memory){
        return keys[msg.sender];
    }

    function retrieveKey(address reciever) public view returns (string memory){
         return keys[reciever];
    }
}
