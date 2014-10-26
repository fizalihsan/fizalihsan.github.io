---
layout: page
title: "Design Principles"
comments: true
sharing: true
footer: true
---

[TOC]

# Design Idioms

* http://www.slideshare.net/nadeembtech/code-craftsmanship
* Technical debt
* Code smell
* Orthogonal concerns (design & architecture)
* RIA technolgies?
* Data extraction patterns
* Backward Compatibility (Refer to *Practical API Design - Confessions of a Java * Framework Architect*)
  * Source Compatibility
  * Binary Compatibility
  * Functional Compatibility

# API Design - Best Practices

* Do not expose more than you want
  * A method is better than a field
  * A Factory is better than a constructor
  * Make Everything final
  * Do not put setters where they do not belong
  * Give the creator of an object more rights
  * Do not expose deep hierarchies
* Code against Interfaces, not Implementations
  * Removing a method or a field
  * Removing or Adding a Class or an Interface
  * Inserting an Interface or a Class into an Existing Hierarchy
  * Adding a Method or a Field
  * Comparing Java Interfaces and Classes
  * Are Abstract Classes Useful?
* Use Modular Architecture
  * Cyclic dependencies

# Interface 

## Interface Types

(Refer to *Interface Oriented Design*)
* Data Interfaces & Service Interfaces
* Data Access Interface Structures
  * Sequential Vs. Random retrieval
  * Push & Pull Interfaces
  * Alternative Interfaces
* Stateless Vs. Stateful Interfaces

## Properties of an Interface

* Cohesiveness
* Printer interface
* Coupling
* Minimal Vs. Complete
* Complete Vs. Simple

# 5 principles of class design (SOLID)

1. **SRP** [The Single Responsibility Principle](https://docs.google.com/open?id=0ByOwmqah_nuGNHEtcU5OekdDMkk) - A class should have one, and only one, reason to change.
* **OCP** [The Open Closed Principle](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgN2M5MTkwM2EtNWFkZC00ZTI3LWFjZTUtNTFhZGZiYmUzODc1&hl=en) - You should be able to extend a classes behavior, without modifying it.
* **LSP** [The Liskov Substitution Principle](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgNzAzZjA5ZmItNjU3NS00MzQ5LTkwYjMtMDJhNDU5ZTM0MTlh&hl=en) - Derived classes must be substitutable for their base classes.
* **ISP** [The Interface Segregation Principle](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgOTViYjJhYzMtMzYxMC00MzFjLWJjMzYtOGJiMDc5N2JkYmJi&hl=en) - Make fine grained interfaces that are client specific.
* **DIP** [The Dependency Inversion Principle](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgMjdlMWIzNGUtZTQ0NC00ZjQ5LTkwYzQtZjRhMDRlNTQ3ZGMz&hl=en) - Depend on abstractions, not on concretions.

# 6 principles of package design

The next six principles are about packages. In this context a package is a binary deliverable like a .jar file, or a dll as opposed to a namespace like a java package or a C++ namespace. 

## 3 principles of package cohesion

These principles are about package cohesion, they tell us what to put inside packages:

1. **REP** [The Release Reuse Equivalency Principle](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgOGM2ZGFhNmYtNmE4ZS00OGY5LWFkZTYtMjE0ZGNjODQ0MjEx&hl=en) - The granule of reuse is the granule of release.
* **CCP** [The Common Closure Principle](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgOGM2ZGFhNmYtNmE4ZS00OGY5LWFkZTYtMjE0ZGNjODQ0MjEx&hl=en) - Classes that change together are packaged together.
* **CRP** [The Common Reuse Principle](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgOGM2ZGFhNmYtNmE4ZS00OGY5LWFkZTYtMjE0ZGNjODQ0MjEx&hl=en) - Classes that are used together are packaged together.

## 3 principles of package coupling

These principles are about the couplings between packages, and talk about metrics that evaluate the package structure of a system.

1. **ADP** [The Acyclic Dependencies Principle](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgOGM2ZGFhNmYtNmE4ZS00OGY5LWFkZTYtMjE0ZGNjODQ0MjEx&hl=en) - The dependency graph of packages must have no cycles.
* **SDP** [The Stable Dependencies Principle](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgZjI3OTU4ZTAtYmM4Mi00MWMyLTgxN2YtMzk5YTY1NTViNTBh&hl=en) - Depend in the direction of stability.
* **SAP** [The Stable Abstractions Principle](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgZjI3OTU4ZTAtYmM4Mi00MWMyLTgxN2YtMzk5YTY1NTViNTBh&hl=en) - Abstractness increases with stability.

# Object Calisthenics

* http://williamdurand.fr/2013/06/03/object-calisthenics/
* http://www.slideshare.net/rdohms/bettercode-phpbenelux212alternate
* https://github.com/TheLadders/object-calisthenics

* **Rule 1**: One level of indentation per method
  * Each method should do exactly one thing. 
  * How to fix it: Use the 'Extract Method' to pull out behaviors until your methods only have 1 level of indentation.
* **Rule 2**: Don't use the ELSE keyword
  * Every conditional branch creates confusion.
  * How to fix it: Use polymorphism; Use the Null Object pattern.
* **Rule 3**: Wrap all primitives and Strings
  * If the variable of your primitive type has a behaviors, you MUST encapsulate it. And this is especially true for Domain Driven Design. DDD describes Value Objects like Money, or Hour for instance which expresses the intent explicitly.
* **Rule 4**: First class collections
* **Rule 5**: One dot per line
* **Rule 6**: Don’t abbreviate
* **Rule 7**: Keep all entities small
* **Rule 8**: No classes with more than two instance variables
* **Rule 9**: No getters/setters/properties

# Law of Demeter (or Don't talk to strangers)

???