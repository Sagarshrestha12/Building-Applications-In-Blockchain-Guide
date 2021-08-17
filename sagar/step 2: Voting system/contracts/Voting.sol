pragma solidity >=0.7.0 <0.9.0;/// @title Voting with delegation.
contract Voting {
    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single voter.
    struct Voter {
        bool authorized;
        uint weight; // weight is accumulated by delegation
        bool voted;  // if true, that person already voted
        address delegate; // person delegated to
        uint vote;   // index of the voted proposal
    }

    // This is a type for a single proposal.
    struct Proposal {
        uint id;
        bytes32 name;   // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
    }
    uint startTime;
    uint endTIme;
    uint duration;
    address public chairperson;
    // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;
    uint proposal_num;
    // A dynamically-sized array of `Proposal` structs.
    mapping(uint=>Proposal) public proposals;
    /// Create a new ballot to choose one of `proposalNames`.
    constructor() {
        chairperson = msg.sender;
        startTime=block.timestamp;
        duration=60*60;// only after the 1hr of completion of vote winnerName will be published
        endTIme=startTime+1*30*24*60*60;// that means vote end after the 1 month
        proposals[1]=Proposal(1,"Candidate_1",0);
        proposals[2]=Proposal(1,"Candidate_2",0);
        proposals[3]=Proposal(1,"Candidate_3",0);
        proposal_num=3;
        
    }
    modifier isChairperson{
        require(msg.sender == chairperson,"Only chairperson can give right to vote.");
        _;
    }

    // Give `voter` the right to vote on this ballot.
    // May only be called by `chairperson`.
    function giveRightToVote(address _voter) public isChairperson 
    {
        require(block.timestamp<endTIme,"Only chairperson can give right to vote");
        require(!voters[_voter].voted,"The voter already voted.");
        require(voters[_voter].weight == 0);
        voters[_voter].weight = 1;
        voters[_voter].authorized=true;
    }

    /// Delegate your vote to the voter `to`.
    function delegate(address to) public {
        require(block.timestamp<endTIme,"You can only delegate vote during voting duration");
        require(!voters[msg.sender].voted, "You already voted.");
        require(to != msg.sender, "Self-delegation is disallowed.");
        Voter storage sender = voters[msg.sender];
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        // If the delegate already voted, directly add to the number of votes
        if (delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            delegate_.weight += sender.weight;
        }
    }

    /// Give your vote (including votes delegated to you)
    /// to proposal `proposals[proposal].name`.
    function vote(uint proposal) public {
        require(block.timestamp<endTIme,"You can only vote during voting duration");
        require(voters[msg.sender].authorized, "Has no right to vote");
        require(!voters[msg.sender].voted, "Already voted.");
        Voter storage sender = voters[msg.sender];
        sender.voted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += sender.weight;
    }

    /// @dev Computes the winning proposal taking all
    /// previous votes into account.
    function winningProposal() private view
            returns (uint winningProposal_)
    {
        require(block.timestamp >= endTIme);
        uint winningVoteCount = 0;
        for (uint i = 1; i <= proposal_num; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposal_ = i;
            }
        }
    }

    function winnerName() public view
            returns (bytes32 winnerName_)
    {
        require(block.timestamp + duration >= endTIme, "Only published after certain time after voting duration has finished");
        
        winnerName_ = proposals[winningProposal()].name;
    }
}