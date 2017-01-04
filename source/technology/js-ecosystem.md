---
layout: page
title: "JavaScript Ecosystem"
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

# AngularJS

* Angular compiles takes a 'template', loads, compiles, tranforms and renders to DOM called 'view'.
* **Templates**
  * Templates once received from server are cacheable. Only the data changes from then on.
* 2 types of markups
  * Directives - apply special behavior to attributes or elements in the HTML.
  * Double curly braces - `{{ expression | filter }}` - An "expression" in a template is a JavaScript-like code snippet that allows to read and write variables.A filter formats the value of an expression for display to the user.
* **2-way data binding** - Angular provides live bindings or "two-way data binding": Whenever the input values change, the value of the expressions are automatically recalculated and the DOM is updated with their values.
* **Controllers** - The purpose of controllers is to expose variables and functionality to expressions and directives.
* **Services** - The purpose of services is to expose view-independent business logic.
* **Factory**
    ...
* **Modules** - is where all the things need for Angular DI (Dependency Injection) is registered. When Angular starts, it will use the configuration of the module with the name defined by the ng-app directive, including the configuration of all modules that this module depends on.
* **Common Directives**
  * `ng-app` - automatically initializes an application
  * `ng-bind` is same as `{{}}`
  * `ng-model` - stores/updates the value of the input field into/from a variable.
  * `ng-controller` - tells angular that an instance of a Controller is responsible for the element with the directive and all of the element's children.
  * `ng-repeat`
  * `ng-submit` - to group inputs in a form
  * `ng-click`
  * `ng-dblclick`
  * `ng-show`/`ng-hide`

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

# References

* Websites
  * [State of JavaScript 2016](https://www.infoq.com/articles/state-of-javascript-2016?utm_source=twitter&utm_medium=link&utm_campaign=calendar)
