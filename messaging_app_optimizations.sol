// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

struct Message {
    address sender;
    string content;
}

contract CentralContract {
    mapping(address => string) private keys;

    function getPublicKey(address userAddress) public view returns (string memory) {
      return keys[userAddress];
    }

    function createUser(string calldata publicKey) public {
      keys[msg.sender] = publicKey;
    }

    function deliverMessage(address receiverAddress, string memory content) external {
      User u = User(receiverAddress);
      Message memory m = Message(msg.sender, content);
      u.updateInbox(m);
    }

}


contract User {

  CentralContract private c;
  string private publicKey;
  uint8 private numberMessagesReceived;
  mapping(uint8 => Message) private inbox;

  constructor(address centralContractAddress, string memory publicKey_) {
    publicKey = publicKey_;
    c = CentralContract(centralContractAddress);
    numberMessagesReceived = 0;
  }

  function sendMessage(address reciever, string memory message) public {
    c.deliverMessage(reciever, message);
  }

  function getReceiverPublicKey(address receiverAddress) public view returns (string memory) {
    return c.getPublicKey(receiverAddress);
  }

  // can only be called by the central contract 
  function updateInbox(Message calldata message) external {
    inbox[numberMessagesReceived] = message;
    numberMessagesReceived++;
  }

  function checkInbox() internal view returns (mapping(uint8 => Message) storage) {
    return inbox;
  }


}
