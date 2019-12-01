---
layout: page
title: "Angular"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}


* [Angular Docs](https://angular.io/docs)

## Concepts

* Binding
    * Interpolation
    * Data binding
        * `<div class="name">Hello {{name}}</div>`
    * Property binding
        * `<div class="price" [class]="positiveChange ? 'plus' : 'minus'">$ {{price}}</div>`
        * Tells Angular to bind to the __class__ property of the DOM element to the value of the expression. 
        * Square-bracket notation refers to data flowing from the component to the UI.
        * When you bind to the class property, it overrides the existing value of the property. In the example above, `class="price"` has no effect. 
        * Angular data binding only works with DOM properties, and not with HTML attributes. (see section below)
    * Event binding
        * `<button (click)="toggleFavorite()" [disabled]="favorite">Add to Favorite</button>`
        * The parentheses notation refers to events.
        * Angular gives you access to the underlying DOM event by giving access to a special variable `$event`. You can access it or even pass it to your function as follows: `<button (click)="toggleFavorite($event)" [disabled]="favorite">Add to Favorite</button>`
* Directives


_HTML attribute vs. DOM property: What's the difference?_

* In Angular, one-way binding binds to the DOM property, and not to the HTML attributes. 
* Attributes are defined by HTML, while properties are defined by the DOM. Though some attributes (like `ID` and `class`) directly map to DOM properties, others may exist on one side but not the other.
* The distinction between the two is that HTML attributes are generally used for initialization of a DOM element, but after that, they have no purpose or effect on the underlying element. Once the element is initialized, its behavior is controlled by the DOM properties from then on.
* For example, consider the input HTML element. If we bootstrap our HTML with something like: `<input type="text" value="foo"/>` this initializes an input DOM element, with the initial value of the DOM property value to be set to foo. Now let’s assume we type something in the text box, say bar. At this point:
    * If we do input.getAttribute('value'), it would return foo, which was the attribute value we used to initialize the HTML.
    * If we do input.value, we will get the current value of the DOM property, which is bar.
* That is, the attribute value is used to boostrap and set the initial value of the HTML DOM element, but after that, it is the DOM property that drives the behavior. If you inspect the HTML, you will see that it is still the initial HTML we provided, and does not update either.


# Project Structure

## Files

* `main.js` - transpiled code that is specific to your application
* `vendor.js` - includes all the third-party libraries and frameworks you depend on (including Angular)
* `styles.js` - compilation of all the CSS styles that are needed for your application
* `polyfills.js` - includes all the polyfills needed for supporting some capabilities in older browsers (like advanced ECMAScript features not yet available in all browsers)
* `runtime.js` - includes webpack utilities and loaders that is needed for bootstrapping the application.

## Structure

```
.
├── angular.json                     <-- Angular CLI config
├── browserslist                     <-- 
├── e2e                              <-- End-to-end test root directory
│   ├── protractor.conf.js           <-- 
│   ├── src
│   │   ├── app.e2e-spec.ts          <-- 
│   │   └── app.po.ts                <-- 
│   └── tsconfig.json                <-- 
├── karma.conf.js                    <-- 
├── package-lock.json                <-- NPM dependencies lock file
├── package.json                     <-- NPM dependencies
├── src
│   ├── app                          <-- A component directory
│   │   ├── app.component.css        <-- 
│   │   ├── app.component.html       <-- 
│   │   ├── app.component.spec.ts    <-- 
│   │   ├── app.component.ts         <-- Root component
│   │   └── app.module.ts            <-- Main module. Application specific code starts from here
│   ├── assets 
│   ├── environments                 <-- 
│   │   ├── environment.prod.ts
│   │   └── environment.ts
│   ├── favicon.ico
│   ├── index.html                   <-- Root HTML
│   ├── main.ts                      <-- Entrypoint: identifies which Angular module to be loaded when the app starts. Main objective of this file is to point the Angular framework at the core module of your application.
│   ├── polyfills.ts                 <-- 
│   ├── styles.css                   <-- 
│   └── test.ts                      <-- 
├── tsconfig.app.json                <-- 
├── tsconfig.json                    <-- 
├── tsconfig.spec.json               <-- 
└── tslint.json                      <-- 
```

{% img /technology/angular_file_deps.svg File Dependencies! %}

__Root Component__

A component in Angular is nothing but a TypeScript class, decorated with some attributes and metadata. The class encapsulates all the data and functionality of the component, while the decorator specifies how it translates into the HTML.

* There are 2 responsibilities of a component:
    * Load and hold all the data necessary for rendering the component
    * Handle and process any events that may arise from any element in the component

```ts
import { Component } from '@angular/core';

@Component({
  selector: 'app-root', // DOM selector that gets translated into an instance of this component
  templateUrl: './app.component.html', // The HTML template backing this component - in this case, the URL to it
  styleUrls: ['./app.component.css'] // Any component-specific styling
})

export class AppComponent { // The component class with its own members and functions
  title = 'stock-market';
}
```


__Tools__

* build - webpack, npm, ?
* testing - karma, jasmine, protractor, ??
* debug - augury
* stylesheets - css, scss, sass, stylus
* state management - ???

## Questions

* diff b/w unit test and e2e test?
* Typescript - decorators


# References 

* Books
    * O'Reilly - Angular Up and Running - Shyam Seshadri - 2018