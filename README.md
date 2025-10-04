# DAO Governance Voting System

This project implements a **Decentralized Autonomous Organization (DAO) Voting System** using Solidity smart contracts and a simple frontend.  
It allows administrators to create proposals, while voters can cast their votes securely on-chain.  
The goal is to provide transparency, immutability, and decentralized governance using blockchain technology.

---

## Features
- **Admin Dashboard**: Create and manage proposals.
- **Voter Portal**: Cast votes on proposals.
- **Results Page**: View voting outcomes in real-time.
- **Blockchain Integration**: Uses Solidity smart contracts for secure governance.

---

## Tech Stack
- **Smart Contracts**: Solidity, Foundry
- **Frontend**: HTML, CSS, JavaScript
- **Backend**: Node.js (Express, JSON server)
- **Blockchain Network**: zkSync Sepolia Testnet

---

## Screenshots

### Admin Dashboard (Version 1)
![Admin Dashboard v1](screenshots/Adminv1.png.png)

### Admin Dashboard (Version 2)
![Admin Dashboard v2](screenshots/adminv2.png.png)

### Voter Portal
![Voter Portal](screenshots/voterPortal.png.png)

---

## License
This project is licensed under the MIT License.
## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
