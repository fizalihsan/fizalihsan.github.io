---
layout: page
title: "Coding Principles"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}


# Clean Code
***A Handbook of Agile Software Craftmanship - Bob Martin***

## Naming
* Don't reveal implementation detail in variables. e.g., declare `accounts` instead `accountList`
* Use single letter variables only as a local variable
* No need for prefix on variables and class names. e.g., `ICustomer` interface
* Class name should NOT be a verb. Avoid words like `Manager`, `Processor`, `Data` or `Info`
* Use a common word per concept across method names and class names. e.g., `fetch(), get(), retrieve()`. Stick to one.

## Function
* Function should do one thing only. One level of abstraction per function.
* Switch statement - tolerated if it appears only once at very low level. Hide it with 'AbstractFactory' and polymorphism.
* Function arguments
  * Number of arguments
    * Niladic (zero args) - Best
    * Monadic (1) - Better
    * Dyadic (2) - Good
    * Polyadic (multiple) - Needs good justification
  * Avoid functions with output arguments. e.g., `public boolean foo(String input, String output);`
  * Passing flags as arguments is ugly. Based on the flag value, the function might perform one or more things. .e.g., `render(boolean isSuite)`. Split the logic into `renderForSuite()` and `renderForSingleTest()` to make it explicit.
  * Ambiguity issue with dyadic or polyadic functions with same type of arguments. e.g, `assertEquals(int expected, int actual)`. Make function explicit as `assertExpectedEqualsActual(int, int)`.
  * Fix for polyadic functions
    * Club the different arguments into an object and pass that object as input argument
    * Or, make those arguments are field variables. (only for private functions)
* **Side effects**
  * A function promises to do one thing, but it also does other hidden things. e.g., `checkPassword(String user, String password)` method which authenticates and initializes a user session. Session initialization part is hidden from user.
  * Side effects create temporal couplings and order dependencies. *Temporal couplings* mean that the function can only be invoked at certain times. In the above example, if it is called out of order the current session data might be destroyed.
* **Double take** - Any line of code within function that forces you to look at the function signature, then it is called "double take".
* **Prefer exceptions to return error codes** - Function should do one thing. Error handling is another thing. Extract try..catch in a separate function.

```java
 if (delete(page) == OK){
       ....
 } else {
       Error out
 }
```

```java
try{
   ...
 } catch (...){
    //Error processing is separated from the happy path
 } 
```
* **Command Query Separation**: Functions should either do something or return something, but not both.
  * http://martinfowler.com/bliki/CommandQuerySeparation.html


## Formatting
* **Vertical Openness** - Each group of lines should represent a thought. e.g., `given`, `when` & `then` blocks in unit testing
* **Vertical density** implies close association of those lines
* **Vertical distance** - concepts that are closely related should be kept close to each other. e.g., 
  * local variable declarations should right before its usage. 
  * Instance variables should be at the top of the file, not bottom.
  * Dependent functions should be closer to each other.

## Object and Data Structures 
* Getters & Setters - Think before adding them. Blindly adding on every variable beats the purpose of abstraction.
* **Law of Demeter** - method chaining on data structure method is ok.