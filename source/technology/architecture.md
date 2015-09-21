---
layout: page
title: "Architecture"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}


# Enterprise Architecture

## Enterprise Integration Approaches

There have historically been four approaches to integration: file transfer, sharing a database, leveraging services, and asynchronous messaging. One way to look at these approaches is how they affect coupling in your architecture. Broadly, there are three types of coupling:

1. **Spatial coupling (communication)**: Spatial coupling describes the requirement of a producer to know how to communicate with another and how to overcome error scenarios in the communication. A server side fault in an RPC operation, for example, is an example of spatial coupling.
2. **Temporal coupling (buffering)**: Temporal coupling describes the requirement of a producer to be aware of, and available for, a consumer to share data. A decoupled system uses buffering so that a message may be sent, even if the consumer isn’t available to receive it.
3. **Logical coupling (routing)**: Logical coupling describes the requirement of a producer to know how to connect with the consumer. One way to fix this is to introduce a central, shared location where both parties exchange data. Then, if a producer decides to move (change IP, put up a firewall, and so on) or decides to add extra steps before publishing messages, the client remains




# Architecture Patterns

## Domain Driven Design

**Tutorial**

* [Part 1: Domain-Driven Design and MVC Architectures](http://blog.fedecarg.com/2009/03/11/domain-driven-design-and-mvc-architectures/)
* [Part 2: Domain-Driven Design: Data Access Strategies](http://blog.fedecarg.com/2009/03/12/domain-driven-design-and-data-access-strategies/)
* [Part 3: Domain-Driven Design: The Repository](http://blog.fedecarg.com/2009/03/15/domain-driven-design-the-repository/)
* [Part 4: Sample Application](http://blog.fedecarg.com/2009/03/22/domain-driven-design-sample-application/)

### Domain Model

* Responsible only represent the concepts of the business, information about business situations and business rules
* Named after the nouns in domain space
* Should have both data and behaviour (basic idea of object oriented design)
* well connected with other domain objects with relationship and structure
* Examples of behaviour - validations, calculations, business rules
* Only business logic - no persistence or presentation logic
* Completely persistance Ignorant (Mithra domain model breaks this)
* When to use?
* When NOT to use?

### Value Objects

* 2 value objects are equal if all their fields are equal. Although all fields are equal, you don't need to compare all fields if a subset is unique - for example currency codes for currency objects are enough to test equality
* Should be immutable
* A value object should always override .equals() & .hashCode() in Java
* http://c2.com/cgi/wiki?ValueObject
* Diff between Value objects and Domain objects?

### Data Transfer Object

* Simply contain for a set of aggregated data that needs to be transfered across process or network boundary
* holds only data - no business logic
* Needs to be serializable to work with remote interfaces
* Usually an assembler is used to transfer data between DTOs and Domain objects

### Service Layer

* Service layer on top of 'Behaviourally rich domain model' is recommended
* Should be a thin layer

### Anemic Domain Model (Anti-pattern)

* Objects which has only data but no business logic. 
* All the business logic is implemented in a separate 'Service Layer' - Domain model is used only for data
* Incurs all the cost of domain model - No benefits
* Cost related to mapping to database


Martin Fowler - Service Layer, Model Layer
Eric Evans - Application Layer, Domain Layer


## Domain Specific Language (DSL)

* Writing internal DSL in Java - http://jmock.org/oopsla2006.pdf
* http://blog.jooq.org/2012/01/05/the-java-fluent-api-designer-crash-course/
* http://www.infoq.com/articles/internal-dsls-java
* http://weblogs.java.net/blog/carcassi/archive/2010/02/04/building-fluent-api-internal-dsl-java

## Naked Objects Pattern


# Bibliography

* Patterns of Enterprise Application Architecture - Martin Fowler 
* http://martinfowler.com/bliki/ValueObject.html
* http://martinfowler.com/eaaCatalog/dataTransferObject.html
* http://java.sun.com/blueprints/patterns/TransferObject.html
