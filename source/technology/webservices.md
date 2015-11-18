---
layout: page
title: "Web Services"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Service Design Patterns

## API Styles

### 1. RPC API
      
Request/Response or Request/Acknowledge

### 2. Message API
* **Command Messages** [EIP] are used to ask the receiving system to carry out a specific task (e.g., process loan). 
* **Event Messages** [EIP] notify the receiver about interesting events (e.g., inventory was depleted)
* **Document Messages** [EIP] are like business documents (e.g., purchase orders).

### 3. Resource API

* POSTed requests can’t be cached by intermediaries.
* **Safe operations** are supposed to have no side effects. That is, they should not trigger write operations (i.e., creates, updates, or deletes). E.g., GET, HEAD, and OPTIONS.
* **Idempotence** means that no matter how many times a procedure is invoked with the same data, the same results should occur. GET, HEAD, PUT, DELETE, and OPTIONS are idempotent. POST, on the other hand, is not.

**Post-Once-Exactly Pattern**
For example, if a client sends the same order over and over again, the client shouldn’t have to worry about duplicate orders. This means that the service must differentiate one POST from another. The easiest approach is to have the client insert a unique key (i.e., identifier) into the request that is examined by the service before executing its main logic. If the service finds that it has already processed a request with the identifier, it can reject the new request. The problem is ensuring that these identifiers will indeed be unique. Another approach is to have the client query a service to retrieve a unique URI that may be used exclusively for the subsequent POST. This pattern is known as Post-Once-Exactly.

## Client-Service Interactions

**1. Request/Response**

**2. Request/Acknowledge**

Steps involved

* i. Receive the request.
* ii. Authenticate client credentials (optional).
* iii. Authorize the client for the requested operation (optional).
* iv. Validate the request (optional).
* v. Generate a Request Identifier or URI.
* vi. Store and forward the request.
* vii. Return an acknowledgment.

a. ***Request/Acknowledge/Poll***

* Client polls using the request identifier for the status update.
* Cons - Client polling too often for status could put excessive load on the server and cause network traffic.

b. ***Request/Acknowledge/Callbacks***
 Rather than having the client poll a second service for results, a request processor (i.e., background process) pushes information back to the client or forwards it to other parties. For this to happen, the client should have a service running that could be called. 

 The callback service details could be sent as part of the request or queried from a data store. However, when callback recipients are identified in the request, special precautions must be taken to ensure that they cannot be seen or altered by anyone except the authorized parties. The easiest way to protect the request is through Transport Layer Security (TLS).

*Cons*

* Complex to implement
* This pattern cannot be used if the client is unable to or unwilling to provide a publicly addressable callback service.
* Callback service could go down in which case the request processor should implement 'Idempotent Retry' pattern. 

**3. Media Type Negotiation**

**4. Linked Services**

## Request & Response Patterns

* **Service Controller** 
  * Receives requests, evaluate the request’s meaning, and route requests to procedures (i.e., class methods, request handlers), which implement the desired service behaviors.
  * When a web server receives a request, the framework (like JAX-RS) selects and invokes handlers by evaluating various aspects of the request against these expressions. The rules that define which handlers should be invoked for different requests are provided through annotations known collectively as ***Routing Expressions***.
  * This pattern also makes it easy to leverage data-binding technologies that automatically deserialize requests and serialize responses. The methods on Service Controllers can be
* **Request Mapper**
  * How can a service process data from requests that are structurally different yet semantically equivalent? 
* **Response Mapper**
  * How can the logic required to construct a response be reused by multiple services? 


## QoS (Quality of Service)

### How to reduce load on the server?

#### Service Interceptor pattern

An inbound interceptor may, for example, be configured to check to see if the requested data can be found in a distributed memory cache that is shared across web servers. If the requested information can be found in this cache, then the information may be returned directly from the interceptor, and the request handler will not be called.

Server load can be reduced by configuring Reverse Proxies to cache responses. In this case, the proxy evaluates the client’s criterion against its cache and will return a representation if the criterion is met. Regardless of the caching approach, the service owner must determine how long data may be kept in any cache before it is considered stale.

## Design Considerations for WS Implementation

The following factors should be considered when writing web service code.

* **Atomicity**: All web service operations should be atomic. Web services that are exposed to external business partners generally don’t support distributed transactions for reasons relating to security and scalability.
* **State management**: Always prefer stateless webservices. Managing session state of client not only leads to memory management issues, but also scalability issues. If required badly, use a distributed cache to store session data.
* **Service composition**: Avoid invoking other webservices from within a webservice. This is to alleviate issues like network latency, retry attempts when dependant service is down, etc.
* **Service Interceptor**
  * Security, logging, etc
  * Does Jersey provide any such interceptors?
    * logging interceptor
    * Exception handler interceptor

# Tools

* cUrl
* soapUI

# References

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

