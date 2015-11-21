---
layout: page
title: "Patterns"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Design Patterns

## Adapter
Also called 'Wrapper' pattern

### Object Adapter

### Class Adapter

## Bridge

## Builder

## Chain of Responsibility

## Circular Buffer

## Command

## Composite

## Decorator

## Factory

Beware of the ambiguity in the names - Static Factory Method (in Effective Java) is not the same as Factory Method (in GoF)

### Factory Idiom - Not a pattern

* (+) Dynamically creates objects based on some input parameters. Client refers to the product via common interface.
* (+) Creates objects without exposing the instantiation logic to the client.
* (+) Since client refers to the product via a common interface, factory can change the product implementation anytime after go-live.

**Type 1: Parameterized Factory Method**
Classical switch-case/if-condition based factory method that takes a parameter to decide the type of product to return
* (+) New products can be added without changing the client code.
* (-) Tight coupling between factory and product implementations. In other words, Factory class needs to change for every new product. It violates the Open Close Principle.
* (-) Sub-classing means replacing all the factory class references everywhere in the code.

```
public class Factory{
   public Product getProduct(String type){
      if(type==1){
          return new Product1();
      } else if(type==2){
          return new Product2();
      } ....
   }
}
```

**Type 2: Dynamic Class Registration**
Keep the map of key and product type away from the factory. It could be a properties file or statically registered in common registry class. Factory can dynamically create an instance of the product either by Class.forName() or using reflection.
* (+) Factory class is not changed every time a product is added
* (-) Using reflection impacts the performance

```
public class Factory{
   private Map<String, Class<Product>> map = new HashMap<>();

   public void register(String type, Class<Product> klass){
      map.put(type, klass);
   }

   public Product getProduct(String type){
      Class<Product> klass = map.get(type);

      //Class.forName() or Reflection
   }
} 
```

### Static Factory Method

* Creates objects without exposing the instantiation logic to the client. Client refers to the product via common interface. 
* The ability of static factory methods to return the same instance from repeated invocations allows classes to maintain strict control over what instances exist at any time. Such classes are called Instance-controlled classes.

* (+) Overloaded constructors with similar parameter list can be replaced with static factory methods with meaningful names. E.g., `BigInteger.probablePrime(int, int, Random)` is better than `new BigInteger(int, int, Random)`
* (+) Unlike constructors, there is no need to create a new object every time the method is invoked. E.g.,`public static Boolean valueOf(boolean b) {return b ? Boolean.TRUE : Boolean.FALSE;}`
* (+) Unlike constructors, they can return objects of any sub-type of their return type. Helps hiding implementation classes and exposing only the interface. E.g., Non-instantiable class `java.util.Collections` hides 32 different implementations of `Collection` interface.
* (+) It will also enhance the software maintainability and performance since the class of the returned object can be varied from release to release.
* (+) Reduces the verbosity of creating parameterized type instances. e.g., `Map<String, List<Integer>> m = HashMap.newInstance();` (Generic Type Inference)
* (+) Used in building internal-DSLs along with method chaining
* (-) Classes without public/protected constructors cannot be sub-classed
* (-) Static Factory methods are not easily distinguishable from other static methods


### Factory Method

Defines an interface for creating an object, but lets subclasses decide which class to instantiate. Factory Method lets a class defer instantiation to subclasses.

* (+) Creates objects without exposing the instantiation logic to the client.
* (+) Since client refers to the product via a common interface, factory can change the product implementation anytime after go-live.
* (+) Used in builder pattern using which internal-DSLs are possible

|    |    |
| -- | -- |
| {% img /technology/FactoryMethod.png %}| {% img /technology/FactoryMethodExample.png %}|

### Abstract Factory

* Nothing but an additional layer of abstract on top of Factory method pattern
* Provide an interface for creating families of related or dependent objects without specifying their concrete classes.
* Unlike in Factory method pattern, Factory class in this pattern can have one or more factory methods.
* Type of Factory class is not known to client at compile-time.

> Read Oracle Certified Professional Java SE 7 - Programmer Exams - Page 135 for difference b/w Factory and Abstract Factory


* (+) Addresses the concerns in both the factory method implementations.
* (-) Factory cannot be a singleton
* (-) Relatively difficult to implement
* (-) A new factory has to be created for every new product

 {% img /technology/AbstractFactory.png %}

## Flyweight

## Interpretor

## Iterator

## Mediator

## Memento

## Observer

## Prototype

## Proxy

### Dynamic Proxy

Mockito, Spring container

#### Virtual Proxy

#### Counting Proxy

## Singleton

* Why Singleton? Can I not achieve the same in a public static class & method?
* All-static method class CANNOT implement an interface.
* All-static method class makes itself extendable. Singleton class DOESN'T allow that.
* Lazy loading singletons - http://crazybob.org/2007/01/lazy-loading-singletons.html

**Implementation Variations**

* **Early initialization**
  * Type 1 - public static final field – Not serializable until all the instance fields are transient and override readResolve() method to return the singleton instance.
  * Type 2 - private static final field & factory method – Same issues as above. At least gives flexibility to decide whether the class should be singleton or not.
  * Type 3 - Enum – No serialization and reflection issues.
* **Lazy initialization**
  * public static synchronized getInstance() – Performance impact due to acquiring lock for every call
  * DCL (Double-checked locking) – Broken except for 2 conditions
    * Instance field is declared volatile – Works only from JDK 1.5 and above
    * Class is immutable – All fields are final. Reading & Writing references to immutable objects are atomic.
  * Use external container like Spring/Guice or custom factory to manage the number of instances created
* **Issues with Singleton**
  * Single threaded environment
    * Hard to unit test the class – especially when it holds state like counter, etc.
      * Work around: package protect constructor and reset state
    * Potentially allows multiple version - Via Serialization or Reflection
      * Work around: override readResolve() or use enum model
    * Violates SRP (Single Responsibility Principle)
      * Work around: Use external container like Spring or some kind of registry/factory to manage the number of instances created
  * Multi threaded environment
    * Double-checked locking anti-pattern
      * Work around: use volatile field or make class immutable


** Type 1 - Early init with public static final field	**
<pre>
public class Singleton{
   <span style="color:red">public static final</span> Singleton INSTANCE = new Singleton();
   private Singleton(){}
}
</pre>

** Type 2 - Early init with private static field & factory method**
```
public class Singleton{
   private static final Singleton INSTANCE = new Singleton();
   private Singleton(){}

   //static factory method
   public static Singleton getInstance(){
     return INSTANCE;
   }
}
```

**Type 3 - Early init via Enum**
<pre>
 public <span style="color:red">enum</span> Singleton{
    INSTANCE; //By default, public static final
 }
</pre>

**Type 4 - Lazy init - not thread-safe**
<pre>
public class Singleton{
   private static Singleton instance;
   private Singleton(){}

   //static factory method
   public static Singleton getInstance(){
     <span style="color:red">
     if(instance==null){
        instance = new Singleton();
     }
     return instance;
     </span>
   }
}
</pre>

**Type 5 - Lazy init - Thread-safe but worst performing**
<pre>
 public class Singleton{
   private static Singleton instance;
   private Singleton(){}

   //static factory method
   public <span style="color:red">synchronized</span> static Singleton getInstance(){
     if(instance==null){
        instance = new Singleton();
     }
     return instance;
   }
}
</pre>

**Type 6 - Lazy init - Thread-safe via Double-checked lock (BROKEN)**
<pre>
 public class Singleton{
   private static Singleton instance;
   private Singleton(){}

   public static Singleton getInstance(){
   <span style="color:red">
     if(instance==null){ //check
        synchronized(Singleton.class){ //lock
           if(instance==null){//check</span>
              instance = new Singleton();
           }
        }
     }
     return instance;
   }
}
</pre>

**Type 7 - Lazy init - Thread-safe via DCL and volatile instance (works in Java 5+)**
<pre>
public class Singleton{
   private static <span style="color:red">volatile</span> Singleton instance;
   private Singleton(){}

   public static Singleton getInstance(){
     if(instance==null){ //check
        synchronized(Singleton.class){ //lock
           if(instance==null){//check
              instance = new Singleton();
           }
        }
     }
     return instance;
   }
}
</pre>

## State

## Strategy

## Reactor

## Recycle Bin

http://c2.com/cgi/wiki?RecycleBin
You can also find recycle bins in Java, such as in the thread pooling that you can configure using classes like ScheduledThreadPoolExecutor and ThreadPoolExecutor.

## Template Method

## TransferObject

## ValueObject

## Visitor

# Anti Patterns

> Excerpts from book 'Refactoring: Improving the Design of Existing Code')

* Large class
* Long parameter list
* Divergent Change
  * Occurs when one class is commonly changed in different ways for different reasons. If you look at a class and say, "I have to change these four methods every time there is a new financial instrument," you likely have a situation in which two objects are better than one. That way each object is changed only as a result of one kind of change. Any change to handle a variation should change a single class, and all the typing in the new class should express the variation. To clean this up you identify everything that changes for a particular cause and use `Extract Class` to put them all together.
* Shotgun Surgery
  * Similar to divergent change but is the opposite. You whiff this when every time you make a kind of change, you have to make a lot of little changes to a lot of different classes. When the changes are all over the place, they are hard to find, and it's easy to miss an important change. In this case you want to use `Move Method` and `Move Field` to put all the changes into a single class. If no current class looks like a good candidate, create one. Divergent change is one class that suffers many kinds of changes, and shotgun surgery is one change that alters many classes.


# Concurrency Patterns

> Refer "Software Architecture Design Patterns" book

## Active Object

## Balking Pattern

## Barrier

## Consistent Lock Order

## Critical Section

## Disruptor

## Guarded Suspension

## Monitor Object

## Producer/Consumer pattern

## Read-Write Lock

# Architectural Patterns

## Active Record

## Business Delegate

## Data Access Object (DAO)

## Dependency Injection or IOC

(http://www.martinfowler.com/articles/injection.html) Decoupling the implementation dependencies from the application class to a plug-in model. 

Types of Dependency injections

* Constructor injection
* Setter injection
* Interface injection

## Facade

### Session Facade

### Wrapper Facade

## Front Controller

## Interceptor

## Mock object



## Model View Controller 

MVC & MVC2

## Naked objects

## Null object

## Service Locator

## Token Synchronization



# Bibliography

* Design Patterns
  * http://c2.com/cgi/wiki?ExecuteAroundMethod 
  * http://c2.com/cgi/wiki?CodeSmell
  * http://c2.com/cgi/wiki?LawOfDemeter
  * http://c2.com/cgi/wiki?TooManyParameters
  * http://c2.com/cgi/wiki?FeatureEnvySmell
  * http://www.techjava.de/topics/2008/01/java-class-loading/