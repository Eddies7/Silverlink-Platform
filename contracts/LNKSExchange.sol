pragma solidity ^0.4.8;

import "./SafeMath.sol";
import './OwnableMultiple.sol';
import './LNKSToken.sol';


contract LNKSExchange is OwnableMultiple {
  using SafeMath for uint;

  struct Order {
    address buyer;
    uint amount;
  }

  LNKSToken token;
  mapping(address => bool) usedAddresses;
  Order[] orders;

  function LNKSExchange() {}

  function setTokenAddress(address _tokenAddress) public onlyOwner {
    token = LNKSToken(_tokenAddress);
  }

  event BuyDirectEvent(address _buyer, uint _amount);

  function buyDirect() public payable {
    Order memory order = Order({
      buyer: msg.sender,
      amount: msg.value
    });

    orders.push(order);
    usedAddresses[msg.sender] = true;

    BuyDirectEvent(order.buyer, order.amount);
  }

  function getOrder(uint _index) public onlyOwner returns (address, uint) {
    Order memory order = orders[_index];
    return (order.buyer, order.amount);
  }

  function approveOrder(uint _index, uint _tokensAmount, uint _fee) public onlyOwner {
    require(orders[_index].amount > 0);

    // Deduct $10 if address is never used
    if (usedAddresses[msg.sender] == false) {
      _tokensAmount = _tokensAmount.sub(_fee);
      usedAddresses[msg.sender] == true;
    }

    Order memory order = orders[_index];

    // mint tokens for the buyer
    token.mint(order.buyer, _tokensAmount);

    // remove order from orders array
    orders[_index] = orders[orders.length-1];
    orders.length--;
  }

  function getOrdersLength() public onlyOwner returns (uint) {
    return orders.length;
  }

  /*
  * Fallback function in case someone accidentally sends Ether to the contract
   */
  function() payable {}
}


  // function deleteEntity(address entityAddress) public returns(bool success) {
  //   if(!isEntity(entityAddress)) throw;
  //   uint rowToDelete = entityStructs[entityAddress].listPointer;
  //   address keyToMove   = entityList[entityList.length-1];
  //   entityList[rowToDelete] = keyToMove;
  //   entityStructs[keyToMove].listPointer = rowToDelete;
  //   entityList.length--;
  //   return true;
  // }
