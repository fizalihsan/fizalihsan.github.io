---
layout: page
title: "Event Sourcing"
comments: false
sharing: false
footer: true
---

* list element with functor item
{:toc}

## Concepts

* publish events reliably and atomically whenever state changes
* Whenever the state of a business entity changes, a new event is appended to the list of events.
* 100% reliable audit log of the changes made to a business entity
* the application reconstructs an entity's current state by replaying the events 
* events are stored in an Event Store.
* __Event Store__
    * Event Store = Database + Message broker
    * also acts as a message broker which enables services to subscribe to events
    * Technology implications
        * The storage system becomes an additive only architecture
        * Append-only architectures distribute
        * Far fewer locks to deal with
        * Horizontal Partitioning is difficult for a relational model
    * Business implications
        * Criteria is tracked from inception as an event stream
        * You can answer questions from the origin of the system
        * You can answer questions not asked yet!
        * Natural audit log
* Periodical snapshotting 
* __Drawbacks__
    * Needs CQRS to implement queries - which means application must handle eventually consistent data. However, one should embrace the fact that information is always from the past.
    

* __Features of eventsourcing library__
    * Automatic versioning
    * Subscribe to events
        * Can be used to updated a view
        * Republish domain events to other downstream apps
    * Snapshotting - avoids replaying the entire stream to get the state of the entity
        * Can be taken manually 
        * Can be taken automatically. e.g., every 10 events
        * Separate table for snapshot records
    * Encryption is optionally enabled
    * Hashchains

## Event-First Design

* Events First Domain Driven Design

> When you start modeling events, it forces you to think about the behavior of the system. As opposed to thinking about the structure of the system. - Greg Young

* Immutable append-only event store - means easy to scale
* Events can help manage failure instead of avoiding it
* Why? 
    * Modeling events forces behavioral focus over structural focus of the system
    * Modeling events forces temporal focus
        * e.g., what if this happens before that
    * Event sourcing is naturally functional model - append-only immutable log of events happened in the past, left-fold to get current state
    * One single-source of truth with all history
    * No impedance mismatch or object-relational mismatch
    * Allows others to subscribe to state changes
    * ES enables time travel
        * Replace the log for historic debugging
        * Replace the log for auditing and traceability
        * Replace the log on failure
        * Replace the log for replication
    * Event-first design helps
        * Move faster towards a scalable and resilient architecture
        * design autonomous services
    * Event logging allows
        * AVOID CRUD and ORM
        * take control of your system’s history
        * time-travel
        * Balance Strong and eventual consistency


## Best Practices

* Intention-revealing interfaces
* Domain model is always in a valid state - no additional validation rules
* Side-effect free functions
* __Onion Architecture__
    * Domain model - e.g., Profile, ProfileRepository, Opteam, OpteamReopository
        * Contains information about the Domain
        * state of the business objects is held here
        * Does not contain persistence details
    * Domain services
        * Contains business logic that are not natural part of entities or value objects
        * services are stateless
        * services can usually manipulate multiple entities
    * Application services - e.g., EmailSender, TicketSender, etc.
        * Does not contain business logic
        * Does not hold state of the business objects
    * User interface / Test 
    * Infrastructure
        * acts as a supporting layer for other layers
        * implements persistence for business objects e.g., SmtpEmailSender, SDSKCreator, etc


__Design Philosophy__

Event sourcing allows to embrace the following design philosophies

* Domain Driven Design
* Actor Models
* Message-driven and asynchronous
* Distributed persistence concepts (CQRS and ES)
* Functional programming
* Microservices

## Versionining

There are few things to take care of before versioning in event sourced systems - https://leanpub.com/esversioning/read

* Why can’t I update an event?
    * Immutability - with immutable you can use a caching layer or reverse proxy to serve from cached information. How do caches get invalidated on an update?
    * Consumers - say an event is consumed by an email service that sends email to customer about order creation. If the order event is updated, do we send another email?
    * Audit - when you edit an event, you lose the audit trail.
* Avoid versioning via types - e.g., CreateOrderEvent_v1, CreateOrderEvent_v2…
* Strong schema or out-of-band schema: Without the schema, the message cannot be deserialized. E.g., Binary serialization of Java objects. Producer cannot change, unless all consumers are ready to change.
* Weak schema or hybrid schema - e.g., JSON, XML.
* If you find projections making calls to other projections or external services or temporal business logic to calculate the current state, then replaying events will be a problem since the data can change over time. e.g., calculating tax based on tax percent which changes
* Semantic meaning should not change between versions. e.g., when storing weather, switching from Celsius to Fahrenheit can be disastrous.
​

## References

1. [Greg Young - A Decade of DDD, CQRS, Event Sourcing](https://www.youtube.com/watch?v=LDW0QWie21s)
2. [Event Sourcing: What it is and why it's awesome](https://t.co/TKYrLtv9fC)
1. [Greg Young - Exploring CQRS and Event Sourcing](https://docs.microsoft.com/en-us/previous-versions/msp-n-p/jj554200(v%3dpandp.10))
2. [Greg Young - Event Versioning](https://leanpub.com/esversioning/read)
3. [Data Dichotomy](https://www.confluent.io/blog/data-dichotomy-rethinking-the-way-we-treat-data-and-services/)
4. [Martin Fowler - Many meanings to Event-Driven Architecture](https://www.youtube.com/watch?v=STKCRSUsyP0)
5. [Single Writer Principle](https://mechanical-sympathy.blogspot.com/2011/09/single-writer-principle.html)
6. [Pat Helland - Immutability changes everything](http://highscalability.com/blog/2015/1/26/paper-immutability-changes-everything-by-pat-helland.html)
    1. [Immutability changes everything](http://cidrdb.org/cidr2015/Papers/CIDR15_Paper16.pdf)
    2. [Life beyond distribute transactions](http://adrianmarriott.net/logosroot/papers/LifeBeyondTxns.pdf)
    3. [Standing on distributed shoulders of giants](https://queue.acm.org/detail.cfm?id=2953944)


