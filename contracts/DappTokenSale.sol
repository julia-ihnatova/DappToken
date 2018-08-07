pragma solidity ^0.4.23;
import "./DappToken.sol";

contract DappTokenSale{

    address admin;
    DappToken public tokenContract; //contract type variable
    uint256 public tokenPrice;

    constructor(DappToken _tokenContract, uint256 _tokenPrice) public{ //we can add a reference to DappToken contract inside of constructor

        //assign an admin
        admin = msg.sender;

        //assign the Token contract
        tokenContract = _tokenContract;

        //token Price
        tokenPrice = _tokenPrice;
    }
}