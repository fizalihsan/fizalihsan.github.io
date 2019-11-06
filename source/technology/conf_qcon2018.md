---
layout: page
title: "QCon 2018"
comments: false
sharing: false
footer: false
---

* list element with functor item
{:toc}

# QCon 2018

## Day 1

* Keynote - Developers as a Malware distribution vehicle (@guypod)
    * XCodeGhost - Sep 2015, malwares in XCode -started from China appstore - undetected for 4 months
    * Induc Malware - 2009, Delphi programming language, undetected for 10 months, replicates via compilers not executables
    * Ken Thompson Hack - 1984 - adds a malware while compiling, but removes itself during decompiling - Solution from David Wheeler
    * Malicious python, npm packages, docker images
    * Injecting Vulnerability into Angular.js
    * Syrian Electronic Army and Financial times (2013) - read article from Andrew Betts "A Sobering Day"
    * Uber Hack (2016) - 
    * [Security Ergonomics - Youtube video](https://www.youtube.com/watch?v=fDryj_9I5eM)
    * How companies implement security
        * [Google BeyondCorp](https://cloud.google.com/beyondcorp) (IAP - Identity Aware Proxy)
        * Microsoft PAW (Privileged Access Workstations)
        * Netflix BLESS
* Chick-fil-A architecture
    * https://medium.com/@cfatechblog
    * Problem: Driving food production via IoT, automating some of the cooking devices, sales data, payment processing, etc
    * Edge computing - every restaurant runs a Kubernetes cluster
    * Why edge - because every restaurant should continue to operate even in absence of network failure or other disasters
    * 2000 restaurants - 2000 clusters, 6000 nodes, 7 engineers including an SRE run the infra
    * Restaurant data center - NUC device = Intel quadcore processor, 8GB RAM
    * manageable remotely, automated device discovery and self-clustering, self-healing
    * Friers and other devices are controlled by this device
    * prometheus runs on the edge
    * Components
        * Highlander - custom tool for clustering leader election
        * Istio - alternate to NGinx
        * cluster initialization
            * used RKE(Rancher Kubernetes Engine)
            * other options tried: kops ( no bare metal), kubespray (slow, brittle), kubeadm (may be in future), RKE
        * Resetting cluster state:
            * need to be able to re-image remotely
            * solution: Overlay FS + HAMS (manages wiping clsuters and restoring to base)
        * [Hooves up](https://github.com/chick-fil-a/hoovesup) - self healing AWS SSM (Simple systems manager) registration - able to do remote commands and patch reporting/management - remotely logging via SSM and issue AWS commands to install Ansible
        * Fleet (custom)
            * custom package and deployment management tool
            * other tools: SQS, MQTT, Helm
            * supports variety of deploymnet models including canary, blue/green
            * sane rollback 
* Canopy: Scalable Distributed Tracing & Analysis @Facebook
    * Observability
    * how distributed tracing works in microservices world - [OpenTracing](http://opentracing.io/documentation/)
    * what is p75 and p90 in terms of latency
    * Distributed Tracing - holistic view of a single request - each request is assigned a token - tracing happens at transport level, not application level - each writes to a common store - don't trace all requests, use sampling say one out of every 100 or 1000 requests
    * multithreaded service calls
    * Does NewRelic support distrubted tracing?
    * [canopy-end-to-end-performance-tracing-at-scale](https://research.fb.com/publications/canopy-end-to-end-performance-tracing-at-scale/)
    * Understanding RPC vs REST for HTTP APIs
    * Open source
        * [OpenTracing](http://opentracing.io)
        * [OpenZipkin](https://zipkin.io)
        * [XRay from Amazon](https://aws.amazon.com/xray/)
        * 

* Scaling Push Messaging for Millions of Devices @Netflix
    * PUSH - persist until something happens
    * Zuul - uses WebSockets/SSE
    * used to push real-time update of movie suggestions - helped reduce 12% of load on Netflix servers
    * what is C10K challenge - 10K concurrent connections at a time to a server - creating a new thread for each socket connection doesn't scale - Async I/O uses read/write callback and single thread
    * Netflix uses Netty non-blocking I/O
    * Zuul push server
        * clients connect to these servers which opens a websocket connection
        * connections are auto-closed periodically on the server to avoid clients connecting to old version of software/cluster after a server upgrade (avoiding thundering herd problem) - randomize each connection lifetime ( to avoid recurring thundering herd problem caused by any blips) - ask client to close connection within a time frame
        * how to optimize push servers - Goldilocks strategy - more smaller instances, not fewer large instances
        * how to auto-scale - based on open connections per server
        * Amazon ELBs cannot proxy websockets - by default they run as HTTP load balancer - run ELB as a TCP load balancer to solve the problem. Amazon now supports ALB (websocket-aware application load balancer) supports web sockets
    * Zuul push registry 
        * keeps track of which client is connected to which push server 
        * any data store with with following features can be used as push registry. Netflix uses Dynomite
            * low read latency
            * record expiry (when client disconnects) 
            * sharding and replication
    * Message Processing
        * uses kafka
        * application uses push library to push the message to a queue
        * multiple - uses Mantis (similar to Flink) to streamline process the queues

* Forced Evolution: Shopify's Journey to Kubernetes
    * 
* 3 Common Pitfalls in Microservice Integration
    * Google for InfoWorld article on the same topic by the presenter
    * Challenges of Asynchronicity
        * synchronous blocking call exhausts threads in pool - use circuit breaker (Netflix Hystrix) 
        * fail fast is important but not enough - (e.g., flight check-in failure due to bar code generator)
        * Workflow engines, state machines - AWS Step Functions, Uber Cadence, Netflix Conductor, jBPM, Camunda (Java based), Zeebe by Camunda, Activiti
        * Manigfold architecture options to run a workflow engine - blog article
        * A synchronous response is possible in the happy case, otherwise it is switched to async processing
    * Communication is complex
        * Client has to implement timeout, retry, compensation
        * Service Providers has to implement idempotency - (anti-pattern: Do not refresh the page)
        * It is hard to differentiate communication problems - unable to communicate to service or service received request but unable to respond back
        * Problems operating message bus - dead message, no context, inaccesible payload, hard to redeliver, ...
    * Distributed Transactions
        * Paper: Life beyond distributed transactions: an apostate's opinion - Pet Helland
        * [Saga pattern](http://microservices.io/patterns/data/saga.html)
            * or compensating activity (BPMN engine can do that automatically) - Distributed transactions using compensation - eventual consistency
        * Service Provider has to offer compensation
    * [Flowing Retail](https://github.com/flowing/flowing-retail)


## Day 2

* Keynote - A brief, opinionated history of the API by Joshua Bloch
* Efficient Fault Tolerant Java with Aeron Clustering
    * Fault Tolerance
        * Load balancer is another form of fault tolerance
        * Fault tolerance of state - partition, replication
        * Guaranteed messaging / queueing don't store the previous state of a system
            * Exactly-Once vs. atleast-once
            * blocking ACK spiral
            * nondeterministic restarts
            * Contention and coherence
            * poison message and error queues
        * Better way: Contiguous log with snapshot & replay
            * processing the log, build a state
            * Aircrafts and spacecrafts process log, build state, marking the snapshot and store the state at that snapshot. In case of failure, it restarts from the last snapshot/checkpoint and starts from the stored state. Same concept as in database checkpoints
        * Clustered services
        * Replicated state machines
            * Raft consensus
                * Strong leader - elected member of the cluster, orders input, disseminates consensus
                * Raft is an algorithm with formal verification
                * Raft is not a specification or a complete system
            * in real-world, we need more than raft
                * leader timestamps events
                * async, not rpc-based
                * timers
            * Benefits
                * determinism
                * log is immutable
                * log can beplayed, stopped and replayed
                * each event is timestamped
                * services are restrated from snapshot and log
            * Distributed key/value store, distributed timers, distributed locks
        * Finance: matching engines, order management, P&L, risk
        * CQRS is another system built on the idea of event logs 
    * Aeron ()
        * Efficient reliable UDP unicast, UDP multicast, and IPC message transport
* How to Accelerate Delivery of Reliable Software (OverOps)
    * [Culture of Observability](http://onemogin.com/observability/stripe/culture/monitoring/monitorama/creating-a-culture-of-observability.html)
    * AI Ops, MetricsHub app
    * Shift to Observability
        * Application monitoring - 
        * Application observability (like operations to devops)
            * debugging needs more context
        * Accelerate release lifecycle
    * Overops captures all swallowed exceptions, including the threadstack and data flowing through the code, also provides the author the code causing the error - tells you if the error is new or resurfaced
    * Overops gives app metrics like bugs introduced, swallowed exceptions, etc. release over release - helps towards code accountability
* Debugging Microservices: How Google SREs Resolve Outages (Google)
    * SLO (Service level objective) - Google has only regional SLOs
        * e.g., Percentage of slow user queries too high
    * [OODA (Observe-Orient-Direct-Act) loop](https://en.wikipedia.org/wiki/OODA_loop)
    * SLO breach debugging steps
        * Layer peeling
        * Dynamic Data Joins
        * Exemplars
    * What is StackDriver? Panopticon? Monarch?
    * [Cloud Platform - Google Blog](https://cloudplatform.googleblog.com)
* How Blockchains Work and How To Scale Them ([BloxRoute Labs](http://www.bloxroute.com)
    * What is blockchain
        * goal: cut out middlemen
        * special nodes called Miners (Proof of Work)
            * listen to txns
            * aggregate txs into blocks
            * each block reward it
    * Scability Problem
        * [Blockchain Scalability](https://blockgeeks.com/guides/blockchain-scalability/)
    * Solution
        * sending lot of data to lot of people is a solved problem - Akamai '96
        * Relay networks (1 block in bitcoin takes a 10 secs to reach the entire n/w)
            * cons - censorship, discrimination (one miner can restrict blocks from a particular person), ban wallets, requires everyone's trust 
    * bloXroute design
        * Blockchain distribution Network (BDN)
        * new network primitive - similar to relay - acts as a peer
        * Open-source "Magic Gateway"
        * x1000 faster
        * Neutrality
            * Hide content, source and destination
            * encrypted blocks
            * send key afterwards
            * Relay via Peer (TOR like)
            * Receive via Peer
        * Other scaling alternatives
            * sharding (layer 1)
            * lightning network / plasma (layer 2)
            * blockchain/DAG (e.g., Hashgraph)
* Create and Deploy a Blockchain App in the Cloud (alf@us.ibm.com, Lennart Frantzell) 
    * Actors
        * Blockchain Developer - Application smart contract, ledger
        * Operator - traditional procesing platforms, tranditional data sources, events, systems integration, peers, concensus, security, 
        * Architect - business concerns, design trade offs
    * Use cases
        * [Blockchain use cases](https://www.ibm.com/blockchain/use-cases) - good place for beginners
    * How do we program the ledger?
        * With Chaincode aka Smart Contracts - [Hyperledger docs](http://hyperledger-fabric.readthedocs.io/en/release-1.1/) - best documentation for smart contract developers
        * [Hyperledger Fabric](https://www.hyperledger.org/projects/fabric)
        * [Hyperledger Compose](https://www.hyperledger.org/projects/composer) - web-based tool to create smart contracts
            * files involved
                * Model file (*.cto)
                * Script file (file.js)
                * Access control file (file.acl)
            * business network has
                participant
                asset 
                transaction
                event
            * to deploy - zip above files are put in a *.bna (business network archive) file and deploy to Hyperledger Fabric
            * to deploy to cloud
                * IBM Blockchain Starter Plan Beta


## Day 3

* Key note: The history of fire escapes (Tanya Reilly - Principal Engineer @squarespace)
    * NY Tenement museum
    * Disaster management (reliability is everyone's job)
        * prevention 
            * think of SREs and ops as fire fighters - as last resort
            * `#hugops`
            * making it harder for the fire to start
            * wiring inspection (good test suite, chaos engineering)
        * detection
            * stop while it is small
            * use of canary env to test out the impact
            * feature flags to restrict the impact
            * sprinklers - automatic replacement of bad instances or servers instead of 3 am call
        * isolation - preventing it from spreading
            * fire barriers - sharding/replication to isolate the problem
            * fire drills - train on incident response
            * avoiding encumbrances - pay technical debt, tired people make mistakes
        * response
            * controlled burns - controlled outages
    * DO NOT add fire escapes (reliability) as an after-thought to the buildings (software)
    * Bad softwares also could kill people - so the stakes are high
* Translytical Databases & the New Data-Driven Apps (SAP)
    * SAP HANA platform - multi-modal, in-memory data processing environment
    * Using SQL to query the same data which would typically live in 2 diff db - OLTP and OLAP
    * document store is not-relational. supports columnar
    * supports geo-spatial queries
    * support text analysis
    * Express edition - free license up to 32 GB RAM - both on premise or cloud deployment
        * VM/Docker/Kubernetes
    * https://developers.sap.com
* Seamlessly Migrating To Serverless with 80-Million Users (Bustle.com CTO)
    * [Strangler pattern](https://www.martinfowler.com/bliki/StranglerApplication.html)
* Help! I accidentally distributed my system
    * 
* Have You Tried Turning It Off and On Again? (David Blank-Edelman, Author of Seeking SRE, Founder of SRECon, @otterbook)
    * useless machine video (funny example of resiliency)
    * What is SRE (check pic)
    * SLO (Service level objective)
    * Characteristics of a resilient system
        * blameless postmortems - focus on improvement to the process
        * Nature of Work
            * Toiling without any value makes no sense
            * resiliency is a long game, it won't happen overnight - you cannot burn out people
        * Interfaces
            * Error budget - developers and SRE meeting constantly to discuss the state of the code and system. There is no point in blaming each other about quality of code and instability of the system
        * Data

## New technologies

* Companies: 
    * Doordash
    * Atomist
    * SynkSec (security company)
    * Shopify
    * Stripe - provides APIs that web developers can use to integrate payment processing into their websites and mobile applications.
    * Twilio
    * Bustle

* Camunden? - BPMN solution 
* [Aeron clustering](https://github.com/real-logic/aeron)
* Systems Management, Distributed Tracing, Monitoring solutions
    * [StackDriver](https://cloud.google.com/stackdriver/) - hybrid cloud solution supporting both Google 
    * [Zipkin](https://zipkin.io) - distributed tracing framework
    * [Honeycomb](https://www.infoq.com/news/2016/10/honeycomb-debug-systems) - a tool for observing and correlating events in distributed systems 
    * [OpenCensus](https://opencensus.io)
* Chaos Engineering
    * Gremlin - chaos engineering tool
* Cloud
    * Ballerina - Cloud native programming language
* Web
    * Vaadin - Framework to convert Java to web programming language
* DevOps
    * JFrog Xray - software violation rules are defined in SaaS - Xray can be installed locally and integrated with Jenkins - scans through the packages recursively including python, npm, docker, etc. looking for vulnerabilities


## Questions

* What is Web Assembly
* Learn how to implement 2FA in an application
* What is Edge computing
* what is control plane
* What is MQTT (similar to AWS SQS)
* Google Firebase - what is backend-as-a-service
* What is Service Mesh
* Raft consensus algo
* Helm (Chart)
* [Probablistic Programming Language](https://en.wikipedia.org/wiki/Probabilistic_programming_language)
* Hack programming language
    * by Facebook - dialect of PHP - built for HHVM(HipHop VM) - both dynamically typed and statically typed (also called gradually typing system) - Hack seems to add some features to PHP to make it a more reasonable programming language


## Try out 

* AWS Step Functions



## Books

* Accelerate
* Real-Life BPMN