---
layout: page
title: "Groovy"
comments: true
sharing: true
footer: true
---

[TOC]

# Overview

* Use Groovy for flexibility and readability. Use Java for performance
* Runs on JVM - Groovy is nothing but a new way of creating Java classes - Java code can be called from Groovy and vice-versa
* Is type in Groovy synonymous to class in Java ?
* Every Groovy type is a subtype of java.lang.Object - Every Groovy object is an instance of a type in the normal way
* Groovy class IS A Java class
* Groovy supports dynamic typing
* To compile a Groovy script - `groovyc –d classes Foo.groovy`
* To run a compiled Groovy class in Java - `java -cp $GROOVY_HOME/embeddable/groovy-all-1.0.jar:classes Foo`
* To run a Groovy script - `groovy Foo.groovy`
* Behind the scenes it compiles to a Java class and executes
* Any Groovy code can be executed this way as long as it can be run; that is, it is either a script, a class with a main method, a Runnable, or a GroovyTestCase.
* Groovy is purely object-oriented
* everything is an object. E.g `2*3`, though they look like primitives, they are actually java.lang.Integer objects
* every operator is a method call. E.g. `a+b` //logic for the + operator is implemented in method plus() on the object 
* Groovy automatically imports following packages: `groovy.lang.*, groovy.util.*, java.lang.*, java.util.*, java.net.*, and java.io.*` as well as the classes `java.math.BigInteger` and `BigDecimal`.
* Say there is a Groovy class called Foo, we can use Foo objects without explicitly compiling the Book class as long as Foo.groovy is on the classpath.
* A Groovy script can also have a class definition inside them.

# Fundamentals

## Control Structure

### Boolean Evaluation

* Groovy’s `==` Is Equal to Java’s `equals()` only if the class does not implement the `Comparable` interface. If it does, then it maps to the class’s `compareTo()` method. 
* Reference comparison is done via `is()` method. Custom truth conventions can be added by implementing `asBoolean()` method.

``` groovy
str = 'Hello'
if(str) println str + 'World' //Groovy checks if the object reference is null
list = [1]
if(list) println list //Groovy checks if list is not-null and not empty
```

### Safe-navigation operator (?.) 

* eliminates the mundane null check. If input is null, returns null instead of NPE.
``` groovy
def foo(str) { if (str != null) { str.reverse() } } //Before
def foo(str) { str?.reverse() } //After
```

### Looping methods

* Using Ranges: `for(i in 0..5){println i}  //prints 0,1,2,3,4`
* Using times function: `5.times { println "$it" } //prints 0,1,2,3,4`
* Using upto function: `0.upto(5) { println "$it" } //prints 0,1,2,3,4`
* Using step function: `0.step(5, 2) { println "$it" } //prints 0,2,4`

### Static imports

``` groovy
import static Math.random as rand 
double value = rand() // alias name is used here to avoid confusion among static imports
```

## Exceptions

* Not forced to catch exceptions we don't care. Any exception we don’t handle is automatically passed on to a higher level.
* Catching all exceptions that may be thrown. (not Throwables or Errors) e.g., `try{...} catch(ex){...}`

---

## OOPS

* All methods and classes are public by default.
* Getters and setters are automatically created by Groovy. No setters created for final fields. To prevent non-final fields from modification, implement setter method manually and throw an error.
* `"hello".class.name` instead of `"hello".getClass().getName()`. This class property has special meaning in Map and Builders so it won't work.
* We can use 'this' within static methods to refer to the Class object.

### Basics

#### Optional Parameters

* With Default value
``` groovy
def log(x, base=10) { Math.log(x) / Math.log(base) }
log(1024) //default base 10 is used
log(1024, 2)
```

* Trailing array parameter as optional. Much like Java varargs.
``` groovy
def task(name, String[] details) { println "$name - $details" }
task 'name1'
task 'name2', 'blah..'
task 'name3', 'blah..blah..'
```

#### Named arguments in method calls

* Class with no-argument constructor
``` groovy
class Robot { def type, height, width }
robot = new Robot(type: 'arm', width: 10, height: 40)
println "$robot.type, $robot.height, $robot.width"
```

* Excess Parameters as Map - If the number of arguments sent is more than what the method parameters, and if the excess arguments are in name-value pair, then Groovy treats the name-value pairs as a Map.
``` groovy
class Robot { 
  def access(location, weight, fragile) {
    println "Received fragile? $fragile, weight: $weight, loc: $location"
  }
}
new Robot().access(x: 30, y: 20, z: 10, 50, true)
//You can change the order
new Robot().access(50, true, x: 30, y: 20, z: 10, a:5)
```

#### Multiple Assignments

* Method returning an array is assigned to multiple variables 
``` groovy
def splitName(fullName) { fullName.split(' ') }
def (firstName, lastName) = splitName('James Bond')
println "$lastName, $firstName $lastName"
```

* Swapping two variables without a temporary variable using above technique
``` groovy
def (first, last) = ["James", "Bond"]
(first, last) = [last, first]
println "$first $last"
```

#### Implementing Interface

* Block of code morphed as the implementation of an interface
``` groovy
interface Greeting { void greet(greeting) }
interface WellWisher { void wish(wish) }
void greeter(Greeting greeting){ greeting.greet()}
void wellwisher(WellWisher wellwisher){ wellwisher.wish()}

greeter(new Greeting(){ void greet(greeting){println 'Java style'}}) 
groovyStyle = {println 'Groovy style'}
greeter(groovyStyle as Greeting) 
//block of code is morphed into an implementation of the
// interface via 'as' operator
wellwisher(groovyStyle as WellWisher) 
```

* Groovy does not force us to implement all the methods in an interface. Very useful while mocking for unit testing.
* Implementation of multi-method interface as a Map
``` groovy
interface Greeting { void greet(greeting); void wish(wish); void regard(regard); }
void callMe(Greeting greeting){ greeting.greet(); greeting.wish()}
//method name as key, implementation as value. Not all methods are implemented
greetingsMap = [ greet: {println 'Greet Hello World'}, wish: {println 'Wish Hello World'} ] 
callMe(greetingsMap as Greeting) 
```

#### Operator Overloading

* Each operator has a standard mapping to methods.
``` groovy
== equals
+ plus
- minus
++ next
.. next (for-each syntax)
-- previous
<< leftShift
<=> compareTo
```

* Example 1: `for (ch in 'a'..'c') { println ch }`
* Example 2: `lst = ['hello']; lst << 'there'; println lst`
* Example 3: Custom class and operator overriding

``` groovy
class Name{
  def name; 
  def plus(other){
    new Name(name: name + "~~" + other.name)
  }
  String toString() { "name: " + name}
}
def name1 = new Name(name: "Hello")
def name2 = new Name(name: "World")
println name1 + name2
```

### Coercion

* Implementing operators is straightforward when both operands are of the same type. Things get more complex with a mixture of types, say 1 + 1.0. One of the two arguments needs to be promoted to the more general type, and this is called coercion.
* <span style="color:red">Double dispatch???? - Need better description & example ????</span>
* Examples
``` groovy
== equals
+ plus
- minus
++ next
-- previous
<=> compareTo
```

### Strings

* Plain strings (instance of java.lang.String)
* GStrings (instance of groovy.lang.GString)
* GStrings allow placeholder expressions to be resolved and evaluated at runtime. ( Also called String interpolation ) Placeholders may appear in a full `${expression}` syntax or an abbreviated $reference syntax.


## Arrays and Collection

* Groovy supports collections at language level
* Groovy supports generics but favors dynamic behavior. Compile-time type checking is turned off by default.

### Arrays
``` groovy
[1,2,3] //Groovy treats this as list. 
[1,2,3] as int[] //Now the list is converted to an array here
```

### Ranges

For loops and conditionals are not objects, cannot be reused, and cannot be passed around, but ranges can. Ranges let you focus on what the code does, rather than how it does it. This is a pure declaration of your intent, as opposed to fiddling with indexes and boundary conditions.

Custom Range - Any datatype can be used with ranges, provided that both of the following are true:

1. The type implements next and previous; that is, it overrides the ++ and -- operators.
2. The type implements java.lang.Comparable; that is, it implements compareTo, effectively overriding the `<=>` spaceship operator.

### List

* The sequence can be empty to declare an empty list. 
* Lists are by default of type `java.util.ArrayList` and can also be declared explicitly by calling the respective constructor. The resulting list can still be used with the subscript operator. In fact, this works with any type of list, as we show here with type `java.util.LinkedList`.
* Lists can be created and initialized at the same time by calling `toList` on ranges.

## Annotations

* groovyc ignores @Override
* `@Canonical` - auto-generates `toString()` implementation as comma-separated field values

``` groovy
 import groovy.transform.*
 @Canonical(excludes="age, password")
 class Person {
 String firstName, lastName, password
 int age
 }
 def sara = new Person(firstName: "Sara", lastName: "Walker", age: 49, password: "passw0rd")
 println sara
```

* `@Delegate`

``` groovy 
import groovy.transform.*
class Worker {
 def work() { println 'get work done' }
 def analyze() { println 'analyze...' }
 def writeReport() { println 'get report written' }
}
class Expert {
 def analyze() { println "expert analysis..." }
}
class Manager {
 //At compile time, Groovy examines the Manager class and brings 
 // in methods from the delegated classes only if those methods 
 // don’t already exist
 @Delegate Expert expert = new Expert() 
 //only work() and writeReport() methods are brought here
 @Delegate Worker worker = new Worker()
}
def bernie = new Manager()
bernie.analyze()      //invokes Expert.analyze()
bernie.work()         //invokes Worker.work()
bernie.writeReport()  //invokes Worker.writeReport
```

* `@Immutable` - Groovy adds the hashCode(), equals(), and toString() methods
``` groovy
 import groovy.transform.*
 @Immutable
 class CreditCard { String cardNumber; int creditLimit }
 println new CreditCard("4000-1111-2222-3333", 1000)
```

* `@Lazy` - provides a painless way to implement the virtual proxy pattern with thread safety as a bonus
``` groovy
 class AsNeeded {
 def value
 //heavy1 and heavy2 are lazy-initialized only at the time of invocation
 @Lazy Heavy heavy1 = new Heavy()
 @Lazy Heavy heavy2 = { new Heavy(size: value) }()
 AsNeeded() { println "Created AsNeeded" }
 }
```

* `@Newify` - Create objects via Ruby-like and Python-like constructors without using 'new Foo()' style. Comes handy in DSL creation.
``` groovy
@Newify([CreditCard, Person]) //specify the list of types here. 
def fluentCreate() {
 println CreditCard("1234-5678-1234-5678", 2000) //Python-like constructor invocation with new keyword
 println Person.new("John", "Doe") //Ruby-like constructor invocation where new() is a method
}
fluentCreate()
```

* `@Singleton`
``` groovy
 @Singleton(lazy = true)
 class TheUnique {
  private TheUnique() { println 'Instance created' }
 def hello() { println 'hello' }
 }
 TheUnique.instance.hello()
 TheUnique.instance.hello()
 new TheUnique().hello() //Caveat: since Groovy does not honor private methods, clients can still do this.
```

* `@InheritConstructors`
``` groovy
 @Canonical
 class Car {
 def make, model, year
 Car(make, model){ this.make = make; this.model = model; this.year = 2000; }
 Car(make, model, year){ this.make = make; this.model = model; this.year = year; }
 }
 @InheritConstructors
 class Honda extends Car{
 //no need to explicitly override all the constructors here
 }
 println new Car("Honda", "Accord")
```
---

## Closures

In OO languages, the Method-Object pattern has often been used to simulate the same kind of behavior by defining types whose sole purpose is to implement an appropriate single-method interface so that instances of those types can be passed as arguments to methods, which then invoke the method on the interface. e.g., `java.io.File.list(FilenameFilter)` where FilenameFilter interface specifies a single method, and its only purpose is to allow the list of files returned from the list method to be filtered while it’s being generated.


## Questions

1. What is the difference between a Groovy script and a Groovy class?
* how closure is better than an anonymous inner class?
* what is a spaceship operator? <=>
* how to implement dynamic parameters and method?
* What is relaying and duck typing and how dynamic typing enables to achieve them?