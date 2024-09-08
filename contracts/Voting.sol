// SPDX-License-Identifier:MIT
pragma solidity 0.8.24;

contract Voting {
    struct Candidate {
        string name;
        uint256 votingCount;
    }

    Candidate[] public candidates;
    address owner;

    mapping(address => bool) public voters;

    uint256 public votingStarts;
    uint256 public votingEnds;

    constructor(string[] memory _candidateName, uint256 _durationInMinuts) {
        for (uint256 i = 0; i < _candidateName.length; i++) {
            candidates.push(
                Candidate({name: _candidateName[i], votingCount: 0})
            );
        }

        owner = msg.sender;
        votingStarts = block.timestamp;
        votingEnds = block.timestamp + (_durationInMinuts * 1 minutes);
    }

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    function addCandidate(string memory _name) public onlyOwner {
        candidates.push(Candidate({name: _name, votingCount: 0}));
    }

    function vote(uint256 _candidateIndex) public {
        require(!voters[msg.sender], "You have alredy Voted!");
        require(_candidateIndex < candidates.length, "Invalid Candidate Index");

        candidates[_candidateIndex].votingCount++;
        voters[msg.sender] == true;
    }

    function getAllVotesOfCandidaates()
        public
        view
        returns (Candidate[] memory)
    {
        return candidates;
    }

    function getVotingStatus() public view returns (bool) {
        return (block.timestamp >= votingStarts &&
            block.timestamp <= votingEnds);
    }

    function getRemainingTime() public view returns (uint256) {
        require(
            block.timestamp >= votingStarts,
            "Voting is Not Yet Started!!!"
        );

        return votingEnds - block.timestamp;
    }

    function getWinner() public view returns (string memory, uint256) {
        require(
            block.timestamp > votingEnds,
            "Voting is Still goingon! Please wait aa wile"
        );

        uint256 maxNoOfVoteCount = 0;
        uint256 winnerIndex = 0;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].votingCount > maxNoOfVoteCount) {
                maxNoOfVoteCount = candidates[i].votingCount;
                winnerIndex = i;
            }
        }
        return (candidates[winnerIndex].name, maxNoOfVoteCount);
    }
}
