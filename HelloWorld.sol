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

contract HelloWorld is Ownable {

    using SafeMath for uint;
    
    string public text;
    uint public number;
    address payable public userAddress;
    bool public answer;
    mapping (address => uint) public hasInteracted;
    mapping (address => uint) public balances;

    function setText(string memory myText) onlyOwner public {
        text = myText;
        setInteracted();
    }

    function setNumber(uint myNumber) public payable {
        require(msg.value >= 1 ether, "Insufficient ETH sent");

        // incrementa o saldo do endereço que chamou a função
        balances[msg.sender] = balances[msg.sender].sum(msg.value);

        number = myNumber;
        setInteracted();
    }

    function setUserAddress() public {
        userAddress = payable(msg.sender);
        setInteracted();
    }

    function setAnswer(bool trueOrFalse) public {
        answer = trueOrFalse;
        setInteracted();
    }

    function setInteracted() private {
        hasInteracted[msg.sender] += 1;
    }

    // função que implementa transferência de valores entre 2 contas
    // apenas para fins de estudo, já que a própria rede Ethereum já implementa essa transferência
    function sendETH(address payable targetAddress) public payable {
        // endereço payable faz transferência através do transfer
        targetAddress.transfer(msg.value);
    }

    // função responsável pelo saque
    function withdraw() public {
        require(balances[msg.sender] > 0, "Insufficient funds");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;
        // necessário fazer conversão explícita
        // payable(msg.sender)
        // ver Breaking Changes da versão 0.8.3
        payable(msg.sender).transfer(amount);
    }

    // função que recebe 2 números e faz o primeiro elevado a potência do segundo, retornando o resultado
    function pow(uint num1, uint num2) public pure returns(uint) {
        return num1 ** num2;
    }

    // função que soma 1 valor passado por parâmetro e um armazenado na Blockchain, retornando o resultado
    // usa a palavra reservada "view" pois apenas consulta valores na Blockchain, sem alterar
    function sumStored(uint num1) public view returns(uint) {
        return num1.sub(number);
    }
}