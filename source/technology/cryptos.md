---
layout: page
title: "Cryptos"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}


# Blockchain

* Blockchain definition
    * TECHNICAL: Back-end database that maintains a distributed ledger, openly.
    * BUSINESS: Exchange network for moving value between peers.
    * LEGAL: A transaction validation mechanism, not requiring intermediary assistance.
* Blockchain = Software Engineering + Game Theory + Cryptography Science
    * __Game theory__ 
        is ‘the study of mathematical models of conflict and cooperation between intelligent rational decision-makers.” Bitcoin blockchain, originally conceived by Satoshi Nakamoto, had to solve a known game theory conundrum called the __Byzantine Generals Problem__. 
        * Solving that problem consists in mitigating any attempts by a small number of unethical Generals who would otherwise become traitors, and lie about coordinating their attack to guarantee victory. This is accomplished by enforcing a process for verifying the work that was put into crafting these messages, and time-limiting the requirement for seeing untampered messages in order to ensure their validity.
    * __Cryptography__
        * rests on hashing, public/private keys, and digital signatures.

* Decentralized Consensus
    * [Proof-of-Work](https://en.wikipedia.org/wiki/Proof-of-work_system) (POW) - 
        * BitCoin initiated this. Based on [Practical Byzantine Fault Tolerance](https://en.wikipedia.org/wiki/Byzantine_fault_tolerance#Practical_Byzantine_fault_tolerance)
        * is NOT environmentally friendly, because it requires large amounts of processing power from specialized machines that generate excessive energy.
    * [Proof-of-Stake](https://en.wikipedia.org/wiki/Proof-of-stake) (POS)
        * algorithm which relies on the concept of virtual mining and token-based voting, a process that does not require the intensity of computer processing as the POW, and one that promises to reach security in a more cost-effective manner.
    * Other consensus protocols: Raft, Paxos, DPOS (Delegated POS)


When discussing consensus algorithm, you need to consider the ___permissioning___ method, which determines who gets to control and participate in the consensus process. The 3 popular choices for the type of permissioning are:

* Public (e.g., POW, POS, Delegated POS)
* Private (uses secret keys to establish authority within a confined blockchain)
* Semi-private (e.g., consortium-based, uses traditional Byzantine Fault Tolerance in a federated manner)

# Cryptocurrency

- Digital Currency History
    - 1983 - David Chaum - Father of Digital Currency and Father of Online Anonymity
    - 2008 - Satoshi Nakamoto publishes whitepaper on Bitcoin. Claiming to solve 'double spending' problem in predecessor digital currencies
    - 2009 - Satoshi Nakamoto launches Bitcoin
- Cryptocurrency networks
    - Bitcoin network
    - Ethereum network
        - Ethereum 2.0 uses gas-metering model with a block - users can select how much gas they want to pay to make a seamless transaction.  The more gas they pay, the better transaction they will get access to.
    - Litecoin network
    - Solana network
    - Polkadot network
        - Faster transation throughput (1000/s)
        - Uses weight-based transaction fee model
        - $0 txn fee (zero-cost blockchain transaction fee)
        - processes parallel transactions with infinte scaling
- Famous Cryptocurrencies
    - Bitcoin
    - Ether
    - AMP

- Cryptocurrency Wallet 
    - stores private key + public keys + addresses
    - Key pair (private + public) is created. Using the public key, an address is created
    - What is a hot wallet?
    - What is a cold wallet?
- Cryptocurrency blockchains like Bitcoin are not encrypted, so anyone can read the transactions stored within them.
- Cryptocurrency isn’t used to encrypt the data in the blockchain. It’s used to sign messages that you send to the blockchain.

- Consensus Algorithms
    - Proof-of-Work
        - GPUs, ASICs (Application Specific Integrated Circuits), FPGA, etc.
        - GPUs and FPGAs are residential friendly
    - Proof-of-Stake
- Cryptocurrency Miners Community
    - https://miningchamber.com
    - Mining Chamber - https://discord/gg/bK6ptDN
    - https://coinsutra.com
    - https://asicminervalue.com
    - https://fpga.guide
    - https://whattomine.com
    - https://minerstat.com - What is a DAG file
    - https://etherscan.io
    - https://bitcoinblockhalf.com - Bitcoin rewards are halved every 4 yrs. Doesn't happen in Ethereum
    - https://ethermine.org
    - Types of Mining
        - CPU Mining
        - USB Mining
        - Storage Mining
    - Types of Mining Rigs
        - ASICs
        - FPGAs
        - GPU Mining
        - CPU Mining
        - ....
    - Types of Mining
        - Pool mining
            - https://crazypool.org
            - https://ezil.me
        - Solo mining
    - Types of Mining Services
        - Cloud mining - most of them are scams.
        - Hosting - if you are in a country like Germany where the electricity costs are high, you can host the rigs in a cheaper place like USA, that is if you know someone trustworthy paying them some comission.
        - Pre-builts
            - https://cryptominersoutlet.com
    - What impacts your mining profits
        - Transaction fees
        - Cryptocoin price
        - Difficulty of the network



https://coinmarketcap.com/alexandria/glossary

Double-spending problem
[Layer-1 Blockchain](https://coinmarketcap.com/alexandria/glossary/layer-1-blockchain) e.g., AVA
    Layer-1 solutions
        Consensus protocol
            Proof-of-work - BTC, ETH
            Proof-of-stake - PoW encourages selling. PoS encourages holding.
            Delegated Proof-of-stake - 
            Proof-of-history - 
        Sharding: scalability technique - Instead of making a network sequentially work on each transaction, sharding breaks these transaction sets into small data sets which are known as "shards," and these can then be processed by the network in parallel
What is gas fees?
Bridges
    A Dapp created on Ethereum blockchain would not work on Bitcoin blockchain.
    Bridges aim to connect two completely different blockchains to allow developers to benefit from faster processing speeds on less overloaded blockchains.
    Bridges are also used to connect source blockchain and side chains. This is done when the parent and child blockchains are operating based on different consensus mechanisms.
    Transfer of token happens between blockchains using `mint-and-burn` protocol.
    Easiest ways to make blockchain protocols interoperable is by creating wrapped tokens. e.g., Wrapped Bitcoin (WBTC)
    A recent successful blockchain bridge is between Tezos and Ethereum.
Side chains
    A sidechain is a side blockchain that is linked to another blockchain, referred to as the main chain, via a two-way peg.
    A well-known side chain bridge of the Ethereum blockchain was created to host the game Axie Infinity.
Shard chains
    Ethereum 2.0 has its own variation of sidechains called shard chains that are attached to the recently launched Beacon Chain, which aims to ultimately become the main chain of proof-of-stake (PoS)-based Ethereum.
Blockchain Trilemma
Stable coin, Alt coin, ...


* Halving & Burning
    - "Halving" and "Burning" creates scarcity which pushes the price of the coin up.
    - Bitcoin halves the reward for miners every 4 years.
    - From Ethereum 2.0 introduces __fee burning__ - which is burning the gas fees. When ETH moves to Proof-of-stake, which rewards miners based on the number of coins held/stake and not the highest computational power. Combination of these 2 changes would represent a __“triple halving,”__ as they would reduce sell pressure by an estimated 90% — the equivalent of three Bitcoin halvings.


* Questions
    * double-spending
    * Ethereum - smart contract
    * Digital Asset Holding - R6 - Corda
    * Dapps
    * Merkel tree
    * 21,000,000 is the max of bitcoins that can ever be mined - what does that mean and why?
    * DAO - Distributed Autonomous Organization

# References

* Books
    * The Business Blockchain