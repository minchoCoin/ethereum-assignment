// SPDX-License-Identifier: MIT
pragma solidity ^0.6.4;

import "./token.sol";

contract Voting{
    VoteToken public voteContract;
    uint256 public tokenPrice;
    bool public votingActive;
    address[] public candidates;
    address owner;
    uint256 public tokensSold;

    mapping(address=>uint256) public votesReceived;
    mapping(address=>bool) public registeredCandidates;
    mapping(address=>uint256) public votesCast;

    event CandidateRegistered(address _candidate);
    event VoteCasted(address _candidate, uint256 _votes);
    event voteSell(address indexed buyer, uint256 indexed _amount);
    event VotingEnded(address _owner);
    event transferRights(address _from, address _to, uint256 _amount);

    constructor(VoteToken _voteContract, uint256 _tokenPrice) public{
        owner = msg.sender;
        voteContract = _voteContract;
        tokenPrice = _tokenPrice;
        votingActive=true;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "this function can only be called by owner");
        _;
    }

    function buyToken(uint256 _numberOfTokens) public payable{
        require(votingActive);
        require(msg.value ==_numberOfTokens * tokenPrice * 1 ether,"send ether exactly!");
        require(voteContract.balanceOf(address(this))>=_numberOfTokens,"oops! sorry, out of tokens");
        tokensSold +=_numberOfTokens;
        emit voteSell(msg.sender, _numberOfTokens);
        require(voteContract.transfer(msg.sender, _numberOfTokens),"oops! tranfering to you is failed!");
    }

    function registerCandidate() public{
        require(!registeredCandidates[msg.sender],"already registered!");
        registeredCandidates[msg.sender]=true;
        candidates.push(msg.sender);
        emit CandidateRegistered(msg.sender);
    }

    function vote(address candidate, uint256 voteCount) public{
        require(votingActive,"vote is ended");
        require(registeredCandidates[candidate],"Not a registered candidate");
        require(voteContract.balanceOf(msg.sender) >= voteCount,"Insufficient tokens");
        require(voteContract.getAllowance(msg.sender,address(this))>=voteCount,"Insufficient approve tokens");
        voteContract.transferFrom(msg.sender, address(this),voteCount);
        votesReceived[candidate] += voteCount;
        votesCast[msg.sender] += voteCount;

        emit VoteCasted(candidate, voteCount);
    }

    function transferVoteRights(address _to, uint256 _amount) public{
        
        require(voteContract.balanceOf(msg.sender)>=_amount);
        require(voteContract.getAllowance(msg.sender, _to)>=_amount);
        voteContract.transferFrom(msg.sender, _to, _amount);
        emit transferRights(msg.sender, _to, _amount);
    }

    function endVote() public onlyOwner{
        require(votingActive,"Voting is already ended");
        votingActive=false;

        require(voteContract.transfer(msg.sender,voteContract.balanceOf(address(this))));
        msg.sender.transfer(address(this).balance);
    }
    function setTokenPrice(uint256 _price) public onlyOwner{
        tokenPrice = _price;
    }
    function getCandidateVotes(address _candidate) public view returns (uint256){
        require(registeredCandidates[_candidate],"not registered");
        return votesReceived[_candidate];
    }
}