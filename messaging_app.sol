// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

contract Storage {
    mapping(address => string) private keys;

    function updateKeys(address user_address, string memory new_key) public{
        keys[user_address] = new_key;
    }

    function retrieveMyKey() public view returns (string memory){
        return keys[msg.sender];
    }

    function retrieveKey(address reciever) public view returns (string memory){
         return keys[reciever];
    }
}

contract centralContract {
    address storage_address;

    constructor (address storage_address_) {
        storage_address = storage_address_;
    }

    function create_a_user(string memory public_key) public {
        Storage s = Storage(storage_address);
        s.updateKeys(msg.sender, public_key);
    }

    function get_my_public_key() public view returns (string memory){
        Storage s = Storage(storage_address);
        return s.retrieveMyKey();
    }

    function send_message(address reciever, string memory message) public {
        Reciever r = Reciever(reciever);
        r.recieve_message(message);
        // value = _n;
    }

    function get_public_key(address reciever) public view returns (string memory){
        Storage s = Storage(storage_address);
        return s.retrieveKey(reciever);
    }
}

contract Sender {
    address smart_contract_address;
    // uint256 user_id;
    string public_key;
    
    constructor (address smart_contract_address_, string memory public_key_) {
        smart_contract_address = smart_contract_address_;
        // user_id = user_id_;
        public_key = public_key_;
    }
    function create_user() public{
        centralContract c = centralContract(smart_contract_address);
        c.create_a_user(public_key);
    }
    function send_message(address reciever, string memory message) public{
        centralContract c = centralContract(smart_contract_address);
        c.send_message(reciever, message);
    }

    function get_public_key(address reciever) public view returns (string memory){
        centralContract c = centralContract(smart_contract_address);
        return c.get_public_key(reciever);
    }
}

contract Reciever {
    string message;
    address smart_contract_address;
    // uint256 user_id;
    string public_key;
    
    constructor (address smart_contract_address_, string memory public_key_) {
        smart_contract_address = smart_contract_address_;
        // user_id = user_id_;
        public_key = public_key_;
    }
    function create_user() public{
        centralContract c = centralContract(smart_contract_address);
        c.create_a_user(public_key);
    }
    function recieve_message(string memory message_) public {
        message = message_;
    }
    function get_message()  public view returns (string memory){
        return message;
    }
}
