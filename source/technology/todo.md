---
layout: page
title: "TODO - Topics to learn in-depth"
comments: false
sharing: false
footer: false
---

* list element with functor item
{:toc}

* Algorithms
	* List sorting algorithms
	* String paths - backtracking algorithms
* Architecture
	* Shared nothing architecture
	* SEDA
* Cloud computing
	* What are the things to do to migrate an application to cloud? or How do you design an application to be cloud-native?
* Coding principles
	* Command Query Separation
* Datastructures.md
	* Skiplist
	* Self-balanced tree
	* Splay tree
	* Graphs
* Db Design
	* Time-series database
* Db performance
	* Lock type - update lock
	* Row-wide partitioning
	* Column-wide partitioning
	* DB Replication (HADR)
* Distributedcomputing
  * Types of protocols like *full strict quorum protocols*
  * Read about [Paxos](http://harry.me/blog/2014/12/27/neat-algorithms-paxos/), [Raft](https://ramcloud.stanford.edu/raft.pdf) or viewstamped replication. ( [A primer on consensus](http://harry.me/blog/2013/07/07/id-like-to-have-an-argument-a-primer-on-consensus/))
* Elasticsearch
	* learn this in-depth
* Functional programming
	* Persistent Data structures (STM)
	* Loan Pattern
* Groovy
	* Concurrency
	* DSL
	* Double dispatch
	* Expando
	* How coercion works

```
Point p = [1,2]
println p

Point p2 = [x:1, y:2]
println p2
```

* Java concurrency
	* Exchanger
	* Phaser
	* StampedLock
	* CompletableFuture
	* Java Memory Model
	* Actor, STM
	* LMAX Disruptor
	* How to unit test concurrent programs
	* Collections [happen-before](http://docs.oracle.com/javase/7/docs/api/java/util/concurrent/package-summary.html#MemoryVisibility)
	* Concurrency issues - missed signal and fairness
* Java database
	* JPA
	* `javax.sql.rowset.WebRowSet`
	* Connection.isHoldability?
* Java IO
	* Buffers, Channels, Selectors
* Java JMX
	* [Monitoring key JVM characteristics](http://marxsoftware.blogspot.com/2013/03/monitoring-key-jvm-characteristics-groovy-jmx.html)
* Java Performance
	* GC in-depth
		* [1. Becoming a Java GC Expert - Understanding Java Garbage Collection](http://www.cubrid.org/blog/dev-platform/understanding-java-garbage-collection/)
		* [2. Becoming a Java GC Expert - How to monitor Java GC](http://www.cubrid.org/blog/dev-platform/how-to-monitor-java-garbage-collection/)
		* [3. Becoming a Java GC Expert - How to tune Java GC](http://www.cubrid.org/blog/dev-platform/how-to-tune-java-garbage-collection/)
		* [4. Becoming a Java GC Expert - MaxClients in Apache and its effect on Tomcat during Full GC](http://www.cubrid.org/blog/dev-platform/maxclients-in-apache-and-its-effect-on-tomcat-during-full-gc/)
		* [5. Becoming a Java GC Expert - The Principles of Java Application Performance Tuning](http://www.cubrid.org/blog/dev-platform/the-principles-of-java-application-performance-tuning/)
		* [How Statement Pooling in JDBC affects the Garbage Collection](http://www.cubrid.org/blog/dev-platform/how-statement-pooling-in-jdbc-affects-garbage-collection/)
	* How G1 collector works
* Java
	* Dates
		* [TimeZone uncertainity](http://martinfowler.com/bliki/TimeZoneUncertainty.html)
		* Java 8 Date API in detail
	* UUID concepts in general
	* Java 8 Default Methods
	* HashMap - Significance of 'initial capacity' and 'load factor' in performance
* Logging and monitoring
	* What is write-ahead logging? Used in HBase.
* RDBMS
	* Reorg 
	* Block nested loop join
* REST services
	* What SOAP has that REST doesn't?
	* REST fault messages
	* Routing idiom JAX-RS API implements mimic from Rails
	* JAX-RS defines: transitional links which describe optional next actions and structural links which provide optional detailed information. Transitional links tell a client where to proceed next, while structural links help to shorten representations in order to avoid aggregate data. Details are replaced by links. Transitional links have some support in JAX-RS 2.0, but structural links are not supported due to their level of complexity.
* Scalability
	* [Horizontal and Vertical Scaling Strategies for Batch applications](http://www.ontheserverside.com/blog/2014/07/23/horizontal-and-vertical-scaling-strategies-for-batch-applications)
* Security
	* OAuth
	* JSON Web Tokens
* Transaction
	* Check Spring in Action Chapter 9
* VCS
	* Git flow
