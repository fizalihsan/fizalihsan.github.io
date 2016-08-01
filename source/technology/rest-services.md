---
layout: page
title: "RESTful Services"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}


[Must read on REST concepts](https://developer.github.com/v3/)

# Why REST?

* **Ability to leverage commodity caching technologies**
This API style leverages commodity caching technologies designed specifically with HTTP in mind. If, for example, a client requests a product that hasn’t changed within the past day, and information on that product can be found in a Reverse Proxy, then the cached representation will be returned and service execution can be bypassed. This reduces the load on the Origin Server, especially in cases where the service would have queried a database or performed a CPU- or memory-intensive computation

# Basic definitions

* **What is REST?** Representational State Transfer. The server sends a representation via GET operations describing the state of a resource. The client sends a representation via POST/PUT describing the state it would like the resource to have. That’s representational state transfer.
* Though REST usually means REST over HTTP, it is actually not protocol-specific. Despite the occurrence of Transport in its name, HTTP acts as an API in RESTful approach and not simply as a transport protocol. 
* **What is a Resource?** A resource in the RESTful sense is something that is accessible through HTTP because this thing has a name—URI (Uniform Resource Identifier). 
* **What is a Representation?** Whatever document the server sends back through the URL request, we call that document a representation of the resource. A representation can be any machine-readable document containing any information about a resource.
* **What is Addressability?** The principle of addressability just says that every resource should have its own URL. If something is important to your application, it should have a unique name, a URL, so that you and your users can refer to it unambiguously.
* **What is Application State?** Using a browser when you visit a site's homepage, from there to "About Us" page and from there to "Contact Us" page, the state of the browser is changing. In REST terminology, this is called 'Application State' change.
* **What is Resource State?** State of the resources being served via the web service. It can be static or dynamic. PUT and POST methods typically alter the state of the resource.
* **What is Hypermedia?** Hypermedia is the general term for things like HTML links and forms: the techniques a server uses to explain to a client what it can do next. Hypermedia is a way for the server to tell the client what HTTP requests the client might want to make in the future. It’s a menu, provided by the server, from which the client is free to choose.
* **What is a hypermedia control?** HTML `<a>` tag, HTML `<form>`, HTML `<img>`, URI Template, etc.
* **What is HATEOAS?** “Hypermedia as the engine of application state”. To say that hypermedia is the engine of application state is to say that we all navigate the Web by filling out forms and following links.
* **What is a safe method?** GET & HEAD are defined as safe HTTP methods. It’s just a request for information. Sending a GET request to the server should have the same effect on resource state as not sending a GET request—that is, no effect at all. Incidental side effects like logging and rate limiting are OK, but a client should never make a GET request hoping that it will change the resource state.
* **What is Idempotence?** Sending a request twice has the same effect on resource state as sending it once. GET, DELETE and PUT are idempotent. This notion comes from math. Multiplying a number by zero or one is an idempotent operation. Once you multiply a number by zero, you can keep multiplying it by zero indefinitely and get the same result: zero. 

| GET | Cacheable, Safe method (no side effects)| 
| POST | Unsafe operation which can't be repeated| 
| PUT | Idempotent (same request yields same result) | 
| DELETE | Idempotent (same request yields same result)| 
| HEAD | Safe method (no side effects), No message body| 

* URL Vs URI 
  * A URI has two subtypes: 
    1. The URL, which specifies a location, and 
    2. and the URN, which is a symbolic name but not a location.
  * URI - short string to identify a resource. URI may or may not have a representation. URI is nothing but an identifier. E.g., `urn:isbn:9781449358063`. It designates a resource: the print edition of a book. Not any particular copy of this book, but the abstract concept of an entire edition.
  * URL - short string to identify a resource. Every URL is a URI. URL always has a representation. URL is an identifier that can be dereferenced (get a representation of a resource using the identifier).

# How REST works?

In the usual case of web service access to a resource, the requester receives a representation of the resource if the request succeeds. It is the representation that transfers
from the service machine to the requester machine. In a REST-style web service, a client does two things in an HTTP request:

* Names the targeted resource by giving its URI, typically as part of a URL.
* Specifies a verb (HTTP method), which indicates what the client wishes to do; for example, read an existing resource, create a new resource from scratch, edit an existing resource, or delete an existing resource.
 
As web-based informational items, resources are pointless unless they have at least one representation. In the Web, representations are MIME typed. The most common type of resource representation is probably still text/html, but nowadays resources tend to have multiple representations.
 
For the record, RESTful web services are Turing complete; that is, these services are equal in power to any computational system, including a system that consists of SOAP-based web services or DOA stubs and skeletons.


# Architectural Principles

* **Addressable resources** - The key abstraction of information and data in REST is a resource, and each resource must be addressable via a URI (Uniform Resource Identifier).
* **A uniform, constrained interface** - The Uniform, Constrained Interface - The idea behind it is that you stick to the finite set of operations of the application protocol you’re distributing your services upon. This means that you don’t have an “action” parameter in your URI and use only the methods of HTTP for your web services. HTTP has a small, fixed set of operational methods. Use a small set of well-defined methods to manipulate your resources.
* **Representation-oriented** - interact with services using representations of that service. A resource referenced by one URI can have different formats. Different platforms need different formats. For example, browsers need HTML, JavaScript needs JSON (JavaScript Object Notation), and a Java application may need XML.
* **Communicate statelessly** - stateless means that there is no client session data stored on the server. Client should maintain sessions, if required. A service layer that does not have to maintain client sessions is a lot easier to scale, as it has to do a lot fewer expensive replications in a clustered environment. It’s a lot easier to scale up, because all you have to do is add machines.
* **Hypermedia As The Engine Of Application State (HATEOAS)**
	* Hypermedia is a document-centric approach with the added support for embedding links to other services and information within that document format. The more interesting part of HATEOAS is the “engine.”  Let your data formats drive state transitions in your applications.
	* The architectural principle that describes linking and form submission is called HATEOAS. 
	* HATEOAS stands for Hypermedia As The Engine Of Application State.
	* The idea of HATEOAS is that your data format provides extra information on how to change the state of your application. On the Web, HTML links allow you to change the state of your browser. When reading a web page, a link tells you which possible documents (states) you can view next. When you click a link, your browser’s state changes as it visits and renders a new web page. HTML forms, on the other hand, provide a way for you to change the state of a specific resource on your server. When you buy something on the Internet through an HTML form, you are creating two new resources on the server: a credit card transaction and an order entry.
	* When applying HATEOAS to web services, the idea is to embed links within your XML or JSON documents. While this can be as easy as inserting a URL as the value of an element or attribute, most XML-based RESTful applications use syntax from the Atom  Syndication Format as a means to implement HATEOAS.


# WADL

* WADL stands for Web Application Description Language 
* JAX-RS implementations such as Metro do provide a WSDL counterpart, the WADL document that describes a JAX-RS service and can be used to generate client-side code.
* `wadl2java` utility tool generates Java code from a WADL document.
* The publisher of JAX-RS service generates the WADL dynamically, although a WADL, like a WSDL, can be edited as needed—or even written from scratch. The syntax for getting the WADL differs slightly among JAX-RS implementations. In the Jersey implementation, the document is available as `application.wadl`. E.g, if the resource URI is `localhost/resourceA/` then the Jersey generated WADL can be accessed at `localhost/resourceA/application.wadl`. If it were CXF, then `localhost/resourceA?wadl`.
* The WADL document is language-neutral but its use is confined basically to the Java world. Other languages and frameworks have their counterparts; for example, Rails has the ActiveResource construct that lets a client program interact with a service but without dealing explicitly with documents in XML or JSON.
* The trade-off in using a tool such as wadl2java to avoid dealing explicitly with XML or similar payloads:
  * The upside is avoiding an XML or comparable parse.
  * The downside is learning yet another API.

# JAX-RS API

JAX-RS is a framework that focuses on applying Java annotations to plain Java objects. 

* It has annotations to bind specific URI patterns and HTTP operations to individual methods of your Java class. (@Path and @GET, etc.,)
* It has parameter injection annotations so that you can easily pull in information from the HTTP request. (@PathParam)
* It has message body readers and writers that allow you to decouple data format marshalling and unmarshalling from your Java data objects. 
* It has exception mappers that can map an application-thrown exception to an HTTP response code and message.

In vanilla JAX-RS, services can either be singletons or per-request objects. 

* A singleton means that one and only one Java object services HTTP requests. 
* Per-request means that a Java object is created to process each incoming request and is thrown away at the end of that request. Per-request also implies statelessness, as no service state is held between requests.

* In JAX-RS, any non-JAX-RS-annotated parameter is considered to be a representation of the HTTP input request’s message body. Only one Java method parameter can represent the HTTP message
body. This means any other parameters must be annotated with one of the JAX-RS annotations.
( In JAX-RS, you are also allowed to define a Java interface that contains all your JAX-RS annotation metadata instead of applying all your annotations to your implementation class. This approach isolates the business logic from all the JAX-RS annotations. 
* The JAX-RS specification also allows you to define class and interface hierarchies if you so desire.

* Implementations include Jersey (RI), JBoss RESTEasy, Apache Wink and Apache CXF, Apache Axis2
* relies upon Java annotations to advertise the RESTful role that a class and its encapsulated methods play.
* JAX-RS has APIs for programming RESTful services and clients against such services; the two APIs can be used independently.
* JAX-RS uses Java annotations heavily but there are no annotations to express hyperlinks

## @Path

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

## Matrix Parameters

E.g., `http://example.cars.com/mercedes/e55;color=black/2006`

Matrix parameters are name-value pairs associated with a URI. These are different from query parameters. These are more like adjectives and are not included to uniquely identify a resource.

**Subresource Locators**

Subresource locators are Java methods annotated with `@Path`, but with no HTTP method annotation, like `@GET`, applied to them. This type of method returns an object that is, itself, a JAX-RS annotated service that knows how to dispatch the remainder of the request.

```java
@Path("/item")
public class ItemResource {
    @Context UriInfo uriInfo;
 
    @Path("content")
    public ItemContentResource getItemContentResource() {
        return new ItemContentResource();
    }
 
    @GET
    @Produces("application/xml")
        public Item get() { ... }
    }
}
 
public class ItemContentResource {
    @GET
    public Response get() { ... }
 
    @PUT
    @Path("{version}")
    public void put(@PathParam("version") int version, @Context HttpHeaders headers, byte[] in) {
        ...
    }
}
```

## JAX-RS Injections

(Request header related annotations)

When the JAX-RS provider receives an HTTP request, it finds a Java method that will service this request. If the Java method has parameters that are annotated with any of these injection annotations, it will extract information from the HTTP request and pass it as a parameter when it invokes the method.

1. `@PathParam` - to extract values from URI template parameters.
2. `@MatrixParam` - to extract values from a URI’s matrix parameters.
3. `@QueryParam` - to extract values from a URI’s query parameters.
4. `@FormParam` - to extract values from posted form data.
5. `@HeaderParam` - to extract values from HTTP request headers.
6. `@CookieParam` - to extract values from HTTP cookies set by the client.
7. `@Context` - This class is the all-purpose injection annotation. It allows you to inject various helper and informational objects that are provided by the JAX-RS API.

## HTTP Content Negotiation

There are multiple ways to implement the content negotiation discussed above:

* Each method is responsible for returning response in a specific format.

``` java
@Produces({"application/xml"})
public Customer getCustomerXml(@PathParam("id") int id) {...}

@Produces({"application/json"})
public Customer getCustomerJson(@PathParam("id") int id) {...}
```

* A single method could be responsible to return responses in either xml or json format. Return type is a Java object which is annotated with JAXB annotations. Based on the information in Header 'Accept', either XML or JSON is returned.

``` java
@Produces({"application/xml", "application/json"})
public Customer getCustomer(@PathParam("id") int id) {...}
```

* For complex negotiations, where multiple combinations of data formats, languages and encodings need to be dealt, JAX-RS provides classes like `HttpHeaders`, `Variant`, `VariantBuilder`, etc. which could be leveraged.
* Negotiation by URI patterns: Some client like Firefox browser do not support conneg. In such cases, embed conneg information in URI. E.g., 

```
/customers/en-US/xml/3323
/customers/3323.xml.en-US
```

* Custom media types: Example: `application/vnd.rht.customers+xml`. The convention is to combine a vnd prefix, the name of your new format, and a concrete media type suffix  delimited by the “+” character.

## Request & Response Management

* **Service Controller** 
  * Receives requests, evaluate and route requests to procedures (i.e., class methods, request handlers), which implement the desired service behaviors.
  * The rules that define which handlers should be invoked for different requests are provided through annotations known collectively as ***Routing Expressions***.
  * When a web server receives a request, the framework (like JAX-RS) selects and invokes handlers by evaluating various aspects of the request against these expressions.
  * **Routing Expression Types**
    * URI templates - e.g., `http://www.acmeCorp.org/products/{ProductId}`. 
    * Request Method Designators - e.g., `@GET`, `@POST`. These handlers could use the same URI template, but different request methods (e.g., `GET`, `PUT`, `DELETE`) to trigger each handler.
    * Media Type Negotiation - e.g., JSON, XML. For the same URI and request method, different clients may want the request and/or responses in different media format. 
  * This pattern also makes it easy to leverage data-binding technologies that automatically deserialize requests and serialize responses. The methods on Service Controllers can be annotated with binding instructions to tell the framework how requests and responses should be handled. The default options include XML and JSON, but developers may also tell the framework to use a custom approach.

  * JAX-RS Service Interface Classes

    define request handlers and routing expressions, but don’t have any implementation. Service Controller implementing these interfaces must implement these methods but can omit the routing expressions. Though the service controller classes can omit the annotations, JAX-RS specification recommendeds to always repeat annotations instead of relying on annotation inheritance. 

* **Request Mapper**
  * decouple domain logic from the syntactic structure of service request
* **Response Mapper**
  * decouple clients from internal representation of domain objects


## Asynchronous JAX-RS

### Client-side Async API - Using Futures

* The client async API allows to spin off a bunch of HTTP requests in the background and then either poll for a response, or register a callback that is invoked when the HTTP response is available
* To invoke an HTTP request asynchronously on the client, you interact with the `javax.ws.rs.client.AsyncInvoker` interface or the `submit()` methods on `javax.ws.rs.client.Invocation`.

```java Example 1 - Using Futures
Client client = ClientBuilder.newClient();

Future<Response> future1 = client.target("http://example.com/customers/123")
                                 .request()
                                 .async().get();

Future<Order> future2 = client.target("http://foobar.com/orders/456")
                              .request()
                              .async().get(Order.class);

Response res1 = future1.get(); // block until complete
try{
   Customer result1 = res.readEntity(Customer.class);
} catch (Throwable t){
  t.printStackTrace()
} finally {
  res1.close(); //IMPORTANT
}

try {
    Order result2 = future2.get(5, TimeUnit.SECONDS); // Wait 5 seconds
} catch (TimeoutException timeout ) {
    ... handle exception ...
} catch(ExecutionException e){
  Throwable cause = ee.getCause();

  if (cause instanceof WebApplicationException) {
    WebApplicationException wae = (WebApplicationException)cause;
    wae.close();
  } else if (cause instanceof ResponseProcessingException) {
    ResponseProcessingException rpe = (ResponseProcessingException)cause;
    rpe.close();
  } else if (cause instanceof ProcessingException) {
    // handle processing exception
  } else {
    // unknown
  }
}
```

* In *Example 1*, two separate requests are executed in parallel. 
* *Blocking call*
  * For request 1, a blocking call is made indefinitely to get the `Response` object.
* *Blocking call with timeout*
  * For request 2, a blocking call with timeout is made to get the business domain object *Order* directly unmarshalled from the `Response`. 
  * If the response is something other than *200, OK*, then the JAX-RS runtime throws one of the exceptions from the JAX-RS error exception hierarchy.
  * If the call takes longer than timeout, then `java.util.concurrent.TimeoutException` is thrown.
* You can also invoke the non-blocking `isDone()`, `isCancelled()` methods on the Future.

> Always make sure the underlying JAX-RS response is closed, otherwise the OS may exhaust the limit on allowable open connections.

### Client-side Async API - Using Callbacks

* Callback style has 2 interfaces: `AsyncInvoker` & `InvocationCallback` 

```java AsyncInvoker methods
package javax.ws.rs.client;

public interface AsyncInvoker {
  <T> Future<T> get(InvocationCallback<T> callback);
  <T> Future<T> post(Entity<?> entity, InvocationCallback<T> callback);
  <T> Future<T> put(Entity<?> entity, InvocationCallback<T> callback);
  <T> Future<T> delete(Entity<?> entity, InvocationCallback<T> callback);
  ...
}
```

```java InvocationCallback methods
package javax.rs.ws.client;

public interface InvocationCallback<RESPONSE> {
  public void completed(RESPONSE response);
  public void failed(Throwable throwable);
}
```

* In the below example, client wants the `Response` object from callback. If there is an issue sending the request to the server or the JAX-RS runtime is unable to create a `Response`, then `failed()` method will be invoked.

```java Example getting Response from InvocationCallback
public class CustomerCallback implements InvocationCallback<Response> {
  public void completed(Response response) {
    if (response.getStatus() == 200) {
      Customer cust = response.readEntity(Customer.class);
    } else {
      System.err.println("Request error: " + response.getStatus());
    }
  }

  public void failed(Throwable throwable) {
    throwable.printStackTrace();
  }
}

```

```java Example getting unmarshalled domain object from InvocationCallback
public class OrderCallback implements InvocationCallback<Order> {
  public void completed(Order order) {
    System.out.println("We received an order.");
  }
  
  public void failed(Throwable throwable) {
    if (throwable instanceof WebApplicationException) {
      WebApplicationException wae = (WebApplicationException)throwable;
      System.err.println("Failed with status: " + wae.getResponse().getStatus());
    } else if (throwable instanceof ResponseProcessingException) { // when there is an issue unmarshalling
      ResponseProcessingException rpe = (ResponseProcessingException)cause;
      System.err.println("Failed with status: " + rpe.getResponse().getStatus());
    } else {
      throwable.printStackTrace();
    }
  }
}
```

* Use Futures when there is a need to wait for all requests to complete and perform another task.

### Server-side Async API

* For a typical HTTP server, one thread is dedicated to the processing of a request and its HTTP response to the client.
* The nature of HTTP traffic started to change somewhat as JavaScript clients started to become more prevalent. One problem that popped up often was the need for the server to push events to the client. A typical example is a stock quote application where you need to update a string of clients with the latest stock price. These clients would make an HTTP GET or POST request and just block indefinitely until the server was ready to send back a response. This resulted in a large amount of open, long-running requests that were doing nothing other than idling. Not only were there a lot of open, idle sockets, but there were also a lot of dedicated threads doing nothing at all. Most HTTP servers were designed for short-lived requests with the assumption that one thread could process requests from multiple concurrent users. When you have a very large number of threads, you start to consume a lot of operating system resources. Each thread consumes memory, and context switching between threads starts to get quite expensive when the OS has to deal with a large number of threads. It became really hard to scale these types of server-push applications since the Servlet API, and by association JAX-RS, was a “one thread per connection” model.
* In 2009, the Servlet 3.0 specification introduced asynchronous HTTP. With the Servlet 3.0 API, you can suspend the current server-side request and have a separate thread, other than the calling thread, handle sending back a response to the client. For a serverpush app, you could then have a small handful of threads manage sending responses back to polling clients and avoid all the overhead of the “one thread per connection” model. JAX-RS 2.0 introduced a similar API.
* Asynchronous doesn’t necessarily mean automatic scalability. For the typical web app, using server asynchronous response processing will only complicate your code and make it harder
to maintain. It may even hurt performance.

* To use server-side processing, `AsyncResponse` interface is provided.
* Get access to an `AsyncResponse` instance by injecting it into a JAX-RS method using `@Suspended` annotation
* When you inject an instance of AsyncResponse using the `@Suspended` annotation, the HTTP request becomes suspended from the current thread of execution. 
* A new background thread is created to send the response back to the client by calling the `AsyncResponse.resume()` method.
* When you invoke `AsyncResponse.resume(Object)`, the response filter and interceptor chains are invoked, and then finally the `MessageBodyWriter`. If an exception is thrown by any one of these components, then the exception is handled in the same way as its synchronous counterpart with one caveat. Unhandled exceptions are not propagated, but instead the server will return a *500, Internal Server Error* back to the client.
* If an `AsyncResponse` is not resumed or cancelled, it will eventually time out. The default timeout is container-specific. A timeout results in a *503, Service Unavailable* response code sent back to the client. You can explicitly set the timeout by invoking: `response.setTimeout(5, TimeUnit.SECONDS);` or register a callback `response.setTimeoutHandler(new TimeoutHandler{...});`
* Instead of creating threads manually like in below example, thread pools can be used. In case of highly CPU-intensive requests, number of requests can be limited by queueing up those requests in a thread pool that guarantees that onlya few of those expensive operations will happen concurrently.

```java
import javax.ws.rs.container.AsyncResponse;
import javax.ws.rs.container.Suspended;

@Path("/orders")
public class OrderResource {
  @POST
  @Consumes("application/json")
  @Produces("application/json")
  public void submit(final Order order, final @Suspended AsyncResponse response) {
     new Thread() {
       public void run() {
         OrderConfirmation confirmation = null;
         try {
           confirmation = orderProcessor.process(order);
         } catch (Exception ex) {
           response.resume(ex);
           return;
         }
         response.resume(order);
       }
     }.start();
  }
}
```

## Exception Handling

**HTTP Response Codes**

* 100 to 199 - Informational response codes
* 200 to 299 - successful response codes
  * 200, "OK"
  * 204, "No Content"
* 300 to 399 - Redirection codes
* 400 to 499 - client error codes
  * 404, "Not Found"
  * 405, "Method Not Found" - if client invokes an HTTP method on a valid URI to which no JAX-RS resource method is bound. *The exception to this rule is the HTTP HEAD and OPTIONS methods. If a JAX-RS resource method isn't available that can service HEAD requests for that particular URI, but can GET there does exist a method that can handle GET, JAX-RS will invoke the JAX-RS resource method that handles GET and return the response from that minus the request body. If there is no existing method that can handle OPTIONS, the JAX-RS implementation is required to send back some meaningful, automatically generated response along with the Allow header set.*
  * 406, "Not Acceptable" - say, if the client requets a response format that is not supported/implemented
* 500 to 599 - server error codes

**Exception Handling**

* Errors can be reported to a client either by creating and returning the appropriate `Response` object or by throwing an exception. 
* Application code is allowed to throw any checked (classes extending `java.lang.Exception`) or unchecked (classes extending `java.lang.RuntimeException`) exceptions they want. 

* **Exception Mappers**
  * Thrown exceptions are handled by the JAX-RS runtime if you have registered an exception mapper. 
  * Exception mappers can convert an exception to an HTTP response. If the thrown exception is not handled by a mapper, it is propagated and handled by the container (i.e., servlet) JAX-RS is running within.
  * JAX-RS also provides the `javax.ws.rs.WebApplicationException`. If the application code throws this exception, JAX-RS can process it without explicitly registering a mapper.
  * Catching and throwing all application exceptions wrapped up in `WebApplicationException` is tedious. Alternatively, one can implement `ExceptionMapper` to map an application exception to a `Response` object

```java ExceptionMapper Interface
public interface ExceptionMapper<E extends Throwable> {
  Response toResponse(E exception);
}
```

  * `ExceptionMapper` implementation must be annotated with `@Provider` to tell JAX-RS runtime that it is a component.
  * JAX-RS supports exception inheritance as well. When an exception is thrown, JAX-RS will first try to find an ExceptionMapper for that exception’s type. If it cannot find one, it will look for a mapper that can handle the exception’s superclass. It will continue this process until there are no more superclasses to match against.

```java Example Mapper
@Provider
public class EntityNotFoundMapper implements ExceptionMapper<EntityNotFoundException> {
  public Response toResponse(EntityNotFoundException e) {
    return Response.status(Response.Status.NOT_FOUND).build();
  }
}
```

## Conneg (Content Negotiation)

[HTTP Conneg Basics](/technology/webconcepts.html#http-content-negotiation-conneg)

# Pagination

* While designing a REST API capable of returning vast datasets, it is important to limit the amount of data returned for bandwidth and performance reasons. 
* The bandwidth concerns become more important in the case of mobile clients consuming the API. 
* Limiting the data can vastly improve the server’s ability to retrieve data faster from a datastore and the client’s ability to process the data and render the UI. By splitting the data into discrete pages or paging data, REST services allow clients to scroll through and access the entire dataset in manageable chunks.

There are 4 different pagination styles.

## 1. Page Number Pagination

* The clients specify a page number containing the data they need. For example, a client wanting all the blog posts in page 3 of a blog service, can use the following `GET` method: `http://blog.example.com/posts?page=3`
* The REST service in this scenario would respond with a set of posts. The number of posts returned depends on the default page size set in the service. 
* It is possible for the client to override the default page size by passing in a page-size parameter: `http://blog.example.com/posts?page=3&size=20`
* GitHub’s REST services use this pagination style. By default, the page size is set to 30 but can be overridden using the per page parameter: https://api.github.com/user/repos?page=2&per_page=100

## 2. Limit Offset Pagination

* The clients uses two parameters to retrieve the data that they need. 
  * a **limit** - indicates the maximum number of elements to return
  * an **offset** indicates the starting point for the return data. 
( For example, to retrieve 10 blog posts starting from the item number 31, a client can use the following request: `http://blog.example.com/posts?limit=10&offset=30`

## 3. Cursor-based Pagination

* The clients make use of a pointer or a cursor to navigate through the data set.
* A cursor is a service-generated random character string that acts as a marker for an item in the data set.
* Consider a client making the following request to get blog posts: `http://blog.example.com/posts`. On receiving the request, the service would send data similar to this:

```json
{
  "data" : [
  ... Blog data
  ],
  "cursors" : {
    "prev" : null,
    "next" : "123asdf456iamcur"
  }
}
```

* This response contains a set of blogs representing a subset of the total dataset. 
* The cursors that are part of the response contains a `prev` & `next` fields to get the previous and next subset of the data. E.g., `http://api.example.com/posts?cursor=123asdf456iamcur`
* This pagination style is used by applications such as Twitter and Facebook that deal with real-time datasets (tweets and posts) where data changes frequently. 
* The generated cursors typically don’t live forever and should be used for short-term pagination purposes only.

## 4. Time-base Pagination

* The client specifies a timeframe to retrieve the data in which they are interested.
* Facebook supports this pagination style and requires time specified as a Unix timestamp. These are two Facebook example requests:
  * `https://graph.facebook.com/me/feed?limit=25&until=1364587774` - specifies the end of the time range
  * `https://graph.facebook.com/me/feed?limit=25&since=1364849754` - specifies the beginning of the time range

## Pagination Data

* All the above pagination styles return only a subset of the data. So, in addition to supplying the requested data, it is also important for the service to communicate pagination-specific information such as total number of records or total number of pages or current page number and page size. 
* The following example shows a response body with pagination information:

```json
{
  "data": [
    ... Blog Data
  ],
  "totalPages": 9,
  "currentPageNumber": 2,
  "pageSize": 10,
  "totalRecords": 90
}
```

* Clients can use the pagination information to assess the current state as well as construct URLs to obtain the next or previous datasets. 
* The other technique services employ is to include the pagination information
in a special `Link` header. The Link header is defined as part of [RFC 5988](http://tools.ietf.org/html/rfc5988). It typically contains a set of ready-made links to scroll forward and backward.  GitHub uses this approach; here is an example of a Link header value:

`Link: <https://api.github.com/user/repos?page=3&per_page=100>; rel="next", <https://api.github.com/user/repos?page=50&per_page=100>; rel="last"`

# Scalability

## Caching

* **Browser Cache** is one of the more important features of the Web. When you visit a website for the first time, your browser stores images and static text in memory and on disk. If you revisit the site within minutes, hours, days, or even months, your browser doesn’t have to reload the data over the network and can instead pick it up locally. This greatly speeds up the rendering of revisited web pages and makes the browsing experience much more fluid. Browser caching not only helps page viewing, it also cuts down on server load and reduced network traffic.
* **Proxy caches** are pseudo–web servers that work as middlemen between browsers and websites. Their sole purpose is to ease the load on master servers by caching static content and serving it to clients directly, bypassing the main servers. Content delivery networks (CDNs) like Akamai have made multimillion-dollar businesses out of this concept. These CDNs provide you with a worldwide network of proxy caches that you can use to publish your website and scale to hundreds of thousand of users.

* REST services can leverage the browser & proxy cache, if the HTTP constrained interface is followed religiously. Because any service URI that can be reached with an HTTP GET is a candidate for caching, as they are read-only and idempotent. 

## HTTP Caching

HTTP protocol gives fine-grained control over the caching behavior of both browser and proxy caches.

**HTTP 1.0 style Expires Header**

In the example below, *Expires* field in the header tells the browser that the response can be cached until the date & time provided. After expiry, the client should re-fetch the data from server.

```http HTTP 1.0 Response
HTTP/1.1 200 OK
Content-Type: application/xml
Expires: Tue, 15 May 2014 16:00 GMT
<customer id="123">...</customers>
```

```java JAX-RS example of setting expires
@Path("/customers")
public class CustomerResource {
  @Path("{id}")
  @GET
  @Produces("application/xml")
  public Response getCustomer(@PathParam("id") int id) {
    Customer cust = findCustomer(id);
    Date date = Calendar.getInstance(TimeZone.getTimeZone("GMT")).set(2010, 5, 15, 16, 0);
    
    return Response.ok(cust, "application/xml").expires(date).build();
  }
}
```

**HTTP 1.1 style Cache-Control**

HTTP 1.1 provides richer feature set over browser and CDN/proxy caches including cache revalidation. 

```http HTTP 1.1 Response
HTTP/1.1 200 OK
Content-Type: application/xml
Cache-Control: private, no-store, max-age=300
<customers>...</customers>
```

```java JAX-RS example setting cache-control
@Path("/customers")
public class CustomerResource {
  @Path("{id}")
  @GET
  @Produces("application/xml")
  public Response getCustomer(@PathParam("id") int id) {
    Customer cust = findCustomer(id);
    CacheControl cc = new CacheControl();
    cc.setMaxAge(300);
    cc.setPrivate(true);
    cc.setNoStore(true);
    
    return Response.ok(cust, "application/xml").cacheControl(cc).build();
  }
}
```

| Cache Control Directive | Description |
| `private` | The private directive states that no shared intermediary (proxy or CDN) is allowed to cache the response. This is a great way to make sure that the client, and only the client, caches the data.| 
| `public` | The public directive is the opposite of private. It indicates that the response may be cached by any entity within the request/response chain. | 
| `no-cache` | Usually, this directive simply means that the response should not be cached. If it is cached anyway, the data should not be used to satisfy a request unless it is revalidated with the server (more on revalidation later).| 
| `no-store` | A browser will store cacheable responses on disk so that they can be used after a browser restart or computer reboot. You can direct the browser or proxy cache to not store cached data on disk by using the no-store directive. | 
| `no-transform` | Some intermediary caches have the option to automatically transform their cached data to save memory or disk space or to simply reduce network traffic. An example is compressing images. For some applications, you might want to disallow this using the no-transform directive.
| `max-age` | This directive is how long (in seconds) the cache is valid. If both an Expires header and a max-age directive are set in the same response, the max-age always takes precedence.| 
| `s-maxage` | The s-maxage directive is the same as the max-age directive, but it specifies the maximum time a shared, intermediary cache (like a proxy) is allowed to hold the data. This directive allows you to have different expiration times than the client.| 


**Revalidation and Conditional GETs**

* *Revalidation* - when the cache is stale, the cacher can ask the server if the data it is holding is still valid. To perform revalidation, the server will send back a `Last-Modified` and/or an `ETag` (entity tag) header with its initial response to the client.

* *Last-Modified*
  * represents a timestamp of the data sent by the server. 

```http Response header with Last-Modified
HTTP/1.1 200 OK
Content-Type: application/xml
Cache-Control: max-age=1000
Last-Modified: Tue, 15 May 2013 09:56 EST
<customer id="123">...</customer>
```
  * As in example below, after 1000 seconds, client may opt to revalidate its cache data by sending a *conditional GET* request by passing a request header called `If-Modified-Since` with the value of the cached `Last-Modified` header.
  * When a service receives this GET request, it checks to see if its resource has been modified since the date provided within the `If-Modified-Since` header. If it has been changed since the timestamp provided, the server will send back a `200, “OK,”` response with the new representation of the resource. If it hasn’t been changed, the server will respond with `304, “Not Modified,”` and return no representation. In both cases, the server should send an updated `Cache-Control` and `Last-Modified` header if appropriate.

```http
GET /customers/123 HTTP/1.1
If-Modified-Since: Tue, 15 May 2013 09:56 EST
```

* *ETag*

The ETag header is a pseudounique identifier that represents the version of the data sent back. Its value is any arbitrary quoted string and is usually an MD5 hash. Here’s an example response:

```http Response header with ETag
HTTP/1.1 200 OK
Content-Type: application/xml
Cache-Control: max-age=1000
ETag: "3141271342554322343200"
<customer id="123">...</customer>
```

  * As in example below, after 1000 seconds, client may opt to revalidate by sending a *conditional GET* request by passing `If-None-Match` in header with the same has value.
  * If the tags don’t match, the server will send back a `200, “OK,”` response with the new representation of the resource. If it hasn’t been changed, the server will respond with `304, “Not Modified,”` and return no representation. In both cases, the server should send an updated `Cache-Control` and `ETag` header if appropriate.
  * A *strong ETag* should change whenever any bit of the resource’s representation changes. 
  * A *weak ETag* changes only on semantically significant events. Weak ETags are identified with a *W/*prefix. e.g., `ETag: W/"3141271342554322343200"`
  * `Last-Modified` and `ETag` can be used for concurrency control as well. In other words, when 2 clients are trying to update the same resource, these header values can be used to conditionally update only if the server value hasn't changed since. (This is called *Optimistic Concurrency Control*)

```http
GET /customers/123 HTTP/1.1
If-None-Match: "3141271342554322343200"
```

## Reverse proxy

* One of the best way to cache your API is to put a gateway cache (or reverse proxy) in front of it. Some frameworks provide their own reverse proxies, but a very powerful, open-source one is [Varnish](https://www.varnish-cache.org/).
* When a safe method is used on a resource URL, the reverse proxy should cache the response from the API. It will then use this cached response to answer all subsequent requests for the same resource before they hit the API. When an unsafe method is used on a resource URL, the cache ignores it and passes it to the API. The API is responsible for making sure that the cached resource is invalidated.
* HTTP has an unofficial `PURGE` method that is used for purging caches. When an API receives a call with an unsafe method on a resource, it should fire a `PURGE` request on that resource so that the reverse proxy knows that the cached resource should be expired. Note that you will still have to configure your reverse proxy to actually remove a resource when it receives a request with the PURGE method.

```http
GET /article/1234 HTTP/1.1
   - The resource is not cached yet
   - Send request to the API
   - Store response in cache and return

GET /article/1234 HTTP/1.1
   - The resource is cached
   - Return response from cache

PUT /article/1234 HTTP/1.1
   - Unsafe method, send to API

PURGE /article/1234 HTTP/1.1
   - API sends PURGE method to the cache
   - The resources is removed from the cache

GET /article/1234 HTTP/1.1
   - The resource is not cached yet
   - Send request to the API
   - Store response in cache and return
```


# Security

[Basics of Security](/technology/security.html)

## Authentication

* To enable authentication, modify the */WEB-INF/web.xml* file in the war file deployed.
* Value of `<auth-method>` could be `BASIC`, 'DIGEST' or `CLIENT_CERT`
* The `<login-config>` element doesn’t turn on authentication. To enforce authentication, you must specify a URL pattern you want to secure. e.g., `<url-pattern>/services/customers</url-pattern>`
* The `<http-method>` element says that we only want to secure POST requests to this URL. If we leave out this element, all HTTP methods are secured.
* `<auth-constraint>` specifies which roles are allowed to POST to `/services/customers`
* `<role-name>` - If you set this to `*` then it means anybody who is able to log in can access the constrained URL. Authentication with a valid user would still be required, though. 
* *Limitation* - When declaring `<security-constraints>` for JAXRS resources, the `<url-pattern>` element does not have as rich an expression syntax as JAX-RS `@Path` annotation values. It supports only simple wildcard matches via the `*` character. No regular expressions like `/*`, `/foo/*` or `*.txt` are supported. 

```xml Sample web.xml file
<?xml version="1.0"?>
<web-app>
  <security-constraint>
    <web-resource-collection>
      <web-resource-name>customer creation</web-resource-name>
      <url-pattern>/services/customers</url-pattern>
      <http-method>POST</http-method>
    </web-resource-collection>
    <auth-constraint>
      <role-name>admin</role-name>
    </auth-constraint>
  </security-constraint>
  <login-config>
    <auth-method>BASIC</auth-method>
    <realm-name>jaxrs</realm-name>
  </login-config>
  <security-role>
    <role-name>admin</role-name>
  </security-role>
</web-app>
```

* **Enforcing Encryptiong (HTTPS)** - To enforce HTTPS access for these constraints, specify a `<user-data-constraint>` as shown here. If a user tries to access the URL pattern with HTTP, she will be redirected to an HTTPS-based URL

```xml Enforcing HTTPS
<security-constraint>
  ...
  <user-data-constraint>
    <transport-guarantee>CONFIDENTIAL</transport-guarantee>
  </user-data-constraint>
</security-constraint>
```

## Authorization

* The server and application know the permissions for each user and do not need to share this information over a communication protocol. This is why authorization is the domain of the server and application
* JAX-RS relies on the servlet and Java EE specifications to define how authorization works. Authorization is performed in Java EE by associating one or more roles with a given user and then assigning permissions based on that role.
* You do not assign access control on a per-user basis, but rather on a per-role basis.

* Authorization can be enabled through XML or by applying annotations to JAX-RS resource classes

**Authorization Annotations**

* Java EE defines a set of following annotations in package `javax.annotation.security` :  
  * `@RolesAllowed` - defines the roles permitted to execute a specific method or defines the default ACL (Access Control List) for all HTTP operations. 
  * `@DenyAll`
  * `@PermitAll`
  * `@RunAs`

* Pros
  * Annotations allow to express fine-grained constraints that are not possible in *web.xml* because of the limited expression capabilities of `<url-pattern>`
  * Allows to apply constraints at method-level using these annotations.

* Cons
  * Specify security related annotations within business logic code is a leakage of concern. To add or remove role constraints periodically, one has to recompile the whole application.

```java
@Path("/customers")
@RolesAllowed({"ADMIN", "CUSTOMER"})
public class CustomerResource {
  @GET
  @Path("{id}")
  @Produces("application/xml")
  public Customer getCustomer(@PathParam("id") int id) {...}
  
  @RolesAllowed("ADMIN")
  @POST
  @Consumes("application/xml")
  public void createCustomer(Customer cust) {...}
  
  @PermitAll
  @GET
  @Produces("application/xml")
  public Customer[] getCustomers() {}
}
```

# Versioning


[Excellent article - Nobody Understands REST or HTTP](http://blog.steveklabnik.com/posts/2011-07-03-nobody-understands-rest-or-http)

* There is no established industry standard for expressing versioning information for REST service contracts. We need to select a convention that works best for our IT enterprise.

4 popular approaches to versioning a REST API. 

1. URI versioning
2. URI parameter versioning
3. Accept header versioning
4. Custom header versioning

## URI versioning

* In this approach, version information becomes part of the **Base URI**. For example, http://api.example.org/v1/users and http://api.example.org/v2/users represent two different versions of an application API.
* It is used by major public APIs such as Twitter, LinkedIn, Yahoo, etc. 
  * LinkedIn: https://api.linkedin.com/v1/people/~
  * Yahoo: https://social.yahooapis.com/v1/user/12345/profile
  * Twitter: https://api.twitter.com/1.1/statuses/user_timeline.json
  * SalesForce: http://na1.salesforce.com/services/data/v26.0
  * Twilio: https://api.twilio.com/2010-04-01/Accounts/{AccountSid}/Calls
* Version Type
  * Twitter and LinkedIn used `v` notation. 
  * Salesforce uses major + minor version
  * Twilio uses datestamp to differentiate

* Pros
  * Clean sweep approach. Replicate the entire code base and maintain parallel code paths for each version.
  * Easy to implement
* Cons
  * If client stores the permalinks locally, then for every upgrade it needs to be updated

## URI parameter versioning

* Similar to the URI versioning except that the version information is specified as a URI request parameter. E.g., http://api.example.org/users?v=2 
* The version parameter is typically optional and a default version of the API will continue working for requests without version parameter. Most often, the default version is the latest version of the API. 
* Although as not popular as other versioning strategies, a few major public APIs such as Netf lix have used this strategy. 

* Cons
  * The URI parameter versioning shares the same disadvantages of URI versioning. 
  * Some proxies don’t cache resources with a URI parameter, resulting in additional network traffic. 

## Accept header versioning

* This approach uses the *Accept* header to communicate version information. Because the header contains version information, there will be only one URI for multiple versions of API.
* To pass additional version information, we need a custom media type. The following convention is popular when creating a custom media type: `vnd.product_name.version+suffix`
  * The **vnd** is the starting point of the custom media type and indicates vendor. 
  * The **product** or producer name is the name of the product and distinguishes this media type from other custom product media types.
  * The **version** part is represented using strings such as v1 or v2 or v3. 
  * Finally, the **suffix** is used to specify the structure of the media type. For example, the `+json` suffix indicates media type `application/json`. [RFC 6389](https://tools.ietf.org/html/rfc6839) gives a full list of standardized prefixes such as `+xml`, `+json`, and `+zip`. 
* Using this approach, a client, for example, can send an `application/vnd.quickpoll.v2+json` accept header to request the second version of the API.
* GitHub is a popular public API that uses this *Accept* header strategy. For requests that don’t contain any Accept header, GitHub uses the latest version of the API to fulfill the request.

```http
Accept: application/vnd.company.myapp-v3.0+json
Content-Type: application/vnd.company.myapp-v3.0+json 
```

* Pros
  * Only one URI for multiple versions of API
  * The Accept header versioning approach is becoming more and more popular as it allows fine-grained versioning of individual resources without impacting the entire API. 
* Cons
  * This approach can make browser testing harder as we have to carefully craft the Accept header.

## Custom header versioning

* The custom header versioning approach is similar to the Accept header versioning approach except that, instead of the Accept header, a custom header is used. 
* Microsoft Azure takes this approach and uses the custom header `x-ms-version`. For example, to get the latest version of Azure (at the time of writing this),  your request needs to include a custom header:

```http
x-ms-version: 2014-02-14
```

This approach shares the same pros and cons as that of the Accept header approach. Because the HTTP specification provides a standard way of accomplishing this via the Accept header, the custom header
approach hasn’t been widely adopted.


# Transactions

How do I perform atomic operations using REST? If I would like to execute multiple operations, but have them all appear as an single, atomic transaction, REST seems inappropriate.

__Low Granularity Services Approach__

REST faces the exact same problem as SOAP-based web services with regards to atomic transactions. There is no stateful connection, and every operation is immediately committed; performing a series of operations means other clients can see interim states.

Unless, of course, you take care of this by design. First, ask yourself: do I have a standard set of atomic operations? This is commonly the case. For example, for a banking operation, removing a sum from one account and adding the same sum to a different account is often a required atomic operation. But rather than exporting just the primitive building blocks, the REST API should provide a single "transfer" operation, which encapsulates the entire process. This provides the desired atomicity, while also making client code much simpler. This approach is known as *low granularity services*, or *high-level batch operations*.

__Batch Command Pattern__

If there is no simple, pre-defined set of desired atomic operation sequences, the problem is more severe. A common solution is the **batch command pattern**. Define one REST method to demarcate the beginning of a transaction, and another to demarcate its end (a 'commit' request). Anything sent between these sets of operations is queued by the server but not committed, until the commit request is sent.

This pattern complicates the server significantly -- it must maintain a state per client. Normally, the first operation ('begin transaction') returns a transaction ID (TID), and all subsequent operations, up to and including the commit, must include this TID as a parameter.

It is a good idea to enforce a timeout on transactions: if too much time has passed since the initial 'begin transaction' request, or since the last step, the server has the right to abort the transaction. This prevents a potential DoS attack that causes the server to waste resources by keeping too many transactions open. The client design must keep in mind that each operation must be checked for a timeout response.

It is also a good idea to allow the client to abort a transaction, by providing a 'rollback' API.

The usual care required in designing code that uses multiple concurrent transactions applies as usual in this complex design scenario. If at all possible, try to limit the use of transactions, and support high-level batch operations instead.


# Other REST Frameworks

Java Web Service APIs include:

* HttpServlet and its equivalents (e.g., JSP scripts)
* JAX-RS (Java API for RESTful services) - Jersey is the reference implementation
* Restlet, which is similar in style to JAX-RS
* JAX-WS (Java API for Web Services) which is a relatively low-level API. Metro is the reference implementation.

## Servlet based Web Services

JAX-RS and Restlet are roughly peers (arguably). Both of these APIs emphasize the use of Java annotations to describe the RESTful access to a particular CRUD operation. Each framework supports the automated generation of XML and JSON payloads. When published with a web server such as Tomcat or Jetty, JAX-RS and Restlet provide servlet interceptors that mediate between the client and the web service.

## RESTlet 

* The Restlet web framework supports RESTful web services, and the API is similar to JAX-RS; indeed, a Restlet application can use JAX-RS annotations such as @Produces instead of or in addition to Restlet annotations.
* A Restlet web service has three main parts, each of which consists of one or more Java classes:
  * A programmer-defined class, in this example AdagesApplication, extends the Restlet Application class. The purpose of the extended class is to set up a routing table, which maps request URIs to resources. The resources are named or anonymous Java classes; the current example illustrates both approaches. The spirit of Restlet development is to have very simple resource classes.
  * There are arbitrarily many resource classes, any mix of named or anonymous. In best practices, a resource implementation supports a very small number of operations on the resource—in the current example, only one operation per resource. For example, the adages2 service has seven resources: six of these are named classes that extend the Restlet ServerResource class and the other is an anonymous class that implements the Restlet interface. The named classes are CreateResource, the target of a POST request; UpdateResource, the target of a PUT request; XmlAllResource, the target of a GET request for all Adages in XML; JsonAllResource, the target of a GET request for all Adages in JSON; XmlOneResource, the target of a GET request for a specified Adage; and so on.
  * The backend POJO classes are Adage and Adages, each slightly redefined from the earlier adages web service.
* These APIs also mimic the routing idioms that have become so popular because of frameworks such as Rails and Sinatra.

## JAX-WS API

* JAW-WS is an API used mostly for SOAP-based services but can be used for REST-style services as well. In the latter case, the `@WebServiceProvider` annotation is central. The `@WebServiceProvider` interface is sufficiently flexible that it can be used to annotate either a SOAP-based or a REST-style service; however, JAX-WS provides a related but higher level annotation, `@WebService`, for SOAP-based services. The `@WebServiceProvider` API is deliberately lower level than the servlet, JAX-RS, and Restlet APIs, and the `@WebServiceProvider` API is targeted at XML-based services. For programmers who need a low-level API, Java supports the `@WebServiceProvider` option. JAX-RS, Restlet, and `@WebServiceProvider` have both service-side and client-side APIs that can be used independently of one another. For example, a Restlet client could make calls against a JAX-RS service or vice versa.
* JAX-RS and Restlet are state-of-the-art, high-level APIs for developing RESTful services; by contrast, the JAX-WS API for RESTful services is low-level. Nonetheless, JAX-WS support for RESTful services deserves a look.

Following are the JAX-WS Implementations

### Metro

* [Metro](http://www.oracle.com/technetwork/java/index-jsp-137051.html) is the reference implementation of JAX-WS API and is part of the GlassFish project. Although JAX-WS technically belongs to enterprise rather than core Java, the core Java JDK (1.6 or greater) includes enough of the Metro distribution to compile and publish RESTful and SOAP-based services. 
* integrated web services stack provided by Oracle Java. 
* Metro stack consisting of JAX-WS, JAXB, and WSIT (Web Services Interoperability Technologies), enable you to create and deploy secure, reliable, transactional, interoperable Web services and clients.

### Apache CXF

* Apache CXF is an open source services framework. CXF helps you build and develop services using frontend programming APIs, like JAX-WS and JAX-RS. These services can speak a variety of protocols such as SOAP, XML/HTTP, RESTful HTTP, or CORBA and work over a variety of transports such as HTTP, JMS or JBI.
* Features: Generating WSDL from Java and vice-versa, Spring support, OSGi support, WS-* support, proprietary Aegis Databinding (similar to JAXB), RESTful services

### Apache Axis2

* a Web Services / SOAP / WSDL engine
* Features: proprietary ADB Databinding (faster than CXF)

# Open Questions

* There are no annotations in JAX-RS to express hyperlinks. You have to design those yourself. what does that mean?
* URL opacity - http://www.zapthink.com/2012/10/08/the-power-of-opacity-in-rest/ 
* REST service - Proxy XJC
	* WADL & XJC
	* Handling Breaking changes - xsd or wsdl changes
	* Authentication - WS-Policy, WS-Security
	* Things to try using JAX-RS
		* how to time out a client
		* how to restrict number of clients accessing the service
		* how to implement pagination - Linking Services

# References

* Books
  * Building Web Services with Java (2E)
  * Java Web Services - Up & Running - O'Reilly 2013
  * RESTful Java with JAX-RS -2010
  * RESTful Java with JAX-RS 2.0 -2013
  * RESTful Web APIs - O'Reilly 2013
  * Spring REST
  * Web Services Testing with soapUI (2012)