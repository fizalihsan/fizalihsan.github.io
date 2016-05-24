---
layout: page
title: "Web Concepts"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# HTTP

## HTTP Basics
* Browser-based web applications see only a tiny fraction of the features of HTTP. 
* Non-RESTful technologies like SOAP and WS-* use HTTP strictly as a transport protocol and thus use a very small subset of its capabilities. Many would say that SOAP and WS-* use HTTP solely to tunnel through firewalls
* HTTP Request has 4 parts:  the method, the target URL, the HTTP headers, and the entity-body.
  * HTML `<a>` tag: has URL and the HTTP method(implicitly definied by HTML spec)
  * HTML form: has all 4 parts in it.
  * URI Template: only has the URL part. It defines nothing about the HTTP request except for the target URI. It’s not telling you to make a GET request,   a POST request, or any kind of request in particular. That’s why URI Templates   don’t make sense on their own.

## HTTP Methods

HTTP has its well-known verbs, officially known as methods or protocol semantics. HTTP verbs 1 to 4 correspond to the CRUD (Create, Read, Update, Delete) operations. 5, 6 are used by clients to explore an API. 

 #  | HTTP verb  | CRUD operation  | Safe  | Idempotent
 -  | ---------  | --------------  | ----  | ----------
 1  | POST       | Create          | No    | No
 2  | GET        | Read            | Yes   | Yes
 3  | PUT        | Update          | No    | Yes
 4  | DELETE     | Delete          | No    | Yes
 5  | HEAD       | Read            | Yes   | Yes
 6  | OPTION     |                 |       | 
 7  | CONNECT    |                 |       | 
 8  | TRACE      |                 |       | 
 9  | LINK       |                 | No    | Yes
 10 | UNLINK     |                 | No    | Yes
 
 Any GET request should be sideeffect free (idempotent) because a GET is a read rather than a create, update, or delete operation. A GET as a read with no side effects is called a 'safe GET'.

## HTTP Content Negotiation (Conneg)

Clients invoking the services could expect the response in various data formats, languages and encodings. HTTP Content Negotiation feature comes handy for such cases.

* Response Data Format
  * clients could specify the response format via "Accept". If the requested format is not supported, then 'not accepted' error is returned. 

```http
GET http://example.com/stuff
Accept: application/xml, application/json
```

  * specifying preference using wild cards. 

```http
GET http://example.com/stuff
Accept: text/*, text/html;level=1, */*, application/xml
```

  * Order of preference
    * when multiple preference are provided, the most specific types takes priority. In above example, 'text/html;level=1' takes precedence.
    * 'q' MIME type property could be used as well. Higher the q value, more preferred it is. Default q value is 1.0. e.g., `text/*;q=0.9, */*;q=0.1, audio/mpeg, application/xml;q=0.5`. 
* Language Negotiation

```http
GET http://example.com/stuff
Accept-Language: fr;q=1.0, es;q=1.0, en=0.1
```

* Encoding Negotiation

```http
GET http://example.com/stuff
Accept-Encoding: gzip;q=1.0, compress;0.5; deflate;q=0.1
```

## Caching

* Browser caching
* Proxy caches (CDNs)
* HTTP caching
  * Cache-control
    * private - shared intermediaries like proxy or CDNs cannot cache. Only clients can cache.
    * public - anyone can cache
    * no-cache - 
    * no-store - cached data is stored in disks.
    * no-transform - intermediary caches typically transforms data like images by compressing.
    * max-age - expiration time
    * s-maxage - expiration time for intermediary caches
  * Revalidation: When the cache is stale, the cacher can ask the server if the data it is holding is still valid. This is called revalidation. To be able to perform revalidation, the client needs some extra information from the server about the resource it is caching. The server will send back a Last-Modified and/or an ETag header with its initial response to the client. If the client supports revalidation, it will store this timestamp along with the cached data.

    * Last-Modified<br/>

```http
HTTP/1.1 200 OK
Content-Type: application/xml
Cache-Control: max-age=1000
Last-Modified: Tue, 15 May 2009 09:56
```


    * Conditional GET
       * the client may opt to revalidate its cache of the item. To do this it does a conditional GET request by passing a request header called If-Modified-Since with the value of the cached Last-Modified header. For example: 

```http
GET /customers/123 HTTP/1.1
If-Modified-Since: Tue, 15 May 2009 09:56 EST
```

* ETag or Entity Tag
  * The ETag header is a pseudounique identifier that represents the version of the data sent back. Its value is any arbitrary quoted string and is usually an MD5 hash. Here’s an example response:

```http
HTTP/1.1 200 OK
Content-Type: application/xml
Cache-Control: max-age=1000
ETag: "3141271342554322343200"
```

---


# Bibliography

* Books
  * RESTful Web APIs - OReilly 2013
  * HTTP - The Definitive Guide