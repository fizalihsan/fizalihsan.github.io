---
layout: page
title: "Functional Programming"
comments: false
sharing: false
footer: true
---

* list element with functor item
{:toc}

# Abstraction
* Object-oriented programming is mostly about abstracting over data, while functional programming is mostly about abstracting over behavior.
* **Declarative vs. Imperative Programming**
	* Object-oriented programming is primarily imperative, where we tell the computer what to do. E.g., calculating factorial in for loop which involves mutations.
	* Functional programming is primarily declarative, where we define properties and relations, and let the runtime figure out how to compute what we want. E.g., calculating factorial in a recursive method without any mutations.
	* Declarative programming is made easier by lazy evaluation, because laziness gives the runtime the opportunity to “understand” all the properties and relations, then determine the optimal way to compute values on demand. Like lazy evaluation, declarative programming is largely incompatible with mutability and functions with side effects.

# FP principles & concepts

* **Avoiding mutable state**
	* eases concurrent programming. We still need to handle mutations in a thread-safe way. Software Transactional Memory and the Actor Model give us this safety
* **Functions as First-Class Values**
	* A method is associated with a class or an object. A function is more general and is not associated with anything.
	* Java only has methods and methods aren’t first-class in Java. You can’t pass a method as an argument to another method, return a method from a method, or assign a method as a value to a variable.
* **Lambdas and Closures**
	* A closure is a function that carries an implicit binding to all the variables referenced within it.
* **Higher-order functions**
	* Higher-order functions is a special term for functions that take other functions as arguments or return them as results. These are a powerful tool for building abstractions and composing behavior.
* **Side-Effect-Free Functions**
	* Functions that mutate state are called side-effects. e.g., setting values of an object’s field or global variables. In mathematics, functions are always side-effect-free.
	* Side-effect-free functions make excellent building blocks for reuse, since they don’t depend on the context in which they run. Compared to functions with side effects, they are also easier to design, comprehend, optimize, and test. Hence, they are less likely to have bugs.
* **Lazy vs. Eager Evaluation**
	* Lazy representation of infinite data structures wouldn’t be possible without this feature! Both referential transparency and lazy evaluation require side-effect-free functions and immutable values.
	* Finally, lazy evaluation is useful for deferring expensive operations until needed or never executing them at all.
	* Defer expensive calculation as much later as possible
	* Allows to create infinite collections, which keep delivering elements as long as they keep receiving requests.
* __Referential Transparency__
	* A function is considered referentially transparent, if it has the same effect and output on the same input. If not, it is called *referentially opaque*.
	* If a function can also throw an exception, it isn’t a safe substitute for a value.
* __Currying__
	* Both currying and partial application give you the ability to manipulate the number of arguments to functions or methods, typically by supplying one or more default values for some arguments (known as *fixing arguments*)
	* Currying describes the conversion of a multiargument function into a chain of single-argument functions. It describes the transformation process, not the invocation of the converted function. The caller can decide how many arguments to apply, thereby creating a derived function with that smaller number of arguments.
	* Use currying to construct specific functions from general ones.
	* Currying is a metafunction technique: doing something to the function itself rather than the function results. 
	* Currying acts as a factory (pattern) for functions.

```java Example 1
	def product = { x, y -> 
		println "x = $x, y = $y"
		x * y 
	}

	def quadrate = product.curry(4)
	println quadrate.call(2) 

	//x = 4, y = 2
	//8
```

```java Example 2
	println product.curry(4).curry(2).call() //same result as above
```

```java Example 3
	def productWithX = product.curry(4)
	println productWithX(2) //same result as above
```

* **Memoization**
	* The word memoization was coined by Donald Michie, a British artificial-intelligence researcher, to refer to function-level caching for repeating values.
	* In order to memoize a function in Groovy, you define it as a closure, then execute the `memoize()` method to return a function whose results will be cached.
	* Groovy built memoization into its Closure class; other languages implement it differently.
	* Memoization acts as a flyweight (pattern) for functions.

* **Command-Query Responsibility Segregation (CQRS)**


# Data Structures

* **Filter**
	* Create a new collection, keeping only the elements for which a filter method returns true. The size of the new collection will be less than or equal to the size of the original collection.
* **Map**
	* Create a new collection where each element from the original collection is transformed into a new value. Both the original collection and the new collection will have the same size.
* **Fold or Reduce or Inject or Accumulate**
	* Starting with a “seed” value, traverse through the collection and use each element to build up a new final value where each element from the original collection “contributes” to the final value. An example is summing a list of integers.

* Combinators (Filter, map and fold) are modular, composable & reusable.
	* filter and map, return a new List, while fold can return anything we want.
	* Recursion can be avoided by using combinators.
	* Persistent Data Structures (Software Transactional Memory)
		
# Concurrency Principles

## The Actor Model

The Actor model isn’t really a functional approach to concurrency, but it fits our general goal of managing state mutation in principled ways. In the Actor model of concurrency, work is coordinated by message passing between “actors.” Each actor has a queue, sometimes called a mailbox, for incoming messages. The actor processes each message, one at a time.

## Software Transactional Model (STM)

* Software Transactional Memory (STM) brings transactions to locations in memory that are referenced by variables. STM can’t provide durability, because memory isn’t durable (e.g., if the power is lost), but STM can provide the ACI, atomicity, consistency, and isolation in ACID.
* Persistent Data Structures are exactly what STM needs.

# Lambdas

## Java 8 Lambda Styles

```java
Runnable noArguments = () -> System.out.println("Hello World");

ActionListener oneArgument = event -> System.out.println("button clicked");

Runnable multiStatement = () -> {
	System.out.print("Hello");
	System.out.println(" World");
};

BinaryOperator<Long> add = (x, y) -> x + y;

BinaryOperator<Long> addExplicit = (Long x, Long y) -> x + y;
```

## Concepts

* Lambda expression’s type is context dependent and it gets inferred by the compiler.
* Lambda expressions capture values, not variables.

### Lexical Scoping
	public static Predicate<String> checkIfStartsWith(final String letter) {
		return name -> name.startsWith(letter);
	}
			
* In `return name -> name.startsWith(letter)`, it’s clear what name is: it’s the parameter passed to this lambda expression. But what’s the variable letter bound to? Since that’s not in the scope of this anonymous function, Java reaches over to the scope of the definition of this lambda expression and finds the variable letter in that scope. This is called lexical scoping. Since this lambda expression closes over the scope of its definition, it’s also referred to as a closure.
* Local variables referenced from a lambda expression must be final or effectively final.

### Data Type Inference
In the following example, data type of the parameters are inferred by the compiler. If the parameters are inferred, then they are NOT final. In general, modifying parameters is in poor taste and leads to errors, so marking them final is a good practice. - E.g., `friends.forEach(name -> System.out.println(name));`

### Functional Interface

* A functional interface is an interface with a single abstract method that is used as the type of a lambda expression.
* There are some interfaces in Java that have only a single method but aren’t normally meant to be implemented by lambda expressions.For example, they might assume that the object has internal state and be interfaces with a single method only coincidentally. A couple of good examples are `java.lang.Comparable` and `java.io.Closeable`. For an object to be Closeable it must hold an open resource, such as a file handle that needs to be closed at some point in time. Again, the interface being called cannot be a pure function because closing a resource is really another example of mutating state.
* For those reasons, all functional interfaces should annotate with `@FunctionalInterface`.
* Some useful functional interfaces

```java
Predicate<T> - input = T, output = boolean
Consumer<T> - input = T, output = none
Function<T,R> - input = T, output = R
Supplier<T> - input = None, output = T
UnaryOperator<T> - input = T1, output = T2
BinaryOperator<T> - input = (T1, T2), output = T3
```

### Default Methods
* default methods are designed primarily to allow binary compatible API evolution. It allows API providers to add new methods to interfaces, and clients no longer are forced to implement them.
* Can be added only in interfaces, functional or not.
* If a class implements 2 interfaces with default methods by the same name, then a compilation error is thrown.
* If a class implements an interface with a default method, and extends a class which also implements the same interface but overrides the default method, then invoking the method in the concrete class takes precedence. To resolve this conflict, the new class can override the method and invoke one of the default methods via Interface.super.methodName().
* Previously, super acted as a reference to the parent class, but by using the InterfaceName.super variant it’s possible to specify a method from an inherited interface.
* Unlike classes, interfaces don’t have instance fields, so default methods can modify their child classes only by calling methods on them.
* With default methods, interfaces have now become like abstract classes. The only difference is abstract classes can have state while the interfaces can't.

* ***Rules of Default Methods**

1. Any class wins over any interface. So if there’s a method with a body, or an abstract declaration, in the superclass chain, we can ignore the interfaces completely.
2. Subtype wins over supertype. If we have a situation in which two interfaces are competing to provide a default method and one interface extends the other, the subclass wins.
3. No rule 3. If the previous two rules don’t give us the answer, the subclass must either implement the method or declare it abstract.

### Method References

```java
artist -> artist.getName() == Artist::getName
Classname::new - is for call constructors.
```

* The above two statements are one and the same. The standard form is `Classname::methodName`. Remember that even though it’s a method, you don’t need to use brackets because you’re not actually calling the method. You’re providing the equivalent of a lambda expression that can be called in order to call the method.
* Method references can refer to static methods, non-static methods and methods with input parameters.

### Streams
```java
allArtists.stream().filter(artist -> artist.isFrom("London")).count();
```

* Methods such as filter that build up the Stream recipe but don’t force a new value to be generated at the end are referred to as lazy. Methods such as count that generate a final value out of the Stream sequence are called eager.
* It’s very easy to figure out whether an operation is eager or lazy: look at what it returns. If it gives you back a Stream, it’s lazy; if it gives you back another value or void, then it’s eager. This makes sense because the preferred way of using these methods is to form a sequence of lazy operations chained together and then to have a single eager operation at the end that generates your result.
* This whole approach is somewhat similar to the familiar builder pattern. In the builder pattern, there are a sequence of calls that set up properties or configuration, followed by a single call to a build method. The object being created isn’t created until the call to build occurs.

```java
List<String> collected = Stream.of("a", "b", "hello") .map(string -> string.toUpperCase()) .collect(toList());
```

### Data Parallelism
* Data parallelism is a way to split up work to be done on many cores at the same time. In streams framework, we can utilize data parallelism by calling the parallel or parallelStream methods.
* Going by horses-pulling-carts analogy, it would be like taking half of the goods inside our cart and putting them into another cart for another horse to pull, with both horses taking an identical route to the destination.
* Data parallelism works really well when you want to perform the same operation on a lot of data. The problem needs be decomposed in a way that will work on subsections of the data, and then the answers from each subsection can be composed at the end.
* _Data parallelism_ is often contrasted with _task parallelism_, in which each individual thread of execution can be doing a totally different task. Probably the most commonly encountered task parallelism is a Java EE application container.
* The five main factors influencing performance are 
	* the data size, 
	* the source data structure, 
	* whether the values are packed, 
	* the number of available cores, 
	* and how much processing time is spent on each element.

__Libraries__

* Java 8 introduces default methods and static methods on interfaces. This change means that methods on interfaces can now have bodies and contain code.
* As a consequence of these performance overheads, the streams library differentiates between the primitive and boxed versions of some library functions. The mapToLong higher-order function and ToLongFunction, shown in Figure 4-1, are examples of this effort. Only the int, long, and double types have been chosen as the focus of the primitive specialization implementation in Java 8 because the impact is most noticeable in numerical algorithms.

## Lambdas and Patterns

* Loan Pattern
* Execute Around Method - A synchronized block of code, such as synchronized { ... }, is a realization of the _execute around method_ pattern.
* Referential transparency
* Tail-Call Optimization
	* The biggest hurdle to using recursion is the risk of stack overflow for problems with large inputs. The brilliant TCO technique can remove that concern. A tail call is a recursive call in which the last operation performed is a call to itself. Java does not directly support TCO at the compiler level, but we can use lambda expressions to implement it in a few lines of code. This is called 'trampoline calls' and lets enjoy the power of recursion without the concern of blowing up the stack.

# References

* Functional Programming for Java Developers - Venkat Subramaniam - Pragmatic Programmers
* Java 8 Lambdas - O'Reilly
* Functional Thinking - by Neal Ford - O'Reilly