// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./GovernanceToken.sol";

/// @title MuhammadTalhaGovernor
/// @notice Fraud-resistant DAO governance
contract SimpleGovernor is Ownable, ReentrancyGuard {
    GovernanceToken public token;
    uint256 public proposalCount;
    uint256 public votingDelay;
    uint256 public votingPeriod;
    uint256 public proposalDeposit; // tokens required to create proposal
    uint256 public quorumPercent; // % of total supply required

    enum ProposalState {
        Pending,
        Active,
        Succeeded,
        Defeated,
        Cancelled
    }

    struct Proposal {
        uint256 id;
        address proposer;
        string metadata;
        uint256 startBlock;
        uint256 endBlock;
        uint256 forVotes;
        uint256 againstVotes;
        bool executed;
        bool cancelled;
    }

    mapping(uint256 => mapping(address => bool)) public hasVoted;
    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(uint256 id, address proposer, string metadata);
    event VoteCast(
        uint256 proposalId,
        address voter,
        uint8 support,
        uint256 weight
    );
    event ProposalFinalized(uint256 proposalId, ProposalState state);

    constructor(
        address tokenAddress,
        address initialOwner,
        uint256 _votingDelay,
        uint256 _votingPeriod,
        uint256 _proposalDeposit,
        uint256 _quorumPercent
    ) Ownable(initialOwner) {
        token = GovernanceToken(tokenAddress);
        votingDelay = _votingDelay;
        votingPeriod = _votingPeriod;
        proposalDeposit = _proposalDeposit;
        quorumPercent = _quorumPercent;
    }

    function createProposal(
        string calldata metadata
    ) external returns (uint256) {
        require(
            token.balanceOf(msg.sender) >= proposalDeposit,
            "Not enough tokens to propose"
        );
        proposalCount++;
        uint256 id = proposalCount;

        Proposal storage p = proposals[id];
        p.id = id;
        p.proposer = msg.sender;
        p.metadata = metadata;
        p.startBlock = block.number + votingDelay;
        p.endBlock = p.startBlock + votingPeriod;

        emit ProposalCreated(id, msg.sender, metadata);
        return id;
    }

    function castVote(uint256 proposalId, uint8 support) external nonReentrant {
        Proposal storage p = proposals[proposalId];
        require(block.number >= p.startBlock, "Voting not started");
        require(block.number <= p.endBlock, "Voting ended");
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        uint256 weight = token.getPastVotes(msg.sender, p.startBlock);
        require(weight > 0, "No voting power");

        if (support == 1) {
            p.forVotes += weight;
        } else {
            p.againstVotes += weight;
        }

        hasVoted[proposalId][msg.sender] = true;
        emit VoteCast(proposalId, msg.sender, support, weight);
    }

    function finalizeProposal(uint256 proposalId) external {
        Proposal storage p = proposals[proposalId];
        require(block.number > p.endBlock, "Voting not ended");
        require(!p.executed, "Already finalized");

        uint256 totalVotes = p.forVotes + p.againstVotes;
        uint256 supply = token.totalSupply();
        uint256 quorum = (supply * quorumPercent) / 100;

        if (totalVotes >= quorum && p.forVotes > p.againstVotes) {
            p.executed = true;
            emit ProposalFinalized(proposalId, ProposalState.Succeeded);
        } else {
            p.executed = true;
            emit ProposalFinalized(proposalId, ProposalState.Defeated);
        }
    }
}
