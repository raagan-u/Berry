// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Berry {
    string private _name;
    string private _symbol;
    uint8 private _decimals=18;
    uint256 private _totalSupply;
    mapping(address => uint256) _balances;
    mapping(address => mapping(address => uint256)) _allowances;

    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    address private _owner;
    
    modifier onlyOwner() {
        require(msg.sender == _owner, "Berry: caller is not the owner");
        _;
    }

    constructor(
    uint8 decimals_,
    uint256 initialSupply,
    string memory name_,
    string memory symbol_ ) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _totalSupply = initialSupply;
        _balances[msg.sender] = initialSupply;
        _owner = msg.sender;
    
        emit Transfer(address(0), msg.sender, initialSupply);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address owner_) public view returns (uint256 balance) {
        return _balances[owner_];
    }

    function mint(address to, uint256 amount) public onlyOwner returns (bool) {
        require(to != address(0), "Berry: mint to the zero address");

        _totalSupply += amount;
        _balances[to] += amount;

        emit Mint(to, amount);
        emit Transfer(address(0), to, amount);
        return true;
    }

    function burn(uint256 amount) public returns (bool) {
        require(_balances[msg.sender] >= amount, "Berry: insufficient balance to burn");

        _totalSupply -= amount;
        _balances[msg.sender] -= amount;

        emit Burn(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
        return true;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Berry: new owner is zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }


    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Berry: transfer to zero address");
        require(_balances[msg.sender] >= _value, "Berry: insufficient balance");
      

        
        _balances[msg.sender] -= _value;
        _balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_from != address(0), "Berry: transfer from zero address");
        require(_to != address(0), "Berry: transfer to zero address");
        require(_balances[_from] >= _value, "Berry: insufficient balance");
        require(_allowances[_from][msg.sender] >= _value, "Berry: insufficient allowance");
       

        
        _balances[_from] -= _value;
        _balances[_to] += _value;
        _allowances[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0), "Berry: approve to zero address");
        
        _allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address owner_, address _spender) public view returns (uint256 remaining) {
        return _allowances[owner_][_spender];
    }

    function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool success) {
        require(_spender != address(0), "Berry: approve to zero address");
        require(_addedValue > 0, "Berry: added value must be greater than 0");
        
        approve(_spender, _allowances[msg.sender][_spender] + _addedValue);
        return true;
    }

    function decreaseAllowance(address _spender, uint256 _subValue) public returns (bool success) {
        require(_spender != address(0), "Berry: approve to zero address");
        uint256 currentAllowance = _allowances[msg.sender][_spender];
        require(_subValue <= currentAllowance, "Berry: decreased allowance below zero");
        
        approve(_spender, currentAllowance - _subValue);
        return true;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}
