---
layout: page
title: "Microservices"
comments: false
sharing: false
footer: true
---

* list element with functor item
{:toc}

# Event-Driven Microservices

__Definition of a Stateless Service__

* Not a cache or a database
* only stores frequently accessed metadata/configuration
* no instance affinity (i.e., a client request should be served by an instance)
* loss of a node is a non-event

## Downsides of monolith architecture

* Agile development and deployment becomes impossible
* Intimidates developers and becomes a monumental effort for new team members to learn the system
* Some part of the app can be memory-intensive and other parts IO/CPU-intensive. (Cryptography/graphics) Challenging to find optimal hardware to run the system. (EC2 and other cloud providers provide t-shirt sized instances which are either good for memory/IO/CPU intensive cases.) Monoliths running on general-purpose is not optimal
* IDE and app start up time is slow
* Requires front-end and back-end co-ordination before change or deployment
* Requires lot term commitment to the technology stack - rewriting a part of the system to adapt a newer technology to solve a certain problem in a better way is impossible. If the system is built on a legacy technology that no one wants to work with, it becomes harder to find resources

## Challenges of microservices architecture

There are 4 categories of problems: Dependency, Scale, Variance, Change

* __Dependency__
    * Problem
        * Distributed microservices over the network means multiple point of failures for the application
            * n/w latency, n/w failure, n/w congestion, h/w failure, bad deployment on dependency services
            * cascading failures
    * Solution
        * Use a tool like Netflix Hystrix that manages latency and fault tolerance 
            * fallback option (e.g., when a service is down, return a static message)
            * circuit breaker (e.g., if the service is down, don't call it repeatedly)
        * Testing via FIT (Fault Injection Testing)
            * Synthetic transactions, test as if the service is down without taking it down, squeeze testing
        * eventual consistency
        * multi-region failover
* __Scale__
    * Problem
        * How to scale stateless services
    * Solution
        * Auto-scaling group
            * scales seamlessly during node failures or traffic spikes or DDoS attacks or performance bugs in code
            * cost effective
        * Caching
            * Using a distributed cache like EVCache (wrapper on memcached)
        * Redundancy (avoid SPoF)
        * Partitioned workloads
        * failure-driven design
        * Chaos under load
* __Variance__
    * Problem
        * Variety in architecture. More varience = more challenges, due to the complexity of the environment to manage
        * Operation drift (unintentional but it does happen)
            * Drift over the time: Over time configuration settings like alert threshold can vary, and so is timeout, retry, throughput, etc.
            * Drift across microservices: best practices are not uniformly followed by all the services
        * Polyglot
            * Cost of variance.
                * Insight into CPU/memory usage inside a VM or container
                * VM base image fragmentation
                * Node management is complex
                * library/platform duplication (e.g., a piece of code is duplicated in different languages)
                * learning curve
    * Solution
        * Operation drift
            * continuous learning and automation
        * Polyglot (intentional) - polygot persistence, polygot programming
            * Raise awareness of costs
            * Constraint centralized support
            * allowing only a finite set of people to work on these
            * seek reusable solutions
* __Change__
    * Problem
        * How to achieve velocity with confidence?
    * Solution
        * Using a global cloud management and delivery platform like Spinnaker
        * Integrating best practices and production ready checklists into the pipeline as and when needed. 
            * red/black pipelines
            * automated canaries
            * staged deployments
            * squeeze tests, etc.



# Microservices Patterns

{% img right 100 100 /technology/microservices-patterns.png %}

* 3 axes of decomposition from “The Art of Scalability” book. 
 
## Decomposition Patterns

__Functional decomposition__

* Pros of decomposing/partitioning to separate services
    * Change to one service can happen independently and does not impact other services
    * Development and deployment can happen more frequently
    * Different components with conflicting resource requirements can scale easily (in-memory databases that require lot of memory can run on its own machine, while the cryptography/graphics like CPU-intensive modules can run separately)
    * Improved fault isolation - e.g., a memory-leak in one of the components does not impact the entire application
    * Eliminates long term commitment to a single tech stack - leading to modular system, polyglot and multi-framework system
* Cons
    * Complexity of developing a distributed system - inter process communication (RPC, REST, gRPC…), partial failures (other services is slow in responding)
    * Multiple databases and transaction management e.g., eventual consistency
    * Complexity of testing a distributed system  - end-to-end testing (https://martinfowler.com/articles/microservice-testing )
    * Complexity of testing a distributed system - need a lot of automation, virtualized/containerized infrastructure, continuous deployment
    * Co-ordinating feature development that span across services
    * Potential risk of excessive network hops
    * Runtime overhead (nano-service anti-pattern) - e.g., overhead of running JVM which contains only 100 lines of code
    * Tracing requests and performance measurement

__Partitioning Strategies__

* Goals of partitioning: parallelize development and deployment
* Strategies
    * Partition by noun e.g., Catalog service for products
    * Partition by verb e.g., Check out 
    * Single Responsibility Principle
    * Subdomain 
* Anti-pattern: Distributed monolith
    * Partition your app so that most changes only impact a single service.
    * Common Closure Principle - Components that change for the same reason should be packaged together
* Anti-pattern: Nano-services

## Deployment Patterns

* __Multiple services per host__
    * Cons
        * Less isolation 
        * Difficult to limit resource utilization
        * Risk of dependency version conflict 
* __Single service per host__
* __Service per VM__
    * Pros
        * Leverage cloud infrastructure to auto scale and load balance
    * Cons
        * Less efficient resource utilization
        * Slow build and deployment: due to image size and start up time
    * http://packer.io, http://boxfuse.com - for automation of VM image creation
* __Service per container__

## Communication Patterns

* Issues
    * How do clients interact with the services?
    * How do services within the system interact with each other?

__API Gateway__

{% img right /technology/microservices-patterns-api-gateway.png %}

* Forces
    * Different clients (UI, Mobile) need different data
    * The number of service instances and their locations changes dynamically
    * Web unfriendly protocols e.g., Thrift, Protocol Buffer
* API Gateway is responsible for tasks such as load balancing, caching, access control, API metering, monitoring, etc.
* Pros
    * Single point of entry
    * Provides optimal API for client specific (UI, Android, iOS, TV)
    * Protocol translation (http > thrift)
    * Insulates clients from partition and discovery
* Cons
    * Increased complexity - the API gateway is yet another highly available component that must developed, deployed and managed
    * Increased response time due to additional network hop

__Inter Process Communication__

* Netflix approach for Partial failures - when one of the service is slow or not responding. How to deal with it? (Netflix https://medium.com/netflix-techblog/fault-tolerance-in-a-high-volume-distributed-system-91ab4faae74a )
    * Network timeouts: never wait for response indefinitely
    * Invoke remote services via a bounded thread pool
    * Use the circuit breaker pattern e.g., 5 failures in a row indicates the service is down
    * Netflix Hystrix addresses all this

## Service Discovery

{% img /technology/microservices-patterns-discovery-problem.png %}
{% img right /technology/microservices-patterns-clientside-discovery.png %}

* Forces
    * Client or API gateway needs to know where the service is running
    * The destination host and IP are dynamically assigned and bound to change
    * How to load balance

__Client-service discovery__

* When a service comes up, it publishes its location to a central Service Registry. Client queries the registry and load balances the request to appropriate service. e.g., Netflix Eureka (Service Registry) and Ribbon
* Pros
    * Less network hop since client talks to service directly
* Cons
    * couples the client to the service registry
    * Need to implement client-side load balancing and routing logic in multiple languages and frameworks
    * Service Registry is another moving part which must be highly available

__Server-side discovery__

{% img right /technology/microservices-patterns-serverside-discovery.png %}

* Same as client-side, however the client calls a router instead of Service registry. Router talks to Service Registry and then load balances the requests to service instances. e.g., AWS Load Balancer, Nginx, Kubernetes
* Pros
    * Simple client code
    * Built-in to cloud/container environments
* Cons
    * Limited to load balancing algorithms provided by router
    * Other cons as client-side

__Service Registration__

* Forces
    * Service instances must be registered in the registry during start up and unregistered during shutdown
    * Service instances that crash must be unregistered from the registry
    * Service instances that are running but incapable of serving must be unregistered from the registry
    * Who registers the service in the registry - service or 3rd-party?
* Service Registries: Netflix Eureka, Apache Zookeeper, Hashicorp Consul, CoreOS etcd
* _Self Registration_
    * Service registers and unregisters itself. e.g., Netflix Eureka Java client, Zookeeper Java client
    * Pros
        * Simple
    * Cons
        * Couples services to the registry
        * Must implement registration logic in multiple languages/framework
        * Service might lack the self awareness to unregister itself
* _3rd party Registration_
    * Registrar detects somehow the service is up, registers to the Service Registry, periodically performs health check on the service and sends heartbeat to service registry, 
    * Examples
        * AWS Autoscaling groups - automatically register/unregister EC2 instances with ELB
        * Kubernetes/Marathon
        * Netflix Eureka Prana
        * Container Buddy - runs as services’ parent process in docker container, registers services with Consul or etcd

## Cross-cutting concerns

__Microservice Chassis Framework__

* Cross-cutting concerns 
    * External configuration
        * N/w location of external services, credentials, etc.
        * Different for different environments
    * Logging
    * Service discovery
    * Circuit breaker
    * Health checks - e.g., health check URL
    * Metrics - e.g., reporting to metrics collection service
* Chassis Framework
    * Unlike monolith, all the above needs to be repeated multiple times
    * Microservice Chassis is a framework that actually takes care of the above e.g., Spring Boot + Spring Cloud, DropWizard

## Data Management

* Problem of Data Consistency
    * What is the database architecture for a micro service architecture - shared db or db per service?
    * Each microservices has its own data store in order to ensure loose coupling. However, this makes it difficult to maintain consistency across multiple services. You can't, for example, use distributed transactions (2PC).

* Forces
    * Some business transactions must update data owned by other services
    * Some queries must join data owned by other services
    * Different services have different storage requirements
    * Database must sometimes be sharded or replicated for scalability
    * Services must be loosely coupled so that they can be developed and deployed independently

__Pattern: Shared Database__

* Pros
    * Simple
    * Local transactions only
* Cons
    * Services are tightly coupled
    * lack of encapsulation
    * Single db may not satisfy the data access requirements of multiple services

__Pattern: Database per service__

* Private tables: services owns a set of tables that are private to that service
* Private schema: services owns a schema that are private to that service
* Private server: services owns a db server that are private to that service
* Pros
    * Escapes the constraints of relational databases
    * Services are loosely coupled
* Cons
    * Implementing transactions and queries that spans multiple services is challenging
    * More complex to operate

* Problem of 2-phase commit
    * Guaranteed atomicity but 
        * Need a distributed transaction manager
        * DB and message broker must support 2PC
        * Impacts reliability

__Pattern: Transaction log tailing__

* After a record is written to db, other services can read/tail off of it
* LinkedIn Databus https://github.com/linkedin/databus, Mongodb (Oplog), AWS Dynamodb supports streaming of CRUD operations
* Pros
    * No 2PC
    * No app changes needed
    * Guaranteed to be accurate
* Cons
    * Immature
    * Specific to a database solution
    * Low level DB changes rather than business level events = need to reverse-engineer domain events

### Event Sourcing

{% img right /technology/microservices-patterns-eventsourcing1.png %}

* Radically different approach in storing business entities and writing business logic. Most notably, the way in which business entities are stored in a data store is not by storing the current state but by storing the sequence of state-changing events (immutable events). Whenever the current state is needed, you reload past events and compute them.
* For each business entity (aggregate)
    * Identify (state changing) domain events
    * Define Event classes
* Event Store = database + message broker
    * Store entities as a series of state changing immutable events, and reconstruct the current state by replaying them.
    * Functionality of event store
        * Save aggregate events
        * Get aggregate events
        * Subscribe to events
    * Implementations: Greg Young’s https://eventstore.org and https://eventuate.io 
* Pros
    * Solves data consistency issues in a microservice/nosql based architecture
    * Reliable event publishing
    * Eliminate O/R mapping problem
    * Enables temporal querying, audit logs
* Cons
    * Requires application rewrite
    * Must detect and handle duplicate events
        * Idempotent event handlers
        * Or track most recent event and ignore older ones
    * Querying the event store can be challenging
        * Some queries can be complex or inefficient e.g., accounts with balance > X
        * Event store might support only look up of events by entity id
        * Must use CQRS to handle queries => app must handle eventual consistent data. CQRS subscribes to events and stores a denormalized view of the event data that is easier to query

__Event Sourcing Design__

* There are 3 types of components in an event sourcing design
    * Data model
    * Domain events
    * Commands
* Designing data model
    * DDD vocabulary
        * Entities - something that is identified by an id and persisted in db. e.g., Order, Product, Account
        * Value Object - e.g., Money, Date
        * Service
        * Repository
        * Aggregates
            * A transaction can update only a single aggregate. Scope of a transaction is really one aggregate. This fits well for NoSQL databases as well where you can update only one thing/document/aggregate at a time. Hence NoSQL databases are also called as aggregate-oriented databases.
            * Aggregate granularity
                * if you want you could combine Customer, Order and Product as a single aggregate, it will be work and be more consistent, but won’t scale well.
                * however, if they are treated as separate aggregates, then scalability and user experience improves since they can be stored and worked on in parallel.
* Designing Domain Events
    * Domain events store the information about the following 
        * Event Metadata e.g., time of the event, sender Id, etc.
        * Required by aggregate e.g., productId, 
        * Enrichment - useful for consumers e.g., price, product name 
* Designing Commands
    * Created by a service from incoming request
    * Processed by an aggregate 
    * Immutable

__CQRS (Command-Query Responsibility Seggregation) pattern__

{% img right /technology/microservices-patterns-cqrs.png %}

* In relational databases, query a customer and his order details is joining those 2 tables. However, event store only supports primary key look ups.

* Rather a single component performing both command and query operation, handle them separately. 
* Command side would handle HTTP POST, DELETE, PUT methods. 
* Query side would handle GET methods. Query side stores only more materialized or denormalized views of the data.
* View Store could be MongoDb, GraphDb, ElasticSearch, AWS DynamoDb etc. depending on the data needs
* Pros
    * Necessary in an event sourcing architecture
    * Separation of concerns
    * Supports multiple denormalized views either as documents or graphs
    * Improved scalability and performance
* Cons
    * Complexity
    * Code duplication
    * Replication lag/eventually consistent views

# Strategies to refactor Monolith to Microservices

* Strangler Application (Martin Fowler)
* __#1: Stop digging__
    * If you find yourself in a hole, stop digging. https://en.wikipedia.org/wiki/Law_of_holes 
    * Stop adding new features to the monolith, and create a new service. 
    * Router routes the traffic to old / new service
    * Build an anti-corruption layer to bridge/glue between monolith and new service
* __#2: Split front-end and back-end__
* __#3: Extract services__
    * Extract a service, introduce anti-corruption layer and repeat
    * What to extract?
        * Have the ideal partitioned architecture in mind: Partition by noun/verb?
        * Start with modules that gives the highest ROI
            * Velocity -> frequently updated
            * Scalability -> Conflicting resource requirements e.g., cryptograph code that requires more CPU
        * Look for components that interact with each only via messaging. Since they are loosely coupled they could live in separate services. 
* __#4: Anti-corruption layer__
    * First appeared in DDD book by Eric Evans
    * Goal is to prevent your legacy system from polluting the pristine new code

{% img right /technology/microservices-patterns-anticorruption-layer.png %}

# References

* Chris Richardson's talk on "Event-Driven Microservices" in Safari