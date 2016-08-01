---
layout: page
title: "JavaScript Ecosystem"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

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