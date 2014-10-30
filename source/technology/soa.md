---
layout: page
title: "SOA"
comments: true
sharing: true
footer: true
---

[TOC]



# Concepts

## What is SOA?

* SOA is a software system structuring principle based on the idea of self-describing service providers.
* a service is a function (usually a business function) that is accomplished by the interchange of messages between two entities: a service provider, and a service consumer. 
* SOA is just a methodology, an architectural design choice. It has nothing to do with a particular technology 
* It is a type of distributed computing 
* Web services is a realization of SOA 

## Why SOA?

* Reduces coupling between the consumer and provider. This permits controlled changes to the provider, that will not have unforeseen effects on the consumer. It also allows the consumer to switch providers easily, provided only that a compatible service interface is provided. Decoupling allows changes to occur incrementally.
* Increases inter-operability across different systems, technologies and languages like Java, .Net, etc.
* Since heavy monolithic systems are divided into discrete services, development, upgrade, etc. can happen independently.
* Reusability of services 
* Predecessors of SOA : CORBA, DCOM, EJB (all 3 are RPC based), SOAP based Web services 
* Downside of the SOA predecessors 
  * Interoperability across systems and technologies proved to be nettlesome. EJB & DCOM are tied to specific platforms
  * For data exchange, proprietary, binary-based technologies were used unlike XML in SOA
* Downsides of RPC based solutions 
  * tight coupling between server and client 
  * repeated RPC calls increases network load 
  * data type support between 2 incompatible languages, such as C++ and Java is complicated and challenging. 
  * When should SOA be used and should NOT be used?

## SOA Operations

{% img right /technology/soa-operations.png %}

1. Publish
2. Find
3. Bind

## Characteristics of contemporary SOA

1. QoS (Quality of Service) - security, reliability (in message delivery or notification), transactional capabilities (to protect the integrity of the business tasks)
* Autonomous - services should be independent and self-contained
* Based on Open Standards - Data exchange is governed by open standards like SOAP, WSDL, XML, etc.
* Promotes Discovery
* Interoperability - disparate technologies should not prevent service-oriented solutions from interoperating
* Composability - composing 1 or more fine-grained services to form a coarse-grained service. Different solutions can be composed of different extensions and can continue to interoperate as long as they support the common extensions required
* Reusability of services
* Extensibility of services
* Layers of abstraction - encapsulates application logic and technology resources
* Promotes loose-coupling - separation of concerns
* Stateless
* Location-, Language- & Protocol-independent

## Primitive SOA / First Generation Web-services Framework

### Service Roles

* Service Provider - who creates a service description and deploys it. (server side)
* Service Requestor / Service Consumer - who consumes the service
  * service provider entity - the organization providing the WS.
  * service provider agent - the web service itself.
* Service Registry - who publishes the service description. match maker between provider and requestor.
* Intermediary service (routing service)
  1. Passive Intermediary service - It is typically responsible for routing messages to a subsequent location. It may use information in the SOAP message header to determine the routing path, or it may employ native routing logic to achieve some level of load balancing. Either way, what makes this type of intermediary passive is that it does not modify the message.
  2. Active intermediaries - also route messages to a forwarding destination. Prior to transmitting a message, however, these services actively process and alter the message contents (Figure 5.7). Typically, active intermediaries will look for particular SOAP header blocks and perform some action in response to the information they find there. They almost always alter data in header blocks and may insert or even delete header blocks entirely. 
* Initial sender and ultimate receiver - Initial senders are simply service requestors that initiate the transmission of a message. Therefore, the initial sender is always the first Web service in a message path. The counterpart to this role is the ultimate receiver. This label identifies service providers that exist as the last Web service along a message's path
* Service Composition / Service Assemblies - A service can invoke one or more other services to complete a task. Each service participating in such composition is called as 'service composition member'. Service composition is frequently governed by WS-* composition extensions, such as WS-BPEL and WS-CDL, which introduce the related concepts of orchestration and choreography.

### Service Models

* Business service model
* Utility service model - a generic webservice designed for re-use and non-application specific in nature
* Controller service model - Service compositions are comprised of a set of independent services that each contribute to the execution of the overall business task. The assembly and coordination of these services is often a task in itself and one that can be assigned as the primary function of a dedicated service or as the secondary function of a service that is fully capable of executing a business task independently. The controller service fulfills this role, acting as the parent service to service composition members.

### Service Endpoint or Service Description (WSDL)

* Service Endpoint - A WSDL describes the point of contact for a service provider, also known as the service endpoint or just endpoint. It provides a formal definition of the endpoint interface and also establishes the physical location (address) of the service.
* 2 categories of WSDL Description
  1. Abstract description
    * Describes the interface characteristics of the Web service without any reference to the technology used to host.
    * It contains `portType` (or `interface` from WSDL 2.0), `operation` and `message`

``` xml WSDL Abstract description
<portType name="glossaryTerms">
  <operation name="setTerm">
    <input name="newTerm" message="newTermValues"/>
  </operation>
</portType >
```

  2. Concrete description - contains
    * Describes the concrete technology used for physical transport.
    * It contains
      * binding -  represents the transport technology the service can use to communicate. Typically it is SOAP. A binding can apply to a particular operation or all operations.
      * port (or endpoint from WSDL 2.0) - represents the physical address at which a service can be accessed with a specific protocol.
      * service

``` xml WSDL Concrete description
<binding type="glossaryTerms" name="b1">
   <soap:binding style="document"
   transport="http://schemas.xmlsoap.org/soap/http" />
   <operation>
     <soap:operation soapAction="http://example.com/getTerm"/>
     <input><soap:body use="literal"/></input>
     <output><soap:body use="literal"/></output>
  </operation>
</binding>
```

### Service Contract or Service Metadata 

A service contract is comprised of the following documents:

* WSDL definition
* XSD schema
* Policy document - provides rules, preferences, and processing details above and beyond what is expressed in WSDL & XSD.
* Other legal documents

# Bibliography

* Books
  * Service Oriented Architecture - Concepts, Technology and Design - Thomas Earl (2005)
* Sites
  * http://www.service-architecture.com/articles/web-services/index.html
  * http://www.servicetechbooks.com/
  * http://www.servicetechspecs.com
  * http://www.serviceorientation.com
  * http://www.soaglossary.com
  * http://www.whatisrest.com
  * http://www.servicetechmag.com
