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

# Concepts

## Binding
    
* Data binding
    * `<div class="name">Hello \\{{name}}</div>`. This is called _Interpolation_.
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

_HTML attribute vs. DOM property: What's the difference?_

* In Angular, one-way binding binds to the DOM property, and not to the HTML attributes. 
* Attributes are defined by HTML, while properties are defined by the DOM. Though some attributes (like `ID` and `class`) directly map to DOM properties, others may exist on one side but not the other.
* The distinction between the two is that HTML attributes are generally used for initialization of a DOM element, but after that, they have no purpose or effect on the underlying element. Once the element is initialized, its behavior is controlled by the DOM properties from then on.
* For example, consider the input HTML element. If we bootstrap our HTML with something like: `<input type="text" value="foo"/>` this initializes an input DOM element, with the initial value of the DOM property value to be set to foo. Now let’s assume we type something in the text box, say bar. At this point:
    * If we do input.getAttribute('value'), it would return foo, which was the attribute value we used to initialize the HTML.
    * If we do input.value, we will get the current value of the DOM property, which is bar.
* That is, the attribute value is used to boostrap and set the initial value of the HTML DOM element, but after that, it is the DOM property that drives the behavior. If you inspect the HTML, you will see that it is still the initial HTML we provided, and does not update either.


## Components

A component in Angular is nothing but a TypeScript class, decorated with some attributes and metadata. The class encapsulates all the data and functionality of the component, while the decorator specifies how it translates into the HTML.

To some extent, you can consider an Angular application to be nothing but a tree of components

* At its very simplest, a component is nothing but 
    * a _class_ that encapsulates behavior (what data to load, what data to render, and how to respond to user interactions) 
    * and a _template_ (how the data is rendered). 
* 2 responsibilities of a component:
    * Load and hold all the data necessary for rendering the component
    * Handle and process any events that may arise from any element in the component
* A component is defined using the Typescript annotation `@Component`
* Any component needs the below 2 attributes - others are optional
    * a _selector_ (to tell Angular how to find instances of the component being used) 
    * and a _template_ (that Angular has to render when it finds the element). 

_app.component.ts (Root Component)_

```
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

In the example below, we have defined that the `StockItemComponent` is to be rendered whenever Angular encounters the `app-stock-item` selector, and to render the `stock-item.component.html` file when it encounters the element.

_stock-item.component.ts_

```
@Component({
  selector: 'app-stock-item',
  templateUrl: './stock-item.component.html',
  styleUrls: ['./stock-item.component.css']
})
export class StockItemComponent implements OnInit {
   // Code omitted here for clarity
}
```

* Every component has to be part of a module. If you create a new component, and do not add it to a module, Angular will complain that you have components that are not part of any modules.

_app.module.ts_

```
import { AppComponent } from './app.component';
import { StockItemComponent } from './component/stock-item/stock-item.component';

@NgModule({
  declarations: [ // ensures that components and directives are available to use within the scope of the module.
    AppComponent,
    StockItemComponent
  ],
  imports: [ // specify modules that you want imported and accessible within your module. 
    BrowserModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
```

### Component Attributes

* Selector
    * Few way you could specify the _selector_ attribute and how you would use it in the HTML:
        * `selector: 'app-stock-item'` would result in the component being used as `<app-stock-item></app-stock-item>` in the HTML.
        * `selector: '.app-stock-item'` would result in the component being used as a CSS class like `<div class="app-stock-item"></div>` in the HTML.
        * `selector: '[app-stock-item]'` would result in the component being used as an attribute on an existing element like `<div app-stock-item></div>` in the HTML.
* Template
    * `templateUrl` is relative to the path of the component. Using absolute urls will break the build.
    * Angular precompiles a build and ensures that the template is inlined as part of the build process.
* Style
    * A component can have multiple styles attached to it.
    * One thing that Angular promotes out of the box is complete encapsulation and isolation of styles. That means by default, the styles you define and use in one component will not affect/impact any other parent or child component. This ensures that you can be confident that the CSS classes you define in any component will not unknowingly affect anything else, unless you explicitly pull in the necessary styles.
    * Angular will not pull in these styles at runtime, but rather precompile and create a bundle with the necessary styles.

### Component Input & Output

* A component is truly useful when it is reusable. One of the ways we can make a component reusable (rather than having default, hardcoded values inside it) is by passing in different inputs depending on the use case. Similarly, there might be cases where we want hooks from a component when a certain activity happens within its context.
* Input
    * `@Input` decorator on a member variable automatically allows you to pass in values to the component for that particular input via Angular’s data binding syntax. 
    * These inputs are data bound, so if you end up changing the value of the object in AppComponent, it will automatically be reflected in the child StockItemComponent.
* Output
    * `@Output` decorator allows to register and listen to events emitted by a component.
    * We just added an event binding using Angular’s event-binding syntax to the output declared in the stock-item component.
* Both `@Input` and `@Output` are class member variable level decorators.

{% img /technology/component_input_output.png Component Input Output! %}

### View and Content Projection

TBD

### Component Lifecycle

TBD

## Directives

* A __directive__ in Angular allows you to attach some custom functionality to elements in your HTML. 
* A directive allow us to change the behavior of an existing element or to change the structure of the template being rendered.
* Angular only has directives. A __component__ is a direcive that provides both functionality and UI logic.
* Types
    * Component directive
    * Non-component directive (work on and modify existing elements)
        * Attribute directive
            * Attribute directives change the look and feel, or the behavior, of an existing element or component that it is applied on. e.g, `ngClass`, `ngStyle`
        * Structural directive
            * Structural directives change the DOM layout by adding or removing elements from the view. e.g., `ngIf`, `ngFor`

* __Attribute directives__
    * Definition
    * _NgClass_
        * The NgClass directive allows us to apply or remove multiple CSS classes simultaneously from an element in our HTML. For instance, when we have to apply multiple CSS classes to an element like `<div class="price positive large-change">`
        * NgClass directive takes a JavaScript object as input. For each key in the object that has a truthy value, Angular will add that key (the key itself, not the value of the key!) as a class to the element. Similarly, each key in the object that has a falsy value will be removed as a class from that element.
    * _NgStyle_
        * The NgStyle directive is the lower-level equivalent of the NgClass directive. It operates in a manner similar to the NgClass in that it takes a JSON object and applies it based on the values of the keys. But the NgStyle directive works at a CSS style/properties level. The keys and values it expects are CSS properties and attributes rather than class names.
    * _NgSwitch_
        * is an attribute directive
* __Structural directives__
    * Definition
        * are responsible for changing the layout of the HTML by adding, removing, or modifying elements from the DOM. 
        * structural directives are applied on a pre-existing element, and the directive then operates on the content of that element.
        * All structural directives in Angular start with an asterisk (*)
    * _*ngIf_
        * `<div *ngIf="stock.favorite"></div>`
        * this directive allows you to conditionally hide or show elements in your UI. Technically, ngIf removes the element from the rendered DOM.
        * _Why does *ngIf remove the element, instead of hiding it via CSS?_
            * The reason comes down to performance and the implications thereof. Angular continues to listen and watch for events on all elements in the DOM. Removing the element from the DOM is a good way to ensure that it reduces any impact on performance, especially when the element being removed is a resource-intensive component (think a graph, or an autoupdating widget). This does mean that it is slightly less efficient when the condition toggles (since it involves a DOM addition/removal), but in the grand context of things, it is more efficient.
    * _*ngFor_
        * `*ngFor - trackBy`
            * Angular recognizes each element in an array based on their object references, by default. 
            * There are cases when the element reference might change, but you still want to continue using the same element. For example, when you fetch new data from the server, you don’t want to blow away your list and re-create it unless the data has fundamentally changed. This is where the `trackBy` capability of the NgFor directive comes into play.
            * Example: `<div class="stock-container" *ngFor="let stock of stocks; index as i; trackBy: trackStockByCode">`
            * `trackStockByCode` function implementation: `trackStockByCode(index, stock) { return stock.code; }`
            * This will ensure that Angular calls this function to figure out how to identify individual items, instead of using the object reference.
    * Angular does not allow to have more than one directive on the same element. e.g., `<div *ngFor="let stock of stocks" *ngIf="stock.active">` is invalid. 

> __Truthy and Falsy in JavaScript__
> Falsy: `undefined`, `null`, `NaN`,`0`, `""` (any empty string), `false` (the boolean value)
> Truthy: Any nonzero number, Any nonempty string, Any nonnull object or array, `true` (the boolean value)



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