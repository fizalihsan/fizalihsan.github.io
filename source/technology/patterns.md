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

* Also called 'Wrapper' pattern
* converts the interface of a class into another interface the clients expect. Adapter lets classes work together that couldn't otherwise because of incompatible interfaces.
* OO Principle followed: composition over inheritance

| {% img /technology/adapter.png %} | {% img /technology/adapter_example.png %} |

```java
MallardDuck duck = new MallardDuck();
WildTurkey turkey = new WildTurkey();

Duck adapter = new TurkeyAdapter(turkey);
adapter.quack();
```

## Bridge

## Builder

**Benefits**

* Encapsulates the way a complex object is constructed
* Allows objects to be constructed in a multistep and varying process as opposed to one step factories. Used in building fluent APIs.
* Product implementations can be swapped in and out because the client only sees an abstract interface.
* Prevents telescoping constructor problem


## Chain of Responsibility

* Use this pattern when you want to give more than one object a chance to handle a request

**Benefits**

* Decouples the sender of the request and its receivers
* Simplifies your object because it doesn't have to know the chain's structure and keep direct references to its members.
* Allows you to add or remove responsibilities dynamically by changing the members or order of the chain.
* Used in applying filters in servlet request processing, logging a message to multiple channels, etc.

**Drawbacks**

* Execution of the request isn't guaranteed; it may fall off the end of the chain if no object handles it. This can be an advantage or a disadvantage. One can always implement a catch-all handler.
* Can be hard to observe and debug at runtime

| {% img /technology/Chain_of_responsibility.png %} | {% img /technology/Chain_of_responsibility_example.png %} |

```java

ManagerPurchasePower manager = new ManagerPurchasePower();
VPPurchasePower vp = new VPPurchasePower();
CEOPurchasePower ceo = new CEOPurchasePower();
manager.setSuccessor(vp);
vp.setSuccessor(ceo);

manager.approve(request); // if manager is not authorized to approve the request, it will be delegated VP. 
 
```

## Circular Buffer

## Command

* encapsulates a request as an object, thereby letting you parameterize other objects
with different requests, queue or log requests, and support undoable operations.
* `Executor` framework in Java is an example of Command pattern

```java
public interface Command {
   public void execute();
}
```

## Composite

## Decorator

* Attach additional responsibilities to an object dynamically.
* Decorators provide a flexible alternative to subclassing for extending functionality
* OO Principle followed: open-closed principle - classes should be open for extension, closed for modification

| {% img /technology/decorator.png %} | {% img /technology/decorator_example.png %} | 

```java
InputStream in = new LineNumberInputStream(
                    new BufferedInputStream(
                        new FileInputStream("test.txt")
                    )
                );
```

## Facade

* Provides a unified interrace to a set of interfaces in a subsystem. 
* Facade defines a higher level interface that makes the subsystems easier to use
* Not only does it simplify an interface, it also decouples a client from a subsystem of components
* OO Principle followed: Principle of least knowledge - talk only to your immediate friends.

{% img /technology/facade.png %} 

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
* The ability of static factory methods to return the same instance from repeated invocations allows classes to maintain strict control over what instances exist at any time. Such classes are called *Instance-controlled classes*.

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
* **Difference b/w Factory and Abstract Factory**
  *  factory design pattern creates the requested type of object on demand. By contrast, the abstract factory is basically a factory of factories. In other words, the abstract factory design pattern introduces one more indirection to create a specified object. A client of the abstract factory design pattern first requests a proper factory from the abstract factory object, and then it requests an appropriate object from the factory object.
  * when you have only one type of object to be created, you can use a factory design pattern; when you have a family of objects to be created, you can use an abstract factory design pattern.


* (+) Addresses the concerns in both the factory method implementations.
* (-) Factory cannot be a singleton
* (-) Relatively difficult to implement
* (-) A new factory has to be created for every new product

 {% img /technology/AbstractFactory.png %}

## Flyweight

The Flyweight Pattern can be a useful pattern in situations where you have several objects, and many may represent the same value. In these instances, it can be possible to share the values as long as the objects are immutable.

In Java, `Integer.valueOf(int)` method implements this pattern to cache values between *-128* to *127*. It checks the value of the given parameter, and if it is a precached value, the method returns the pre-constructed instance rather than creating a new copy. The cache is initialized in a static block, and so is created the first time an `Integer` is referenced in a running JVM.

This property only holds because `Integer` objects are immutable. If you are ever creating Integer objects, always use the valueOf method to take advantage of the Flyweight Pattern. If you call new, then new instances will always be created,
even if they are within the threshold of the cached values.

Another implementation of the Flyweight Pattern is called the *Null Object Pattern*. This pattern uses a flyweight object to represent null.

## Interpretor

## Iterator

## Mediator

* Use this pattern to centralize complex communications and control between related objects.

**Benefits**

* Increases the reusability of the objects supported by the mediator by decoupling them from the system
* Simplifies maintenance of the system by centralizing control logic.
* Simplifies and reduces the variety of messages sent between objects in the system. 

**Drawbacks**

* Without proper design, the Mediator object itself can become overly complex.

## Memento

* Use this pattern when you need to be able to return an object to one of its
previous states; for instance, if your user requests an undo.

## Observer

* defines a one-to-many dependency between objects so that when one object changes state, all of its dependents are notified and updated automatically.
* Java provides out-of-the-box `Observer` interface and `Observable` class in `java.util` package. However, `Observable` is a class and does not implement any interface. It has other shortcomings as well.
* OO Principle followed: Strive for loosely coupled designs between objects that interact.

{% img /technology/observer.png %}

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


**Type 1 - Early init with public static final field**

```java
public class Singleton{
   public static final Singleton INSTANCE = new Singleton();
   private Singleton(){}
}
```

**Type 2 - Early init with private static field & factory method**

```java
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

```java
 public enum Singleton{
    INSTANCE; //By default, public static final
 }
```

**Type 4 - Lazy init - not thread-safe**

```java
public class Singleton{
   private static Singleton instance;
   private Singleton(){}

   //static factory method
   public static Singleton getInstance(){
     if(instance==null){
        instance = new Singleton();
     }
     return instance;
   }
}
```

**Type 5 - Lazy init - Thread-safe but worst performing**

```java
 public class Singleton{
   private static Singleton instance;
   private Singleton(){}

   //static factory method
   public synchronized static Singleton getInstance(){
     if(instance==null){
        instance = new Singleton();
     }
     return instance;
   }
}
```

**Type 6 - Lazy init - Thread-safe via Double-checked lock (BROKEN)**

```java
 public class Singleton{
   private static Singleton instance;
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
```

**Type 7 - Lazy init - Thread-safe via DCL and volatile instance (works in Java 5+)**

```java
public class Singleton{
   private static volatile Singleton instance;
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
```

## State

## Strategy

* enables an algorithm's behavior to be selected at runtime. 
* OO Principle followed: Open-Closed principle

{% img /technology/strategy.png %}

## Reactor

## Recycle Bin

http://c2.com/cgi/wiki?RecycleBin
You can also find recycle bins in Java, such as in the thread pooling that you can configure using classes like ScheduledThreadPoolExecutor and ThreadPoolExecutor.

## Template Method

* Defines the skeleton of an algorithm in a method, deferring some steps to
subclasses to provide the implementation.
* Lets subclasses redefine certain steps of an algorithm without changing the algorithm structure
* OO Principle followed: Hollywood principle - Don't call us, we'll call you

{% img /technology/template.png %}

## TransferObject

## ValueObject

## Visitor

[Visitor Pattern Explained](http://stackoverflow.com/a/2604798/1732171)

|{% img /technology/visitor.png %}|{% img /technology/visitor_example.png %}|

```java

public class Main {
    public static void main(String[] args) {
        List<Fruit> fruits = Arrays.asList(new Apple(), new Orange(), new Orange(), new Apple());

        final FruitVisitor partitionVisitor = new FruitPartitionVisitor();
        final FruitVisitor priceVisitor = new FruitPriceVisitor();
        for (Fruit fruit : fruits) {
            fruit.accept(partitionVisitor);
            fruit.accept(priceVisitor);
        }
    }
}

-------------------------------------------------------------------------------------------------------
public interface Fruit {
    void accept(FruitVisitor visitor);
}

public class Apple implements Fruit {

    @Override
    public void accept(FruitVisitor visitor) {
        visitor.visit(this);
    }
}

public class Orange implements Fruit{

    @Override
    public void accept(FruitVisitor visitor) {
        visitor.visit(this);
    }
}
-------------------------------------------------------------------------------------------------------
public interface FruitVisitor {
    void visit(Apple apple);
    void visit(Orange orange);
}


public class FruitPriceVisitor implements FruitVisitor {

    @Override
    public void visit(Apple apple) {
        System.out.println("Apple price is $5/kg");
    }

    @Override
    public void visit(Orange orange) {
        System.out.println("Apple price is $3/kg");
    }
}


public class FruitPartitionVisitor implements FruitVisitor {

    @Override
    public void visit(Apple apple) {
        System.out.println("This is an apple");
    }

    @Override
    public void visit(Orange orange) {
        System.out.println("This is an orange");
    }
}
-------------------------------------------------------------------------------------------------------

```


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