---
layout: page
title: "JavaScript"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# JS Ecosystem Overview

* "JavaScript" is not really a single language. Each browser vendor implements their own JavaScript engine, and due to variations between browsers and versions, JavaScript suffers from some serious fragmentation. ([CanIUse.com](http://caniuse.com) documents some of these inconsistencies).
* **ES6**, also known as ES2015 / Harmony / ECMAScript 6 / ECMAScript 2015, is the most-recent version of the JavaScript specification. ([good primer on ES6](http://blog.teamtreehouse.com/get-started-ecmascript-6)).
* __Transpilers__
  * Tools: `Babel`
  * process of transforming the standardized JavaScript into a version that's compatible with older platforms is called_ transpiling_. e.g., ES6 to ES5
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

* Another name for ES6 is ES2015.

* Good tutorial https://babeljs.io/docs/en/learn
* MDN documentation https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/export


__Arrow Functions__

```js
let createGreeting = function(message, name){
  return message + name;
}

let arrowGreeting = (message,name) => message + name;
```

__let keyword__

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

__Template Literals__

```js
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

__Destructuring Assignments__

```js old style
let obj = {
  name: "john",
  color: "blue"
}
console.log(obj.color); // blue
```

```js
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

__Modules__

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
