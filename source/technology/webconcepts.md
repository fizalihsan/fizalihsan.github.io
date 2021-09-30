---
layout: page
title: "Web Concepts"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# DOM

- DOM is an API. 
- DOM is not the source HTML or the code you write. 
- DOM is not what you see in the browser's DevTools
- DOM tree can have 12 different types of nodes
  - Element
  - Text
  - Attr
  - CDATASection
  - EntityReference
  - Entity
  - Comment
  - ProcessingInstruction
  - Document
  - Notation
  - DocumentFragment
  - DocumentType
- Javascript 
  - can interact with DOM and manipulate the DOM.
  - can change, add, or remove HTML elements and attributes
  - can change CSS styles
  - can create and react to HTML events like clicks or hovers
  - cannot target CSS pseudo-elements
    - if the code uses CSS pseudo-elements, the DOM does NOT include it in its tree because the DOM builds itself from the HTML document, not the styles applied to the elements (including CSS). Hence JS cannot target pseudo-elements because they are not part of the DOM.

```js Example of DOM manipulation
const button = document.querySelector('button');

button.removeAttribute('onclick');
```

## DOM Events

DOM Events Visualizer - [https://domevents.dev](https://domevents.dev)

- Event
  - An event is a signal that something has occurred in the browser. 
  - Types of events
    - *user events*, such as click, and 
    - *system events*, such as DOMContentLoaded. Events are dispatched to event targets.
- Event Target
  - `EventTarget` is an interface that is implemented by a number of foundational objects in the browser, such as `window`, `document`, `element` and `XMLHttpRequest`. 
  - When an object implements the `EventTarget` interface, it allows that object to be the target of events as well as enabling other pieces of code to listen for particular events that hit that object.
  - in the HTML code below, parent div, child and button are few event targets.
- Event Listener 
  - Code that is registered to listen for events that hit an event target is known as an **event listener**. The term **event handler** is a name for a particular *method* of adding an event listener. In practice, it is common to see the term event handler used interchangeably with the term event listener.
  - Event targets can exist as their own objects, and they can also participate in a tree, such as when elements participate in a document.
- Event Phases
  - Generally, events flow through event targets in three separate phases. 
  - (1) *Capture Phase*:  In the first phase, the event travels down through the event targets towards the target of the event. This is known as the **capture phase**.
  - (2) *Target Phase*: When the event hits the event target, it then travels through the target. This is the second phase known as the **target phase**.
  - (3) *Bubble Phase*: After that's completed, then the event goes back up to the root event target in the **bubble phase**. 

| {% img /technology/domevents1.png %} | {% img /technology/domevents2.png %} |
| {% img /technology/domevents3.png %} |  |

```html
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>DOM events</title>
    </head>
    <body>
        <div id="parent">
            <h3>Parent element</h3>
            <div id="child">
                <h3>Child element</h3>
                <button type="button">
                    Call to action
                </button>
            </div>
        </div>
    </body>
</html>
```

## HTML Attribute Event Handlers

- It is possible to write code in HTML attributes that will be executed when a matching event occurs.
- Different element types allow different event handler attributes to be set. e.g., `Window`, `document`, and all HTML elements implement the `GlobalEventHandlers` mixin which provides a common set of HTML event handler attributes like `onClick` and `onLoad`.
- **HTML event handler attributes**
  - are a way to define an `EventListener` in the *bubble phase* of an event. 
  - You CANNOT use these types of `EventListener` bindings to listen to events in the capture phase of an event.
  - This style of event binding is also known as a **DOM-zero event handler** and is referred to as *event handler content attributes* in formal specifications.
  - A HTML event handler attributes string can be any JavaScript function body. That is any code, you would normally be able to put inside of a function. e.g., `<button onclick="console.log('clicked');" type="button"/>`
  - There are some fairly magic values that you can use in your HTML event handler attributes string. For example, 
    - `event` - which represents the ActiveEvent.
    - `this` - `this` runtime context of your function is set to the element that the event handler is bound to, which in our case, is the button element. 

```html Magic values in HTML event handler attributes
<button onclick="console.log(event, this);" type="button"/>
```

- Within HTML event handler attributes, you can execute any function body you like. However, it is common to execute a named function that you have defined somewhere else. 
- In order for this code to work, the function `myOnClick()` must be accessible on the **global scope**. If not found on the global scope, then a `ReferenceError` will be thrown when your attribute string is executed.

```html Calling a named function
<button onclick="myOnClick();" type="button"/>
```

```js app.js 
// a function defined on the global scope
function myOnClick(){
  console.log('Inside myOnClick');
}
```

- **Global functions and minifiers**
  - However, a bug can occur with this approach of creating global functions when you *minify* your code. Code minifiers will commonly mangle function names to ensure the smallest amount of code is sent over the wire to your users. Unfortunately, this can break your attempts to use a named function in the global scope.
  - In this case, `myOnClick()` in the JS file can be mangled to say `a()`, however, the html still calls `myOnClick()`, which no longer exists. Because of the minifier, I've broken the link between my html and my JavaScript file.
  - Modern minifiers commonly won't mangle root level function names. Not mangling root level function names is not a guarantee for every minifier that will ever exist. Also, you might change an option for a minifier that can result in top-level function names being mangled without you realizing.
  - **Safer option** 
    - A safer option for defining functions in the global scope is to add a named property to the global `window` object directly. 
    - Minifiers should not minify object properties. You can sidestep the function name mangling concern by using this approach.
    - Attaching functions to the window directly also lets you write your global functions inside of nested scopes, which is pretty commonplace in module systems.

```js app.js - Safer option
// a function defined on the global window object
window.myOnClick = function myOnClick(){
  console.log('Inside myOnClick');
}

function foo(){
  window.myOnClick2 = function(){
    console.log('Inside myOnClick2');
  } 
}

//calling this method is important without which our custom function won't be set on the window object 
foo();
```

__Gotchas of HTML event handler attributes__

- *Broken links from function name refactoring* - it is easy to accidently break the link between the HTML attribute string and any global functions that it is calling. e.g., when you refactor the function name in `apps.js`, the HTML attribute value is not changed, causing `ReferenceError` at runtime.
- *Forgetting to call the function* - Another gotcha is forgetting to actually execute a global function that you're trying to call. While this code may look right, it's not actually executing the `myOnClick` function. e.g., `<button onclick="myOnClick" type="button"/>`
- *Only a single event handler allowed* - you can only add a single event handler attribute of a particular event type. We can only have one `onClick` handler to listen for click events, which sucks at scale.

