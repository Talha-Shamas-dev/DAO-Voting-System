// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/GovernanceToken.sol";
import "../src/SimpleGovernor.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // Step 1: Deploy Governance Token (initial supply = 1 million)
        GovernanceToken token = new GovernanceToken(
            1_000_000 ether,
            deployer // <-- initialOwner
        );

        // Step 2: Deploy Governor contract
        SimpleGovernor governor = new SimpleGovernor(
            address(token),
            deployer, // <-- initialOwner
            1, // votingDelay (1 block)
            50, // votingPeriod (50 blocks)
            100 ether, // proposalDeposit
            4 // quorumPercent (4%)
        );

        vm.stopBroadcast();
    }
}
