---
layout: page
title: "XML"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

## DTD & XSD
* Commonly used DTDs - FpML, DocBook, HRML, RDF
* In XML DTD, how do you create an external entity reference in an attribute value? XML DTD dont support external entity reference in attribute values
* How would you build a search engine for large volumes of XML data?
* Diff b/w DTD & XML schema?
  * DTD doesn't have external entity reference
  * XSD supports data types
  * XSD supports namespaces - solves the problem of tag name conflicts
* Namespaces-
* XPath, XSLT, XLink, XPointer, XQuery

## XML Parsing
* Steps to parse an XML with an example - DOM & SAX - Event-based parser
* SAX (Sequential Access/Push)
  * Disadvantage—user must keep track of previous events
* DOM (Random Access/Pull)
  * Advantage—simple to find particular elements
* XMLPullParser (Sequential Access/Pull)
  * Advantage—flow may be familiar to more programmers
  * Disadvantage—may have more code than the other two alternatives
* Diff b/w DOM & SAX?
* Types
  * Validating & Non-validating parsers
  * Push parsers
    * Advantage—can be simpler code, once paradigm is understood
  * Pull parsers
    * Advantage—appears as a common control style (e.g., loop) in multiple languages


| | Sequential| Random | 
| -- | -- | -- |
| Push | SAX | None |
| Pull | XMLPullParser| DOM | 

## Data Binding

### What is XML Data Binding?
* http://www-128.ibm.com/developerworks/library/x-databdopt/
* What other XML binding tools are available? - Sun's JAXB, Castor
* Advantages
  * DOM generates an in-memory tree for the entire document. In cases where the document is very large, DOM becomes quite memory intensive and performance degrades substantially. XMLBeans scores well on performance by doing incremental unmarshalling and providing xget methods to access built-in schema data types.
  * SAX is less memory intensive compared to DOM. However SAX requires that developers write callback methods for event handlers. This is not required by XMLBeans.
  * JAXB and Castor are XML/Java technology binding technologies like XMLBeans, but none of these provide 100 percent schema support. One of the biggest advantages of XMLBeans is its nearly 100 percent support for XML Schema. Also, XMLBeans allow access to the full XML Infoset. This is useful because the order of the elements or comments might be critical for an application.
  * XMLBeans also provide for on-time validation of the XML instance being parsed.
  * XMLBeans include innovative features such as XML cursors and support for XQuery expressions.

### JAXB

### XMLBeans
