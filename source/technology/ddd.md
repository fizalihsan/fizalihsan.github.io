---
layout: page
title: "Domain Driven Design"
comments: false
sharing: false
footer: true
---

* list element with functor item
{:toc}

* Entities
    * something uniquely identifiable. Entities are the same if they have the same identity. e.g. Profile, Opteam
* Value objects
    * have no uniqueness
    * are the same if they have the same value 
    * are immutable
    * e.g., Number, Money, Address, Date, Duration, Color
* Aggregates
    * cluster of entities and value types
    * each aggregate is treated as one single unit
    * Each aggregate has one root entity known as the "Aggregate Root"
* Repositories
    * responsible for domain objects persistence and retrieval
    * one respository per aggregate (not entities)
    * DDD uses repositories to create persistence ignorance
* Domain Services - 
* Specification
    * encapsulates a single rule. e.g., GoldCustomerSpec().is_satisfied_by(employee)
    * can also construct objects according to some specification
    * can also query objects that match some specification. e.g., repository.get_customers_satisfying(gold_customer_spec)
* Factories
    * create complex domain objects especially useful for aggregates
* BoundedContext - 
    * when you have multiple models, you should consider bounded context.
    * each BC is a self-contained mini application containing it's own model, persistence and code base
    * e.g., user, profiles, documents, data points, ACL
* Context Map
    * To map between bounded contexts, you need Context map
