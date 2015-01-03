---
layout: page
title: "Architecture"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# SDLC

## Continuous integration
* Hudson / Jenkins
* TeamCity
* CruiseControl
* Ivy

## Code Analysis
* Emma
* Corbetura/Clover
* Fortify
* JDepend
* FindBugs
* SONAR

## Code Metrics

* Novel way to visualize whole project, package structure & lines of code - http://redotheweb.com/CodeFlower/
* Cyclomatic Complexity - 
  * http://www.onjava.com/lpt/a/4917
  * http://c2.com/cgi/wiki?CyclomaticComplexityMetric
  * http://www.guru99.com/cyclomatic-complexity.html



## Development Methodologies
http://en.wikipedia.org/wiki/List_of_software_development_philosophies

### Agile


### XP


### Scrum


### KanBan

## Architecture Patterns

### Domain Driven Design

**Tutorial**
* [Part 1: Domain-Driven Design and MVC Architectures](http://blog.fedecarg.com/2009/03/11/domain-driven-design-and-mvc-architectures/)
* [Part 2: Domain-Driven Design: Data Access Strategies](http://blog.fedecarg.com/2009/03/12/domain-driven-design-and-data-access-strategies/)
* [Part 3: Domain-Driven Design: The Repository](http://blog.fedecarg.com/2009/03/15/domain-driven-design-the-repository/)
* [Part 4: Sample Application](http://blog.fedecarg.com/2009/03/22/domain-driven-design-sample-application/)

#### Domain Model

* Responsible only represent the concepts of the business, information about business situations and business rules
* Named after the nouns in domain space
* Should have both data and behaviour (basic idea of object oriented design)
* well connected with other domain objects with relationship and structure
* Examples of behaviour - validations, calculations, business rules
* Only business logic - no persistence or presentation logic
* Completely persistance Ignorant (Mithra domain model breaks this)
* When to use?
* When NOT to use?

#### Value Objects

* 2 value objects are equal if all their fields are equal. Although all fields are equal, you don't need to compare all fields if a subset is unique - for example currency codes for currency objects are enough to test equality
* Should be immutable
* A value object should always override .equals() & .hashCode() in Java
* http://c2.com/cgi/wiki?ValueObject
* Diff between Value objects and Domain objects?

#### Data Transfer Object

* Simply contain for a set of aggregated data that needs to be transfered across process or network boundary
* holds only data - no business logic
* Needs to be serializable to work with remote interfaces
* Usually an assembler is used to transfer data between DTOs and Domain objects

#### Service Layer

* Service layer on top of 'Behaviourally rich domain model' is recommended
* Should be a thin layer

#### Anemic Domain Model (Anti-pattern)

* Objects which has only data but no business logic. 
* All the business logic is implemented in a separate 'Service Layer' - Domain model is used only for data
* Incurs all the cost of domain model - No benefits
* Cost related to mapping to database


Martin Fowler - Service Layer, Model Layer
Eric Evans - Application Layer, Domain Layer


### Domain Specific Language (DSL)

* Writing internal DSL in Java - http://jmock.org/oopsla2006.pdf
* http://blog.jooq.org/2012/01/05/the-java-fluent-api-designer-crash-course/
* http://www.infoq.com/articles/internal-dsls-java
* http://weblogs.java.net/blog/carcassi/archive/2010/02/04/building-fluent-api-internal-dsl-java

### Naked Objects Pattern

## Programming Paradigms
### Aspect Oriented Programming (AOP)
### Functional Programming
### MDD - Model Driven Design
### TDD - Test Driven Design
### FDD - Feature Driven Development


# Bibliography

* Patterns of Enterprise Application Architecture - Martin Fowler 
* http://martinfowler.com/bliki/ValueObject.html
* http://martinfowler.com/eaaCatalog/dataTransferObject.html
* http://java.sun.com/blueprints/patterns/TransferObject.html
