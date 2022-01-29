// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

library SafeMath {

    function add(uint a, uint b) internal pure returns(uint) {
        uint c = 0;
        unchecked {
            c = a + b;
        }

        require(c >= a, "Sum Overflow!");

        return c;
    }

    function sub(uint a, uint b) internal pure returns(uint) {
        require(b <= a, "Sub Underflow!");
        uint c = a - b;
        return c;
    }

    function mul(uint a, uint b) internal pure returns(uint) {
        if(a == 0){
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "Mul Overflow!");

        return c;
    }

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

contract ERC20 {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract BasicToken is Ownable, ERC20 {
    using SafeMath for uint;

    string public constant name = "Test Coin";
    string public constant symbol = "TST";
    uint8 public constant decimals = 18;
    uint internal _totalSupply;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    event Mint(address indexed to, uint tokens);
    
    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    function mint(address to, uint tokens) onlyOwner public {
        balances[to] = balances[to].add(tokens);
        totalSupply = totalSupply.add(tokens);

        emit Mint(to, tokens);
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        require(balances[msg.sender] >= tokens);
        require(to != address(0));

        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);

        emit Transfer(msg.sender, to, tokens);

        return true;
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        require(balances[from] >= tokens);
        require(to != address(0));

        balances[from] = balances[from].sub(tokens);
        balances[to] = balances[to].add(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        emit Transfer(from, to, tokens);

        return true;
    }
}