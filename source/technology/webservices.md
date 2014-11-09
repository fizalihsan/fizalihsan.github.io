---
layout: page
title: "Web Services"
comments: true
sharing: true
footer: true
---

[TOC]


# RESTful Services

## What is REST?

* stands for REpresentational State Transfer
* A resource in the RESTful sense is something that is accessible through HTTP because this thing has a name—URI (Uniform Resource Identifier). 
* Though REST usually means REST over HTTP, it is actually not protocol-specific. Despite the occurrence of Transport in its name, HTTP acts as an API in RESTful approach and not simply as a transport protocol. 

## REST basic definitions

* **What is a Resource?** The technical term for the thing named by a URL is resource.
* **What is a Representation?** Whatever document the server sends back through the URL request, we call that document a representation of the resource. A representation can be any machine-readable document containing any information about a resource.
* **What is Addressability?** The principle of addressability just says that every resource should have its own URL. If something is important to your application, it should have a unique name, a URL, so that you and your users can refer to it unambiguously.
* **What is Application State?** Using a browser when you visit a site's homepage, from there to "About Us" page and from there to "Contact Us" page, the state of the browser is changing. In REST terminology, this is called 'Application State' change.
* **What is Resource State?** State of the resources being served via the web service. It can be static or dynamic. PUT and POST methods typically alter the state of the resource.
* **What is Hypermedia?** Hypermedia is the general term for things like HTML links and forms: the techniques a server uses to explain to a client what it can do next. Hypermedia is a way for the server to tell the client what HTTP requests the client might want to make in the future. It’s a menu, provided by the server, from which the client is free to choose.
* **What is a hypermedia control?** HTML `<a>` tag, HTML `<form>`, HTML `<img>`, URI Template, etc.

* **What is HATEOAS?** “Hypermedia as the engine of application state”. To say that hypermedia is the engine of application state is to say that we all navigate the Web by filling out forms and following links.
* **What is REST?** Representational State Transfer. The server sends a representation via GET operations describing the state of a resource. The client sends a representation via POST/PUT describing the state it would like the resource to have. That’s representational state transfer.
* **What is a safe method?** GET & HEAD are defined as safe HTTP methods. It’s just a request for information. Sending a GET request to the server should have the same effect on resource state as not sending a GET request—that is, no effect at all. Incidental side effects like logging and rate limiting are OK, but a client should never make a GET request hoping that it will change the resource state.
* **What is Idempotence?** Sending a request twice has the same effect on resource state as sending it once. GET, DELETE and PUT are idempotent. This notion comes from math. Multiplying a number by zero or one is an idempotent operation. Once you multiply a number by zero, you can keep multiplying it by zero indefinitely and get the same result: zero. 
* URL Vs URI 
  * A URI has two subtypes: 
    1. The URL, which specifies a location, and 
    2. and the URN, which is a symbolic name but not a location.
  * URI - short string to identify a resource. URI may or may not have a representation. URI is nothing but an identifier. E.g., `urn:isbn:9781449358063`. It designates a resource: the print edition of a book. Not any particular copy of this book, but the abstract concept of an entire edition.
  * URL - short string to identify a resource. Every URL is a URI. URL always has a representation. URL is an identifier that can be dereferenced (get a representation of a resource using the identifier).

## How REST works?

In the usual case of web service access to a resource, the requester receives a representation of the resource if the request succeeds. It is the representation that transfers
from the service machine to the requester machine. In a REST-style web service, a client does two things in an HTTP request:

* Names the targeted resource by giving its URI, typically as part of a URL.
* Specifies a verb (HTTP method), which indicates what the client wishes to do; for example, read an existing resource, create a new resource from scratch, edit an existing resource, or delete an existing resource.
 
As web-based informational items, resources are pointless unless they have at least one representation. In the Web, representations are MIME typed. The most common type of resource representation is probably still text/html, but nowadays resources tend to have multiple representations.
 
For the record, RESTful web services are Turing complete; that is, these services are equal in power to any computational system, including a system that consists of SOAP-based web services or DOA stubs and skeletons.

## RESTful Architectural Principles

### Addressable resources

The key abstraction of information and data in REST is a resource, and each resource must be addressable via a URI (Uniform Resource Identifier).

### A uniform, constrained interface

The Uniform, Constrained Interface - The idea behind it is that you stick to the finite set of operations of the application protocol you’re distributing your services upon. This means that you don’t have an “action” parameter in your URI and use only the methods of HTTP for your web services. HTTP has a small, fixed set of operational methods. Use a small set of well-defined methods to manipulate your resources.

### Representation-oriented

interact with services using representations of that service. A resource referenced by one URI can have different formats. Different platforms need different formats. For example, browsers need HTML, JavaScript needs JSON (JavaScript Object Notation), and a Java application may need XML.

### Communicate statelessly

stateless means that there is no client session data stored on the server. Client should maintain sessions, if required. A service layer that does not have to maintain client sessions is a lot easier to scale, as it has to do a lot fewer expensive replications in a clustered environment. It’s a lot easier to scale up, because all you have to do is add machines.

### Hypermedia As The Engine Of Application State (HATEOAS)

* Hypermedia is a document-centric approach with the added support for embedding links to other services and information within that document format. The more interesting part of HATEOAS is the “engine.”  Let your data formats drive state transitions in your applications.
* The architectural principle that describes linking and form submission is called HATEOAS. 
* HATEOAS stands for Hypermedia As The Engine Of Application State.
* The idea of HATEOAS is that your data format provides extra information on how to change the state of your application. On the Web, HTML links allow you to change the state of your browser. When reading a web page, a link tells you which possible documents (states) you can view next. When you click a link, your browser’s state changes as it visits and renders a new web page. HTML forms, on the other hand, provide a way for you to change the state of a specific resource on your server. When you buy something on the Internet through an HTML form, you are creating two new resources on the server: a credit card transaction and an order entry.
* When applying HATEOAS to web services, the idea is to embed links within your XML or JSON documents. While this can be as easy as inserting a URL as the value of an element or attribute, most XML-based RESTful applications use syntax from the Atom* Syndication Format as a means to implement HATEOAS.


## WSDL & WADL 

### WSDL

* stands for Web Service Description Language
* WSDL documents can describe either category of web service, SOAP-based or REST-style, but there seems to be little interest in WSDLs and WSDL-based tools for RESTful services.

### WADL

* Web Application Description Language 
* JAX-RS implementations such as Metro do provide a WSDL counterpart, the WADL document that describes a JAX-RS service and can be used to generate client-side code.
* wadl2java utility tool generates Java code from a WADL document.
* The publisher of JAX-RS service generates the WADL dynamically, although a WADL, like a WSDL, can be edited as needed—or even written from scratch. The syntax for getting the WADL differs slightly among JAX-RS implementations. In the Jersey implementation, the document is available as application.wadl. E.g, if the resource URI is localhost/resourceA/ then the Jersey generated WADL can be accessed at localhost/resourceA/application.wadl. If it were CXF, then localhost/resourceA?wadl
* The WADL document is language-neutral but its use is confined basically to the Java world. Other languages and frameworks have their counterparts; for example, Rails has the ActiveResource construct that lets a client program interact with a service but without dealing explicitly with documents in XML or JSON.
* The trade-off in using a tool such as wadl2java to avoid dealing explicitly with XML or similar payloads:
  * The upside is avoiding an XML or comparable parse.
  * The downside is learning yet another API.

## Java APIs for RESTful services

Java Web Service APIs include:

* HttpServlet and its equivalents (e.g., JSP scripts)
* JAX-RS (Java API for RESTful services) - Jersey is the reference implementation
* Restlet, which is similar in style to JAX-RS
* JAX-WS (Java API for Web Services) which is a relatively low-level API. Metro is the reference implementation.

### Servlet based Web Services

JAX-RS and Restlet are roughly peers (arguably). Both of these APIs emphasize the use of Java annotations to describe the RESTful access to a particular CRUD operation. Each framework supports the automated generation of XML and JSON payloads. When published with a web server such as Tomcat or Jetty, JAX-RS and Restlet provide servlet interceptors that mediate between the client and the web service.

### JAX-RS API

JAX-RS is a framework that focuses on applying Java annotations to plain Java objects. 

* It has annotations to bind specific URI patterns and HTTP operations to individual methods of your Java class. (@Path and @GET, etc.,)
* It has parameter injection annotations so that you can easily pull in information from the HTTP request. (@PathParam)
* It has message body readers and writers that allow you to decouple data format marshalling and unmarshalling from your Java data objects. 
* It has exception mappers that can map an application-thrown exception to an HTTP response code and message.

In vanilla JAX-RS, services can either be singletons or per-request objects. 

* A singleton means that one and only one Java object services HTTP requests. 
* Per-request means that a Java object is created to process each incoming request and is thrown away at the end of that request. Per-request also implies statelessness, as no service state is held between requests.

In JAX-RS, any non-JAX-RS-annotated parameter is considered to be a representation of the HTTP input request’s message body. Only one Java method parameter can represent the HTTP message
body. This means any other parameters must be annotated with one of the JAX-RS annotations.

In JAX-RS, you are also allowed to define a Java interface that contains all your JAX-RS annotation metadata instead of applying all your annotations to your implementation class. This approach isolates the business logic from all the JAX-RS annotations. The JAX-RS specification also allows you to define class and interface hierarchies if you so desire.

* Implementations include Jersey (RI), JBoss RESTEasy, Apache Wink and Apache CXF, Apache Axis2???
* relies upon Java annotations to advertise the RESTful role that a class and its encapsulated methods play.
* JAX-RS has APIs for programming RESTful services and clients against such services; the two APIs can be used independently.
* JAX-RS uses Java annotations heavily but there are no annotations to express hyperlinks

#### @Path

The `@javax.ws.rs.Path` annotation in JAX-RS is used to define a URI matching pattern for incoming HTTP requests. It can be placed upon a class or on one or more Java methods. For a Java class to be eligible to receive any HTTP requests, the class must  be annotated with at least the `@Path("/")` expression. These types of classes are called JAX-RS root resources.

`@Path` can have complex matching expressions so that you can be more specific on what requests get bound to which incoming URIs. `@Path` can also be used on a Java method as sort of an object factory for subresources of your application.

To receive a request, a Java method must have at least an HTTP method annotation like `@javax.ws.rs.GET` applied to it. This method may or may not have an `@Path` annotation on it, though. 

``` java @Path at class level
@Path("/orders")
public class OrderResource {
    @GET
    public String getUnpaidOrders() {
       ...
    }
}

Relative URI: /orders
```

``` java @Path at class and method level
@Path("/orders")
public class OrderResource {
    @GET
    @Path("unpaid")
    public String getUnpaidOrders() {
       ...
    }
}
Relative URI: /orders/unpaid
```

``` java @Path with wildcard expressions
@GET
@Path("customers/{firstname}-{lastname}")
public String getCustomer(@PathParam("firstname") String first, @PathParam("lastname") String last) {
   ...
}
```

``` java @Path with regular expressions
Regular expressions
@GET
@Path("{id : \\d+}")
public String getCustomer(@PathParam("id") int id) {
   ...
}
```

##### Matrix Parameters

E.g., `http://example.cars.com/mercedes/e55;color=black/2006`

Matrix parameters are name-value pairs associated with a URI. These are different from query parameters. These are more like adjectives and are not included to uniquely identify a resource.

##### Subresource Locators

Subresource locators are Java methods annotated with `@Path`, but with no HTTP method annotation, like `@GET`, applied to them. This type of method returns an object that is, itself, a JAX-RS annotated service that knows how to dispatch the remainder of the request.

#### JAX-RS Injections - Request header related annotations

When the JAX-RS provider receives an HTTP request, it finds a Java method that will service this request. If the Java method has parameters that are annotated with any of these injection annotations, it will extract information from the HTTP request and pass it as a parameter when it invokes the method.

1. `@PathParam` - to extract values from URI template parameters.
* `@MatrixParam` - to extract values from a URI’s matrix parameters.
* `@QueryParam` - to extract values from a URI’s query parameters.
* `@FormParam` - to extract values from posted form data.
* `@HeaderParam` - to extract values from HTTP request headers.
* `@CookieParam` - to extract values from HTTP cookies set by the client.
* `@Context` - This class is the all-purpose injection annotation. It allows you to inject various helper and informational objects that are provided by the JAX-RS API.

#### HTTP Content Negotiation in JAX-RS

There are multiple ways to implement the content negotiation discussed above:

* Each method is responsible for returning response in a specific format.

``` java
@Produces({"application/xml")
public Customer getCustomerXml(@PathParam("id") int id) {...}

@Produces({"application/json"})
public Customer getCustomerJson(@PathParam("id") int id) {...}
```

* A single method could be responsible to return responses in either xml or json format. Return type is a Java object which is annotated with JAXB annotations. Based on the information in 'Accept', either XML or JSON is returned.

``` java
@Produces({"application/xml", "application/json"})
public Customer getCustomer(@PathParam("id") int id) {...}
```

* For complex negotiations, where multiple combinations of data formats, languages and encodings need to be dealt, JAX-RS provides classes like HttpHeaders, Variant, VariantBuilder, etc. which could be leveraged.
* Negotiation by URI patterns: Some client like Firefox browser do not support conneg. In such cases, embed conneg information in URI. E.g., 

```
/customers/en-US/xml/3323
/customers/3323.xml.en-US
```

* Custom media types: Example: `application/vnd.rht.customers+xml`. The convention is to combine a vnd prefix, the name of your new format, and a concrete media type suffix  delimited by the “+” character.

### RESTlet 

* The Restlet web framework supports RESTful web services, and the API is similar to JAX-RS; indeed, a Restlet application can use JAX-RS annotations such as @Produces instead of or in addition to Restlet annotations.
* A Restlet web service has three main parts, each of which consists of one or more Java classes:
  * A programmer-defined class, in this example AdagesApplication, extends the Restlet Application class. The purpose of the extended class is to set up a routing table, which maps request URIs to resources. The resources are named or anonymous Java classes; the current example illustrates both approaches. The spirit of Restlet development is to have very simple resource classes.
  * There are arbitrarily many resource classes, any mix of named or anonymous. In best practices, a resource implementation supports a very small number of operations on the resource—in the current example, only one operation per resource. For example, the adages2 service has seven resources: six of these are named classes that extend the Restlet ServerResource class and the other is an anonymous class that implements the Restlet interface. The named classes are CreateResource, the target of a POST request; UpdateResource, the target of a PUT request; XmlAllResource, the target of a GET request for all Adages in XML; JsonAllResource, the target of a GET request for all Adages in JSON; XmlOneResource, the target of a GET request for a specified Adage; and so on.
  * The backend POJO classes are Adage and Adages, each slightly redefined from the earlier adages web service.
* These APIs also mimic the routing idioms that have become so popular because of frameworks such as Rails and Sinatra.

### JAX-WS API

* JAW-WS is an API used mostly for SOAP-based services but can be used for REST-style services as well. In the latter case, the @WebServiceProvider annotation is central. The @WebServiceProvider interface is sufficiently flexible that it can be used to annotate either a SOAP-based or a REST-style service; however, JAX-WS provides a related but higher level annotation, @WebService, for SOAP-based services. The @WebServiceProvider API is deliberately lower level than the servlet, JAX-RS, and Restlet APIs, and the @WebServiceProvider API is targeted at XML-based services. For programmers who need a low-level API, Java supports the @WebServiceProvider option. JAX-RS, Restlet, and @WebServiceProvider have both service-side and client-side APIs that can be used independently of one another. For example, a Restlet client could make calls against a JAX-RS service or vice versa.
* JAX-WS includes APIs for RESTful and SOAP-based web services, although JAX-WS seems to be used mostly for the latter. The reference implementation is Metro, which is part of the GlassFish project. Although JAX-WS technically belongs to enterprise rather than core Java, the core Java JDK (1.6 or greater) includes enough of the Metro distribution to compile and publish RESTful and SOAP-based services. JAX-RS and Restlet are state-of-the-art, high-level APIs for developing RESTful services; by contrast, the JAX-WS API for RESTful services is low-level. Nonetheless, JAX-WS support for RESTful services deserves a look, and the JAX-WS API for SOAP-based services.
* The JAX-WS API has two main annotations. 
* `@WebServiceProvider` - a POJO class annotated this can deliver both SOAP-based and a RESTful one


Following are the JAX-WS Implementations

#### Metro

* http://www.oracle.com/technetwork/java/index-jsp-137051.html 
* is the reference implementation
* integrated web services stack provided by Oracle Java. 
* Metro stack consisting of JAX-WS, JAXB, and WSIT (Web Services Interoperability Technologies), enable you to create and deploy secure, reliable, transactional, interoperable Web services and clients.

#### Apache CXF

* Apache CXF is an open source services framework. CXF helps you build and develop services using frontend programming APIs, like JAX-WS and JAX-RS. These services can speak a variety of protocols such as SOAP, XML/HTTP, RESTful HTTP, or CORBA and work over a variety of transports such as HTTP, JMS or JBI.
* Features: Generating WSDL from Java and vice-versa, Spring support, OSGi support, WS* support, proprietary Aegis Databinding (similar to JAXB), RESTful services

#### Apache Axis2

* a Web Services / SOAP / WSDL engine
* Features: proprietary ADB Databinding (faster than CXF)


# SOAP Services

There are two ways of developing SOAP web services; contract-first and code-first approaches. 

1. In a contract-first approach, the web service definition or the WSDL is created initially and the service implementation is done after that. 
2. In a code-first approach, the service implementation classes are developed at the beginning and usually the WSDL is automatically generated by the service container in which the web service is deployed.

## Downsides of SOAP services

The performance degradation due to heavy XML processing and the complexities associated with the usage of various WS-* specifications are two of the most common disadvantages of the SOAP messaging model.

## Difference between REST and SOAP

* SOAP is a messaging protocol in which the messages are XML documents, whereas REST is a style of software architecture for distributed hypermedia systems, or systems in which text, graphics, audio, and other media are stored across a network and interconnected through hyperlinks.
* In the Web, HTTP is both a transport protocol and a messaging system because HTTP requests and responses are messages. The payloads of HTTP messages can be typed using the MIME (Multipurpose Internet Mail Extension) type system. MIME has types such as text/html, application/octet-stream, and audio/mpeg3.
* A RESTful request targets a resource, but the resource itself typically is created on the service machine and remains there. A resource may be persisted in a data store such as a database system.

# Data Binding Tools

## GSON

Created by Google

## JAX-B

* JAX-B stands for Java API for data binding; the associating of a Java data type such as String to an XML Schema (or equivalent) type, in this case xsd:string
* Implementations: ???
* How to do in-memory transformations from Object to XML and vice versa
* `schemagen` is a core Java JDK has a schemagen utility that generates an XML schema from a POJO source file. The utility can be invoked from the command: % schemagen Adage.java
* `xjc` is another core JDK utility, that works in the other direction. Given an XML Schema, xjc can generate Java classes to represent the XML types in the schema.

## Jackson

* Created by FasterXML.
* Jackson is an XML/json parser and data binder. 
* Jackson is a:
  * FAST (measured to be faster than any other Java json parser and data binder)
  * Streaming (reading, writing)
  * Zero-dependency (does not rely on other packages beyond JDK)
  * Powerful (full data binding for common JDK classes as well as any Java bean class, Collection, Map or Enum), Configurable
  * Open Source (Apache License – or, until 2.1, alternatively LGPL)
  * JSON processor. It provides JSON parser/JSON generator as foundational building block; and adds a powerful Databinder (JSON<->POJO) and Tree Model as optional add-on blocks.
  * This means that you can read and write JSON either as stream of tokens (Streaming API), as Plain Old Java Objects (POJOs, databind) or as Trees (Tree Model). 

## Jettison

??? 

## JSON

* http://json-schema.org/
* JSON-P format - P stands for with padding.
* JSONP originally signified a way to work around the traditional same domain policy that prevents a page downloaded from a domain such as server.foo.org from communicating with a domain other than foo.org; JSONP still serves this purpose. The JSONP workaround involves script elements in a page, as these elements allow code to be downloaded from anywhere; the downloaded code can then perform arbitrary processing, which includes communicating with servers in arbitrary domains. JSONP works nicely with web services.
* JSONP brings an event-driven API to client-side processing. Using JSONP, the programmer can do the following:
  * Provide a URL to a data source.
  * Specify a callback function to be executed, in browser context, once the data from the specified source arrives.

## XStream

* Created by ThoughtWorks
* XStream includes a persistence API and has extensions in support of the Hibernate ORM (Object Relation Mapper). Among the more interesting features of XStream is that its API does not center on the get/set methods that define Java properties. XStream can serialize into XML an instance of a Java class that has nothing but private fields.
* XStream also supports selective or fine-grained serialization and deserialization.
* The core XStream library also supports the conversion of Java objects to and from JSON. There are various JSON drivers available in this library, the simplest of which is the JsonHierarchicalStreamDriver. This driver supports the serialization of Java objects to JSON but not the inverse operation. If deserialization from JSON to Java is needed, then a driver such as Jettison is a good choice because it interoperates cleanly with XStream.
* XStream supports customized JSON serialization.
* The XStream API is remarkably low fuss but likewise powerful. This API has gained steadily in popularity among Java developers who are looking for quick and easy ways to convert between Java objects on the one side and either XML or JSON documents on the other side.

# Open Questions

* There are no annotations in JAX-RS to express hyperlinks. You have to design those yourself. what does that mean?
* JAX-RS defines: transitional links which describe optional next actions and structural links which provide optional detailed information. Transitional links tell a client where to proceed next, while structural links help to shorten representations in order to avoid aggregate data. Details are replaced by links. Transitional links have some support in JAX-RS 2.0, but structural links are not supported due to their level of complexity.????
* URL opacity - http://www.zapthink.com/2012/10/08/the-power-of-opacity-in-rest/ 
* Routing idiom JAX-RS API implements mimic from Rails???

# Tools

* cUrl
* soapUI

# Bibliography

* Books
  * Building Web Services with Java (2E)
  * Java Web Services - Up & Running - O'Reilly 2013
  * RESTful Java with JAX-RS -2010
  * RESTful Web APIs - O'Reilly 2013
  * Web Services Testing with soapUI (2012)
  * Service Oriented Architecture - Thomas Erl
* Sites
  * [Oracle - Web Services Interoperability Technologies](http://docs.oracle.com/cd/E19502-01/820-1072/ahiaj/index.html)
  * [SlideShare - RESTful Web APIs](http://www.slideshare.net/rnewton/2013-06q-connycrestfulwebapis)

