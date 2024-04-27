// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

/**
 * @title   A structure to represent payments log 
 */
struct log{
    address[] addr;
    uint256[] amount;
}

/**
 * @title   abstract contract for making a function possible to be called by only to the owner
   @dev     using modifier onlyOwner, the functions that using this modifier can only be called from contract owner
 */
abstract contract owned{
    address owner;
    constructor(){
        owner = msg.sender;
    }
    modifier onlyOwner{
        require(msg.sender == owner,"Only the contract owner can call this function!");
        _;
    }
}
/**
 * @title   VendingMachine contract : you can buy beverage!
 * @notice  withdraw and getLogs functions can only be called from contract owner.
 * @dev     receving money, and giving change
 */
contract VendingMachine is owned{
    log private mylog;

    /*withdrawal event with address to receving ether and amount */
    event Withdrawal(address indexed to, uint256 amount);
    /*Purchase event with caller address and amount */
    event Purchase(address indexed from, uint256 amount);

    /**
     * @notice  paying, giving exchange, and writing logs about paying
     * @param   total totalamount(in wei) that sender should pay
     * @param   senderAmount amount(in wei) sent by the sender
     */
    function pay(uint256 total,uint256 senderAmount) private{
        require(senderAmount>=total, "Error : sender amount must be greater than or equal to total amount");
        payable(msg.sender).transfer(senderAmount-total); // send exchange to sender
        emit Purchase(msg.sender, total); //emit purchase event
        mylog.addr.push(msg.sender); //logging address
        mylog.amount.push(total); //logging amount
    }
    
    /**
     * @notice  if you call this function, you will get soda! please note that you should send ether greater than or equal to total price(soda is 1 ether per cup!)
     * @dev     if sender send ether greater than or equal to total price(=1 ether * _count), then call pay function and logging
     * @param   _count Number of cup of soda to buy
     * @return  payment successful info
     */
    function getSoda(uint256 _count) payable public returns (string memory){
        //Soda is 1 ether
        uint256 total = 1 ether*_count;
        require(msg.value>=total,"please send more ethereum. Soda is 1 ether");
        pay(total,msg.value);
        return "Payment completed successfully. you get soda!";
        
    }

    /**
     * @notice  if you call this function, you will get juice! please note that you should send ether greater than or equal to total price(juice is 2 ether per cup!)
     * @dev     if sender send ether greater than or equal to total price(=2 ether * _count), then call pay function and logging
     * @param   _count Number of cup of juice to buy
     * @return  payment successful info
     */
    function getJuice(uint256 _count) payable public returns (string memory){
        //Juice is 2 ether
        uint256 total = 2 ether*_count;
        require(msg.value>=total,"please send more ethereum. Juice is 2 ether");
        pay(total,msg.value);
        return "Payment completed successfully. you get juice!";
    }
    
    /**
     * @notice  if you call this function, you will get water! please note that you should send ether greater than or equal to total price(water is 3 ether per cup!)
     * @dev     if sender send ether greater than or equal to total price(=3 ether * _count), then call pay function and logging
     * @param   _count Number of cup of water to buy
     * @return  payment successful info
     */
    function getWater(uint256 _count) payable public returns (string memory){
        //Water is 3 ether
        uint256 total = 3 ether*_count;
        require(msg.value>=total,"please send more ethereum. Water is 3 ether");
        pay(total,msg.value);
        return "Payment completed successfully. you get water!";
    }

    /**
     * @notice  withdraw all money in this vending machine to address '_to'. Note that this function can only be called by contract owner.
     * @dev     if balance in this vending machine contract is greater than or equal to 0 then send ether to '_to' and emit withdrawal event
     * @param   _to address to receving ether in this vending machine contract
     * 
     */
    function withdraw(address payable _to) onlyOwner public{
        uint256 balance = address(this).balance;
        if(0<= balance){
            if(_to.send(balance)){
                emit Withdrawal(_to, balance);
            }
            else{
                revert();
            }
        }
        else{
            revert();
        }
    }
    /**
     * @notice return log. caller of this function can view logs. this function can only be called by contract owner
     * @dev return log. caller of this function can view logs. this function can only be called by contract owner
     * @return address[] address list
     * @return uint256[] amount list
     */
    function getLogs() view onlyOwner public returns (address[] memory, uint256[] memory){
        return (mylog.addr, mylog.amount);
    }
    //fallback() external payable {}
    //receive() external payable {}
}