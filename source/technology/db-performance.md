---
layout: page
title: "DB Performance"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Indexes

* http://use-the-index-luke.com/sql/table-of-contents 
* http://www.sqlskills.com/blogs/kimberly/guids-as-primary-keys-andor-the-clustering-key/
* http://www.micmin.com/Session320/Session%20320%20-%20Role%20of%20Indexes.htm 

An index is an ordered set of pointers associated with a table, and is used for performance purposes. 

## How Indexes work?

* Each index entry contains a search-key value and a pointer to the row containing that value. If you specify the `ALLOW REVERSE SCANS` parameter while creating the index, the values can be searched in both ascending and descending order. It is therefore possible to bracket the search, given the right predicate. 
* An index can also be used to obtain rows in an ordered sequence, eliminating the need for the database manager to sort the rows after they are read from the table.

Although the optimizer decides whether to use an index to access table data, except in the following case, you must decide which indexes might improve performance and create these indexes. Exceptions are the dimension block indexes and the composite block index that are created automatically for each dimension that you specify when you create a multi-dimensional clustering (MDC) table.

In addition to the search-key value and row pointer, an index can contain include columns, which are non-indexed columns in the indexed row. Such columns might make it possible for the optimizer to get required information only from the index, without accessing the table itself.

## Limitations of Indexes

Although indexes can reduce access time significantly, they can also have adverse effects on performance. Before you create indexes, consider the effects of multiple indexes on disk space and processing time:

* Each index requires storage or disk space. The exact amount depends on the size of the table and the size and number of columns in the index. 
* Each INSERT or DELETE operation performed on a table requires additional updating of each index on that table. This is also true for each UPDATE operation that changes the value of an index key. 
* Each index potentially adds an alternative access path for a query for the optimizer to consider, which increases the compilation time. 

## Index usage criteria 

The query contains a column in a join clause that matches at least the first column of the index. eg. `create index idx1 on emp (division, dep, emptype) `

* All the below queries will make use of the above index. 
  * `select * from emp where division='acct' `
  * `select * from emp where division='acct' and dept='fin' `
  * `select * from emp where division='acct' and emptype='exempt' `
* However, this query would be NOT be able to use the index since it doesn't specify the first column of the index. 
  * `select * from emp where emptype='exempt' `

## Index Types

* **Clustered** Any index structure having the data accessed in the same way the index is organized so that data with similar or the same key values is stored (or clustered) together. Clustering tends to greatly reduce input/output (I/O) time for queries and sorting.
* **Non-clustered**
* **Unique index**
* **Hashtable index** - An index that maps primary key values to block data addresses in the database for otherwise un-ordered data. Not good for range searches
* **Bitmapped index**
  * A collection of bit vectors to form an index that can be used to quickly search secondary indexes or to search data warehouses. Each bit vector represents a different value of an attribute, and the length of each vector is the number of rows (rows) in the table.
  * Bitmap and Bitmap join indexes
* **Composite index** - An index based on more than one attribute or key (i.e., a concatenated key).
* **Covering Index** - An index with enough information to satisfy certain queries by itself, in other words, the query can be satisfied merely by searching the index and not the database.
* **B+ Tree** 
  * Basic table index based on one or more attributes, often used to enforce uniqueness of primary keys.
  * These indexes are the standard index type. They are excellent for primary key and highly-selective indexes. Used as concatenated indexes, B-tree indexes can retrieve data sorted by the indexed columns. 
  * B-tree indexes have the following subtypes:
    * **Index-organized tables**: An index-organized table differs from a heap-organized because the data is itself the index. 
    * **Reverse key indexes**: In this type of index, the bytes of the index key are reversed, for example, 103 is stored as 301. The reversal of bytes spreads out inserts into the index over many blocks. 
    * **Descending indexes**: This type of index stores data on a particular column or columns in descending order. 
B-tree cluster indexes
* **Dense Vs Sparse Index** - A dense index has a pointer to each row in the table; a sparse index has at most one pointer to each block or page in the table.
* **Function-based indexes**
* **Application Domain indexes**
* **Bi-directional indexes**

## When to use Clustered index?

* **Range searches** - Clustered indexes can improve performance for range retrievals because it can be used to set the bounds of a search, even if the query involves the large percentage of the rows in the table. Because the data is in sorted order, the db can use it to find the starting and ending points of the range, and scan only the data pages within the range. 
* Without a clustered index, the rows could be randomly spread throughout the table, and the db would have to perform a table scan to find all rows within the range. 
* Columns containing number of duplicates - Same concept holds true for indexes on columns with a large number of duplicates. With a clustered index, the duplicate values are grouped together. This minimizes the no. of pages that would have to be read to retrieve them. 
* Columns often referenced in an ORDER BY. Most sorts require that the table be copied into a buffer pool(DB2) or work table in tempdb(Sybase). This incurs additional I/O overhead. However if you're performing an ORDER BY on clustered index columns on a table, you can avoid creating a work table even if a query contains no search arguments.
* Columns other than primary key reference in join clauses - Clustered indexes can also be more efficient for joins that are non-clustered indexes, cos clustered indexes usually are much smaller in size; typically they are atleast on level less in the B-tree. 
* **Single index table** - If you require only a single index on a table, it typically is advantageous to make it a clustered index, as the resulting overhead of maintaining clustered indexes during updates, inserts and deletes can be considerably less than the other one. 

## Index Covering 

* Index covering is a mechanism for using the leaf level of a non-clustered index the way the data page of a clustered index would work. This occurs when all columns referenced in a query are contained in the index itself. 
* Because the non-clustered index contains a leaf row corresponding to every data row in the table, db can satisfy the query from the leaf rows of the non-clustered index without having to read the data pages. 
* Because all leaf index pages point to the next page in the leaf-page chain, the leaf level of the index can be scanned just like the data pages in a table. 
* Because the leaf index rows typically are much smaller than the data rows, a non-clustered index that covers a query will be faster than a clustered index on the same columns, due to the fewer number of pages that must be read. 
* **Covered Queries** - in a query, if all the columns mentioned in the conditions section are part of an index, then it's a covered query 

## Indexing Rules of Thumb

* Index every primary key and most foreign keys in the database.
* Attributes frequently referenced in SQL WHERE clauses are potentially good candidates for an index.
* Use a B+tree index for both equality and range queries
* Choose carefully one clustered index for each table
* Avoid or remove redundant indexes
* Add indexes only when absolutely necessary
* Add or delete index columns for composite indexes to improve performance. Do not alter primary key columns
* Use attributes for indexes with caution when they are frequently updated.
* Keep up index maintenance on a regular basis; drop indexes only when they are clearly hurting performance
* Avoid extremes in index cardinality and value distribution.
* Covering indexes (index only) are useful, but often overused
* Use bitmap indexes for high-volume data, especially in data warehouses.


## Index Selection Decisions

* Does this table require an index or not, and if so which search key should I build an index on?
* When do I need multi-attribute (composite) search keys, and which ones should I choose?
* Should I use a dense or sparse index?
* When can I use a covering index?
* Should I create a clustered index?
* Is an index still preferred when updates are taken into account? What are the tradeoffs between queries and updates for each index chosen?
* How do I know I made the right indexing choice?

## Properties of an Index (Oracle feature)

* **Usability**
  * Indexes are usable (default) or unusable. An unusable index is not maintained by DML operations and is ignored by the optimizer. An unusable index can improve the performance of bulk loads. Instead of dropping an index and later re-creating it, you can make the index unusable and then rebuild it. Unusable indexes and index partitions do not consume space. When you make a usable index unusable, the database drops its index segment.
* **Visibility**
  * Indexes are visible (default) or invisible. An invisible index is maintained by DML operations and is not used by default by the optimizer. Making an index invisible is an alternative to making it unusable or dropping it. Invisible indexes are especially useful for testing the removal of an index before dropping it or using indexes temporarily without affecting the overall application.
* **Composite Indexes**
  * A composite index, also called a concatenated index, is an index on multiple columns in a table. Columns in a composite index should appear in the order that makes the most sense for the queries that will retrieve data and need not be adjacent in the table.
  * `CREATE INDEX employees_ix ON employees (last_name, job_id, salary);`
  * Queries that access all three columns, only the last_name column, or only the last_name and job_id columns use this index. In this example, queries that do not access the last_name column do not use the index.
  * Multiple indexes can exist for the same table if the permutation of columns differs for each index. You can create multiple indexes using the same columns if you specify distinctly different permutations of the columns. For example, the following SQL statements specify valid permutations:
  * `CREATE INDEX employee_idx1 ON employees (last_name, job_id);`
  * `CREATE INDEX employee_idx2 ON employees (job_id, last_name);`
* **Unique and Nonunique Indexes**
  * Indexes can be unique or nonunique. Unique indexes guarantee that no two rows of a table have duplicate values in the key column or column. For example, no two employees can have the same employee ID. Thus, in a unique index, one rowid exists for each data value. The data in the leaf blocks is sorted only by key.
  * Nonunique indexes permit duplicates values in the indexed column or columns. For example, the first_name column of the employees table may contain multiple Mike values. For a nonunique index, the rowid is included in the key in sorted order, so nonunique indexes are sorted by the index key and rowid (ascending).
  * Oracle Database does not index table rows in which all key columns are null, except for bitmap indexes or when the cluster key column value is null.

# Query Optimization

When db processes the query, it performs the following steps: 

* Parses and normalizes the query, validating syntax and object references 
* Optimizes the query and generates the query plan 
  * Phase 1 - Query Analysis 
    * Find the search arguments (SARG) 
    * Find the ORs c. Find the joins 
  * Phase 2 - Index Selection 
    * Choose the best index for each SARG 
    * Choose the best method for ORs 
    * Choose the best indexes for any join clauses 
    * Choose the best index to use for each table 
  * Phase 3 - Join Order Selection 
    * Evaluate the join orders 
    * Compute the costs 
    * Evaluate other server options for resolving joins 
  * Phase 4 - Plan Selection 
* Compiles the query plan 
* Executes the query plan and returns the results to the user.

How do you tune a SQL query? How do you use an access plan?

## Query Execution Plan

* What is?
* How to read a query execution plan?

Page Extent - Denotes the # of contiguous pages of data read from the hard disk at a time. SQL reads 8 pages(64K) at a time.

# Concurrency 

http://msdn2.microsoft.com/en-us/library/ms171845(SQL.90).aspx 

* Dirty reading
* Phantom reading

## Locks
* Locks http://www.dbazine.com/db2/db2-disarticles/gulutzan6 
  * Shared Lock
  * Update Lock 
  * Exclusive Lock (http://www.dbazine.com/db2/db2-disarticles/gulutzan6) 
* Deadlock 
  * Deadlock is a situation when two processes, each having a lock on one piece of data, attempt to acquire a lock on the other's piece. Each process would wait indefinitely for the other to release the lock, unless one of the user processes is terminated. SQL Server detects deadlocks and terminates one user's process. 
  * How do you avoid deadlocks?
* Livelock 
  * A livelock is one, where a request for an exclusive lock is repeatedly denied because a series of overlapping shared locks keeps interfering. SQL Server detects the situation after four denials and refuses further shared locks. A livelock also occurs when read transactions monopolize a table or page, forcing a write transaction to wait indefinitely. 
* Lock contention 
* Lock escalation

## Isolation Levels
* Access to uncommitted data (only with UR)
* Non-repeatable read (only with UR & CS)
* Phantom read phenomenon (only with UR, CS & RS)
* Isolation levels
* Repeatable Read(RR)
* Read Stability (RS)
  * Cursor Stability (CS)
  * Uncommitted Read (UR)

# References

* Sybase - Performance and Tuning Guide
* Physical Database Design - Database Professional's Guide to Exploiting Indexes, Views, Storage & More
* Dissecting SQL Server Execution Plans and SQL Tuning