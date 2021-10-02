---
layout: page
title: "JavaScript"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Overview

* "JavaScript" is not really a single language. Each browser vendor implements their own JavaScript engine, and due to variations between browsers and versions, JavaScript suffers from some serious fragmentation. ([CanIUse.com](http://caniuse.com) documents some of these inconsistencies).
* **ES6**, also known as ES2015 / Harmony / ECMAScript 6 / ECMAScript 2015, is the most-recent version of the JavaScript specification. ([good primer on ES6](http://blog.teamtreehouse.com/get-started-ecmascript-6)).
* __Transpilers__
  * Tools like `Babel`
  * process of transforming the standardized JavaScript into a version that's compatible with older platforms is called _transpiling_. e.g., ES6 to ES5
  * It's not much different from compiling. By using a transpiler, you don't need to worry as much about the headaches of whether or not a given browser will support the JavaScript feature you're using.
  * Transpiler tools don't just convert ES6 JavaScript to ES5. There are also tools to do the same thing for JavaScript-variants (such as ClojureScript, TypeScript, and CoffeeScript) to regular JavaScript.
    * ClojureScript is a version of Clojure that compiles down to JavaScript.
    * TypeScript is essentially JavaScript, but with a type system.
    * CoffeeScript is very similar to JavaScript, but with shinier syntax; much of the syntactic sugar promoted by CoffeeScript has been adopted by ES6 now.
* __Build Tools__
  * Tools: `grunt`, `gulp`, `bower`, `browserify`, `webpack`
  * Basically compiling the code into a production-ready format.
  * Requiring each JavaScript dependency as part of a page, script tag by script tag, is slow. Therefore, most sites use so-called JavaScript _bundles_. The bundling process takes all of the dependencies and "bundles" them together into a single file for inclusion on your page.
* __Test Tools__
  * Tools: `Mocha`, `Jasmine`, `Chai`, `Tape`, `Karma`, `PhantomJS`
  * Karma is a test runner that can run both Jasmine and Mocha-style tests.
  * PhantomJS is a _headless browser_ - it runs without GUI.

# Node.js

* Node.js is a tool for writing server-side JavaScript.
* ___npm___ Node package manager. JavaScript modules are usually packaged and shared via npm.
* ___nvm___ Node version manager. Facilitates managing different version of Node.js.

__Runtime Environment__

* Node.js is not a language; not a framework; not a tool. It is a runtime environment for running JS-based applications like JRE for Java.
* _JavaScript Virtual Machine (JsVM)_
  * Node.js has a virtual machine called _JavaScript Virtual Machine (JsVM)_ which generates machine code for JS-based applications to enable it on different platforms.
  * We have separate Node.js requirements for different platforms like Windows, Macintosh, and Linux and hence the JsVM.
  * V8 is an open source JavaScript engine from Google. (Nashorn is the Java-based JS engine in JVM). Like the JVM, the JsVM (V8 engine) also has main components like JIT and GC for performing tasks, runtime compilation, and memory management respectively.
* Node.js also has a set of libraries which may otherwise be known as _Node API_ or _Node Modules_ to help run JS applications at runtime, similar to Java Libraries within the JRE.

* How the JavaScript program is compiled and executed.
  * The source code is written in JavaScript (.js). There is no intermediate code generated before giving it to JsVM, the V8 engine.
  * The JsVM takes this source code directly and compiles it to machine code specific to the given target platform for execution.


__Web Application Architecture__

* The client requests are handled by a single thread, but asynchronously. With Java, each client request is handled by a separate thread synchronously.
* There are many frameworks/libraries available for Node.js-based web application development. E.g., Express.js, Angular.js, Mongoose.js, etc.
  * Client layer: Angular.js, a client-side MVC framework.
  * Presentation + Service layer: can be developed by using Express.js. This also comes with a standalone server for running Node.js applications.
  * Data layer: uses an Object Data Modelling module (e.g. Mongoose.js) for communicating with NoSQL databases like MongoDB.  
  * This particular stack is called _MEAN stack_ , which consists of MongoDB, Express.js, Angular.js, and Node.js (the runtime environment)

# ES6 Basics

- Another name for ES6 is ES2015.
- Since ES6, the ECMAScript specification has moved to a yearly release cadence, and versions of the language—ES2016, ES2017, ES2018, ES2019, and ES2020—are now identified by year of release.

- The core JavaScript language defines a minimal API for working with numbers, text, arrays, sets, maps, and so on, but does not include any input or output functionality. Input and output (as well as more sophisticated features, such as networking, storage, and graphics) are the responsibility of the _“host environment”_ within which JavaScript is embedded.
- The original host environment for JavaScript was a web browser. The web browser environment allows JavaScript code to obtain input from the user’s mouse and keyboard and by making HTTP requests. And it allows JavaScript code to display output to the user with HTML and CSS.
- Instead of constraining JavaScript to work with the APIs provided by a web browser, Node gives JavaScript access to the entire operating system, allowing JavaScript programs to read and write files, send and receive data over the network, and make and serve HTTP requests. Node is a popular choice for implementing web servers and also a convenient tool for writing simple utility scripts as an alternative to shell scripts

* Good tutorial https://babeljs.io/docs/en/learn
* MDN documentation https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/export

## Types, Values, Variables

- JavaScript types can be divided into two categories: _primitive types_ and _object types_.
- Primitive Types
  - JavaScript’s primitive types include numbers, strings, and booleans
  - The special JavaScript values `null` and `undefined` are primitive values, but they are not numbers, strings, or booleans.
  - Primitives are immutable

__Object Types__

- __Object__: Any JavaScript value that is not a number, a string, a boolean, a symbol, null, or undefined is an __object__. An object (that is, a member of the type object) is a collection of properties where each property has a name and a value (either a primitive value or another object). One very special object is the __global object__.
  - Objects are sometimes called _reference types_ to distinguish them from JavaScript’s primitive types
- __Array__: The language also defines a special kind of object, known as an __array__, that represents an ordered collection of numbered values.
  - Object types are mutable.
- __Variables__
  - Constants are declared with `const` and variables are declared with `let` (or with `var` in older JavaScript code).

__Numbers__

- Arithmetic in JavaScript does not raise errors in cases of overflow, underflow, or division by zero. When the result of a numeric operation is larger than the largest representable number (overflow), the result is a special infinity value, `Infinity`. Similarly, when the absolute value of a negative value becomes larger than the absolute value of the largest representable negative number, the result is negative infinity, `-Infinity`.
- Underflow occurs when the result of a numeric operation is closer to zero than the smallest representable number. In this case, JavaScript returns 0. If underflow occurs from a negative number, JavaScript returns a special value known as _“negative zero.”_
- Division by zero is not an error in JavaScript: it simply returns infinity or negative infinity. There is one exception, however: zero divided by zero does not have a well-defined value, and the result of this operation is the special not-a-number value, NaN. NaN also arises if you attempt to divide infinity by infinity, take the square root of a negative number, or use arithmetic operators with non-numeric operands that cannot be converted to numbers.
- BigInt literals are written as a string of digits followed by a lowercase letter `n`. e.g., `1234n`

__Text__

- JavaScript uses the UTF-16 encoding of the Unicode character set, and JavaScript strings are sequences of unsigned 16-bit values.
- String literals - enclosed within a matched pair of single or double quotes or backticks (' or " or `
- As of ES5, however, you can break a string literal across multiple lines by ending each line but the last with a backslash (\)
- standard `===` equality and `!==` inequality operators
- The ES6 backtick syntax allows strings to be broken across multiple lines, and in this case, the line terminators are part of the string literal.

```js
// A string representing 2 lines written on one line:
'two\nlines'

// A one-line string written on 3 lines:
"one\
 long\
 line"

// A two-line string written on two lines:
`the newline character at the end of this line
is included literally in this string`
```

__Template Literals__

Template literals are string literals with JavaScript expressions in it.

```js Template literals
let name = "Hans"
let message = `Hello ${name}. It's ${new Date().getHours()} I'm sleepy`;

console.log(message); // "Hello Hans. It's 15 I'm sleepy"
```

```js Passing template literal to a function
function foo(strings, ...values){
  console.log(strings); // [ 'Hello ', ". It's ", " I'm sleepy" ]
  console.log(values);  // [ 'Hans', 20 ]
}

let name = "Hans"
let message = foo`Hello ${name}. It's ${new Date().getHours()} I'm sleepy`;
```


__Symbols__

- Property names are typically (and until ES6, were exclusively) strings. But in ES6 and later, Symbols can also serve this purpose.
- To obtain a Symbol value, you call the `Symbol()` function. This function never returns the same value twice, even when called with the same argument. This means that if you call `Symbol()` to obtain a Symbol value, you can safely use that value as a property name to add a new property to an object and do not need to worry that you might be overwriting an existing property with the same name. Similarly, if you use symbolic property names and do not share those symbols, you can be confident that other modules of code in your program will not accidentally overwrite your properties.

```js Symbol
let strname = "string name";      // A string to use as a property name
let symname = Symbol("propname"); // A Symbol to use as a property name
typeof strname                    // => "string": strname is a string
typeof symname                    // => "symbol": symname is a symbol
let o = {};                       // Create a new object
o[strname] = 1;                   // Define a property with a string name
o[symname] = 2;                   // Define a property with a Symbol name
o[strname]                        // => 1: access the string-named property
o[symname]                        // => 2: access the symbol-named property
```

- The `Symbol()` function takes an optional string argument and returns a unique Symbol value. If you supply a string argument, that string will be included in the output of the Symbol’s `toString()` method. Note, however, that calling `Symbol()` twice with the same string produces two completely different Symbol values.
  - when using Symbols, you want to keep them private to your own code so you have a guarantee that your properties will never conflict with properties used by other code.

```js Symbol toString
let s = Symbol("sym_x");
s.toString()             // => "Symbol(sym_x)"
```

- The `Symbol.for()` function takes a string argument and returns a Symbol value that is associated with the string you pass. If no Symbol is already associated with that string, then a new one is created and returned; otherwise, the already existing Symbol is returned. That is, the `Symbol.for()` function is completely different than the Symbol() function: `Symbol()` never returns the same value twice, but `Symbol.for()` always returns the same value when called with the same string.

```js Symbol.for()
let s = Symbol.for("shared");
let t = Symbol.for("shared");
s === t          // => true
s.toString()     // => "Symbol(shared)"
Symbol.keyFor(t) // => "shared"
```

__Global Object__

- The global object is a regular JavaScript object that serves a very important purpose: the properties of this object are the globally defined identifiers that are available to a JavaScript program. 
- When the JavaScript interpreter starts (or whenever a web browser loads a new page), it creates a new `global` object and gives it an initial set of properties that define:
  - Global constants like `undefined`, `Infinity`, and `NaN`
  - Global functions like `isNaN()`, `parseInt()`, and `eval()`
  - Constructor functions like `Date()`, `RegExp()`, `String()`, `Object()`, and `Array()`
  - Global objects like `Math` and `JSON`
- In Node, the global object has a property named global whose value is the global object itself, so you can always refer to the global object by the name global in Node programs.
- In web browsers, the Window object serves as the global object for all JavaScript code contained in the browser window it represents. This global Window object has a self-referential window property that can be used to refer to the global object. The Window object defines the core global properties, but it also defines quite a few other globals that are specific to web browsers and client-side JavaScript. Web worker threads have a different global object than the Window with which they are associated. Code in a worker can refer to its global object as self.
- ES2020 finally defines globalThis as the standard way to refer to the global object in any context. As of early 2020, this feature has been implemented by all modern browsers and by Node.
- Global object can be referenced as `globalThis`.

__Scope__

- Variables and constants declared with let and const are _block scoped_.
- When a declaration appears at the top level, outside of any code blocks, we say it is a _global_ variable. 
  - In Node and in client-side JavaScript modules, the scope of a _global_ variable is the file that it is defined in. 
  - In traditional client-side JavaScript, however, the scope of a _global_ variable is the HTML document in which it is defined. That is: if one `<script>` declares a _global_ variable or constant, that variable or constant is defined in all of the `<script>` elements in that document (or at least all of the scripts that execute after the `let` or `const` statement executes).
- __Hoisting__ 
  - One of the most unusual features of `var` declarations is known as hoisting. When a variable is declared with `var`, the declaration is lifted up (or __“hoisted”__) to the top of the enclosing function. The initialization of the variable remains where you wrote it, but the definition of the variable moves to the top of the function. So variables declared with var can be used, without error, anywhere in the enclosing function. If the initialization code has not run yet, then the value of the variable may be undefined, but you won’t get an error if you use the variable before it is initialized. (This can be a source of bugs and is one of the important misfeatures that `let` corrects: if you declare a variable with `let` but attempt to use it before the `let` statement runs, you will get an actual error instead of just seeing an `undefined` value.)

```js using var
var message = "hi";
{
  var message = "bye";
}

console.log(message); // prints bye
```

```js using let
let message = "hi";
{
  let message = "bye";
}

console.log(message); // prints hi
```


__Destructuring assignment__

ES6 implements a kind of compound declaration and assignment syntax known as _destructuring assignment_.

```js Destructuring assignment
let [x,y] = [1,2];              // Same as let x=1, y=2
let [x,y] = [1];                // x == 1; y == undefined
let [x, ...y] = [1,2,3,4];      // y == [2,3,4]
let [first, ...rest] = "Hello"; // first == "H"; rest == ["e","l","l","o"]

// in function return statement
function toPolar(x, y) {
    return [Math.sqrt(x*x+y*y), Math.atan2(y,x)];
}

// In for loop
let o = { x: 1, y: 2 }; // The object we'll loop over
for(const [name, value] of Object.entries(o)) {
    console.log(name, value); // Prints "x 1" and "y 2"
}

// Same as const sin=Math.sin, cos=Math.cos, tan=Math.tan
const {sin, cos, tan} = Math;

// Same as const cosine = Math.cos, tangent = Math.tan;
const { cos: cosine, tan: tangent } = Math;

```

```js old style
let obj = {
  name: "john",
  color: "blue"
}
console.log(obj.color); // blue
```

```js New style
let obj = {
  name: "john",
  color: "blue"
}
let {color} = obj
console.log(color); // blue
```

```js Multiple properties
let {color, position} = {
  color: "blue",
  name: "John",
  state: "New York",
  position: "Forward"
}

console.log(color);
console.log(position);
```

```js Give a new variable name
function generateObj() {
  return {
    color: "blue",
    name: "John",
    state: "New York",
    position: "Forward"
  }
}

let {name:firstname, state:location} = generateObj();

console.log(firstname); // John
console.log(location); // New York
``` 

```js Destructuring array items
let [first,,,,fifth] = ["red", "yellow", "green", "blue", "orange"]

console.log(first); // red
console.log(fifth); // orange
```

```js Print first names only
let people = [
  {
    "firstName": "Skyler",
    "lastName": "Carroll",
    "phone": "1-429-754-5027",
    "email": "Cras.vehicula.alique@diamProin.ca",
    "address": "P.O. Box 171, 1135 Feugiat St."
  },
  {
    "firstName": "Kylynn",
    "lastName": "Madden",
    "phone": "1-637-627-2810",
    "email": "mollis.Duis@ante.co.uk",
    "address": "993-6353 Aliquet, Street"
  },
]

people.forEach(({firstName})= > console.log(firstName))
// Skyler
// Kylynn
```

```js Destructuring in function parameters
let people = [
  {
    "firstName": "Skyler",
    "lastName": "Carroll",
    "phone": "1-429-754-5027",
    "email": "Cras.vehicula.alique@diamProin.ca",
    "address": "P.O. Box 171, 1135 Feugiat St."
  },
  {
    "firstName": "Kylynn",
    "lastName": "Madden",
    "phone": "1-637-627-2810",
    "email": "mollis.Duis@ante.co.uk",
    "address": "993-6353 Aliquet, Street"
  },
]

let [,secondperson] = people;

function logEmail({email}){
  console.log(email);
}

logEmail(secondperson) // mollis.Duis@ante.co.uk
```


## Expressions and Operators

__Conditional Expressions__

- `expression ?. identifier`
- `expression ?.[ expression ]`
- In JavaScript, the values `null` and `undefined` are the only two values that do not have properties. In a regular property access expression using `.` or `[],` you get a `TypeError` if the expression on the left evaluates to `null` or `undefined`. You can use `?.` and `?.[]` syntax to guard against errors of this type.
- This form of property access expression is sometimes called __“optional chaining”__ because it also works for longer “chained” property access expressions like this one:

```js Conditional Expressions
let a = { b: null };
a.b?.c.d   // => undefined
```

__Conditional Invocation__

- In ES2020, you can also invoke a function using `?.()` instead of `()`. Normally when you invoke a function, if the expression to the left of the parentheses is `null` or `undefined` or any other non-function, a `TypeError` is thrown. With the new `?.()` invocation syntax, if the expression to the left of the ?. evaluates to `null` or `undefined`, then the entire invocation expression evaluates to `undefined` and no exception is thrown.
- Note, however, that `?.()` only checks whether the lefthand side is `null` or `undefined`. It does not verify that the value is actually a function.

```js Conditional Invocation
function square(x, log) { // The second argument is an optional function
    log?.(x);             // Call the function if there is one
    return x * x;         // Return the square of the argument
}
```

__Object Creation Expression__

```js Object Creation Expression
new Object()
new Point(2,3)

// If no arguments are passed to the constructor function in an object creation expression, the empty pair of parentheses can be omitted:

new Object
new Date

```

__eval()__

- `eval()` expects one argument. If you pass any value other than a string, it simply returns that value. 
- If you pass a string, it attempts to parse the string as JavaScript code, throwing a `SyntaxError` if it fails. 
- If it successfully parses the string, then it evaluates the code and returns the value of the last expression or statement in the string or undefined if the last expression or statement had no value. If the evaluated string throws an exception, that exception propogates from the call to `eval()`.
- The key thing about `eval()` (when invoked like this) is that it uses the variable environment of the code that calls it. That is, it looks up the values of variables and defines new variables and functions in the same way that local code does. If a function defines a local variable `x` and then calls `eval("x")`, it will obtain the value of the local variable. If it calls `eval("x=1")`, it changes the value of the local variable.

__First-Defined (??) operator__

The first-defined operator `??` evaluates to its first defined operand: if its left operand is not null and not undefined, it returns that value. Otherwise, it returns the value of the right operand.

```js First-defined operator
a??b

//is equivalent to
(a !== null && a !== undefined) ? a : b
```

## Statements

__for/of__

The for/of loop works with iterable objects

```js for/of
let data = [1, 2, 3, 4, 5, 6, 7, 8, 9], sum = 0;
for(let element of data) {
    sum += element;
}
console.log(sum);       // => 45
```

__for/in__

- A for/in loop looks a lot like a for/of loop, with the `of` keyword changed to `in`. While a for/of loop requires an __iterable object__ after the `of`, a for/in loop works with __any object__ after the in. 
- The for/of loop is new in ES6, but for/in has been part of JavaScript since the very beginning (which is why it has the more natural sounding syntax). Attempting to use for/of on a regular object throws a `TypeError` at runtime.
- The for/in loop does not actually enumerate all properties of an object. It does not enumerate properties whose names are symbols. And of the properties whose names are strings, it only loops over the enumerable properties.


__try-catch__

Occasionally you may find yourself using a catch clause solely to detect and stop the propagation of an exception, even though you do not care about the type or the value of the exception. In ES2019 and later, you can omit the parentheses and the identifier and use the catch keyword bare in this case. Here is an example:

```js try-catch
// Like JSON.parse(), but return undefined instead of throwing an error
function parseJSON(s) {
    try {
        return JSON.parse(s);
    } catch {
        // Something went wrong but we don't care what it was
        return undefined;
    }
}
```

__function__

- The `function` declarations in any block of JavaScript code are processed before that code runs, and the function names are bound to the function objects throughout the block. We say that function declarations are __“hoisted”__ because it is as if they had all been moved up to the top of whatever scope they are defined within. The upshot is that code that invokes a function can exist in your program before the code that declares the function.
- Unlike functions, `class` declarations are not hoisted, and you cannot use a class declared this way in code that appears before the declaration.


__import and export__

- The `import` and `export` declarations are used together to make values defined in one module of JavaScript code available in another module. 
- A module is a file of JavaScript code with its own global namespace, completely independent of all other modules. The only way that a value (such as `function` or `class`) defined in one module can be used in another module is if the defining module exports it with export and the using module imports it with import. 
- The export directive has more variants than the import directive does. Here is one of them:

```js geometry/constants.js
const PI = Math.PI;
const TAU = 2 * PI;
export { PI, TAU };
```

The `export` keyword is sometimes used as a modifier on other declarations, resulting in a kind of compound declaration that defines a constant, variable, function, or class and exports it at the same time. And when a module exports only a single value, this is typically done with the special form export default:

```js export
export const TAU = 2 * Math.PI;
export function magnitude(x,y) { return Math.sqrt(x*x + y*y); }
export default class Circle { /* class definition omitted here */ }
```

A function is declared and exported from a file named `math/addition.js`.

```js math/addition.js
function sumTwo(a,b){
  return a + b;
}

export { sumTwo }
```

To use the above function in a different file,

```js import the module
import { sumTwo } from `math/addition`;

console.log(
  "2 + 3 + 4 = ",
  sumThree(2, 3, 4)
); // 2 + 3 + 4 = 9
```

We can also directly export on the function definition.

```js math/addition.js - Using export directly on the function definition
export function sumTwo(a,b){
  return a + b;
}

export function sumTwo(a,b,c){
  return a + b + c;
}
```

```js import a function using an alias
import {
  sumTwo as addTwoNumbers,
  sumThree
} from 'math/addition';
```

We can also import all the functions from the module using `*`. 

```js Import all
import * as addition from 'math/addition';

console.log(
  "1 + 3",
  addition.sumTwo(1, 3) // 4
);

console.log(
  "1 + 3 + 4",
  addition.sumTwo(1, 3, 4) // 8
);
```

3rd party modules can be imported in the same fashion. Say, `npm install --save lodash`

```js main.js Import lodash
import * as _ from 'lodash';
```

__Arrow Functions__

Arrow functions are most commonly used when you want to pass an unnamed function as an argument to another function.

```js
let createGreeting = function(message, name){
  return message + name;
}

let arrowGreeting = (message,name) => message + name;
```

__Default values in function parameters__

```js example of default value in parameter
function greet(greeting, name = "John"){
  console.log(greeting + ", " + name);
}

greet("Hello");// prints Hello John
```

```js example of a function as a default value
function receive(complete = () => console.log("complete")){
  complete();
}
```

or even better

```js
let receive = (complete = () => console.log("complete")) => complete();
```

__Shorthand properties__

```js
let firstName = "John";
let lastName = "Lindquist";

let person = {firstName, lastName}

console.log(person); //prints { firstName: 'John', lastName: 'Lindquist' }
```

```js nested example
let firstName = "John";
let lastName = "Lindquist";

let person = {firstName, lastName}

let mascot = "Moose";
let team = {person, mascot};

console.log(team); //prints {  person: { firstName: 'John', lastName: 'Lindquist' },   mascot: 'Moose' }
```


```js Object enhancements
let color = "red";
let speed = 10;

let car = {color, speed};

console.log(car.color); // "red"
console.log(car.speed); // 10
```

```js
let car = {
  color,
  speed,
  go(){
    console.log("vroom");
  }
};

console.log(car.color); // "red"
console.log(car.speed); // 10
console.log(car.go()); // "vroom"
```

__Spread operator__

The spread operator allows you to "explode" an array into its individual elements.

```js
console.log([ 1, 2, 3]); // [1, 2, 3]
console.log(...[ 1, 2, 3]) // 1 2 3
```

```js add without spread operator
let first = [ 1, 2, 3];
let second = [ 1, 2, 3];

first.push(second);

console.log(first); // [ 1, 2, 3, [ 4, 5, 6] ]
```

```js add with spread operator
first.push(...second);

console.log(first); // [1, 2, 3, 4, 5, 6]
```

```js spread as input parameters
function addThreeThings( a, b, c){
  let result = a + b + c;
  console.log(result); // 6
}

addThreeThings(...first);
```




__Promises__

- Promises in ES6 are very similar to those of Angular's **$q service**.
- The callback inside of a promise takes two arguments, `resolve` and `reject`.
- Promises can either be resolved or rejected. When you resolve a promise, the `.then()` will fire, and when you reject a promise, the `.catch()` will fire instead. Usually, inside of your promise, you have some sort of logic that decides whether you're going to reject or resolve the promise.
- The `.then()` method callback also takes an argument. This one we'll call `data`. The value for `data` is the argument that is passed into the `resolve` method. 
- Alternatively, in the `.catch()` method, we also have a callback function as the argument, but here, what will be passed back is the information that's supplied into the `reject` method of our promise. 

```js Promise example
let d = new Promise((resolve, reject) => {
  if (true) {
    resolve('hello world');
  } else {
    reject('no bueno');
  }
});

d.then((data) => console.log('success : ', data));

d.catch((error) => console.error('error : ', error));
```

- Promises are useful for a lot of things. Most importantly, they allow you to perform **asynchronous operations** in a **synchronous-like manner**
- For example, let's add a 2 seconds timeout in the above code


```js Promise with delay
let d = new Promise((resolve, reject) => {
  setTimeout(() => {
    if (true) {
      resolve('hello world');
    } else {
      reject('no bueno');
    }
  }, 2000);
});
```

There is a variation of `.then()` method which takes error function as a 2nd parameter. But from readability perspective, it is better to keep them separate.

```js
d.then ((data) => console.log('success : ', data), (error) => {
  console.error('new error msg: ', error);
});
```

Several `.then` methods can be chained together and have them called in succession. In this case, once the `resolve` is called, both _.thens_ will fire one after another.

```js chained then methods
d.then((data) => console.log('success : ', data))
  .then((data) => console.log('success 2 : ', data)) //prints "success 2 : undefined"
  .catch((error) => console.error('error : ', error));
```

As you notice, the 2nd `then` input parameter `data` is `undefined`. This is because the `data` that's available in the callback of the second `then` is not what is originally passed into the `resolve` but rather what is returned from the 1st `.then` method.

```js chained then version 2
d.then((data) => {
    console.log('success : ', data);
    return 'foo bar';
  })
  .then((data) => console.log('success 2 : ', data)) //prints "success 2 : foo bar"
  .catch((error) => console.error('error : ', error));
```

# References

* Websites
  * [State of JavaScript 2016](https://www.infoq.com/articles/state-of-javascript-2016?utm_source=twitter&utm_medium=link&utm_campaign=calendar)
