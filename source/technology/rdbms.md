---
layout: page
title: "DBMS Concepts"
comments: true
sharing: true
footer: true
---

[TOC]

# Concepts

## Keys

> Refer to SQL Tips and Techniques-2002

* **Primary Key***
  * PK is an attribute or a set of attributes that uniquely identify a specific instance of an entity. 
  * PKs enforce entity integrity by uniquely identifying entity instances. 
* **Candidate Key** - an entity can have more than one attribute that can serve as a primary key. Any key or minimum set of keys that could be a primary key is called a candidate key. (Eg. EmpId, SSN, Name of an Employee entity) 
* **Alternate Key** - Rest of the non-primary keys are called alternate keys 
* **Composite Key** - A primary key made up of more than one attribute is known as a composite key 
* **Foreign Key**
  * is an attribute that completes a relationship by identifying the parent entity. 
  * Foreign keys provide a method for maintaining integrity in the data (called referential integrity) and for navigating between different instances of an entity. 

**Difference between a primary key and a unique key?**
Both primary key and unique enforce uniqueness of the column on which they are defined. But by default primary key creates a clustered index on the column, whereas unique key creates a nonclustered index by default. Another major difference is that, primary key doesn't allow NULLs, but unique key allows one NULL only. Identity columns & default values

## Integrity

* **Data integrity** - means, in part, that you can correctly and consistently navigate and manipulate the tables in the database. There are two basic rules to ensure data integrity; entity integrity and referential integrity. 
  * **Entity Integrity**- Entity integrity rule states that for every instance of an entity, the value of the primary key must exist, be unique, and cannot be null. 
  * **Referential Integrity**- rule states that every foreign key value must match a primary key value in an associated table. Referential integrity ensures that we can correctly navigate between related entities. FKs can have nulls.

### Constraints
* Constraints enable the RDBMS enforce the integrity of the database automatically, without needing you to create triggers, rule or defaults.
* **Types of constraints**: NOT NULL, CHECK, UNIQUE, PRIMARY KEY, FOREIGN KEY 
* **Check Constraints** 

## Data Types

## LOB

## Cursors

* **Static Cursor** - Specifies that cursor will use a temporary copy of the data instead of base tables. This cursor does not allow modifications and modifications made to base tables are not reflected in the data returned by fetches made to this cursor. 
* **Dynamic Cursor** - 
* **Forward-ONLY Cursor** - Specifies that cursor can only fetch data sequentially from the first to the last row. FETCH NEXT is the only fetch option supported. 
* **KeySet Cursor** - 
  * Specifies that cursor uses the set of keys that uniquely identify the cursor's rows (keyset), so that the membership and order of rows in the cursor are fixed when the cursor is opened. SQL Server uses a table in tempdb to store keyset. 
  * The KEYSET cursor allows updates nonkey values from being made through this cursor, but inserts made by other users are not visible. 
  * Updates non-key values made by other users are visible as the owner scrolls around the cursor, but updates key values made by other users are not visible. If a row is deleted, an attempt to fetch the row returns an @@FETCH_STATUS of -2
* **Ref Cursors** - Cursor variables are like pointers to result sets. You use them when you want to perform a query in one subprogram, and process the results in a different subprogram (possibly one written in a different language). A cursor variable has datatype REF CURSOR, and you might see them referred to informally as REF CURSORs.
* **Implict & Explicit cursors**

## Triggers

Triggers are special kind of stored procedures that get executed automatically when an INSERT, UPDATE or DELETE operation takes place on a table. Triggers can't be invoked on demand. They get triggered only when an associated action (INSERT, UPDATE, DELETE) happens on the table on which they are defined.

### Disadvantages of cursors 
Each time you fetch a row from the cursor,it results in a network round trip, where as a normal SELECT query makes only one round trip, however large the resultset is. Further, there are restrictions on the SELECT statements that can be used with some types of cursors.

## Joins

* http://www.codinghorror.com/blog/2007/10/a-visual-explanation-of-sql-joins.html
* http://publib.boulder.ibm.com/infocenter/iseries/v5r4/index.jsp?topic=%2Fsqlp%2Frbafyjoin.htm 

* **Inner Join** - Records in both table A and table B where the given condition matches. e.g, `SELECT * FROM TableA INNER JOIN TableB ON TableA.name = TableB.name`
* **Cross Join** - Every possible pair of rows from both the tables. If no condition is provided in Inner join, then it becomes a cross join. e.g., `SELECT * FROM TableA CROSS JOIN TableB`
* **Full Outer Join** = Left Outer + Right Outer. e.g., `SELECT * FROM TableA FULL OUTER JOIN TableB ON TableA.name = TableB.name`
* **Right Outer Join** - e.g., `SELECT * FROM TableA RIGHT OUTER JOIN TableB ON TableA.name = TableB.name`
* **Left Outer Join** - e.g., `SELECT * FROM TableA LEFT OUTER JOIN TableB ON TableA.name = TableB.name`
* **Outer Join** - Records NOT in table A and table B where the given condition matches. e.g, `SELECT * FROM TableA FULL OUTER JOIN TableB ON TableA.name = TableB.name WHERE TableA.id IS null OR TableB.id IS null `
* **Equijoin** - 
* **Natural Join**- is an equijoin with redundant columns removed. 
* **Self Join** - 
* **Projection** - The project operator retrieves a subset of columns from a table, removing duplicate rows from the result.

### Join Algorithms

#### Nested Loop Join 

* *when one table is small, and other table is large*
* **What is?** The nested loops join, also called nested iteration, uses one join input as the outer input table and one as the inner input table. The outer loop consumes the outer input table row by row. For every outer row, the inner loop searches for matching rows in the inner input table.
* In the simplest case, the search scans an entire table or index; this is called a **naive nested loops join**. 
* If the search exploits an index, it is called an **index nested loops join**. 
* If the index is built as part of the query plan (and destroyed upon completion of the query), it is called a **temporary index nested loops join**. (All these variants are considered by the query optimizer.)
* **When is it effective?** A nested loops join is particularly effective if the outer input is small and the inner input is preindexed and large. In many small transactions, such as those affecting only a small set of rows, index nested loops joins are superior to both merge joins and hash joins. In large queries, however, nested loops joins are often not the optimal choice.
* Block nested loop join???
{% img right /technology/nested-loop-join.gif 300 300 %}

#### Merge Join / Sort-Merge Join

* *when both the tables involved in the join are large*
* The merge join requires both inputs to be sorted on the merge columns, which are defined by the equality (ON) clauses of the join predicate. The query optimizer typically scans an index, if one exists on the proper set of columns, or it places a sort operator below the merge join. In rare cases, there may be multiple equality clauses, but the merge columns are taken from only some of the available equality clauses.
* Because each input is sorted, the Merge Join operator gets a row from each input and compares them. For example, for inner join operations, the rows are returned if they are equal. If they are not equal, the lower-value row is discarded and another row is obtained from that input. This process repeats until all rows have been processed.
* The merge join operation may be either a regular or a many-to-many operation. A many-to-many merge join uses a temporary table to store rows. If there are duplicate values from each input, one of the inputs will have to rewind to the start of the duplicates as each duplicate from the other input is processed.
* If a residual predicate is present, all rows that satisfy the merge predicate evaluate the residual predicate, and only those rows that satisfy it are returned.
* Merge join itself is very fast, but it can be an expensive choice if sort operations are required. However, if the data volume is large and the desired data can be obtained presorted from existing B-tree indexes, merge join is often the fastest available join algorithm.
{% img right /technology/merge-join.gif 300 300 %}

#### Hash Join

* *when the data set is large but the result set expected is small*
* This algorithm also has a startup penalty by forcing you to build a hash table of one of the input sets before the actual join can start. 
* Performance
  * Compared to the sort merge join this is easier as it involves only one sweep through the data and therefore the computational complexity is `O(n)` while sorting won't be better than `O(n log n)`. So in general you can build the hash faster than you would be able to do the sorting.
  * The hash also needs to be computed for only one input set and this could be the smaller one.
  * This makes the hash join often the preferred choice over the sort merge join.
* Generally speaking the hash join wins when you expect a large result set and the nested loop join wins when you expect a small result set. One of the most dominant problems in this area is the planner getting the estimates wrong and taking the other path.
* The hash join can only be used if you use equality as join relation.
* Building the hash needs temporary space and increasing work_mem sometimes helps.
* The hash join is also a good candidate for parallel processing. 

* http://etutorials.org/Misc/advanced+dba+certification+guide+and+reference/Chapter+6.+The+DB2+Optimizer/Joining+in+DB2+UDB/
* http://pic.dhe.ibm.com/infocenter/db2luw/v9r7/index.jsp?topic=%2Fcom.ibm.db2.luw.admin.perf.doc%2Fdoc%2Fc0005311.html

# Design

## Physical Database Design

* Data compression techniques
* Data Striping (RAID)
  * What is RAID and what are different types of RAID configurations? 
  * RAID stands for Redundant Array of Inexpensive Disks, used to provide fault tolerance to database servers. There are six RAID levels 0 through 5 offering different levels of performance, fault * tolerance.
* Mirroring
* Denormalization
* Security
  * Permissioning - Users & Groups

### Data Modelling

### Normalization

> Refer to Sybase Performance and Tuning Guide

* http://dev.mysql.com/tech-resources/articles/intro-to-normalization.html 
* http://www.bkent.net/Doc/simple5.htm 
* http://publib.boulder.ibm.com/infocenter/dzichelp/v2r2/index.jsp?topic=%2Fcom.ibm.db2z10.doc.intro%2Fsrc%2Ftpc%2Fdb2z_denormalizationforperformance.htm

#### What is?
* process to eliminate data redundancy, and to remove potential update inconsistencies which arise from inserting, modifying, and deleting data. 
* The goal of normalization is to create a set of relational tables that are free of redundant data and that can be consistently and correctly modified. This means that all tables in a relational database should be in the third normal form (3NF). 
* A relational table is in 3NF if and only if all non-key columns are (a) mutually independent and (b) fully dependent upon the primary key. Mutual independence means that no non-key column is dependent upon any combination of the other columns. The first two normal forms are intermediate steps to achieve the goal of having all tables in 3NF. In order to better understand the 2NF and higher forms, it is necessary to understand the concepts of functional dependencies and lossless decomposition.

#### Types

* 1st Normal Form- A relational table, by definition, is in first normal form. 1NF requires all values of the columns to be atomic. That is, they contain no repeating values. Table in 1NF contains redundancy of data. Redundancy causes what is called as 'Update anomalies'
* 2nd Normal Form- The second normal form (or 2NF) any non-key columns must depend on the entire primary key. In the case of a composite primary key, this means that a non-key column cannot depend on only part of the composite key.
* 3rd Normal Form- Third Normal Form (3NF) requires that all columns depend directly on the primary key. Tables violate the 3NF when one column depends on another column, which in turn depends on the primary key (a transitive dependency). One way to identify transitive dependencies is to look at your table and see if any columns would require updating if another column in the table was updated. If such a column exists, it probably violates 3NF. 
* 4th Normal Form-
* 5th Normal Form- 
* Update Anomalies-Problems that arise when information is inserted, updated or deleted

## Patterns


* How do you implement 1-to-1, 1-to-many and many-to-many relationships while designing tables? 
* 1-to-1 relationship can be implemented as a single table and rarely as two tables with primary and foreign key relationships. 
* 1-to-Many relationships are implemented by splitting the data into two tables with primary key and foreign key relationships. 
* Many-to-Many relationships are implemented using a junction table with the keys from both the tables forming the composite primary key of the junction table.

### Bi-temporal milestoning
* Bi-temporal chaining – Database chaining mechanisms
* spatial and temporal locality

### Schema Patterns
* Data Warehouse schema types - http://datawarehouse4u.info/Data-Warehouse-Schema-Architecture.html
* Star schema

## Anti-Patterns

> Refer to SQL Anti-patterns

* Logical Database Anti-patterns
  * Comma separated lists
  * Multi-column attributes
  * Entity attribute value
  * Metadata tribbles
* Physical Database Anti-patterns
  * ID Required
  * Phantom Files
  * FLOAT Antipattern
  * ENUM Antipattern
  * Readable Passwords
* Query Anti-patterns
  * Ambiguous GROUP BY
  * HAVING antipattern
  * Poor Man's Search Engine
  * Implicit columns in SELECT and INSERT
* Application Anti-patterns
  * User-supplied SQL
  * SQL Injection
  * Parameter Façade
  * Pseudokey Neat Freak
  * Session Coupling
  * Phantom Side Effects

## Database Refactoring

> Refer to Refactoring Databases
* Database smells
* Refactoring strategies

# Performance

## Indexes

> Refer to Sybase - Performance and Tuning Guide

* http://use-the-index-luke.com/sql/table-of-contents 
* http://www.sqlskills.com/blogs/kimberly/guids-as-primary-keys-andor-the-clustering-key/
* http://www.micmin.com/Session320/Session%20320%20-%20Role%20of%20Indexes.htm 

An index is an ordered set of pointers associated with a table, and is used for performance purposes. 

### How Indexes work?

Each index entry contains a search-key value and a pointer to the row containing that value. If you specify the ALLOW REVERSE SCANS parameter in the CREATE INDEX statement, the values can be searched in both ascending and descending order. It is therefore possible to bracket the search, given the right predicate. An index can also be used to obtain rows in an ordered sequence, eliminating the need for the database manager to sort the rows after they are read from the table.

Although the optimizer decides whether to use an index to access table data, except in the following case, you must decide which indexes might improve performance and create these indexes. Exceptions are the dimension block indexes and the composite block index that are created automatically for each dimension that you specify when you create a multi-dimensional clustering (MDC) table.

In addition to the search-key value and row pointer, an index can contain include columns, which are non-indexed columns in the indexed row. Such columns might make it possible for the optimizer to get required information only from the index, without accessing the table itself.

### Limitations

Although indexes can reduce access time significantly, they can also have adverse effects on performance. Before you create indexes, consider the effects of multiple indexes on disk space and processing time:

* Each index requires storage or disk space. The exact amount depends on the size of the table and the size and number of columns in the index. 
* Each INSERT or DELETE operation performed on a table requires additional updating of each index on that table. This is also true for each UPDATE operation that changes the value of an index key. 
* Each index potentially adds an alternative access path for a query for the optimizer to consider, which increases the compilation time. 

### Index usage criteria 

The query contains a column in a join clause that matches at least the first column of the index. eg. `create index idx1 on emp (division, dep, emptype) `

* All the below queries will make use of the above index. 
  * `select * from emp where division='acct' `
  * `select * from emp where division='acct' and dept='fin' `
  * `select * from emp where division='acct' and emptype='exempt' `
* However, this query would be NOT be able to use the index since it doesn't specify the first column of the index. 
  * `select * from emp where emptype='exempt' `

### Index Types

1. **Clustered** Any index structure having the data accessed in the same way the index is organized so that data with similar or the same key values is stored (or clustered) together. Clustering tends to greatly reduce input/output (I/O) time for queries and sorting.
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
  * These indexes are the standard index type. They are excellent for primary key and highly-selective indexes. Used as concatenated indexes, B-tree indexes can retrieve data sorted by the indexed columns. B-tree indexes have the following subtypes:
    * **Index-organized tables**: An index-organized table differs from a heap-organized because the data is itself the index. 
    * **Reverse key indexes**: In this type of index, the bytes of the index key are reversed, for example, 103 is stored as 301. The reversal of bytes spreads out inserts into the index over many blocks. 
    * **Descending indexes**: This type of index stores data on a particular column or columns in descending order. 
B-tree cluster indexes
* **Dense Vs Sparse Index** - A dense index has a pointer to each row in the table; a sparse index has at most one pointer to each block or page in the table.
* **Function-based indexes**
* **Application Domain indexes**
* **Bi-directional indexes**

### When to use Clustered index?

* **Range searches** - Clustered indexes can improve performance for range retrievals because it can be used to set the bounds of a search, even if the query involves the large percentage of the rows in the table. Because the data is in sorted order, the db can use it to find the starting and ending points of the range, and scan only the data pages within the range. 
* Without a clustered index, the rows could be randomly spread throughout the table, and the db would have to perform a table scan to find all rows within the range. 
* Columns containing number of duplicates - Same concept holds true for indexes on columns with a large number of duplicates. With a clustered index, the duplicate values are grouped together. This minimizes the no. of pages that would have to be read to retrieve them. 
* Columns often referenced in an ORDER BY. Most sorts require that the table be copied into a buffer pool(DB2) or work table in tempdb(Sybase). This incurs additional I/O overhead. However if you're performing an ORDER BY on clustered index columns on a table, you can avoid creating a work table even if a query contains no search arguments.
* Columns other than primary key reference in join clauses - Clustered indexes can also be more efficient for joins that are non-clustered indexes, cos clustered indexes usually are much smaller in size; typically they are atleast on level less in the B-tree. 
* **Single index table** - If you require only a single index on a table, it typically is advantageous to make it a clustered index, as the resulting overhead of maintaining clustered indexes during updates, inserts and deletes can be considerably less than the other one. 

### Index Covering 

* Index covering is a mechanism for using the leaf level of a non-clustered index the way the data page of a clustered index would work. This occurs when all columns referenced in a query are contained in the index itself. 
* Because the non-clustered index contains a leaf row corresponding to every data row in the table, db can satisfy the query from the leaf rows of the non-clustered index without having to read the data pages. 
* Because all leaf index pages point to the next page in the leaf-page chain, the leaf level of the index can be scanned just like the data pages in a table. 
* Because the leaf index rows typically are much smaller than the data rows, a non-clustered index that covers a query will be faster than a clustered index on the same columns, due to the fewer number of pages that must be read. 
* **Covered Queries** - in a query, if all the columns mentioned in the conditions section are part of an index, then it's a covered query 

### Indexing Rules of Thumb

> Refer to Physical Database Design - Database Professional's Guide to Exploiting Indexes, Views, Storage & More

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


### Index Selection Decisions

* Does this table require an index or not, and if so which search key should I build an index on?
* When do I need multi-attribute (composite) search keys, and which ones should I choose?
* Should I use a dense or sparse index?
* When can I use a covering index?
* Should I create a clustered index?
* Is an index still preferred when updates are taken into account? What are the tradeoffs between queries and updates for each index chosen?
* How do I know I made the right indexing choice?

### Properties of an Index (Oracle feature)

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

## Query Optimization

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

### Query Execution Plan

> Refer to Dissecting SQL Server Execution Plans and SQL Tuning
* What is?
* How to read a query execution plan?

Page Extent - Denotes the # of contiguous pages of data read from the hard disk at a time. SQL reads 8 pages(64K) at a time.

## Concurrency 

http://msdn2.microsoft.com/en-us/library/ms171845(SQL.90).aspx 

* Dirty reading
* Phantom reading

### Locks
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

### Isolation Levels
* Access to uncommitted data (only with UR)
* Non-repeatable read (only with UR & CS)
* Phantom read phenomenon (only wit UR, CS & RS)
* Isolation levels
* Repeatable Read(RR)
* Read Stability (RS)
  * Cursor Stability (CS)
  * Uncommitted Read (UR)

# FAQs

* What's the difference between DELETE TABLE and TRUNCATE TABLE commands? 
  * DELETE TABLE is a logged operation, so the deletion of each row gets logged in the transaction log, which makes it slow. 
  * TRUNCATE TABLE also deletes all the rows in a table, but it won't log the deletion of each row, instead it logs the de-allocation of the data pages of the table, which makes it faster. Of course, TRUNCATE TABLE can be rolled back. 
* Pivoting
* Co-related subquery? Co-related query is a query in which subquery depends on execution of main query 
``` sql
Select DeptNo,Ename,Sal From Emp e1 Where Sal=(Select Max(Sal) From Emp e2 Where e1.DeptNo=e2.DeptNo)
```
* What is SQL Injection and how to prevent it?
* How to select first/last/max per group in SQL : http://www.xaprb.com/blog/2006/12/07/how-to-select-the-firstleastmax-row-per-group-in-sql/ 
* SQL query to get 4th or 5th maximum value from a table 
``` sql
select max(id) from EMP A where N=(select count(id) From EMP B where B.ID>=A.ID) 
OR 
select * from (select rownum rn,id from (select distinct id From EMP order by id desc)) where rn between N-1 and N;
```
* How to identify the performance order (Big-O notation) of a query?
* How query execution order works when a SQL has sub-queries in it?
* When we need to use USING clause in the sql?For example in this below: SELECT emp_name, department_name, city FROM employees e JOIN departments d USING (department_id) JOIN locations l USING (location_id) WHERE salary > 10000;
* How to delete duplicate records in a table? 
``` sql
DELETE FROM test t1 WHERE EXISTS ( SELECT * FROM test t2 WHERE t2.col1=t1.col1 AND t2.rowid <> t1.rowid);
```
* What will be the o/p of this query? 
* `SELECT 1 FROM DUAL UNION SELECT 'A' FROM DUAL;` The query would throw an error. The two data types in the union set should be same. Out here it is a 1 and 'A', datatype mismatch and hence the error.

# Bibliography

* Physical Database Design - The Database Professional's Guide to Exploiting Indexes, Views, Storage, and More
* Refactoring Databases
* SQL Anti-patterns
* http://www.geekinterview.com/articles/sql-interview-questions-with-answers.html