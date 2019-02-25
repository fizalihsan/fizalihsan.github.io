---
layout: page
title: "O'Reilly Software Architecture Conference 2017"
comments: false
sharing: false
footer: false
---

* list element with functor item
{:toc}

# Day 1

## Building Reactive Systems with Akka

* Sample code: http://github.com/henrikengstrom/sa-2017-akka
* Circuit-breakers - technique for resiliency. disallow customers from calling the service when it reaches the breaking point
* Reactive manifesto - http://www.reactivemanifesto.org
	* Responsive
	* Resilient (self-healing)
	* Elastic
	* Message Driven 
* Actors live inside a container called 'Actor System'.
* Actors are location-transparent. One can send a message to another actor which could be one a different node
* Akka Persistence - Event Sourcing style persistence, enables CQRS style architectures
* Akka Streams - Back Pressure
* JDK 9 - reactive streams support - java.util.current.flow, Websockets?
* Akka HTTP
* Alpakka is similar in goals to Apache Camel

## Cloud-Native Architecture Patterns


* Matt Stein (Software Architecture Radio)
* [Presentation Slides](https://www.slideshare.net/mstine/cloud-native-architecture-patterns-tutorial)
* Waterscrumfall
* Mean Time Between Failures -> Mean Time To Recovery
* DevOps
	* The Three Ways
		* Flow: Dev -> Ops
		* Feedback: Ops -> Dev
		* Continual Learning and Experimentation
	* If a microservice is not letting you do 3 ways, then you should stop building a microsevice
	* DevOps Handbook - Gene Kim, Jez Humble, ...Book
* Continuous Delivery
	* Ingredients
		* Configuration Management
		* Continous Integration
		* Automated Testing
* Cloud Computing
	* Service Model (*aaS pyramid)
		* SaaS 
		* Functions aaS
		* PaaS
		* Container aaS - Kubernetes
		* Infrastructure aaS
* Cloud Native Architecture Concepts
	* Modularity
	* Decomposition Strategies
		* Bounded Contexts (check DDD book for definition)
		* Value Streams
		* Single Responsibility Principle
		* Failure Domains
		* Anti-Corruption Layers (DDD)
* Article - [Everything you know about latency is wrong](http://bravenewgeek.com/everything-you-know-about-latency-is-wrong/)
* Architecting for Cloud Infrastructure
	* Architecting for DevOps aids in Continuous Delivery
	* Exploiting the capabilities of Cloud can enhance our ability to practice DevOps and CD
	* Architectural Responsibilities
		* Disposability, Replacability & Consequence
* Patterns
	* Externalizing Configuration
	* Externalizing State
		* Snow flake deployments -> Phoenix deployments
		* Spring Session - provides feature to store the session information to Redis, Hazlet, etc.
	* Brick Telemetry
		* inverse of the externalizing configuration
		* Microservices frameworks like Sprint Boot, Dropwizard follow this pattern
	* Mortar Patterns
		* Service Discovery
	* Edge Gateway
	* Fault Tolerance/Resilience patterns
		* Circuit breaker - e.g., 10 failures in 1 minute. [Netflix Hystrix](https://github.com/Netflix/Hystrix) is an open-source circuit breaker solution.
		* Tolerant Reader
		* Intelligent Agent
	* __Blue-Green deployment__, __Canary releases__, AB deploys
* [Netflix Eureka](https://github.com/Netflix/eureka/wiki)
* BFF pattern ([Backends for frontend](http://samnewman.io/patterns/architectural/bff/))
* DataDog - Monitoring service for cloud-scale applications
> DeskScribble - white boarding tool

# Day 2

## Keynotes

* __The evolution and future of Software Architecture__ (Mark Richards)
	* Agility, Velocity, Modularity, Testability, Performance, Scalability, Simplicity, Reliability
	* Streaming solutions
	* Autonomic self-healing systems that can monitor themselves and adapt to their environment
	* James Blieck - Faster 
* __Computers are easy; people are hard__ (Bridget Kromhout, Pivotal)
	* @honest_status, @ntakayama
	* Manager role is not a promotion, it's a different job
* __Introduction to serverless__ (Mike Roberts, Symphonia)
	* Backend-as-a-Service (BaaS)
		* Google Firebase (DB for Mobile developers)
		* Auth0
		* AWS solution?
	* Functions-as-a-Service (FaaS)
		* Triggers a function on a particular event - creates a new container, executes the function, returns result, destroys container
		* Events like message-event, time event, network file system, http requests
		* Faas = no management of Server hardware or server processes
		* AWS Lambda
	* Serverless = BaaS + FaaS
	* Common traits of serverless
		* no management of server hosts or server processes
		* self autoscale and auto provision based on load
		* costs based on precise usage (zero usage = zero cost). e.g., 5 mins of EC2 instance, you are paying for extra 55 mins of idle host
		* performance capabilities defined in terms other than host size/count
		* implicit high availability (not necessarily disaster recovery)
	* Why serverless? 
		* cheaper
		* better (experts manage the complex parts. let other people do the repetitive work for you), 
		* faster to develop and deploy apps
	* Adrian Cockroft - youtube video
	* Dangers
		* re-architect the app
		* state management
	* http://bit.ly/serverless-saconf-nyc

## Advanced continuous delivery strategies for containerized applications using DC/OS 

* Neil Gehani (Mesosphere, Inc)
* Container orchestration: Mesos, Kubernetes, Docker Swarm
* DC/OS - Data center Operating System
* OCI - Open Container Initiative
* Book - Continuous Delivery
* Github vs. Gitlab

## From VMs to Containers: A DevOps Journey

* David Grizzanti (Comcast)
* From where we started
	* Tickets for everything
	* Manual build and push of an RPM via puppet
	* Hardware load balancing + VIPs (virtual IPs)
	* Logging & Metrics
	* Separate dev and ops team
* Tech stack: 
	* Apache Mesos
	* Marathon
	* Docker
	* [Weave](https://www.weave.works/weave-discovery-and-docker-swarm/)
	* HashiCorp's [Consul](https://www.consul.io) - service discovery, secret management
	* HAProxy & Bamboo
* Good
	* Scala sbt kicking off Docker container for build/testing?
	* Jenkins - how to integrate with Docker?
* Bad
	* Visibility into the containers - e.g., checking the logs from more than one container. Mesos/Marathon comes for help
	* Significant decrease in performance - caused by Docker log driver taking CPU cycles during log compression
	* Application teardown - SIGKILL vs SIGTERM

## Daily development with Docker, Kubernetes, and OpenShift 

* Steven Pousty (Red Hat OpenShift)
* [Presentation](http://bit.ly/OSSoftArch) 
* [OpenShift](https://www.openshift.com)
* Kubernetes cluster architecture
	* etcd database - node/cluster checks current state with truth and updates to match the truth (Chef policy-like)
	* pods are the atomic unit
	* Do not put more than one container in a pod
* `oc new-app centos/nginx-16-centos7` 
* `oc new-app python:3.5~https://`
* open source project: source2image
* https://openshift.katacoda.com
* HyperV, Xhyve (lightweight virtualization on OS-X based on bhyve)

## Architectures for enabling serendipity 

* Daniel Somerfield (ThoughtWorks), Ryan Murray (ThoughtWorks)


## When microservices met event sourcing

* CQRS - Command Query Responsibility Seggregation

# Day 3

## Keynotes

* __Give me that old-time pattern language__ by Matt Stein
	* [Software Architecture Pattern Language](http://slack.osapl.org)
* __The Architects below__ by Jessica Karr ( [Atomists](http://atomist.com) )
* __Serverless architectures built on an open source platform__ by Daniel Krook (IBM)
	* bare metal --> VMs --> containers --> functions
	* Apache OpenWhisk
* __It starts and ends with you__ by Aaron Bedra ([Eligible](http://eligible.com))
	* As a system designer security begins and ends with you
	* Threat Modeling
		* First	
			* Open your system diagram
			* for every line, add a protocol
			* for every box, add the assets in transit aand at rest, and the controls in play
			* draw boundaries around logical network groupings
		* Second
			* Identify any assets with weak or missing controls
			* identify all points of entry into the system
			* list the bisiness objectives, goals and risks
			* map business risks to assets missing controls
			* rank you list of findings
		* Books
			* http://threatmodelingbook.com

## An architect's guide to evaluating cloud services: 10 things to consider 

* Matt Stein ( [Software Architecture Radio](http://www.softwarearchitecturerad.io) )
* Business Requirement
	* What is the business problem you are trying to solve?
	* How does this type of service address the problem?
	* how do providers of this type of service differentiate themselves with respect to your business problem?
* Resiliency
	* What are your resiliency requirements?
		* Availabilty
		* Consistency
		* PArtition tolerance
		* Durability - Load balancers, service registry, have state
* Security
	* Authentication
		* how does a client prove identity
		* how are credentials provisioned/stored
		* how are credentials delivered
		* how are credentials rotated
	* Authorization
		* what permission types are supported
		* are permissions grouped into roles
		* are roles customizable
		* how are roles assigned to actors
* Regulatory Compliance
	* data residency/sovereignty - e.g., German companies want data stored only in Germany
	* encryption
		* Data at Rest 
			* hardware level: disk encryption
			* encrypting data files in a DB
			* application level: encrypted password on a row level in DB
		* Data in Flight
	* Auditability
		* what happened
		* when did it happen
		* what actor caused it
		* where did it happen
		* why did it happen 
	* Certification Checkboxes
		* SOX compliant
		* PCI
		* HIPAA
		* FedRAMP
		* NIST 800-53
		* FIPS 140-2, ...
* Economics
	* who is operating the service? public cloud, hybrid, private cloud
	* what is your expected rate of consumption
	* how is your rate of consumption projected to grow
	* how is the service priced/costed
	* is the equation cost effective relative to your consumption rate and growth rate?
* Scalability
	* do you need to scale? 
	* how id your load/volume expected to grow? don't go for some fancy auto-scaling mechanism if you don't need it.
	* is your load/volume busty?
	* is your load/volume unpredictable?
	* does the service support scaling according to these needs?
* Provider 'Lock-In'
	* is there a sensible way to leverage multiple providers
	* is the service supported by open/defacto standards
	* is there a meaningful abstraction layer
	* are you subject to "data gravity"? Amazon provides a truck to migrate your data from your data center to AWS. Now what if you wanted to move out of AWS? Will that vendor provide a truck?
* Available Tooling
	* how good is the documentation
	* does the service have a well designed API
	* are client libraries available for your language(s) of choice?
	* Does your app framework of choice support the service?
	* is good management tooling available?
	* is there a management API? ß
	* is there automation tooling available for management?
* Undifferentiated heavy lifting
	* what gaps do you need to close that EVERYONE has to close?
	* what will it cost you to close those gaps?
	* what will it cost you to keep them closed? 
	* are there ecosystem partners in ths business of closing these gaps?
	* is the provider working on closing these gaps?
* Differentiating Features
	* (this is where we often start, but is the least important one. Don't look for the latest shiny thing)
	* there's a lot of parity out there
	* but could be the decision maker (AWS, Azure, Google - Google has its own fiber for networking)

* Scorecard
	* summarized view of why you made a particular choice
	* you want an organized way to demonstrate why you made your decision
	* Scorecard
		*KISS
		* No binary 
		* Simple ranges: 1-3 or 1-5 
		* Add weights for prioritization
		* Call out subcategories when valuable

## It’s not continuous delivery if you can’t deploy right now.

* Ken Mugrage (ThoughtWorks ) - [GoCD](https://www.thoughtworks.com/go/)
* Job of a a pipeline is to avoid release candidates
* Continuous deployment is not continuous delivery. Deployment is installing in prod. Delivery/Release is when the business approves to toggle the flag and users start to see the changes.
* Recommended CI practices
	* everyone commits to trunk at least daily
	* automates tests are run for evey commit
	* avoid branches
* Releasing incomplete work
	* Feature toggles (http://martinfowler.com/articles/feature-toggles.html) 
		* Don't confuse deploy with release
* Pipelines you should be including
	* test before you commit http://thoughtworks.github.io/talisman
	* have you included private keys? Authentication tokens?
	* Static Application Security Testing (SAST) - like FindBugs?
	* Dynamic Application Security Testing (DAST)
* Performance Testing
	* Load testing - simplest form of performance testing. 
	* Stress testing - to understand the upper limits of capacity within the system
	* Soak testing (or endurance testing) is usually done to determine if the system can sustain the continuous expected load	* Spike testing
* Build pipeline
	* Run as much as possible in parallel
* Managing Risk
	* Deployment patterns
		* Canary release
		* Dark launching	- Facebook messenger trial running their app selectively
		* http://githubengineering.com/move-fast
	* Feeback loops
		* create useful logging for everything
		* Run (some of) your tests against production
		* Ensure alerts are useful
	* Optimized for Recovery
		* MTBF (Mean time between failures)
		* MTTR (Mean time to repair)
		* State of devops report 
	* Knight Capital
		* deployed untested software to prod which had an obsolete function. Incident happened due to a techician forgetting to copy the new Retail Liquidity Program (Lack of automated testing costed the company $440,000,000)

## Hybrid cloud deployment patterns using Kubernetes

* Sandeep Parikh (Google)
* Kubernetes, Pods, Services, Replica Sets, Namespaces, Container Engine
* Deployment Types
	* Hybrid, heterogenous, multi-cloud, public/private
	* _Heterogenous_
		* Why Heterogenous
			* maxed out resources
			* limited geo reach
			* high availability
			* avoid vendor lock-in
			* comuter flexibility
			* access to services
		* Heterogenous is hard
	* _Multiple cloud_ 
		* Auto-scaling is hard
		* Load balancing 
* Service spec
	* Handling requests with Ingress
* Federation
	* Why?
		* Sync resources across clusters
		* cross-cluster service discovery
		* HA apps
	* Why not?
		* increased network bandwidth and cost
		* reduced cross-cluster isolation
		* each deployment is a snowflake (https://martinfowler.com/bliki/SnowflakeServer.html)

## The little things of horror 

* Alasdair Allan (Babilim Light Industries)
* Security breaches
 	* 750GB+ of TSA data exposed to public for over a year
	* CCTV cameras
	* IoT devices taken over
	* Baby monitors
	* Baby Toys - Cloud Pets teddy bears
	* Carna botnet 
	* Hacking printers
	* Garage door - Garadget company
	* 'Ring' smart door bell company
	* iKettle
	* Hotel radio connected to Wifi

## 10 lessons learned from building cloud-native middleware microservices

* Kai Wähner (TIBCO)
* Pattern
	* Backends for frontends (http://thoughtworks.com/insights/blog/bff-soundcloud)
* _4_ Design microservices with open APIs in mind
	* [12 factor apps](https://12factor.net)
* _5_ Cloud-native is much more than just cloud-washed
* Containers
	* Cloud Foundry uses Garden
* _6_ Microservices and containers are often used together, but also work very well without each other
	* http://github.com/cncf/landscape
	* http://slideshare.net/cdavisafc/cloud-foundry-technical-overview
* _7_ Be cloud platform-agnostic
* _8_ containers are low-level technology. Only the infrastructure provider should care, but not the app developer
* _9_ Automation (CI/CD/DevOps) and cultural changes are key changes to success
* _10_ Cloud native middleware microservices leverage various technologies, open source frameworks and infrastructure components like containers or messaging

# TODO

* Containerization
	* Docker
	* container-focused schedulers? 
	* Kubernetes
* Circuit breaker
* CQRS - Even sourcing
* Reactive
	* Actor model 
	* Akka (Lightbend)
	* Reactive Streams
	* FRP-based libraries (Functional Reactive Programming)
	* Reactive toolkits: Netty, Akka, Play, RxJava
	* Back-pressure 

# Theme

* Container ecosystem - Kubernetes, OpenShift
* DevOps - Continuous Delivery
* Reactive architecture - Akka
* Microservices
* Serverless

