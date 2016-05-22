---
layout: page
title: "Big Data"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Big Data Concepts

* Large data processing in low latency
* Process unstructured data
* 3Vs of Big Data - Volume, Velocity and Variety
* [7Vs of Big Data](http://fizalihsan.wordpress.com/2014/01/02/7vs-of-big-data-briefly/) - Volume, Velocity and Variety, Veracity, Variability, Visualization and Value
* Why Big Data?
  * Old data mining systems were expensive, not easily scalable
* Scaling concepts
  * Scale Up
    * When volume of data increases, add computing power to a single server or move to a bigger server.
    * Pros: no change in architecture needed.
    * Cons: there are limitation on how big a single host can be.
  * Scale Out
    * Processing is handled by more than 1 server. When data volume increases, add more servers to the farm.
    * Pros: Cheaper purchase costs than scale up, High availability
    * Cons: complex data processing stratagies involved.
    * Features: smart-software-dumb-hardware, move-processing-not-data.
    * Challenges: Bottlenecks, increased risk of failure
* Caching
* Adhoc query
* Sharding
* Replication
* Fault tolerance
  * [Byzantine fault tolerance](https://en.wikipedia.org/wiki/Byzantine_fault_tolerance)

# MapReduce (Programming Model)

> Source: Hadoop Operations -OReilly


* Designed to simplify the development of large-scale, distributed, fault-tolerant data processing applications
* In MapReduce, developers write jobs that consist primarily of a map function and a reduce function, and the framework handles the gory details of parallelizing the work, scheduling parts of the job on worker machines, monitoring for and recovering from failures, and so forth.
* User-provided code is invoked by the framework rather than the other way around.
* Features
  * **Simplicity of development** - Developers use functional programming concepts to operate on one record at a time. Map functions operate on these records and produce intermediate key-value pairs. The reduce function then operates on the intermediate key-value pairs, processing all values that have the same key together and outputting the result. These primitives can be used to implement filtering, projection, grouping, aggregation, and other common data processing functions.
  * **Scalability** - MapReduce is designed to be a 'share-nothing' system. Since tasks are independent, they can run in parallel in one or more machines.
  * **Automatic parallelization and distribution of work** -  Developers focus on the map and reduce functions that process individual records (where “record” is an abstract concept—it could be a line of a file or a row from a relational database) in a dataset. The storage of the dataset is not prescribed by MapReduce, although it is extremely common, as we’ll see later, that files on a distributed filesystem are an excellent pairing. The framework is responsible for splitting a MapReduce job into tasks. Tasks are then executed on worker nodes or (less pleasantly) slaves.
  * **Fault Tolerance** - MapReduce treats failure as a first-class citizen and supports reexecution of failed tasks on healthy worker nodes in the cluster. Should a worker node fail, all tasks are assumed to be lost, in which case they are simply rescheduled elsewhere.


# Big Data Ecology
## Apache Hadoop

* Hadoop is an open source platform that provides implementations of both the MapReduce and GFS (Google File System) technologies and allows the processing of very large data sets across clusters of low-cost commodity hardware.
* The terms host or server refer to the physical hardware hosting Hadoop's various components. The term node will refer to the software component comprising a part of the cluster.
* Where Hadoop is not a good fit?
  * not well suited for low-latency queries like websites, real time systems, etc. (HBase on top of Hadoop serves low-latency queries)
  * smaller data sets.
* The term *Hadoop Streaming* refers to a mechanism allowing scripting languages to be used to write map and reduce tasks
* Hadoop installation consists of four types of nodes—a NameNode, DataNodes, a JobTracker, and TaskTracker HDFS nodes (NameNode and DataNodes) provide a distributed filesystem where the JobTracker manages the jobs and TaskTrackers run tasks that perform parts of the job. Users submit MapReduce jobs to the JobTracker, which runs each of the Map and Reduce parts of the initial job in TaskTrackers, collects results, and finally emits the results.

### HDFS (Hadoop Distributed File System)

* is a distributed filesystem that can store very large data sets by scaling out across a cluster of hosts. It has specific design and performance characteristics; in particular, it is optimized for throughput instead of latency, and it achieves high availability through replication instead of redundancy.
* similar to any other linux file system like ext3 - but cannot be mounted - and requires applications to be specially built for it.
* Block size in old file systems are typically 4KB or 8KB of size. In HDFS, it is 64MB to 1GB.
* Replicates each block to multiple machines (default 3) in the cluster. Should the number of copies of a block drop below the configured replication factor, the filesystem automatically makes a new copy from one of the remaining replicas. 
* Due to replicated data, failures are easily tolerated.
* not a POSIX-compliant filesystem.
* HDFS is optimized for throughput over latency; it is very efficient at streaming read requests for large files but poor at seek requests for many small ones.

{% img right /technology/hadoop-server-roles.png %}

### Daemons

* Namenode (NN)
  * 1 per cluster
  * Purpose: Stores filesystem metadata, stores file to block map, and provides a global picture of the filesystem
* Secondary namenode (SNN)
  * 1 per cluster (better not to share machine with NameNode)
  * Purpose: Performs internal namenode transaction log checkpointing
* DataNode 
  * Many per cluster
  * Purpose: Stores block data (file contents)
* Each storage node runs a process called a DataNode that manages the blocks on that host, and these are coordinated by a master NameNode process running on a separate host.
* Instead of handling disk failures by having physical redundancies in disk arrays or similar strategies, HDFS uses replication. Each of the blocks comprising a file is stored on multiple nodes within the cluster, and the HDFS NameNode constantly monitors reports sent by each DataNode to ensure that failures have not dropped any block below the desired replication factor. If this does happen, it schedules the addition of another copy within the cluster. (include archictecture diagram from internet)
* The master (NameNode) monitors the health of the cluster and handle failures by moving data blocks around.
* Processes on each server (DataNode) are responsible for performing work on the physical host, receiving instructions from the NameNode nd reporting health/progress status back to it.
* NameNode Federation - Since NameNodes keep all the metadata in memory, there is inherent limitation up to which it can scale up. Scaling out with multiple namenodes is called namenode federation
* HDFS interface
  * HDFS shell
  * Java API
  * REST API - WebHDFS, HttpFS(standalone RESTful HDFS proxy service) 

### MapReduce (Hadoop Implementation)

* is a data processing paradigm that takes a specification of how the data will be input and output from its two stages (called map and reduce) and then applies this across arbitrarily large data sets. MapReduce integrates tightly with HDFS, ensuring that wherever possible, MapReduce tasks run directly on the HDFS nodes that hold the required data.
* Concepts
  * concepts of functions called map and reduce come straight from functional programming languages where they were applied to lists of input data.
  * divide and conquer", where a single problem is broken into multiple individual subtasks. This approach becomes even more powerful when the subtasks are executed in parallel;
* Unlike traditional relational databases that require structured data with well-defined schemas, MapReduce and Hadoop work best on semi-structured or unstructured data.
* Instead of data conforming to rigid schemas, the requirement is instead that the data be provided to the map function as a series of key value pairs. The output of the map function is a set of other key value pairs, and the reduce function performs aggregation to collect the final set of results.
* Hadoop provides a standard specification (that is, interface) for the map and reduce functions, and implementations of these are often referred to as mappers and reducers. A typical MapReduce job will comprise of a number of mappers and reducers, and it is not unusual for several of these to be extremely simple. The developer focuses on expressing the transformation between source and result data sets, and the Hadoop framework manages all aspects of job execution, parallelization, and coordination.
* The master (JobTracker) monitors the health of the cluster and handle failures by rescheduling failed work.
* Processes on each server (TaskTracker) are responsible for performing work on the physical host, receiving instructions from the JobTracker, and reporting health/progress status back to it.

## HCatalog

* provides one consistent data model for various Hadoop tools.
* provides a shared schema.
* allows users to see when shared data is available.
* decouples tools like Pig and Hive from data location, data format, etc.
* Based currently on Hive's metastore.

## Hive

* Hive is a data warehouse system layer build on Hadoop.
* Allows you to define a structure for your unstructured Big Data.
* Simplifies analysis and queries with an SQL-like scripting language called HiveQL for adhoc querying on HDFS data.
* Hive is 
  * not a relational database. It uses a database to store metadata, but the data that Hive processes is stored in HDFS.
  * not designed for online transaction processing. not suited for real-time queries and row-level updates. 
* Components
  * CLI, Web interface (Beeswax?), Micrsoft HDInsight
* When to use Hive? 
  * for adhoc querying; for analysts with SQL familiarity
* HiveQL - SQL-like syntax. based on SQL-92 specification.
* Hive Table
  * A Hive Table consists of (1) Data: typically a file or group of files in HDFS (2) Schema: in the form of metadata stored in a database
  * Schema and data are separate
  * A schema can be defined for existing data; Data can be added/removed independently; Before querying data in HDFS using Hive, a schema needs to be defined.

## Pig

3 components of Pig: 

### 1. Pig Latin
* High level scripting language to describe data flow - statements translate into a series of MapReduce jobs - can invoke Java, JRuby or Jython programs and vice versa - User defined functions (UDF) can be written in Java and uploaded as jar.
* Sample Pig Latin script

```
 a = LOAD 'nyse_stocks' using org.apache.hcatalog.pig.HCatLoader();
 b = filter a by stock_symbol == 'IBM';
 c = group b all;
 d = foreach c generate AVG(b.stock_volume);
 dump d;
```

* Pig Latin script describes a DAG (directed acyclic graph) - http://vkalavri.com/tag/apachepig/
* Pig script is not converted to a MapReduce job unless a DUMP/STORE command is invoked.

```
 runs = foreach batting generate $0 as playerID, $1 as year, $8 as runs;
 (playerID,yearID,R)
 (john,2008,10)
 (john,2009,22)
 (john,2010,0)
 (adam,2008,58)
 (adam,2009,105)
 (adam,2010,106)
 (adam,2011,118)

 grp_data = group runs by (year);
 (2008, [(john,2008,10), (adam,2008,58)])
 (2009, [(john,2009,22), (adam,2009,105)])
 (2010, [(john,2010,0),  (adam,2010,106)])
 (2011, [(adam,2011,118)])
```

### 2) Grunt
Interactive command-line shell

### 3) Piggybank
* A repository to store the UDFs
* When to use Pig?
  * for ETL purposes; for preparing data for easier analysis; when you have a long series of steps to perform.
* Data Model difference b/w Pig and Hive
  * In Pig, data objects exist and are operated on in the script. They are deleted after the script completes. They can be stored explicitly for later use.
  * In Hive, data objects exist in Hadoop data store. After every line of execution, results are stored in Hadoop which can be useful for debugging.

# Clustering

* What is Clustering
* How clustering works
* Why clustering
* Terms to know
* Failover
* Replication
* Scalability vs. High availability
* Physical node vs. virtual node
* Quorum
* Load balancing


# Bibliography

* Hadoop
  * Hadoop Beginner's Guide
* Clustering
  * http://publib.boulder.ibm.com/infocenter/iseries/v5r4/index.jsp?topic=%2Frzaig%2Frzaigconceptsbasiccluster.htm
  * http://www.slideshare.net/yashamwan/cluster-16097908?from_search=9
  * http://www.slideshare.net/itsec/clustering-and-high-availability