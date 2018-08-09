pragma solidity ^0.4.23;
import "./DappToken.sol";

contract DappTokenSale{

    address admin;
    DappToken public tokenContract; //contract type variable
    uint256 public tokenPrice;
    uint256 public tokenSold;

    event Sell(
        address _buyer,
        uint256 _amount
    );

    constructor(DappToken _tokenContract, uint256 _tokenPrice) public{ //we can add a reference to DappToken contract inside of constructor

        //assign an admin
        admin = msg.sender;

        //assign the Token contract
        tokenContract = _tokenContract;

        //token Price
        tokenPrice = _tokenPrice;
    }

    //multiply
    function multiply(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    //BUY TOKENS
    function buyTokens(uint256 _numberOfTokens) public payable{

        //Require that value is equal to the number tokens
        require(msg.value == multiply(_numberOfTokens, tokenPrice));

        //Require that the contract has enough tokens
        require(tokenContract.balanceOf(this) >= _numberOfTokens);

        //Require that a transfer is successful
        require(tokenContract.transfer(msg.sender, _numberOfTokens));

        //keep track of tokenSold
        tokenSold += _numberOfTokens;

        //emit the Sell Event
        emit Sell(msg.sender, _numberOfTokens);
    }

    //Ending the token sale
    function endSale() public{

        //require admin can do this
        require(msg.sender == admin);

        //transfer remaining dapp tokens to admin
        require(tokenContract.transfer(admin, tokenContract.balanceOf(this)));

        // UPDATE: Let's not destroy the contract here
        // Just transfer the balance to the admin
        admin.transfer(address(this).balance);
    }
}