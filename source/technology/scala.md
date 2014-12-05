---
layout: page
title: "Scala"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Interesting Features

* Scala program can call Java methods and vice versa
* Interface defined in Java can be implemented in Scala
* Anonymous functions- e.g.?
* Pass a function as argument to another function- e.g.?
* Nested functions - e.g.?
* Function as a return value of a function - e.g.?
* Data Types
  * Unit is like void
* Everthing is an object including
  * primitives like int, boolean, etc.
  * functions
* Classes
  * Can have parameters - e.g., `class Complex(real: Double, imaginary : Double)`. Now an object is created with those parameters passed in `new Complex(1.1, 2.3)` .
* Import statements
  * Multi-class import - e.g., `import java.util.{Date, Locale}`
  * To import all classes in a package - `import java.util._`  NOT `java.util.*` because asterisk is an identifier
  * Static member import - `import java.util.DateFormat._`
* Method definition
  * Method with no argument and no return type
  * Method with 1 argument and no return type
  * Method with multiple args and no return type
  * Method with return type
    * Implicit - `def getName() = name; or def getName = name;` Though the return  type * here is not specified, compiler automatically deduces from variable type  'name'
    * Explicit -
  * Anonymous functions
* Method calls (see program 1)
  * No argument methods with no brackets - e.g., `new Date` or `class.method`
  * 1 argument methods can be called in infix format - e.g., `df format date` rather than `df.format(now)`
* Inheritence
  * Super class is scala.AnyRef like java.lang.Object
  * Abstract class is same as Java
  * When overriding a method from super class, override modifier is mandatory. e.g.,  `override def toString() = "" + re + (if (im < 0) "" else "+") + im + "i"`
* Case class
  * new keyword is not mandatory to create instances
  * Getter functions are automatically defined for default constructor parameters - e.g. `caseclass.parameter1` returns parameter1.
  * `equals,hashCode & toString` methods are provided by-default on the structure of the instances
* End of statement - no semicolon required


## Simple Hello World

``` scala
object HelloWorld {
  def main(args: Array[String]) {
    println("Hello, world!")
  }
}
```
 
* Comments
  * Defining HelloWorld as 'object' means it is both a class and a singleton   instance of it
  * No return type required for main since it is a procedure method
  * There is no static fields or methods in Scala
 
Simple Programs

*Program 1:*

``` scala
import java.util.{Date, Locale}
import java.text.DateFormat
import java.text.DateFormat._
 
object FrenchDate {
  def main(args: Array[String]) {
    val now = new Date
    val df = getDateInstance(LONG, Locale.FRANCE)
    println(df format now)
  }
}
```

*Program 2: Passing function as input to another function*

``` scala
object Timer {
  def oncePerSecond(callback: () => Unit) {
    while (true) { callback(); Thread sleep 1000 }
  }
 
  def timeFlies() {
    println("time flies like an arrow...")
  }
 
  def main(args: Array[String]) {
    oncePerSecond(timeFlies)
  }
}
```

* Passing anonymous functions, it becomes `oncePerSecond( () => println("Time indeed flies"))`