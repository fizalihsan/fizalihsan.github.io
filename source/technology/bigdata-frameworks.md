---
layout: page
title: "Distributed Processing Frameworks"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Apache Storm

# Apache Kafka

* an open source, distributed, partitioned, and *replicated commit-log-based* publish-subscribe messaging system, mainly designed with the following characteristics:
* **Persistent messaging**: To derive the real value from big data, any kind of information loss cannot be afforded. Apache Kafka is designed with `O(1)` disk structures that provide constant-time performance even with very large volumes of stored messages that are in the order of TBs. With Kafka, messages are persisted on disk as well as replicated within the cluster to prevent data loss.
* **High throughput**: Keeping big data in mind, Kafka is designed to work on commodity hardware and to handle hundreds of MBs of reads and writes per second from large number of clients. 
* **Distributed**: Apache Kafka with its cluster-centric design explicitly supports message partitioning over Kafka servers and distributing consumption over a cluster of consumer machines while maintaining per-partition ordering semantics. Kafka cluster can grow elastically and transparently without any downtime.
* **Multiple client support**: The Apache Kafka system supports easy integration of clients from different platforms such as Java, .NET, PHP, Ruby, and Python. 
* **Real time**: Messages produced by the producer threads should be immediately visible to consumer threads; this feature is critical to event-based systems such as ***Complex Event Processing (CEP)*** systems.

* Producers
	* Web Application logs, page visits, clicks, social media activities, Web Analytics logs
* Consumers
	* *Offline consumers*: that are consuming messages and storing them in Hadoop or traditional data warehouse for offline analysis
	* *Near real-time consumers*:  that are consuming messages and storing them in any NoSQL datastore, such as HBase or Cassandra, for near real-time analytics
	* *Real-time consumers*: such as Spark or Storm, that filter messages in-memory and trigger alert events for related groups

* Kafka can be compared with Scribe or Flume as it is useful for processing activity stream data; but from the architecture perspective, it is closer to traditional messaging systems such as ActiveMQ or RabitMQ.	

* Use cases:
	* **Log Aggregation**: the process of collecting physical log files from servers and putting them in a central place (a file server or HDFS) for processing.
	* **Stream processing**: an example is raw data consumed from topics and enriched or transformed into new Kafka topics for further consumption. Hence, such processing is also called 'stream processing'.
	* **Commit logs**: Kafka can be used to represent external commit logs for any large scale distributed system. Replicated logs over Kafka cluster help failed nodes to recover their states.
	* **Click stream tracking**: data such as page views, searches, etc. are published to central topics with one topic per activity type as the volume is very high. These topic are available for subscription by many consumers for a wide range of apps.
	* **Messaging**: Message brokers are used for decoupling data processing from data producers. Kafka can replace many popular message brokers as it offers better throughput, built-in partitioning, replication, and fault-tolerance.


## Clusters

**Types**

* A single node—single broker cluster
* A single node—multiple broker clusters
* Multiple nodes—multiple broker clusters

**Cluster Components**

A Kafka cluster primarily has five main components:

* **1. Topic**: A topic is a category or feed name to which messages are published by the message producers. In Kafka, topics are partitioned and each partition is represented by the ordered immutable sequence of messages. A Kafka cluster maintains the partitioned log for each topic. Each message in the partition is assigned a unique sequential ID called the offset.
* **2. Broker**: A Kafka cluster consists of one or more servers where each one may have one or more server processes running and is called the broker. Topics are created within the context of broker processes.
* **3. Zookeeper**: ZooKeeper serves as the coordination interface between the Kafka broker and consumers. ZooKeeper allows distributed processes to coordinate with each other through a shared hierarchical name space of data registers (we call these registers znodes), much like a file system.
	* The main differences between ZooKeeper and standard filesystems are that every znode can have data associated with it and znodes are limited to the amount of data that they can have. ZooKeeper was designed to store coordination data: status information, configuration, location information, and so on.
* **4. Producers**: Producers publish data to the topics by choosing the appropriate partition within the topic. For load balancing, the allocation of messages to the topic partition can be done in a round-robin fashion or using a custom defined function.
* **5. Consumer**: Consumers are the applications or processes that subscribe to topics and
process the feed of published messages.

https://vimeo.com/63040812