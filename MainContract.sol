/*  Задача:

    Разработать смартконтракт, который:
     - hardCap = 10 000 ETH;
     - выпускает токены на сумму hardCap, по цене 0.01 ETH за токен;
    - с использованием стандартов Zeppelin
    - токены эмитируются в момент перевода ETH на кошелек контракта
    - должна присудствовать возможность сжигания токена с обновляемой логикой
*/

pragma solidity ^0.4.18;

/*
  Импортируем набор стандартных контрактов и инструментов:
    https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
    https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
    https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20.sol
    https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20Basic.sol
    https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/BasicToken.sol
    https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/StandardToken.sol
    https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/BurnableToken.sol
*/

import  "./ht_token.sol";

contract BestEvertToken is BurnableToken, Ownable {
    string public name = "Best Ever Token";   // Название токена
    string public symbol = "BET";             // Короткое Название
    uint8 public constant decimals = 18;      // Количество знаков после запятой

    uint256 public totalSupply = 0;           // Общая эмиссия
    uint256 public hardCap = 10000 * 1 ether; // Максимальое количество привлекаемых ETH
    
    uint256 public tokenCost = 0.001 * 1 ether; // Цена токена: 1 BET = 0.001 ETH
    
    using SafeMath for uint;
    using SafeMath for uint256;
    
    // адрес агентсткого контракта
    address private SalesAgent = 0x0;
    
    modifier isSalesAgent(address _salesAgent) {
        assert(SalesAgent == _salesAgent);
        _;
    }
    
    // задаем адрес агента
    function setSalesAgentAddr(address _salesAgent) onlyOwner returns (bool) {
        SalesAgent = _salesAgent;
        return true;
    }
    
    event Mint(address indexed to, uint256 amount);
    
    // функция для эмиссии
    function mint(address _to, uint256 _amount) isSalesAgent(msg.sender) public returns (bool) {
        require(totalSupply + _amount > totalSupply && _amount > 0 && totalSupply + _amount <= hardCap);
        
        totalSupply = totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        Mint(_to, _amount);
        Transfer(address(0), _to, _amount);
        return true;
    }
}
