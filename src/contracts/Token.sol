pragma solidity >=0.5.0;

import "/home/arunav/Desktop/lockchain/first-blockchain/node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Token{

    using SafeMath for uint;

    //variables
    string public name="ArC Token";
    string public symbol="ArC";
    uint256 public decimal=18;
    uint256 public totalSupply;
    //track balance of the address
    mapping(address => uint256) public balanceOf;

    //event
    event Transfer(address indexed from,address indexed to,uint256 value);

    //send token
    function transfer(address _to,uint256 _value) public returns(bool success){
        require(_to != address(0),'Invalid Address');
        require(balanceOf[msg.sender] >= _value,'Required Balance Not Meet');
        //actual transfer process
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        //trigger event to transfer the token
        emit Transfer(msg.sender,_to,_value);
        return true;
    }

    constructor() public{
        totalSupply = 100000*(10**decimal);
        balanceOf[msg.sender] = totalSupply;
    }
}