pragma solidity ^0.4.18;

contract SalesAgent {
    address RootContract = 0x1439818dd11823c45fff01af0cd6c50934e27ac0; // адрес основного контракта
    
    event Invest (address indexed _from, uint256 _value); // событие о покупке токенов
    
    function invest () payable {
        uint256 tokens = msg.value * 100; // количество токенов, 100 tokens == 1 ether
        
        // вызов функции основного контракта, которая фактическеи обменивает эфир на токен
        assert(RootContract.call("mint", msg.sender, tokens) == true);
        Invest(msg.sender, tokens);
    }
}
