---
layout: page
title: "O'Reilly Software Architecture Conference 2019"
comments: false
sharing: false
footer: false
---
* list element with functor item
{:toc}
# Software Architecture Conference 2019

# Day 1 - META: Microservices
* META: Microservice-based Enterprise Transformation Approach
* Barriers to Digital Transformation
    * Highly-integrated apps and data
    * Legacy tech, packaged solutions, skill gaps
    * Large, hierarchical organizations
    * Outsourcing, geographical distribution
    * industry regulations, shareholder/public scrutiny
* Essential vs. accidental complexity
    * Essential - stuff that can't be broken down. the complexity of the software's functional scope and the problems it solves (e.g., correlating and analyzing large amounts of data in real time)
    * accidental - complexity of language implementation
    * Frederick Brook - Mythical man month - No silver bullet article
* Modularization
    * Modularity is to a technological economy what the division of labor is for the manufactoring
    * Aligned modularization with domains (DDD)
* Agile
* System control
    * Roy Fieldings quote on control and REST
* Beyond system
    * the biggest cause of failure in software-intensive systems is not technical failure; it's building the wrong thing. (Mary Poppendieck - creator of Lean Software Development)
    * almost always
* Lessons
    * 1 - differentiate the complexity
    * 2 - modularize the system
    * 3 - start small and iterate
    * 4 - influence - don't control - the system
    * 5 - the system is more then 'The System' (people, etc)

# Design
## Program Design
## System Design
* Define the target system scope
* Determine functional domains
    - bounded contexts, services, and interactions
* Determine non-functional domains
    - trust domains (security), operational domains (availability, reliability, capacity)
__Complexity in a microservice architecture__
* Essential complexity in microservices
    * in a microservice architecture, the topology of the implemented system closely resembles the model of the system's essence
* Accidental complexity in microservices
    * in a microservice architecture, accidental complexity can be minimized through automation and distribution
DDD provides a framework for defining and modeling the essentail capabilities of complex software systems.
* Event Storming - by Alberto Brandolini
    * product, technology teams together - discuss business events and outcomes - sticky notes
* Innovative dilemma book - 'jobs-to-be-done' process
* Susan Fowler - Production Ready Microservices book
## Service Design
* Sketch the service
    * take an 'outside in' approach
* Design the _interface_
    * API contract
    * prototype it
    * Design canvas based on Lean Canvas concept
        * the idea here is to put all the information about the service in a single page before jumpting into the implementation
* Determine the _implementation_
    * Find a reusable service
    * evolve an existing service
    * develop net new service
* 'Just enough' design
## Foundation Design
* think of the capabilities you need, before choosing a technology
* POISED: technological capability foundation
    * Microservices (honeycomb)
        * platform capabilities
        * observation capabilities
        * interop capabilities
        * security capabilities
        * engineering capabilities
        * deployment capabilities
## 
* Processes & Methodologies
* Organizational Practices
* Cultural Practices
* Agile - Spotify (idea of guilds)

# Architectural anti-patterns when delivering a software ecosystem with Kubernetes
* Anti-patterns
    * Statefulness
    * Keep configurations as environment variables
    * Health check/probes
        * liveness probe - if K8S finds a pod is not passing liveness, it will restart
        * readiness probe - if K8S finds a pod is not passing readiness, it will not restart. It will stop the traffic to that service.
        * Liveness and readiness health checks should be different urls
        * use different port for app and management
    * one pod - multiple containers within.
        * this is nothing but a modular monolith. You cannot deploy or scale independently

# Day 2 - Keynotes
* 37 things one architect knows about IT transformation - Gregor Hohpe
* IBM KNative
* Architect skills (Trisha Gee - JetBrains)
    * Skills
        * Asking questions - and listening to answers
        * Good communication skills
            * good emails, documentation
            * talking to computers is easy
        * Adaptability - and being open minded
            * don't be dogmatic about stuff
        * Prioritisation - and time management
        * Technology skills
            * ability to learn new skills
        * Be aware
            * If you perform non-technical activities too well, you may well be moved to non-technical roles
    * Scaling
        * to become a 10x developer, teach 10 other developers
        * Pair programming
            * best way to share knowledge
            * Mob programming - not just developers, but also QA + product
        * Community support
        * Internal learning sessions
            * Monday morning brown bags
            * Internal user groups
            * Guilds
        * Book club
            * everyone read one chapter from a book and present it
    * Summary
        * your key skills are not technical
        * to scale your skills, share them
 
* Chat with Mark Richards
    * Those who cannot remember their past are condemned to repeat the mistakes
    * ArchUnit - automated architecture governance tool. https://www.archunit.org/
    * Cart before the horse. Jumping the band wagon - microservice, cloud, ...
    * Next Gen - self-governing, self-protecting, self-healing autonomic systems
 
* Serverless Content Delivery
    * SymphoniaCloud - https://github.com/SymphoniaCloud
    * https://github.com/symphoniacloud/sacon-nyc-2019-continuous-delivery
    * Serverless attributes
        * no managing of hosts or processes
        * self auto scaling and provisioning
        * costs based on precise usage
        *
    * Serverless = FaaS + BaaS
        * Function aaS (AWS Lambda, Auth0 Webtask, Google Cloud Functions)
        * Backend aaS (AuthO, Firebase, CloudFront, S3, Parse)
    * S3
        * 99.9999999999% durability
        * 99.99% availability
        * hosting a website on S3
        * pay by the request
        * no servers (from our perspective)
        * highly available
        * highly scalable
        * Caveats
            * relatively slow
            * S3 is regional , so requests must go to the regional data center
            * custom domain require a specific bucket name
                * S3 global bucket namespace == squatting, requires support intervention
            * S3 transfer/request pricing
    * CloudFormation + AWS Route 53 DNS + ACM (AWS Certificate Manager) + Lambda@Edge basics
    * Lambda@Edge basics
        * a flavor of lambda that runs in cloudfront
        * hooks into viewer and origin request/response events
        * Node.js runtime only
        * viewer requests/response has limited capability (5 secs runtime, 10MB response, 1 MB function)
        * origin requests/response (30 secs runtime)
 
* Gitops
* Fitness function driven development
 
* Security Principles
    * Least privilege - limit privileges to the minimum for the context
    * Separate responsibilities - separate and compartmentalize responsibilities and privileges
    * Trust cautiously - assume unknown entities are untrusted, have a clear process to establish trust, validate who is connecting
    * Simplest solution possible - actively design for simplicity - avoid complex failure modes, implicit behavior, unnecessary features
    * Audit sensitive events - record all security significant events in a tamper-resistent store
    * Secure defaults & Fail securely - force changes to security sensitive parameters. Think through failures - to be secure but recoverable
    * Never ruly on obscurity - assume attacker with perfect knowledge, this forces secure system design
    * Defence in depth - don't rely on single point of security, secure every level, stop failures at one level propagating
        * Hardening - Highly secure linux hosts
    * Never invent security tech - don't create  your own security technology - always use a proven component
        * Use tools like Hashicorp Vault
    * Secure the weakest link - find the weakest link in the security chain and strengthen it - repeat! (Threat modelling)
 
    * Hackers need to get lucky only once. You need to be lucky all the time.
    * Book: Software Systems Architecture
 
* Kubernetes for Java Developers
    * Java 9 modularity - jlink, jdeps
    * Micro VMs - Fire cracker, NanoVM
   
* Continuous Threat modelling
    * Email the author for the presentation
    * "All software developers are now security engineers. Your code is now the security of the org you work for" - Jim Manico
    * In addition to performance questions in interviews, ask security questions too.
    * Threat Modelling
        * around for a long time - predates Agile
        * threat model every story
            * if the story generates a security 'notable event', either fix it or pop it up as a 'threat model candidate finding' for the curator to take notice of
        * "Teach principles not formulas" - Richard Feynman
        * Principle checklist
            * not more than a page
        TM as code
            * ThreatSpec - @zeroXten - TM in code
            * ThreatPlaybook - @abhaybharghav - TM from code
            * PyTM (https://github.com/izar/pytm)
                * write python code - generate images as output
 
# Day 3
 
* Keynotes
    * Book list
    * Observability
    * Interops
    * Codifying best practices - Archunit
    * Kubernetes Operators - extension points
 
* Choreographing Microservices (Allen Holub @allenholub holub.com)
    * Small
    * Independently deployable - one service change should not force other services to change. this includes the UI
    * hides implementation details
    * modeled around business concepts ( DDD is necessary)
    * decentralized ( distributed)
    * highly observable
    * autonomous, highly isolated
        * Microsoft Service Fabric is an abomination - now you are dependent on a platform. Same thing with OpenShift vs Mulesoft
    * temporal isolation
    * location transparency - you don't know where it is running. sticky routing
    * Think 'object' - an object is defined by what it does, not what it contains. Services should be doing something, not providing data.
   * You shouldn't know who's talking to you - you shouldn't need to know the IP address, location, etc. Decoupling.
    * you should be able to radically change the implementation of a class without impacting the clients
    * Bounded context - models business structure or flow.
        * sometimes each bounded context is a microservice, sometimes not
        * context is a runtime boundary
        * no generalized classes shared across contexts
    * UI layer - MVC is a lie.
    * Inter-service communication
        * no RPC. Local != Remote
        * REST - they do only one thing. they manipulate data: GET, PUT
    * Orchestration
        * one central thing orchestrates the entire system
        * synchronous services - one central service orchestrates the workflow with 3 other services. If one goes, down, then
        *
            * Circuit breaker
            *
        * When there's failure (none of the options below work)
            * 1. Saga pattern doesn't work either
            * 2. REtry again
            * 3. Multi-phase commit
            * 4. after-the-fact repair
    * Choreography
        * Choreographed systems are always asynchronous (REST is a synchronous protocol)
        * Orchestration should not be used at all for microservices
        * Reactivity reduces latency
 
* Developer Experience (Daniel Bryant - DataWire)
    * Author of Continuous Delivery in Java
    * Martin Fowler's article - you must be this tall to use microservices - https://martinfowler.com/bliki/MicroservicePrerequisites.html
    * DevEx = DevOps Handbook + Implementing Lean software development + Design of Everyday Things
    * https://speakerdeck.com/stilkov/microservices-patterns-and-antipatterns-1
    * Netflix Hystrix in Java and Ruby are completely different. So polyglot in microservices is not a silver bullet.
    * https://www.infoq.com/news/2017/06/paved-paas-netflix
    * https://www.infoq.com/news/2018/07/shopify-kubernetes-paas
    * https://landscape.cncf.io/
    * https://github.com/cncf/landscape
    * https://articles.microservices.com/developer-workflow-trail-for-cloud-native-applications-request-for-feedback-a9365b64c790
    * https://aws.amazon.com/architecture/well-architected/
    * Develop and test services
        * Local/remote container dev tools like Telepresence/Squash allow hybrid
        * Redhat's Kubernetes native IDE
    * https://medium.com/@copyconstruct
    * https://medium.com/netflix-techblog/automated-canary-analysis-at-netflix-with-kayenta-3260bc7acc69
    * https://blog.openshift.com/multiple-deployment-methods-openshift/
    * https://www.appdirect.com/blog/evolution-of-the-appdirect-kubernetes-network-infrastructure
    * https://www.infoq.com/articles/ambassador-api-gateway-kubernetes
    *     focused canary testing
    * Control planes for Envoy: Gloo, Istio, [Ambassador](https://www.getambassador.io/)
    * Continuous Delivery with Docker Containers and Java: The Good, the ... - https://www.youtube.com/watch?v=hJkhPP2OLA8
    * Observability > Testing
        * is there a common correlation id from UI to database?
        * https://www.infoq.com/articles/observability-financial-times
 
* Micro front-end architecture (@lucamezzarila)
    * Microapps
        * https://www.forbes.com/sites/adrianbridgwater/2015/07/16/what-are-micro-apps-and-why-do-they-matter-for-mobile/
        * https://dzone.com/articles/micro-apps-what-they-are-and-why-you-should-not-ig
    * SPA - Monolith - DB
    * SPA - API Gateway - Microservices * - DB *

# Action Items
* 