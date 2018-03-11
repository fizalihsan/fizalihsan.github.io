---
layout: page
title: "Blockchain"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}


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