---
layout: page
title: "JNDI"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}


# Overview

* A naming service associates names with distributed objects, files, and devices so that they can be located on the network using simple names instead of cryptic network address. An example of a naming service is the DNS, which converts an Internet hostname like www.google.com into a network address that browsers use to connect to web servers.
* Naming services allow printers, distributed objects, and JMS administered objects to be bound to names and organized in a hierarchy similar to a filesystem.
* A directory service is a more sophisticated kind of naming service.

# JNDI

* JNDI (Java Naming & Directory Interface) is a standard Java extension that provides a uniform API for accessing a variety of naming & directory services.
* JNDI lets you write code that can access different directory and naming services like LDAP, NDS, CORBA Naming Service, and proprietary naming services provided by JMS servers.
* JNDI is both virtual and dynamic. 
  * It is virtual because it allows one naming service to be linked to another. Using JNDI, you can drill down through directories to files, printers, JMS administered objects, and other resources following virtual links between naming services. The user doesn’t know or care where the directories are actually located. As an administrator, you can create virtual directories that span a variety of different services over many different physical locations.
  * JNDI is dynamic because it allows the JNDI drivers for specific types of naming and directory services to be loaded dynamically at runtime. A driver maps a specific kind of naming or directory service into the standard JNDI class interfaces. Drivers have been created for LDAP, Novell NetWare NDS, Sun Solaris NIS+, CORBA CosNaming, and many other types of naming and directory services, including proprietary ones. Dynamically loading JNDI drivers (service providers) makes it possible for a client to navigate across arbitrary directory services without knowing in advance what kinds of services it is likely to find.


``` java Sample jndi.properties
 java.naming.factory.initial = org.apache.activemq.jndi.ActiveMQInitialContextFactory
 java.naming.provider.url = tcp://localhost:61616
 java.naming.security.principal=system
 java.naming.security.credentials=manager

 connectionFactoryNames = TopicCF
 topic.topic1 = jms.topic1
 ```