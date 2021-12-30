pragma solidity ^0.5.0;

//import the token 
import "./Token.sol"; 

//let's see if we can put smart contract on the blockchain 
contract EthSwap { 
    //name is a state variable 
    //EthSwap name is stored on the blockchain 
    string public name = "EthSwap Instant Exchange"; 
    Token public token; 
    uint public rate = 100; 

    event TokenPurchased(
        address account, 
        address token, 
        uint amount,
        uint rate
    );

    event TokenSold(
        address account, 
        address token, 
        uint amount,
        uint rate
    );

    //we can interact with this token later 
    constructor(Token _token) public { 
        token = _token; 
    }
    //now we must update our migrations 

    function buyTokens() public payable { 
        //Redemption rate = # of tokens they receive for 1 ether 
        //Amount of Ethereum * Redemption rate 
        uint tokenAmount = msg.value * rate;

        //require - if it function evaluates to true, keep evaluating the function, 
        //if it evaluates to false, stop executing the function 
        //requires that ethSwap has enough tokens 
        require(token.balanceOf(address(this))>= tokenAmount); 

        //transfer tokens from ethSwap contract to person buying them 
        token.transfer(msg.sender, tokenAmount);  

        //Emit an event
        //emit TokenPurchased(account, address)
        emit TokenPurchased(msg.sender, address(token), tokenAmount, rate);
    }
        //inspect the event 

        //now let's create a sellTokens function 
        //must be public to function outside of smart contract 
    function sellTokens(uint _amount) public { 

        //user cant sell more tokens than they have 
        require(token.balanceOf(msg.sender) >= _amount); 
            //opposite of transfer from ethSwap to investor 
            //instead of being from the ethSwap exchange (msg.sender) 
            //to the investor (tokenAmount)
            //we must make the function from the investor to the ethSwap exchange 

            //calculate the amount of Ether to redeem 
        uint etherAmount = _amount / rate; 

        //Require that ethSwap has enough Ether 
        require(address(this).balance >= etherAmount); 

            //Perform sale 
            //msg.sender is the person calling the function 
            //transfer function(from, to, amount)
        token.transferFrom(msg.sender, address(this), _amount);
        msg.sender.transfer(etherAmount);

            
        //emit an event 
        emit TokenSold(msg.sender, address(token), _amount, rate); 
    
    }
}

