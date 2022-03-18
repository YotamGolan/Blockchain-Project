// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

/** @title Storage stores user information such as public key. */
contract Storage {
    mapping(address => string) private keys;        // Hash map, key is user address, string is the public encryption key. 

    /** @dev Stores the user's public encryption key.
      * @param user_address Memory address of user. 
      * @param new_key User's public key.
      */
    function updateKeys(address user_address, string memory new_key) public{
        keys[user_address] = new_key;
    }

    /** @dev Retreives the user's public encryption key.
      * @return string Public encryption key for the given user. 
      */
    function retrieveMyKey() public view returns (string memory) {
        return keys[msg.sender];
    }

    /** @dev Retreives the user's public encryption key.
      * @param reciever Memory address of the user. 
      * @return string Public encryption key.
      */
    function retrieveKey(address reciever) public view returns (string memory) {
         return keys[reciever];
    }
}

/** @title centralContract Coordinates creating new users and sending messages between users. */
contract centralContract {
    address storage_address;    // Memory address of the deployed Storage contract. 

    /** @dev Constructor for the centralContract. 
      * @param storage_address_ Memory address of deployed storage contract. 
      */
    constructor (address storage_address_) {
        storage_address = storage_address_;
    }

    /** @dev Creates a new user and stores their public key to the deployed Storage contract. 
             Alternatively, can call this function from the Sender smart contract.
      * @param public_key Public encryption key provided by the user. 
      */
    function create_a_user(string memory public_key) public {
        Storage s = Storage(storage_address);
        s.updateKeys(msg.sender, public_key);
    }

    /** @dev Retreives the user's public encryption key.
      * @return string User's public encryption key.
      */
    function get_my_public_key() public view returns (string memory) {
        Storage s = Storage(storage_address);
        return s.retrieveMyKey();
    }

    /** @dev Sends a message to a given receiver. 
      * @param reciever Memory address of the receiver.
      * @param message Message to be sent to the receiver, should be encrypted on the sender's local machine and provided as ciphertext. 
      */
    function send_message(address reciever, string memory message) public {
        Reciever r = Reciever(reciever);        // Receiver smart contract 
        r.recieve_message(message);
    }

    /** @dev Retreives the public encryption key of a given receiver. 
      * @param reciever Memory address of the receiver. 
      * @return memory Public encryption key.
      */
    function get_public_key(address reciever) public view returns (string memory){
        Storage s = Storage(storage_address);
        return s.retrieveKey(reciever);
    }
}

/** @title Sender smart contract. */
contract Sender {

    address smart_contract_address;
    string public_key;
    
    /** @dev Constructor for the Sender smart contract. 
      * @param smart_contract_address_ memory address for the central contract. 
      * @param public_key_ encryption key for the user.  
      */
    constructor (address smart_contract_address_, string memory public_key_) {
        smart_contract_address = smart_contract_address_;
        public_key = public_key_;
    }

    /** @dev Simulates the users asking to create an account. 
             Alternatively, can call this from the Central Contract. 
    */
    function create_user() public {
        centralContract c = centralContract(smart_contract_address);
        c.create_a_user(public_key);
    }

    /** @dev Calls the central contract to then send a message to a given receiver.
      * @param reciever Memory address of the receiver.
      * @param message Message to be sent. 
      */
    function send_message(address reciever, string memory message) public {
        centralContract c = centralContract(smart_contract_address);
        c.send_message(reciever, message);
    }

    /** @dev Retreives the public encryption key from 
      * @param reciever Memory address of the receiver. 
      * @return Public key. 
      */
    function get_public_key(address reciever) public view returns (string memory) {
        centralContract c = centralContract(smart_contract_address);
        return c.get_public_key(reciever);
    }
}

/** @title Receiver smart contract that coordinates receiving messages. */
contract Reciever {
    string message;
    address smart_contract_address;
    string public_key;
    
    constructor (address smart_contract_address_, string memory public_key_) {
        smart_contract_address = smart_contract_address_;
        public_key = public_key_;
    }

    /** @dev Simulates the users asking to create an account. 
             Alternatively, can call this from the Central Contract. 
    */
    function create_user() public{
        centralContract c = centralContract(smart_contract_address);
        c.create_a_user(public_key);
    }

    /** @dev Receives the message. This is typically called from the Sender or Central Contract. 
      * @param message_ Message for the user. 
      */
    function recieve_message(string memory message_) public {
        message = message_;
    }

    /** @dev Gets the message associated with the receiver. 
      */
    function get_message()  public view returns (string memory) {
        return message;
    }
}
