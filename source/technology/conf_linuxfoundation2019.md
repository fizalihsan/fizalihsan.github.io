---
layout: page
title: "Open FinTech Forum - Linux Foundation - NYC 12/09/2019"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}


* Linux Foundation
    * Security - Let's Encrypt
    * Networking - ONAP (open national automation platform), Open Daylight
    * Cloud - CNCF Cloud Foundry, Cloud information model
    * Automotive - Automotive Rade linux
    * Blockchain - hyperledger
    * Edge/embedded - zephyr, yocto, edge foundry
    * Web - Nodejs, OpenJS foundation
* Film making softwares - OpenVDB, OpenColorIO
* Unlock Open Source Technology's Full Value - [Forrester report]()
* Ant Financial (powers Alibaba pay)
* Air Force F18s runs K8s
* Gitlab - The Multicloud Maturity Model - Sid Sijbrandij, Gitlab CEO (@sytses)
    * Why multicloud
        * functional differences
        * leverage in negotiations
        * acquistions where products are built on cloud
        * customers competing with a specific cloud
        * tough security and compliance regulations
    * Levels of multicloud adoption
        * monocloud
        * no portability: cloud dependent devops process
        * workflow porability: cloud independent devops process
        * application portability: apps can run on any cloud
        * DR portability: apps can failover to another cloud - gitlab geo?
        * workload portability: apps shift workload b/w multiple clouds dynamically
        * data portability: data changes can happen in multiple clouds (hardest) - Cockroach db does this
    * Goldman Sachs - PURE - a logical modeling language and "Alloy". Will be available in a FINOS Gitlab repo under an Apache 2.0 open source license mid-2020
* Robin.io - 
    * K8s to the edge
* Oracle - A new blueprint for a modern app dev and runtime env
    * High perf Microservices - Helidon with GraalVM - microprofile solution - better start up time (0.02 secs) than Dropwizard, Quarkus, SpringBoot
    * Quarkus
* Hyperledger & CensenSys - Blockchain balance
    * Besu - Java based Ethereum client
    * ConsenSys - public blockchain
    * Kmow your supplier - Chainyard and IBM to reimagine supplier procurement
    * libra association - payment permissioned blockchain
    * Santander settles both sides of a $20M bond trade on public Ethereum
    * Lacchain - public permissioned chain
    * Offchain storage - decideing on what really need to be stored on the ledger. Offchain storage allows you to use the benefts of blockchain while protecting PII
    * Trusted Execution Environments - hyperledger avalon, enterprise ethereum alliance, oasis labs
        * HSM - h/w security module?
    * Zero knowledge systems: Zcash, Hyperledger Indy, aztec (protocol)
    * super cookie problem?
* CI/CD AI/MK
    * Dev tools: Kite/Codota
    * Test: predict outcome, trend analysis.
    * Builds: trending B.O.M. testing
    * Statistical analysis of deployment pipelines. Analytics on CM/RM, predictive analytics on defects
    * NLG - Natural language generation tools. 
    * https://s-case.github.io
    * pix2code: Teaching machines to use
    * Image to web/mobile gui generation: http://uiwizard.io
* Blockchain - Is it the right technology for my business? [Slides](https://static.sched.com/hosted_files/oftf19/1b/2019%20Events%20-%20Open%20Fintech%20-%20Linux%20Foundation.pdf)
    * Consensys: app layer on Ethereum blockchain
    * Infura, Besu, Kaleido, MythX, Truffle, Metamask
    * Learnings - http://learn.consensys.net
    * Public Ethereum has scalability, privacy and permissioning problems which is solved by private Ethereum
    * NASDAQ uses blockchain in production - settlements
    * Properties to assess before using blockchain for your business use-cases:
        * secure, peer-to-peer, traceable, immutable, auditable 
    * Properties to assess before using blockchain for your business requirements:
        * legal, governance, user, trustless
* Sysdig, Falco
    * compare with Twistlock
    * [Open source Falco](https://github.com/falcosecurity/falco)
    * [How to implement an open source container security stack](https://sysdig.com/blog/oss-container-security-stack/)
    * image scanning, runtime scanning (wireshark level of system call details)
    * Kube CIS Benchmark across clusters - host level compliance/vulnerability details
    * Crypto jacking detection - CPU spiking above a certain threshold
    * [Kubeless](https://kubeless.io) is a Function as a Service framework for Kubernetes.
* Thread Modelling to secure a cluster - [Controlplane](https://control-plane.io/)
    * @subliminio, @controlplane
    * [Kubesim](https://kubesim.io)
    * Representing a threat model - annotate the architecture diagram
    * Kubernetes is not SOC-friendly
    * https://github.com/cncf/financial-user-group
    * what is a blue or red team? Red team simulates attack and blue team defends. https://securitytrails.com/blog/cybersecurity-red-blue-team
    * https://github.com/kubernetes-simulator/simulator
* Become a data-driven organization through Unified Metadata 
    * https://github.com/ODPi/egeria
    * Design thinking
* Tetrate - Service Mesh to Production with your cloud native
    * https://tetrate.io
    * Multicloud, DevSecOps, Microservices
    * Service Meshes: Istio from Google, Linkerd
    * Proxy: Envoy (written in C++, extremely performant)
    * what is mTLS?
    * What is Citadel? Certificate authority/management
    * SPIFFE X.509 SVID
    * Best practices
        * Assess your existing systems and process