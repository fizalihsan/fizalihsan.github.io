---
layout: page
title: "Scalability"
comments: false
sharing: false
footer: true
---

* list element with functor item
{:toc}


*Options for increasing the DB performance*
	
1. Performance improvements on the existing monolithic DB
2. Vertical Scaling

	* **CPU Upgrades** - 
		* typically this is due to slow read queries. Optimizing those offensive queries can most of the times solve the issue. 
		* If the CPU is high due to too many users, then typically scaling out is the only option.
		* If the memory is low, CPU usage can be high due to *disk swapping*.
	* **Memory Upgrades**
		* Memory is heavily used for caching results, index caching, sorting, aggregation, etc.
		* If the memory runs low, CPU automatically swaps the contents to disk which is typically 100 times slower. Adding more memory generally solves the problem, but there is a limit.
		* Highly inefficient queries also sometimes contribute to high memory usage.
	* **Disk Upgrades**
		* Full table scan queries or high user/transaction volume lead to high disk usage.
		* Using RAID subsystems or Solid State Drives (SSD) sometimes solve the issue. But upgrading disks rarely solve performance issues.

3. Read Scaling

	* Read scaling is a simple technique of creating read-only replicas of the monolithic DB server to reduce the read-only queries on a single DB.

4. Horizontal Scaling

	* When your application involves heavy data reads/writes and heavy transactional volumes, and if none of the above techniques work, then scaling horizontally is the only option.
	* Partitioning/Sharding data across multiple nodes/servers in a cluster also introduces multiple failure points. DB cluster must be *highly available* to ensure the interim server failures do not interrupt the live operations.

# Sharding

##Consistent hashing or Hash Ring

is a special kind of hashing such that when a hash table is resized and consistent hashing is used, only K/n keys need to be remapped on average, where K is the number of keys, and n is the number of slots. In contrast, in most traditional hash tables, a change in the number of array slots causes nearly all keys to be remapped.

The advantage of Consistent Hashing with sharding is to reduce the number of rows affected (i.e., that need to be moved) as new physical shard servers are added or removed.

[Consistent Hashing Explained](http://michaelnielsen.org/blog/consistent-hashing/)

## Black-Box Sharding

The most common sharding technique in existence is black-box sharding, meaning that the shard distribution logic is controlled internally by the toolkit or product, and not exposed to the application.

The primary drawback for the black-box sharding approach is when you need to obtain related data, such as lists of items that have to do with a particular data element. I often refer to this as a *scatter-gather approach*: the data is scattered by key across the cluster, and must be gathered into meaningful lists of related data

## Relational Sharding

With relational sharding, the application or database architect defines the sharding schema along the natural data relationships in the data model. The advantage is that related data is *co-located* in the same physical server, allowing more application queries to be resolved with a single invocation to a given shard server.

The sharding strategy for the relational approach also uses a hash function to partition the data, again typically using a modulus or consistent hash approach. It is also possible to partition data using a key range scheme, where shard keys are grouped together by a range (such as a date range).

While it is true that relational sharding is easiest to implement with a relational DBMS engine, the advantages of this technique can be applied to other types of DBMS engines as well. It can even be used with an object database, through clever utilization of secondary indexes – particularly if the engine stores sharded data in range-based chunks.

Allows easy join of related data unlike in black-box sharding.

# Caching

**Caching Solutions**

* Ehcache
* Distributed Caches
	* Aerospike
	* Coherence (Oracle)
	* Gemfire
	* Gigaspaces
	* Hazelcast
	* Memcached
	* Redis
	* Riak (key-value database)


# References

* Understanding Big Data Scalability - Cory Isaacson