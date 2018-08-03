pragma solidity ^0.4.23;

contract DappToken{
    // Constructor
    // Set the total number of tokens
    // Read the total number of tokens
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    //Name
    string public name = 'Dapp Token';

    //symbol
    string public symbol = 'DAPP';

    //standart (not erc-20 standart)
    string public standart = 'DAPP Token v1.0';

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    constructor(uint256 _initialSupply) public{
        //allocate the initial supply
        balanceOf[msg.sender] = _initialSupply;

        totalSupply = _initialSupply;
    }

    //Transfer the balance
    //fire transfer event
    //return  a boolean
    function transfer(address _to, uint256 _value) public returns(bool success){
        //Exception if account doesn't have enough
        require(balanceOf[msg.sender] >= _value);

        //Transfer the balance
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }


}