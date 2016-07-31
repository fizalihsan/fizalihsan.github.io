---
layout: page
title: "Groovy"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Overview

* Use Groovy for flexibility and readability. Use Java for performance
* Runs on JVM - Groovy is nothing but a new way of creating Java classes - Java code can be called from Groovy and vice-versa
* Every Groovy type is a subtype of `java.lang.Object` - Every Groovy object is an instance of a type in the normal way
* Groovy class IS A Java class
* Groovy supports dynamic typing
* To compile a Groovy script - `groovyc –d classes Foo.groovy`
* To run a compiled Groovy class in Java - `java -cp $GROOVY_HOME/embeddable/groovy-all-1.0.jar:classes Foo`
* To run a Groovy script - `groovy Foo.groovy`
* Behind the scenes it compiles to a Java class and executes
* Any Groovy code can be executed this way as long as it can be run; that is, it is either a script, a class with a main method, a `Runnable`, or a `GroovyTestCase`.
* Groovy automatically imports following packages: `groovy.lang.*, groovy.util.*, java.lang.*, java.util.*, java.net.*, and java.io.*` as well as the classes `java.math.BigInteger` and `BigDecimal`.
* Say there is a Groovy class called Foo, we can use Foo objects without explicitly compiling the Book class as long as Foo.groovy is on the classpath.
* A Groovy script can also have a class definition inside them.

# Fundamentals

## Control Structure

### Boolean Evaluation

* Groovy’s `==` Is Equal to Java’s `equals()` only if the class does not implement the `Comparable` interface. If it does, then it maps to the class’s `compareTo()` method. 
* Reference comparison is done via `is()` method. Custom truth conventions can be added by implementing `asBoolean()` method.
* **Groovy Truth** - Following evaluate to true : non-null references, non-empty strings or collections, non-zero numbers, and the boolean literal true.

``` groovy
str = 'Hello'
if(str) println str + 'World' //Groovy checks if the object reference is null
list = [1]
if(list) println list //Groovy checks if list is not-null and not empty
```

### Operators

**Elvis operator / Safe-navigation operator (?.)** 

``` groovy Elvis operator
def foo(str) { if (str != null) { str.reverse() } } //Before
def foo(str) { str?.reverse() } //After
```

**Spread-dot operator**

Example: `collections*.size()` - returns the size of each element in the collection

**Spaceship**

`obj1 <=> obj2` compares obj1 and obj2 through `compareTo()` method

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
* Catching all exceptions that may be thrown. (not `Throwables` or `Errors`) e.g., `try{...} catch(ex){...}`

---

## OOPS

* Groovy is purely object-oriented
  * everything is an object. E.g `2*3`, though they look like primitives, they are actually java.lang.Integer objects
  * every operator is a method call. E.g. `a+b` //logic for the + operator is implemented in method plus() on the object 
* Scope
  * All methods and classes are *public* scoped by default.
  * Fields are *private* scoped by default.
* Getters and setters are automatically created by Groovy. No setters created for final fields. To prevent non-final fields from modification, implement setter method manually and throw an error.
* `"hello".class.name` instead of `"hello".getClass().getName()`. This class property has special meaning in Map and Builders so it won't work.
* We can use 'this' within static methods to refer to the Class object.

### Optional Parameters

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

### Named arguments in method calls

* Class with no-argument constructor

``` groovy
class Robot { def type, height, width }
robot = new Robot(type: 'arm', width: 10, height: 40)
println "$robot.type, $robot.height, $robot.width"
```

* Excess Parameters as Map - If the number of arguments sent is more than what the method parameters, and if the excess arguments are in name-value pair, then Groovy treats the name-value pairs as a Map.

``` groovy
class Robot { 
  def access(Map location, weight, fragile) {
    println "Received fragile? $fragile, weight: $weight, loc: $location"
  }
}
new Robot().access(x: 30, y: 20, z: 10, 50, true)
//You can change the order
new Robot().access(50, true, x: 30, y: 20, z: 10, a:5)
```

### Multiple Assignments

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

### Implementing Interface

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


### Operator Overloading

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

* Example 1. `for (int ch = 'a'; ch < 'c'; ch++) { println ch }` --> `++` operator in `String` is overloaded by Groovy here mapping to `next()` method
* Example 2. `for (ch in 'a'..'c') { println ch }` --> same as above
* Example 3. `lst = ['hello']; lst << 'there'; println lst` --> `<<` is overloaded to `leftShift()` in `Collection`

``` groovy Custom operator overloading
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

### Duck typing 

* A static reference can only be assigned to an object of that type or one of its subclasses, or a class that implements that interface if the reference is of interface type. e.g., `Car car = `
* In a dynamically typed language, however, we can have any classes stand in for another, as long as they implement the methods we need. e.g., in the below case, as long as the objects implement the method size() it will work.

``` groovy
//Duck typing example
def collection = 
println collection.size()
```

* if it walks like a duck, and quacks like a duck, then it is a duck.

### Coercion

* Implementing operators is straightforward when both operands are of the same type. Things get more complex with a mixture of types, say 1 + 1.0. One of the two arguments needs to be promoted to the more general type, and this is called **coercion**.
* Closure Coersion - e.g. `Collections.sort(list, { ... } as Comparator)` 
  * closure here is coerced to implement interface Comparator
  * if the interface has more than one methods, then pass different closure implementations as map

* Double dispatch

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


## POGOs

* `object.property` - though this looks like accessing a private properties on the object, Groovy goes through the getter and setter methods provided in the class when it looks like properties are being accessed or assigned.
* Map-based constructors
  * `def faith = new Person(name:'Faith',id:1)` - By default, Groovy creates this map-based constructor. (Map is not used behind the implementation though)
  * `def willow = [name:'Willow',id:2] as Person` - a map is coerced into an object

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

## Annotations / AST (Abstract Syntax Tree) Transformations

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


# Groovy Metaprogramming

In Groovy every class has a metaclass. A metaclass is another class that manages the actual invocation process. If you invoke a method on a class that doesn’t exist, the call is ultimately intercepted by a method in the metaclass called `methodMissing`. Likewise, accessing a property that doesn’t exist eventually calls `propertyMissing` in the metaclass. Customizing the behavior of `methodMissing` and `propertyMissing` is the heart of Groovy runtime metaprogramming.


``` groovy "Example of meta-programming in Groovy"

/* Every closure has a delegate property. 
By default the delegate points to the object that the closure was invoked on.
*/

Complex.metaClass.plus = { Complex c -> delegate.add c }
Complex.metaClass.minus = { Complex c -> delegate.subtract c }

def c1 = new Complex(real: 1, imaginary: 2)
def c2 = new Complex(real: 3, imaginary: 4)
def c3 = c1 + c2

println c3 == new Complex(real: 4, imaginary: 6)

@EqualsAndHashCode
class Complex{
    def real, imaginary

    Complex add(Complex c){
        this.real += c.real
        this.imaginary += c.imaginary
        this
    }

    Complex subtract(Complex c){
        this.real -= c.real
        this.imaginary -= c.imaginary
        this
    }

    @Override
    public String toString() {
        return "($real + ${imaginary}i)"
    }
}
```

# Concurrency

...

# DSL

...

## Questions

* What is the difference between a Groovy script and a Groovy class?
* What is relaying and how dynamic typing enables to achieve it?
* How to write new AST annotations?
* Spring + Groovy
* 'Liquid Heart' technique by Dierk Koenig, lead author of Groovy in Action [Manning, 2007]
* Groovy iteration patterns
* JMX 2
* Closure delegation
* Meta object protocol

