---
layout: page
title: "NoSQL"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Key-Value Stores

* Known databases: Riak, Redis, memcached, memcachedb, membase, Voldemort
* Not performant for complex queries and aggregate operations

## Riak

* Riak is a distributed key-value database where values can be anything—from plain text, JSON, or XML to images or video clips—all accessible through a simple HTTP interface
* is a distributed, datareplicating, enhanced key-value store without a single point of failure
* Implementation of Amazon's Dynamo
* Embraces web constructs of HTTP and REST from ground up
* supports advanced querying via mapreduce.
* Riak is a great choice for datacenters like Amazon that must serve many requests with low latency. If every millisecond spent waiting is a potential customer loss, Riak is hard to beat.
* Riak breaks up classes of keys into buckets to avoid key collisions.
* Riak stores everything as a binary-encoded value.
* Links are metadata that associate one key to other keys. Links are uni-directional. What makes Links special in Riak is link walking (and a more powerful variant, linked mapreduce queries)
* URL Pattern: `http://SERVER:PORT/riak/BUCKET/KEY`. 

### Architecture
* Riak server architecture removes single points of failure (all nodes are peers) and allows you to grow or shrink the cluster at will. This is important when dealing with large-scale deployments, since it allows your database to remain available even if several nodes fail or are otherwise unresponsive.
* Riak takes advantage of this fact by allowing you to trade availability for consistency on a per-request basis.
* **Riak Ring** - Riak divides its server configuration into partitions denoted by a 160-bit number (that’s 2^160). The Riak team likes to represent this massive integer as a circle, which they call the ring. When a key is hashed to a partition, the ring helps direct which Riak servers store the value.

### Clustering
* Riak allows us to control reads and writes into the cluster by altering three values: 
  * `N` is the number of nodes a write ultimately replicates to, in other words, the number of copies in the cluster. 
  * `W` is the number of nodes that must be successfully written to before a successful response. If `W` is less than `N`, a write will be considered successful even while Riak is still copying the value in background. 
  * `R` is the number of nodes required to read a value successfully. If `R` is greater than the number of copies available, the request will fail. If `R=1`, there is a potential chance to read stale values. If `R=N`, then if any of those `N` nodes become unavailable, read requests would fail. 
* **Conflict Resolution**
  * Riak uses vector clocks. A vector clock is a token that distributed systems like Riak use to keep the order of conflicting key-value updates intact. Timestamps cannot be used since the clocks across servers may not be synchronized.

### Downsides/Limitations/Trade-offs
* lacks robust support for ad hoc queries, and key-value stores, by design, have trouble linking values together (in other words, they have no foreign keys).
* If you require simple queryability, complex data structures, or a rigid schema or if you have no need to scale horizontally with your servers, Riak is probably not your best choice.

## Redis

* provides for complex datatypes like sorted sets and hashes, as well as basic message patterns like publish-subscribe and blocking queues.
* by caching writes in memory before committing to disk, Redis gains amazing performance in exchange for increased risk of data loss in the case of a hardware failure. good fit for caching noncritical data and for acting as a message broker.

# Column-oriented Databases

## Overview

* Known databases: HBase, Cassandra, Hypertable
* Large data stored across machines, less data relationships
* adding columns is quite inexpensive
* Each row can have a different set of columns, or none at all, allowing tables to remain sparse without incurring a storage cost for null values.

## HBase

* Using Google’s BigTable paper as a blueprint, HBase is built on Hadoop (a mapreduce engine) and designed for scaling horizontally on clusters of commodity hardware.
* supports versioning and compression.
* HBase is a column-oriented database that prides itself on consistency and scaling out.
* A table in HBase is basically a big map. Well, more accurately, it’s a map of maps.
* Unlike a relational database, in HBase a column is specific to the row that contains it. When we start adding rows, we’ll add columns to store data at the same time.
* HBase stores an integer timestamp for all data values, representing time in milliseconds since the epoch (00:00:00 UTC on January 1, 1970). When a new value is written to the same cell, the old value hangs around, indexed by its timestamp. This is a pretty awesome feature. Most databases require you to specifically handle historical data yourself, but in HBase, versioning is baked right in!
* A Bloom filter is a really cool data structure that efficiently answers the question, “Have I ever seen this thing before?”. HBase supports using Bloom filters to determine whether a particular column exists for a given row key (BLOOMFILTER=>'ROWCOL') or just whether a given row key exists at all (BLOOMFILTER=>'ROW'). The number of columns within a column family and the number of rows are both potentially unbounded. Bloom filters offer a fast way of determining whether data exists before incurring an expensive disk read.
* In HBase, rows are kept in order, sorted by the row key. A region is a chunk of rows, identified by the starting key (inclusive) and ending key (exclusive). Regions never overlap, and each is assigned to a specific region server in the cluster.

### Why use HBase?
Scalability, built-in features like versioning, compression, garbage collection of expired data, in-memory tables. Strong consistency guarantees makes it easier to transition from relational world.

### Where to use?
* Best used for online analytical processing systems - though individual queries are slower compared to other dbs, it works really well with enormous datasets. Big companies use this to back logging and search systems. Used by Facebook a principal component of its new messaging infrastructure. Twitter uses HBase extensively, ranging from data generation (for applications such as people search) to storing monitoring/performance data
  
### Architecture
* HBase is designed to be fault tolerant. Hardware failures may be uncommon for individual machines, but in a large cluster, node failure is the norm. By using write-ahead logging and distributed configuration, HBase can quickly recover from individual server failures.
* HBase supports three running modes:
  * Stand-alone mode is a single machine acting alone.
  * Pseudodistributed mode is a single node pretending to be a cluster.
  * Fully distributed mode is a cluster of nodes working together.

### Downsides
  * Although HBase is designed to scale out, it doesn’t scale down.
  * Solving small problems isn’t what HBase is about, and nonexpert documentation is tough to come by, which steepens the learning curve.
  * HBase is almost never deployed alone. Rather, it’s part of an ecosystem of scale-ready pieces. These include Hadoop (an implementation of Google’s MapReduce), the Hadoop distributed file system (HDFS), and Zookeeper (a headless service that aids internode coordination). This ecosystem is both a strength and a weakness; it simultaneously affords a great deal of architectural sturdiness but also encumbers the administrator with the burden of maintaining it.
  * One noteworthy characteristic of HBase is that it doesn’t offer any sorting or indexing capabilities aside from the row keys. Rows are kept in sorted order by their row keys, but no such sorting is done on any other field, such as column names and values. So, if you want to find rows by something other than their key, you need to scan the table or maintain your own index.
  * There is no concept of data types. Everything is an uninterrupted array of bytes


# Document-oriented Databases

## MongoDB
{% img right /technology/mongo-datatypes.png 500 500 %}

* supports consistency. Supports ACID properties at single-document level only.
* offers atomic read-write operations such as incrementing a value and deep querying of nested document structures.
* Using JavaScript for its query language, MongoDB supports both simple queries and complex mapreduce jobs.
* It is a document database, which allows data to persist in a nested state, and importantly, it can query that nested data in an ad hoc fashion. It enforces no schema.
* Mongo is a JSON document database (though technically data is stored in a binary form of JSON known as BSON).
* Every object/document has a unique incrementing numeric primary key called ObjectId. The ObjectId is always 12 bytes, composed of a timestamp, client machine ID, client process ID, and a 3-byte incremented counter.
* In Mongo you can construct ad hoc queries by field values, ranges, or a combination of criteria.
* MongoDB provides several of the best data structures for indexing, such as the classic B-tree, and other additions such as two-dimensional and spherical GeoSpatial indexes.
* What makes Mongo special in the realm of document stores is its ability to scale across several servers, by replicating (copying data to other servers) or sharding collections (splitting a collection into pieces) and performing queries in parallel. Both promote availability.
* A Namespace in Mongo is a combination of database name and collection name. e.g., `db.plans`
* GridFS

### Index

* By default, MongoDB creates an index on the document’s _id primary key field.
* All user-defined indexes are secondary indexes. Any field can be used for a secondary index, including fields within
arrays
* Order of columns on the compound index matters
* Use `explain()` to analyze the performance of a query. `db.plans.find({"clientId" : "014222"}).explain()`
* Use the `hint()` method to tell Mongo which index to use.

#### Index Types

* **Unique indexes**
* **Array indexes** - For fields that contain an array, each array value is stored as a separate index entry. There is no special syntax for array indexes though.
* **Sparse Indexes** - Sparse indexes only contain entries for documents that contain the specified field. Because MongoDB’s allows the data model to vary from one document to another, it is common for some fields to be present only in a subset of all documents. Sparse indexes allow for smaller, more efficient indexes when fields are not present in all documents.
* **Hash Indexes** - Hash indexes compute a hash of the value of a field and index the hashed value. The primary use of this index is to enable hash-based sharding, a simple and uniform distribution of documents across shards
* **Capped collection** - max size of the collection is defined at the time of creation and cannot be altered; an existing regular collection can be converted to capped collection, but not vice versa. It behaves like a circular queue and maintains the insertion order; cannot be sharded.
* **Tailable cursors** - like `tail -f` command, tailable cursors can be defined on capped collections.
* **TTL indexes** - Time-to-Live indexes are customizable capped collections where time-out for each document is defined by the user. A common use is in applications that maintain a rolling window of history (e.g., most recent 100 days) for user actions such as clickstreams.
* **Full-text indexes** - give you the ability to search text quickly, as well as provide built-in support for multi-language stemming and stop words; only index string data; allows searching multiple fields with custom weightage specified (from default 1 to 1 billion); You can create a full-text index on all string fields in a document by creating an index on `$**` 
* **Geo-spatial indexes**
  * Types of Geospatial queries : *intersection*, *within*, and *nearness*; Geospatial queries using *intersection* and *within* functions do not require an index, whereas *near* function does.
  * ***2dsphere index*** - for surface-of-the-earth-type maps; allows you to specify points, lines, and polygons in GeoJSON format. A point is given by a two-element array, representing [longitude, latitude]; A line by an array of Points; A polygon in the same way as lines but with different 'type'; Sample queries: restaurants in given coordinates, restaurants near given coordinates.
  * ***2d index*** - for flat maps, video game maps and time series data; "2d" indexes assume a perfectly flat surface, instead of a sphere; can only store points; 

#### Rules of Index Design

* Any fields that will be queried by *equality* should occur first in the index definition.
* Fields used to sort should occur next in the index definition. If multiple fields are being sorted (such as (last_name, first_name), then they should occur in the same order in the index definition.
* Fields that are queried by range should occur last in the index definition.

### Profiling

* MongoDB provides a range of logging and monitoring tools to ensure collections are appropriately indexed and queries are tuned. 
* The MongoDB Database Profiler is most commonly used during load testing and debugging, logging all database operations or only those events whose duration exceeds a configurable threshold (the default is 100ms). 
* Profiling data is stored in a capped collection 

### Data modelling

**Tips**

* Embed for speed, reference for integrity
* Embed "point-in-time" data. E.g., the address fields in an order document. You don’t want a user’s past orders to change if he updates his profile.
* Do not embed fields that have unbound growth. e.g, comments on a blog article. 
* Store embedded information in arrays for anonymous access. Subdocument should be used only when you know and will always know the name of the field that you are accessing.


#### Embedded document model

* **Pros**
  * Locality. Less disk seeks and hence faster.
  * Atomicity & Isolation during mutant operations.

* **Cons**
  * Querying for all sub-documents with a matching condition would return the sub-document along with parent as well. Major drawback of this approach is that we get back much more data than we actually need.
  * For example, in a document like below, querying for all the comments by John would return all the books where John has commented, not just the comments. Also it is not possible to sort or limit the comments returned.

``` json
{
  "book": "Head First Java",
  "text": "This is a book",
  "comments": [
    {"author": "John", "text": "..."},
    {"author": "Jack", "text": "..."},
    {"author": "John", "text": "..."},
  ]
}
```


* Embedding carries significant penalties with it:
  * The larger a document is, the more RAM it uses.
  * Growing documents must eventually be copied to larger spaces. As you append to the large document, eventually MongoDB is  going to need to move the document to an area with more space available. This movement, when it happens, significantly  slows update performance
  * MongoDB documents have a hard size limit of 16 MB.

* When to use
  * If your application’s query pattern is well-known and data tends to be accessed in only one way, an embedded approach works well.

#### Referenced document model

* Pros
  * Flexibility
  * Best fit for many-to-many relationships.
* Cons
  * No joins hence needs multiple network calls to retrieve complete data.
  * There is no multi-document transaction in Mongodb. In other words, unlike SQL you cannot edit/delete multiple documents in a single transaction. If a business entity spans across multiple collections, you cannot alter that entity from different collections atomically.
* When to use
  * If your application may query data in many different ways, or you are not able to anticipate the patterns in which data may be queried, a more “normalized” approach may be better.
  * Another factor that may weigh in favor of a more normalized model using document references is when you have one-to-many relationships with very high or unpredictable *arity*.



### Transaction Management

* MongoDB write operations are atomic at the document level – including the ability to update embedded arrays and sub-documents atomically
* Document-level atomicity in MongoDB ensures complete isolation as a document is updated
* Multi-document transaction
   * `findAndModify()` command that allows a document to be updated atomically and returned in the same round trip. Will this work for multiple documents?
   * For situations that require multi-document transactions, you can implement two-phase commit in your application to provide support for these kinds of multi-document updates. Using [2 Phase Commit](https://docs.mongodb.com/manual/tutorial/perform-two-phase-commits/) ensures that data is consistent and, in case of an error, the state that preceded the transaction is recoverable. During the procedure, however, documents can represent pending data and states.
* Maintaining Strong Consistency - By default, MongoDB directs all read operations to primary servers, ensuring strong consistency. Also, by default any reads from secondary servers within a MongoDB replica set will be eventually consistent – much like master / slave replication in relational databases.
* Write concerns - The write concern is configured in the driver and is highly granular – it can be set per-operation, per-collection or for the entire database. 
* Journals 
  * Before applying a change to the database – whether it is a write operation or an index modification – MongoDB writes the change operation to the journal. If a server failure occurs or MongoDB encounters an error before it can write the changes from the journal to the database, the journaled operation can be reapplied, thereby maintaining a consistent state when the server is recovered.

#### Why no transactions?

* MongoDB was designed from the ground up to be easy to scale to multiple distributed servers. Two of the biggest problems in distributed database design are distributed join operations and distributed transactions.
* Both of these operations are complex to implement, and can yield poor performance or even downtime in the event that a server becomes unreachable. By “punting” on these problems and not supporting

#### Write concern

* MongoDB has a configurable write concern. This capability allows you to balance the importance of guaranteeing that all writes are fully recorded in the database with the speed of the insert. 
* For example, if you issue writes to MongoDB and do not require that the database issue any response, the write operations will return very fast (since the application needs to wait for a response from the database) but you cannot be certain that all writes succeeded. Conversely, if you require that MongoDB acknowledge every write operation, the database will not return as quickly but you can be certain that every item will be present in the database. 
* The proper write concern is often an application-specific decision, and depends on the reporting requirements and uses of your analytics application.

**Insert acknowledgement**

By setting w=0, you do not require that MongoDB acknowledge receipt of the insert. `db.events.insert(event, w=0)`

**Journal write acknowledgement**
If you want to ensure that MongoDB not only acknowledges receipt of a write operation but also commits the write operation to the on-disk journal before returning successfully to the application, you can use the j=True option: `db.events.insert(event, j=True)`.

MongoDB uses an on-disk journal file to persist data before writing the updates back to the “regular” data files. Since journal writes are significantly slower than in-memory updates (which are, in turn, much slower than “regular” data file updates), MongoDB batches up journal writes into “group commits” that occur every 100 ms unless overridden in your server settings. What this means for the application developer is that, on average, any individual writes with j=True will take around 50 ms to complete, which is generally even more time than it would take to replicate the data to another server.

**Replication acknowledgement**
To acknowledge that the data has replicated to two members of the replica set before returning: `db.events.insert(event, w=2)`.


### Aggregation Framework
* a pipeline that processes a stream of documents through several building blocks: filtering, projecting, grouping, sorting, limiting, and skipping.
* `aggregate()` function returns an array of result documents; cannot write to a collection;
* **Pipeline Operations** - Each operator receives a stream of documents, does some type of transformation on these documents, and then passes on the results of the transformation. If it is the last pipeline operator, these results are returned to the client. Otherwise, the results are streamed to the next operator as input.

### Sharding

* One of the central reasons for Mongo to exist is to safely and quickly handle very large datasets. The clearest method of achieving this is through horizontal sharding by value ranges—or just sharding for brevity. Rather than a single server hosting all values in a collection, some range of values are split (or in other words, sharded) onto other servers. For example, in our phone numbers collection, we may put all phone numbers less than 1-500-000-0000 onto Mongo server A and put numbers greater than or equal to 1-500-000-0001 onto a server B. Mongo makes this easier by autosharding, managing this division for you.
* Diff b/w sharding and replication? Replication copies the exact copy of a data in multiple servers. Sharding stores different subset of data across multiple servers.
* Shard - server participating in a sharded cluster.
* mongos - routing process which sits in front of all the shards. Apps connect to this process.
* Sharding is enabled at database level.
* Shard key - when you enable sharding you choose a field or two that MongoDb uses to break up data. To even create a shard key, the field(s) must be indexed. Before sharding, the collection is essentially a single chunk. Sharding splits this into smaller chunks based on the shard key

* Shard
   * A shard is one or more servers in a cluster that are responsible for some subset of the data. For instance, if we had a cluster that contained 1,000,000 documents representing a website’s users, one shard might contain information about 200,000 of the users. 
   * A shard can consist of many servers. If there is more than one server in a shard, each server has an identical copy of the subset of data (Figure 2-1). In production, a shard will usually be a replica set.
   * Single range shards will lead to cascade effect and lot of data movement when rebalancing is required. Mongo uses multi-range shards to avoid this.
* Chunk
   * A range of data is called a **chunk**. When we split a chunk’s range into two ranges, it becomes two chunks.
   * 200MB is the max size of a chunk by default. This is because moving data is expensive: it takes a lot of time, uses system resources, and can add a significant amount of network traffic. 
* Shard Key
   * You also cannot change the value of a shard key (with, for example, a $set). The only way to give a document a new shard key is to remove the document, change the shard key’s value on the client side, and reinsert it.
   * A document belongs in a chunk if and only if its shard key value is in that chunk’s range. 
* mongos
   * `mongos` is a special routing process that sits in front of your cluster and looks like an ordinary `mongod` server to anything that connects to it. It forwards requests to the correct server or servers in the cluster, then assembles their responses and sends them back to the client. This makes it so that, in general, a client does not need to know that they’re talking to a cluster rather than a single server.
   * *Targeted Query* - While querying, if the query has the shard key, mongos determines which shard/shards contains the data and hits those directly. This is called a targeted query. 
   * *Spewed Query* - If the shard key is absent in the query, mongos must send the query to all of the shards. This can be less efficient than targeted queries, but not necessarily. A “spewed” query that accesses a few indexed documents in RAM will perform much better than a targeted query that has to access data from disk across many shards (a targeted query could hit every shard, too)
* Anatomy of a cluster
   * A MongoDB cluster basically consists of three types of processes: 
      * the shards for actually storing data, 
      * the mongos processes for routing requests to the correct data, and
      * the config servers, for keeping track of the cluster’s state
* Replica Sets
  * Mongo was built to scale out, not to run stand-alone. It was built for data consistency and partition tolerance, but sharding data has a cost: if one part of a collection is lost, the whole thing is compromised. What good is querying against a collection of countries that contains only the western hemisphere? Mongo deals with this implicit sharding weakness in a simple manner: duplication. You should rarely run a single Mongo instance in production but rather replicate the stored data across multiple services.


* Partition
* Cluster has 1 or more shards
* Shard has 1 or more servers
* Shard has 1 or more chunks
* Chunk has 1 range
* Replica set

#### Setup

* To add configuration servers to router - `$mongos --configdb cfg-server1,cfg-server2,cfg-server3` 
   * All administration on a cluster is done through mongos
   * Configuration servers can be 1, 2 or 3 max. They only have configuration information and no data.
* To add a shard - `db.runCommand({"addShard" : "server:port", "name": "shardName"})`
   * Run this from the admin db
* To enable sharding at database level - `db.adminCommand({"enableSharding" : "dbname"})`
* To enable sharding at collection level - `db.adminCommand({"shardCollection" : "dbname.collectionName", key : {"field1" : 1, "field2" : 1}}`
   * If we are sharding a collection with data in it, the data must have an index on the shard key. 
   * All documents must have a value for the shard key, too (and the value cannot be null). After you’ve sharded the collection, you can insert documents with a null shard key value.
* To remove a shard out of the cluster - `db.runCommand({removeShard : "shardName"})`
   * Moves all of the information that was on this shard to other shards before it can remove this shard. 
   * Moving data from shard to shard is pretty slow.


#### Shard Keys

* Bad shard keys
   * Low cardinality keys 
      * e.g., by continent names, by country names, etc. 
      * When the volume increases in one of these shards, there is no way to horizontally scale because there are only limited number of key values. 
      * If you are tempted to use low-cardinality shard key because you query on that field a lot, use a compound shard key (a shard key with two fields) and make sure that the second field has lots of different values MongoDB can use for splitting.
      * If a key has N values in a collection, you can only have N chunks and, therefore, N shards.
   * Ascending Shard key
      * e.g., timestamps, ObjectIds, auto-incrementing primary keys
      * Everything will always be added to the “last” chunk, meaning everything will be added to one shard. This shard key gives you a single, undistributable hot spot.
      * If the key’s values trend towards infinity, you will have this problem.
   * Random Shard Key
* Good shard keys - Ideally, your shard key should have two characteristics:
   * Insertions are *balanced* between shards
   * Most queries can be *routed* to a subset of the shards to be satisfied


#### Sharding concerns

In a sharded environment, the limitations on the maximum insertion rate are:

* The number of shards in the cluster
* The shard key you choose

* Limitations
   * Cannot guarantee uniqueness on any key other than the shard key
   * count of collection may return incorrect numbers 




## CouchDb

* Written in Erlang
* With nearly incorruptible data files, CouchDB remains highly available even in the face of intermittent connectivity loss or hardware failure.
* Like Mongo, CouchDB’s native query language is JavaScript. 
* Storage data format: JSON

### Admin UI

* Futon is a web-based interface to work with CouchDB and it provides support for editing the configuration information, creating databases, documents, design documents, etc. 
* URI: http://localhost:5984/_utils/index.html 
* How to create our first database? * Futon -> Overview -> Create database* . Multiple such databases can be created in this single instance of CouchDb.

### How to access CouchDB programmatically?

via HTTP REST Interface
 Note: If the db is password protected, send requests with credentials as follows: `http://username:pass@remotehost:5984/dbname`

* To check if the CouchDb is up and running: `curl http://localhost:5984`
* To create a db: 
  * Request: `curl -X PUT http://localhost:5984/dbname`
  * Response: `{"ok":true}`
* To delete a db:
  * Request: `curl -X DELETE http://localhost:5984/dbname`
  * Response: `{"ok":true}`
* To retrieve db information: 
  * Request: `curl -X GET http://localhost:5984/dbname`
  * Response: `{"db_name":"dbname","doc_count":0,"doc_del_count":0,"update_seq":0,"purge_seq":0,"compact_running":false,"disk_size":79,"data_size":0,"instance_start_time":"1386975670043000","disk_format_version":6,"committed_update_seq":0}`
* To create a new document: 
  * Request: `curl -H "Content-type: application/json" -X POST http://localhost:5984/dbname -d "{\"title\": \"Lasagne\"}"`
  * Response: `{"ok":true,"id":"d02bdee238b26628d1ce28f1c80313bb","rev":"1-f07d272c69ca1ba91b94544ec8eda1b6"}`
  * Comments: 'id' is a unique document identifier and "rev" is the revision id of the document automatically generated.
* To create a document with custom document id:
  * Request: `curl -H "Content-type: application/json" -X PUT http://localhost:5984/dbname/pasat -d "{\"title\": \"Pasat\"}"`
  * Response: `{"ok":true,"id":"pasat","rev":"1-91b034b589017f930d12f7fec23be727"}`
  * Comments: PUT method is used instead of POST. Custom document id is passed in the url.
* To retrieve a document:
  * Request: `curl -X GET http://localhost:5984/dbname/d02bdee238b26628d1ce28f1c80313bb`
  * Response: `{"_id":"d02bdee238b26628d1ce28f1c80313bb","_rev":"1-f07d272c69ca1ba91b94544ec8eda1b6","title":"Lasagne"}`
  * Comments: Document ID is passed in the request.
* To update a document:
  * Request: `curl -H "Content-type: application/json" -X PUT http://localhost:5984/dbname/pasat -d "{\"title\": \"Fizal\", \"dob\": \"01/01/1980\", \"_rev\": \"1-91b034b589017f930d12f7fec23be727\"}"`
  * Response: `{"ok":true,"id":"pasat","rev":"2-a294dbbe4a308e8586be9acdc527e6dc"}`
  * Comments: Both doc id and rev id is needed to update a document. Updating the document means updating the entire document. You cannot add a field to an existing document. You can only write an entirely new version of the document into the database with the same document ID.
* To delete a document:
  * Request: `curl -H "Content-type: application/json" -X DELETE http://localhost:5984/dbname/pasat?rev=2-a294dbbe4a308e8586be9acdc527e6dc`
  * Response: `{"ok":true,"id":"pasat","rev":"3-fc5a45ddd7178ee92532095c38d66489"}`
  * Comments: Both doc id and rev id is needed to delete a document. Note that a new revision is created after deleting the document for replication purposes. 
* To upload attachments to a document:
  * Request:
* To make a copy of a document:
  * Request: `curl -X COPY ...`
* To request a UUID:
  * Request: `curl -X GET http://localhost:5984/_uuids`
  * Response: `{"uuids":["d02bdee238b26628d1ce28f1c803304f"]}`
* To compact a database:

### Other Administration Tasks

* UI Set up
  * To make Futon accessible outside of the localhost: Futon -> configurations -> Bind_Address - change the value to 0.0.0.0
* User Set up
  * After set up, CouchDb runs in 'Admin Party Mode' (anyone accessing has full admin rights). To create an admin user and password, click on 'Fix me' link at the bottom right corner in Futon. The new admin user id should be visible under http://localhost:5984/_utils/database.html?_users.
  * About Authentication: Couch has a pluggable authentication mechanism. Futon exposes a user friendly cookie-auth which handles login and logout. 
* Database Set up
  * How to create our first database? Futon -> Overview -> Create database
* Replication Set up
  * How to replicate contents from DbX to DbY? Futon -> Tools -> Replicator -> Select from and to databases, and check the 'Continuous' checkbox. If the target db requires authentication, specify the url as http://username:pass@remotehost:5984/DbY. 

# Graph Databases

## Concepts

### Types of technologies in Graph space
1. **Graph Databases** - Technologies used primarily for transactional online graph persistence, typically accessed directly in real time from an application. They are the equivalent of “normal” OLTP databases in the relational world.
  * Available Graph Dbs: Dex, FlockDB (Twitter), HyperGraphDb, InfiniteGraph, Neo4j, OrientDB, Titan, Microsoft Trinity.
2. **Graph Compute Engines** - Technologies used primarily for offline graph analytics, typically performed as a series of batch steps. They are lik eother technologies for analysis of data in bulk, such as data mining and OLAP.
  * Available Graph Compute Engines: 
    * In-memory/Single machine: Cassovary
    * Distributed: Pegasus, Giraph
    

Graph databases either use a native graph storage or a non-native storage back-end (say a relational db). The benefit of a native graph storage is that its purpose-built stack is engineered for performance and scalability. The benefit of a non-native graph storage is the ease of use in production by the operation teams.

### Advantages of Graph Databases
* Performance - In relation dbs, join across multiple tables is complex and tend to slow down with higher volume. In graph db, it is pretty much remains constant.
* Flexible data model: Adding new nodes, subgraphs and relations is lot easier and less intrusive than in relational model. No need to change the schema or the existing queries.
* Schemas are both rigid and brittle. Modifying schema often for business requirements is not an easy change. Creating a generic schema would end up with sparsely populated tables with many nullable columns. Vertical schemas add computational complexity in querying.
* Recursive questions such as *“which customers bought this product who also bought that product?”* is easy to write in graph model compared to relational.
* Pattern matching queries - e.g.?
* Geospatial queries - e.g.,?

### Graph Data Models 
1. Property graph model
  * A property graph has the following characteristics:
  * It contains nodes and relationships
  * Nodes contain properties (key-value pairs)
  * Relationships are named and directed, and always have a start and end node
  * Relationships can also contain properties
* 2. RDF Triples - http://en.wikipedia.org/wiki/Resource_Description_Framework
* 3. Hypergraphs
  * Graph Query Languages: Cypher (Neo4j), SPARQL (RDF query language), Gremlin (Imperative, path-based language) 

* Graph Db Applications
* Recommendation Engines - e.g.,?
* Geospatial apps - e.g.,? Datastructure behind geospatial processing is R-tree. http://en.wikipedia.org/wiki/R-tree


## Neo4j

http://nosql.mypopescu.com/tagged/neo4j

RDBMS is optimized for aggregated data. Neo4j is optimized for highly connected data.

* Cypher
  * Get all node names -->  `START n=node(*) RETURN n;`
  * Get all nodes with rels --> `START n=node(*) MATCH n-[r?]-() RETURN n, r;`
  * Delete all nodes --> `START n=node(*) MATCH n-[r?]-() DELETE n, r;`
  * Query index --> `START n=node:TASK_NAME('TASK_NAME:("Task1", "Task2", "Task3")') RETURN n;`


# Bibliography

* Seven Databases in Seven Weeks
* Graph Databases - O'Reilly
* [http://nosql.findthebest.com/](http://nosql.findthebest.com/)
* [http://www.slideshare.net/samof76/distributed-keyvalue-stores-featuring-riak](http://www.slideshare.net/samof76/distributed-keyvalue-stores-featuring-riak)
* MongoDb
  * MongoDb - The Definitive Guide
  * MongoDB Applied Design Patterns
  * Scaling Mondodb
  * 50 Tips & Tricks for MongoDb Developers
* CouchDb
  * Getting Started with CouchDb
  * [http://www.couchbase.com/press-releases/couchbase-and-spring-data-make-it-easier-developers-build-next-generation-enterprise](http://www.couchbase.com/press-releases/couchbase-and-spring-data-make-it-easier-developers-build-next-generation-enterprise)
  * [http://projects.spring.io/spring-data-couchbase/](http://projects.spring.io/spring-data-couchbase/)