---
layout: page
title: "Design Principles"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Design Idioms

* http://www.slideshare.net/nadeembtech/code-craftsmanship
* Technical debt
* Code smell
* Orthogonal concerns (design & architecture)
* RIA technolgies?
* Data extraction patterns
* Backward Compatibility (Refer to *Practical API Design - Confessions of a Java Framework Architect*)
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

# Class Design Principles

## SOLID principles

1. **SRP** - The Single Responsibility Principle
  * A class should have one, and only one, reason to change.
2. **OCP** - The Open Closed Principle 
  * Open for extension, closed for modification. You should be able to extend a classes behavior, without modifying it.
  * It means that you can add new features through inheritance but should not change the existing classes (other than bug fixes). 
  * The reason is that if you modify a class, you’ll likely break the API/Contract of the class which means that the classes that depend on it might fail when you do so. If you instead inherit the class to add new features, the base contract is untouched and it’s unlikely that dependent classes will fail.
3. **LSP** - The Liskov Substitution Principle
  * Derived classes must be substitutable for their base classes.
  * any method that takes class X as a parameter must be able to work with any subclasses of X.
4. **ISP** - The Interface Segregation Principle
  * Make fine grained interfaces that are client specific.
  * ISP states that interfaces that have become “fat” (like [God classes](https://en.wikipedia.org/wiki/God_object)) should be split into several interfaces. Large interfaces makes it harder to extend smaller parts of the system.
5. **DIP** - The Dependency Inversion Principle
  * Depend on abstractions, not on concretions.
  * The principle which is easiest to understand. DIP states that you should let the caller create the dependencies instead of letting the class itself create the dependencies. Hence inverting the dependency control.
  * Also called '*Hollywood principle - Don't call us, we'll call you*'

## Law of Demeter

* Also called as *Principle of Least Knowledge* or *Don't talk to strangers* or *Talk only to your immediate friends*
* The Law of Demeter for functions requires that a method M of an object O may only invoke the methods of the following kinds of objects:
  * O itself
  * M's parameters
  * Any objects created/instantiated within M
  * O's direct component objects
  * A global variable, accessible by O, in the scope of M
* Don't do this `objectA.getObjectB().getObjectC().doSomething();` except on data structure methods.

# 6 principles of package design

The next six principles are about packages. In this context a package is a binary deliverable like a .jar file, or a dll as opposed to a namespace like a java package or a C++ namespace. 

## 3 principles of package cohesion

These principles are about package cohesion, they tell us what to put inside packages:

1. **REP** [The Release Reuse Equivalency Principle](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgOGM2ZGFhNmYtNmE4ZS00OGY5LWFkZTYtMjE0ZGNjODQ0MjEx&hl=en) - The granule of reuse is the granule of release.
2. **CCP** [The Common Closure Principle](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgOGM2ZGFhNmYtNmE4ZS00OGY5LWFkZTYtMjE0ZGNjODQ0MjEx&hl=en) - Classes that change together are packaged together.
3. **CRP** [The Common Reuse Principle](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgOGM2ZGFhNmYtNmE4ZS00OGY5LWFkZTYtMjE0ZGNjODQ0MjEx&hl=en) - Classes that are used together are packaged together.

## 3 principles of package coupling

These principles are about the couplings between packages, and talk about metrics that evaluate the package structure of a system.

1. **ADP** [The Acyclic Dependencies Principle](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgOGM2ZGFhNmYtNmE4ZS00OGY5LWFkZTYtMjE0ZGNjODQ0MjEx&hl=en) - The dependency graph of packages must have no cycles.
2. **SDP** [The Stable Dependencies Principle](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgZjI3OTU4ZTAtYmM4Mi00MWMyLTgxN2YtMzk5YTY1NTViNTBh&hl=en) - Depend in the direction of stability.
3. **SAP** [The Stable Abstractions Principle](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgZjI3OTU4ZTAtYmM4Mi00MWMyLTgxN2YtMzk5YTY1NTViNTBh&hl=en) - Abstractness increases with stability.

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

