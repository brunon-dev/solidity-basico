pragma solidity 0.8.11;

contract HelloWorld {
    string public text;
    uint public number;
    address public userAddress;
    bool public answer;
    mapping (address => uint) public hasInteracted;
    mapping (address => uint) public balances;

    function setText(string memory myText) public {
        text = myText;
        setInteracted();
    }

    function setNumber(uint myNumber) public payable {
        require(msg.value >= 1 ether, "Insufficient ETH sent");

        // incrementa o saldo do endereço que chamou a função
        balances[msg.sender] += msg.value;

        number = myNumber;
        setInteracted();
    }

    function setUserAddress() public {
        userAddress = msg.sender;
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

    // função que soma 2 valores e retorna o resultado
    // usa a palavra reservada "pure" pois não consulta e nem altera valores na Blockchain
    function sum(uint num1, uint num2) public pure returns(uint) {
        return num1 + num2;
    }

    // função que subtrai 2 valores e retorna o resultado
    function sub(uint num1, uint num2) public pure returns(uint) {
        return num1 - num2;
    }

    // função que multiplica 2 valores e retorna o resultado
    function mult(uint num1, uint num2) public pure returns(uint) {
        return num1 * num2;
    }

    // função que divide 2 valores e retorna o resultado
    function div(uint num1, uint num2) public pure returns(uint) {
        return num1 / num2;
    }

    // função que recebe 2 números e faz o primeiro elevado a potência do segundo, retornando o resultado
    function pow(uint num1, uint num2) public pure returns(uint) {
        return num1 ** num2;
    }

    // função que soma 1 valor passado por parâmetro e um armazenado na Blockchain, retornando o resultado
    // usa a palavra reservada "view" pois apenas consulta valores na Blockchain, sem alterar
    function sumStored(uint num1) public view returns(uint) {
        return num1 + number;
    }   
}