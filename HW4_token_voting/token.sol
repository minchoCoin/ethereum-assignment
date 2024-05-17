pragma solidity ^0.6.4;
contract VoteToken{


    string public name="Test ERC20 Token";
    string public symbol="TET";

    uint public totalSupply;
    uint public decimals;

    address owner;

    event Approval(address indexed _owner, address indexed _spender,uint256 _value);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    mapping(address=>uint256) public balanceOf;
    mapping(address=>mapping(address=>uint256)) public allowance;

    constructor(uint256 _initSupply) public {
        owner = msg.sender;
        balanceOf[msg.sender]=_initSupply;
        totalSupply=_initSupply;
        emit Transfer(address(0),msg.sender, totalSupply);
    }

    modifier onlyOwner() {
        require(msg.sender == owner,"this function can only called by owner");
        _;
    } 
    function transfer(address _to, uint256 _value) public returns (bool success){
        require(balanceOf[msg.sender]>=_value);

        balanceOf[msg.sender]-=_value;
        balanceOf[_to] +=_value;

        emit Transfer(msg.sender, _to, _value);
        return true;

    }
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(_value<=balanceOf[_from]);
        require(_value<=allowance[_from][msg.sender]);

        balanceOf[_from] -=_value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success){
        allowance[msg.sender][_spender]=_value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function burn(uint256 _value) public onlyOwner{
        require(balanceOf[msg.sender]>=_value,"Insufficient balance");
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        emit Transfer(msg.sender, address(0), _value);
    }
    function mint(uint256 _value) public onlyOwner{
        totalSupply += _value;
        balanceOf[msg.sender] += _value;
        emit Transfer(address(0), msg.sender, _value);
    }
    function getAllowance(address _from, address _to) public view returns (uint256){
        return allowance[_from][_to];
    }
}