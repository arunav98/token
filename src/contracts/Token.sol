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
    //allowed allowance for a exchange to transfer or spend
    mapping(address => mapping(address => uint256)) public allowance;
    //event
    event Transfer(address indexed from,address indexed to,uint256 value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    //send token
    function transfer(address _to,uint256 _value) public returns(bool success){
        require(balanceOf[msg.sender] >= _value,'Required Balance Not Meet');
        _transfer(msg.sender,_to,_value);
        return true;
    }

    //approve transfer
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0),"Null Address");
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    //internal function
    function _transfer(address _from,address _to,uint256 _value)internal{
        require(_to != address(0),'Invalid Address');
        //actual transfer process
        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        //trigger event to transfer the token
        emit Transfer(_from,_to,_value);
    }

    //transfer from
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        _transfer(_from, _to, _value);
        //trigger event to transfer the token
        emit Transfer(_from,_to,_value);
        return true;
    }

    constructor() public{
        totalSupply = 100000*(10**decimal);
        balanceOf[msg.sender] = totalSupply;
    }
}