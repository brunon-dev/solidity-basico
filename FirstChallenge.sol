// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

library SafeMath {

    // função que soma 2 valores e retorna o resultado
    // usa a palavra reservada "pure" pois não consulta e nem altera valores na Blockchain
    function sum(uint a, uint b) internal pure returns(uint) {
        uint c = 0;
        // a partir da versão 0.8.0 o revert de overflow e
        // underflow é feito por default - necessário usar
        // o "unchecked" na operação
        unchecked {
            c = a + b;
        }

        // validação para garantir que não houve um overflow
        require(c >= a, "Sum Overflow!");

        return c;
    }

    // função que subtrai 2 valores e retorna o resultado
    function sub(uint a, uint b) internal pure returns(uint) {
        require(b <= a, "Sub Underflow!");
        uint c = a - b;
        return c;
    }

    // função que multiplica 2 valores e retorna o resultado
    function mul(uint a, uint b) internal pure returns(uint) {
        // if para que não ocorra erro no require para a = 0
        if(a == 0){
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "Mul Overflow!");

        return c;
    }

    // função que divide 2 valores e retorna o resultado
    function div(uint a, uint b) internal pure returns(uint) {
        uint c = a / b;

        return c;
    }

}

contract Ownable {
    address payable public owner;

    event OwnershipTransferred(address newOwner);

    constructor () {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner!");
        _;
    }

    // função disponível apenas para o dono que transfere
    // o contrato para um outro dono, mesmo depois do deploy
    function transferOwnership(address payable newOwner) onlyOwner public {
        owner = newOwner;

        emit OwnershipTransferred(owner);
    }
}

contract FirstChallenge is Ownable {

    using SafeMath for uint;

    uint price = 25000000 gwei;

    event NewPrice(uint newPrice);

    function setNumber(uint8 number) public payable returns (string memory) {
        require(number <= 10, "Number out of range.");

        require(msg.value == price, "Insufficient ETH sent");

        doublePrice();

        if(number > 5) {
            return "E maior que cinco!";
        }

        return "E menor ou igual a cinco!";

    }

    function doublePrice() private {
        price = price.mul(2);

        emit NewPrice(price);
    }

    function withdraw(uint myAmount) onlyOwner public {
        // "balance" é uma propriedade nativa de todos ENDEREÇOS (inclusive endereços de contratos)
        require(address(this).balance >= myAmount, "Insufficient funds.");

        owner.transfer(myAmount);
    }
}