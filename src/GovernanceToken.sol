// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title MuhammadTalhaToken (MTT)
/// @notice Governance token with checkpointing for DAO voting
contract GovernanceToken is ERC20, ERC20Permit, ERC20Votes, Ownable {
    constructor(
        uint256 initialSupply,
        address initialOwner
    )
        ERC20("MuhammadTalhaToken", "MTT")
        ERC20Permit("MuhammadTalhaToken")
        Ownable(initialOwner)
    {
        _mint(initialOwner, initialSupply);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // ✅ OpenZeppelin v5 pattern: only _update needs override
    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20, ERC20Votes) {
        super._update(from, to, value);
    }

    // ✅ only ERC20Permit + Nonces, NOT ERC20Votes
    function nonces(
        address owner
    ) public view override(ERC20Permit, Nonces) returns (uint256) {
        return super.nonces(owner);
    }
}
