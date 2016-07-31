---
layout: page
title: "Java Fundamentals"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Fundamentals

## Data Types

### Floating Point Arithmetic

* Java follows Binary Floating-point arithmetic standard
  * "float" - 4 bytes of storage, and have 23 binary digits of precision
  * "double" - 8 bytes of storage, and have 52 binary digits of precision.
* `float f = 3.0f;` <-- single precision floating-point number constant
* `double d = 3.0d;`<-- double precision floating-point number constant
* Not A Number(NaN) is produced if a floating point operation has some input parameters that cause the operation to produce some undefined result. Example, `0.0 / 0.0`, `Math.sqrt(-2.0)`
* `float pi=3.14f;` <-- suffix 'f' is required, since in Java real constants are by default double.

* Default Values
  * **Instance Variables**
    * Objects = null
    * numbers = 0
    * char = ''
    * boolean = false
    * Arrays = null
  * **Local Variables**
    * Local variables are not initialized with any value; not even null. Uninitialized usage throws compilation error
    * Arrays = null
* Where primitives are stored?
  * Local variables -> stack. 
  * Instance and static variables -> heap. 
  * Don't forget that for reference type variables, the value of a variable is a reference, not the object. (Arrays are reference types too - so if you have an int[], the values will be on the heap.)
  * Since Java 6, a smart VM may be able to detect if a particular reference type variable refers to an object which can never "escape" the current method. If that's the case, it could potentially inline the whole object on the stack. (Read more on Escape Analysis)

## Cloning

* Deep copy & shallow copy
* Cloneable interface
* Pitfalls of Cloning
  * Implementation can get really complex, but still leading to unsuccessful copying
  * **Cloning does not call constructor to make a copy**: As a result, it is your responsibility, as a writer of the clone method, to make sure all the members have been properly set. Here is an example of where things could go wrong. Consider a class keeping track of the total number of objects of that type, using a static int member. In the constructors you would increase the count. However, if you clone the object, since no constructor is called, the count will not truly reflect the number of objects!
  * **Problem involving `final` objects**: In the below example, both the copies of 'Dog' will have all the 3 names, though it is not intended. The problem here is that, clone() is shallow copy, and the same List<String> is used for both objects

```java
public class Dog implements Cloneable {
   public final List<String> names = new ArrayList<String>();
   public int age;
   public int weight;
   public Dog clone() {
       try {
           return (Dog) super.clone();
       } catch (CloneNotSupportedException e) {
           throw new Error("Is too");
       }
   }
   public static void main(){
      Dog bowser = new Dog();
      bowser.names.add("Fido");
      Dog bobBarker = bowser.clone();
      bowser.names.add("Bowser");
      bobBarker.names.add("Bob Barker");
   }
}
```

## Date

* Java date – timezone – database timezone support?
* http://www.date4j.net/
* [TimeZone uncertainity](http://martinfowler.com/bliki/TimeZoneUncertainty.html)
* http://c2.com/cgi/wiki/wiki?JavaUtilDate
* Date & Time - GregorianCalendar, TimeZone
* Issues with Java Date API


## Finalization
`java.lang.System.runFinalization()` - Runs the finalization methods of any objects pending finalization. Calling this method suggests that the Java Virtual Machine expend effort toward running the finalize methods of objects that have been found to be discarded but whose finalize methods have not yet been run. When control returns from the method call, the Java Virtual Machine has made a best effort to complete all outstanding finalizations.

## Mutability
An immutable object is one whose externally visible state cannot change after it is instantiated.eg., String, Integer, BigDecimal, etc. For all immutable objects, it’s better to hide constructors and use factories.

* Why Hashtable keys needs to be immutable objects?
  * If you use mutable object as Hashtable key and if the object's state changes, then the Hashtable implementation wouldn't be able return the object it contains since the hashcode is different now. This would lead to memory leak.

## UUID
  
...

# OOPS Concepts

## Access Modifiers

* **public**
  * can be applied to class (both inner & outer), method, field.
  * A public method in a class is accessible to the outside world only if the class is declared as public. If the class does not specify any access modifier, then the public method is accessible only within the containing package.
* **private**
  * can only be applied inner class, method and field.
* **protected**
  * can be applied to inner class, method, field.
* **default**
  * can be applied to class(both inner & outer), method, field.
  * One significant difference between these two access modifiers arises when we talk about a subclass belonging to another package than its superclass. In this case, protected members are accessible in the subclass, whereas default members are not.

## Overloading

* The signature of a method is made up of the method name, number of arguments, and types of arguments. You can overload methods with same name but with different signatures.
* Overloading is an example of static polymorphism - meaning different forms of the method is resolved at compile-time.
* Method & Constructor Overloading
* **Overload resolution** - set of rules used by compiler to resolve which method to call. For resolving a method call, it first looks for the exact match—the method definition with exactly same number of parameters and types of parameters. If it can’t find an exact match, it looks for the closest match by using upcasts. The compiler throws error if there are no matches or ambiguous matches.

## Overriding

* You can invoke methods from the base class reference; however, the actual method invocation depends on the dynamic type of the object pointed to by the base class reference. The type of the base class reference is known as the **static type** of the object and the actual object pointed by the reference at runtime is known as the **dynamic type** of the object. 
* When the compiler sees the invocation of a method from a base class reference and if the method is an overridable method (a non-static and non-final method), the compiler defers determining the exact method to be called to runtime (late binding). At runtime, based on the actual dynamic type of the object, an appropriate method is invoked. This mechanism is known as **dynamic method resolution** or **dynamic method invocation**.
* A static method is resolved statically. Inside the static method, a virtual method is invoked, which is resolved dynamically.
* Things to watch while overriding
  * Should have the same argument list types (or compatible types) as the base version.
  * Should have the same return type. But from Java 5 onwards, the return type can be a subclass–covariant return types.
  * Should not have a more restrictive access modifier than the base version. But it may have a less restrictive access modifier.
  * Should not throw new or broader checked exceptions. But it may throw fewer or narrower checked exceptions, or any unchecked exception.
 * **Covariant Return Types** - copy() method is overridden in line 8 returning Shape, due to which explicit downcasting is needed on line 13. Since Java 5, overridden methods can return a sub-class covariant type to avoid this (returning Circle in this case). 

```java
abstract class Shape {
	// other methods...
	public abstract Shape copy();
}

class Circle extends Shape {
	// other methods...
	public Circle(int x, int y, int radius) { /* initialize fields here */ }

	public Shape copy() { /* return a copy of this object */ }

	class Test {
		public static void main(String []args) {
		Circle c1 = new Circle(10, 20, 30);
		Circle c2 = (Circle)c1.copy();
	}
}
```

* `@Override` - In order to overcome the subtle problems of overloading, Java 5 introduced @Override annotation. This explicitly expresses to the Java compiler the intention of the programmer to use method overriding. In case the compiler is not satisfied with your overridden method, it will issue a complaint. Also, the annotation makes you understand that you are overriding a method.

## final keyword

* Final class - is a non-inheritable class. 
* In general, OOP suggests that a class should be open for extension but closed for modification (Open/Closed Principle). However, it is useful for important reasons
* To prevent a behavior change by subclassing. e.g. java.lang.System, java.lang.String
* Improved performance (moderate)- All method calls of a final class can be resolved at compile time itself. As there is no possibility of overriding the methods, it is not necessary to resolve the actual call at runtime for final classes, which translates to improved performance. For the same reason, final classes encourage the inlining of methods. If the calls are to be resolved at runtime, they cannot be inlined.
* Final methods are non-overrideable
* Final variables are constants - The value of a final parameter cannot be changed once assigned. Here, it is important to note that the “value” is implicitly understood for primitive types. However, the “value” for an object refers to the object reference, not its state. Therefore, you can change the internal state of the passed final object, but you cannot change the reference itself.

## static keyword
* static variable
  * is called class variable since it is associated with its class rather than the object.
  * is initialized when the class is loaded first.
  * A local variable (within a block or method) cannot be declared as static.
* static method
  * invoked by using class names. It is not recommended to use instance variables to call a static method.
  * cannot access instance variables and methods. It can only access static variables and can call only static methods. In contrast, an instance method (non-static) may call a static method or access a static variable.
  * cannot use the this keyword in its body since it is associated with a class and not an instance. Only instance methods have an implicit reference associated with them; hence class methods do not have a this reference associated with them.
  * cannot be overridden. Because, based on the instance type, the method call is resolved with runtime polymorphism. Since static methods are associated with a class (and not with an instance), you cannot override static methods, and runtime polymorphism is not possible with static methods.
  * cannot use the super keyword in its body. Why? You use the super keyword for invoking the base class method from the overriding method in the derived class. Since you cannot override static methods, you cannot use the super keyword in its body.
* static block
  * will be executed by JVM when it loads the class into memory.
* static class - only an inner class can be defined static.

## Nested classes

* Nested class is a class defined inside the body of another class (or interface).
* Types
  * Static nested classes
    * can access static members on the outer class.
    * The outer class can also access the members (even private members) of the nested class through an object of nested class. If you don’t declare an instance of the nested class, the outer class cannot access nested class elements directly.
    * A class or an interface defined inside an interface is implicitly static.
  * Inner classes
    * Every inner class is associated with an instance of the outer class.
    * The accessibility (public, protected, etc.) of the inner class is defined by the outer class.
    * Outer & inner classes can access members of each other regardless of the access specifiers.
    * You can access members of an outer class within an inner class without creating an instance; but this is not the case with an outer class.
    * Limitation: cannot declare static members in an inner class. 
  * Local inner classes
    * Unlike static nested classes and inner classes, local inner classes are not members of an outer class; they are just local to the method or code in which they are defined.
    * Since you cannot declare a local variable static, you also cannot declare a local class static.
    * Since you cannot define methods in interfaces, you cannot have local classes or interfaces inside an interface. Nor can you create local interfaces
    * can acces the method arguments and all the variables defined in the body of the code only if they are declared final.
  * Anonymous classes
    * Same as local inner class without a name. 
    * cannot have explicit constructors since there is no name.
    * can acces the method arguments and all the variables defined in the body of the code only if they are declared final.


<table>
	<thead>
		<tr>
			<th>           </th>
			<th> Static </th>
			<th> Non-static </th>
			<th> Anonymous </th>
		</tr>
		</thead>
		<tbody>
		<tr>
			<td> <strong>Non-local</strong> </td>
			<td style="vertical-align: top"> Static nested class
<pre>
class Outer{
   static class Inner{}
}

class Outer{
   static interface Inner{}
}

interface Outer{
   static class Inner{}
}

interface Outer{
   static interface Inner{}
}
</pre>
			</td>
			<td style="vertical-align: top"> Inner class 
<pre>
class Outer{
   class InnerClass{
   }
}

class Outer{
   interface Inner{}
}
</pre>
			</td>
			<td> Not possible </td>
		</tr>
		<tr>
			<td> <strong>Local</strong>     </td>
			<td> Not possible        </td>
			<td style="vertical-align: top"> Local inner class 
<pre>
class Outer{
   void foo(final Object arg){
      class LocalInner{
      }
   }
}
</pre>
			</td>
			<td style="vertical-align: top"> Anonymous inner class 
<pre>
class Outer{
   Object foo(){
      return new Object(){ 
         public String toString(){ 
            return "anonymous";
         }
      }
   }
}
</pre>
			</td>
		</tr>
	</tbody>
</table>

## Enums

* A constructor in an enum class can only be specified as `private`.
* are implicitly declared `public`, `static`, and `final`, which means you cannot extend them.
* An enum implicitly inherits from java.lang.Enum and get converted internally to classes. Further, enum constants are instances of the enumeration class for which the constant is declared as a member.
* cannot use the new operator on enum data types, even inside the enum class.
* Enumeration constants cannot be cloned.

## Interfaces

* cannot declare static methods.
* All fields are implicitly considered to be declared as `public`, `static` & `final`.
* only public methods and variables are allowed in an interface. No `protected` or `private`.
* All methods declared in an interface are implicitly considered to be `abstract`. You can also explicitly use the `abstract` qualifier for the method.