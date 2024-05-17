pragma solidity >=0.4.22 <0.7.0;

contract SimpleAuction {
    // Parameters of the auction. Times are either
    // absolute unix timestamps (seconds since 1970-01-01)
    // or time periods in seconds.
    address payable public beneficiary;
    uint public auctionEndTime;

    // Current state of the auction.
    address public highestBidder;
    uint public highestBid;

    //auto increasing bid value
    uint autoIncreasingBidValue;

    //auto increasing end time value
    uint autoIncreasingTimeValue;

    //available max bid value by address
    mapping(address => uint) maxAvailableBid;

    // Allowed withdrawals of previous bids
    mapping(address => uint) pendingReturns;

    

    // Set to true at the end, disallows any change.
    // By default initialized to `false`.
    bool ended;

    // Events that will be emitted on changes.
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);
    event AuctionExtended(uint increasing);
 
    constructor(
        uint _biddingTime,
        address payable _beneficiary
    ) public {
        beneficiary = _beneficiary;
        auctionEndTime = now + _biddingTime;

        //set autoincreasingBid and time value
        autoIncreasingBidValue=0.1 ether;
        autoIncreasingTimeValue=30;
    }

 
    function bid(uint initial) public payable {
        
       ///slide #7
       ///write your code for bid function
       //max bid of user is msg.value
        require(msg.value>=initial,"max available bid should be greater than or equal to initial bid");
        require(now<=auctionEndTime,"Auction already ended.");
        require(initial>highestBid,"There is a higher bid than your inital bid.");
        
        //Automatically extend the auction time if a bid is made immediately before the closing time of the bid
        if(auctionEndTime - now <= 10){
            auctionEndTime += autoIncreasingTimeValue;
            emit AuctionExtended(autoIncreasingTimeValue);
        }
       
        if(highestBid!=0){
            //if highestBidder can bid more
            if(maxAvailableBid[highestBidder]>=msg.value + autoIncreasingBidValue){
                highestBid = msg.value + autoIncreasingBidValue; //auto bid more
                pendingReturns[msg.sender] = msg.value; //return all ether received from sender to sender(msg.sender defeat). 
                pendingReturns[highestBidder] = maxAvailableBid[highestBidder] - highestBid; // return remain ether after bid to highestbidder
            }

            //if highestBidder can't bid more
            else{
                maxAvailableBid[msg.sender]=msg.value; // set max available bid
                highestBid = maxAvailableBid[highestBidder] + autoIncreasingBidValue; // set bid to maxavailablebid of previous highestbidder + (0.1 or 1 or ... ether)
                pendingReturns[highestBidder]=maxAvailableBid[highestBidder];//return all ether recevied from previous highestbidder to them(previous highestbidder defeat)
                highestBidder=msg.sender; //change highestbidder to sender(msg.sender win)
                
            }

        }
        else{
            highestBidder = msg.sender;
            highestBid=initial;
            maxAvailableBid[msg.sender]=msg.value;
        }
        
        emit HighestBidIncreased(highestBidder, highestBid);
    }

    /// Withdraw a bid that was overbid.
    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
         
       ///slide #8
       ///write your code for withdraw function
            pendingReturns[msg.sender]=0;
            if(!msg.sender.send(amount)){
                pendingReturns[msg.sender]=amount;
                return false;
            }
        }
        return true;
    }

    /// End the auction and send the highest bid
    /// to the beneficiary.
    function auctionEnd() public {
   
        // 1. checking conditions
        // 2. performing actions (potentially changing conditions)
        // 3. interacting with other contracts
 

        // 1. Conditions
        ///slide #9
        require(now>=auctionEndTime,"Auction not yet ended.");
        require(!ended,"auctionEnd has already called.");

        // 2. Effects
        ///slide #9
        ended=true;
        emit AuctionEnded(highestBidder, highestBid);

        // 3. Interaction
        ///slide #9
        beneficiary.transfer(highestBid);
    }
}