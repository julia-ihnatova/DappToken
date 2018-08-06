pragma solidity ^0.4.23;

contract DappToken{
    // Constructor
    // Set the total number of tokens
    // Read the total number of tokens
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    //Name
    string public name = 'Dapp Token';

    //symbol
    string public symbol = 'DAPP';

    //standart (not erc-20 requirement)
    string public standart = 'DAPP Token v1.0';

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
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

    //Delegated Transfer

    //approve function
    function approve(address _spender, uint256 _value) public returns(bool success){

        //handle the allowance
        allowance[msg.sender][_spender] = _value;

        //handle approve event
        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    //transferFrom
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){

        //require _from account has enough tokens
        require(balanceOf[_from] >= _value);

        //require allowance is big enough
        require(_value <= allowance[_from][msg.sender]);

        //change the balance
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        //update the allowance
        allowance[_from][msg.sender] -= _value;

        //Transfer event
        emit Transfer(_from, _to, _value);

        //return a boolean
        return true;

    }

}