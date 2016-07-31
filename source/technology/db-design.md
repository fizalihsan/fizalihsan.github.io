---
layout: page
title: "DB Design"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Physical Database Design

* Data compression techniques
* Data Striping (RAID)
  * What is RAID and what are different types of RAID configurations? 
  * RAID stands for Redundant Array of Inexpensive Disks, used to provide fault tolerance to database servers. There are six RAID levels 0 through 5 offering different levels of performance, fault-tolerance.
* Mirroring
* Security
  * Permissioning - Users & Groups


## Normalization

* [Intro to Normalization](http://dev.mysql.com/tech-resources/articles/intro-to-normalization.html)
* http://www.bkent.net/Doc/simple5.htm 

* **What is Normalization?**
	* process to eliminate data redundancy, and to remove potential update inconsistencies which arise from inserting, modifying, and deleting data. 
	* The goal of normalization is to create a set of relational tables that are free of redundant data and that can be consistently and correctly modified. This means that all tables in a relational database should be in the third normal form (3NF). 

* **1st Normal Form** 

{% img /technology/1NF.png%}

	* *No multi-value columns*
	* A relational table, by definition, is in first normal form. 
	* 1NF requires all values of the columns to be atomic. That is, they contain no repeating values like comma-separated names. 
	* Table in 1NF contains redundancy of data. Redundancy causes what is called as **Update anomalies**


* **2nd Normal Form**

{% img /technology/2NF.png%}

	* *No partial dependencies*
	* any non-key columns must depend on the entire primary key. In the case of a composite primary key, this means that a non-key column cannot depend on only part of the composite key.


* **3rd Normal Form**

{% img /technology/3NF.png%}

	* *No transitive dependencies*
	* 3NF requires that every non-prime attribute must be dependent on primary key. 
	* Tables violate the 3NF when one column depends on another column, which in turn depends on the primary key (**a transitive dependency**). One way to identify transitive dependencies is to look at your table and see if any columns would require updating if another column in the table was updated. If such a column exists, it probably violates 3NF. 
	* A relational table is in 3NF if and only if all non-key columns are 
		* (a) mutually independent (means that no non-key column is dependent upon any combination of the other columns.)
		* (b) fully dependent upon the primary key.  
	* The first two normal forms are intermediate steps to achieve the goal of having all tables in 3NF. In order to better understand the 2NF and higher forms, it is necessary to understand the concepts of functional dependencies and lossless decomposition.

* **4th Normal Form**: Every non-trivial multivalued dependency in the table is a dependency on a superkey.

* **5th Normal Form**: Every non-trivial join dependency in the table is implied by the superkeys of the table.


* Denormalization

[Denormalization for performance](http://www.ibm.com/support/knowledgecenter/SSEPEK_10.0.0/com.ibm.db2z10.doc.intro/src/tpc/db2z_denormalizationforperformance.htm)

## Concept of Time in Database

### Temporal Data Types

* Instant: something happened at an instant of time. (e.g., now)
* Interval
	* a length of time (e.g., three months)
	* The individual units (months, hours, microseconds, etc.) are termed *granules*
	* An interval is relative; an instant is absolute
	* An interval can be added to an instant, yielding another instant
	* The distance between two instants is an interval
	* Unlike instants, intervals have direction. e.g., -7 days
	* ***Year-Month Intervals*** - store only year, or only month or year-month. 
	* ***Day-Time Intervals***
	* SQL Data types
		* DATE
		* TIME
		* TIME WITH TIME ZONE
		* TIMESTAMP - date + time
		* TIMESTAMP WITH TIME ZONE - includes date, time and an explicit offset from UTC. e.g., `11:08:27.123456-07:00`, where `-07:00` indicates 7 hours behind UTC
* Period: an anchored duration of time (e.g., the fall semester, Aug 24 through
Dec 18, 1998)

> SQL-92 supports instance and intervals only

### Kinds of Time

* (1) User-defined time: an uninterpreted time value
* (2) Valid time: when a fact was true in the modeled reality (VALID_FROM, VALID_TO)
* (3) Transaction time: when a fact was stored in the database (CREATION_TIME, UPDATE_TIME)

* These kinds of time are orthogonal: a table can be associated with none, one, two,
or even all three kinds of time. Understanding each kind of time and determining
which is present in an application is absolutely critical.

>  SQL-92 supports only 'user-defined time'

* Temporal Statements
	* Current: now (*what is now?*)
	* Sequenced: at each instant of time (*what was, and when?*)
	* Nonsequenced: ignoring time (*what was, at any time?*)

### Temporal Table Types

* Valid-Time State tables
	* Valid-time tables capture a history of validity
	* contains `FROM_DATE` & `TO_DATE` 
	* To indicate an active record `TO_DATE` is set to `null` or end-of-time `9999-12-31`
	* The first consequence of adding valid-time support to a table is that the primary key of such tables needs to take the timestamp into consideration, so that the record is unique *at any point in time*.

* Transcation-Time State tables
	* Transaction-time tables capture a history of the changing state of a table.
	* contains information when a record was created and last updated.
	* one of these pairs is used
		* `START_DATE` & `END_DATE`
		* `IN_Z` & `OUT_Z`
		* `CR_TIME` & `UPD_TIME`
	* `END_DATE = '9999-12-31'` indicates an active record
	* rows are *logically* deleted, because physically deleting old rows would prevent past states from being reconstructed. A table that can be reconstructed as of a previous date is termed a **transaction-time state** table, as it captures the transactions applied to the table.
* Bi-Temporal Tables
	* captures both validity and transaction time of a record
	* MarkLogic NoSQL database has a native support for bitemporal collections

> Temporal Tables have also been called *historical tables* but this implies that they record information only about the past. However, 'valid-time' tables often store information about future.

> The presence of a `DATE` column will not render the database as a temporal database; rather, the database must record the time-varying nature of the information managed by the enterprise.

## Time-Series Databases

...

# Patterns

* How do you implement 1-to-1, 1-to-many and many-to-many relationships while designing tables? 
	* 1-to-1 relationship can be implemented as a single table and rarely as two tables with primary and foreign key relationships. 
	* 1-to-Many relationships are implemented by splitting the data into two tables with primary key and foreign key relationships. 
	* Many-to-Many relationships are implemented using a junction table with the keys from both the tables forming the composite primary key of the junction table.

## Schema Patterns

* Data Warehouse schema types - http://datawarehouse4u.info/Data-Warehouse-Schema-Architecture.html
* Star schema

# Anti-Patterns

## Logical Database Anti-patterns

### Comma separated lists (Jaywalking)

* Storing composite values in a single columns. Typically comma separated values.
* Cons
	* DB cannot ensure referential integrity on this column.
	* VARCHAR column will run into length limit issues.

### Multi-column attributes

### Entity attribute value

### Metadata tribbles

### Adjacency List

Storing multi-level hierarchical data like organization chart, threaded discussion and comments, directory structure, etc.

```sql
CREATE TABLE Comment (
	id INT PRIMARY KEY
	parent_id INT,
	....
	FOREIGN KEY (parent_id) REFERENCES Comment (id)
)
```

**Pros**

* Good for use cases where the depth is not more than 2 or 3 and is fixed.

**Cons**

* It is easy to query one or two levels of the hierarchy by self joins. However, in order to extend the query to any depth, it becomes impossible, since the number of joins in SQL must be fixed.
* Copying the entire hierarchy from database to application for tree creation is highly inefficient.
* Inserting a node in a sub-tree is easy, however deleting a node or an entire sub-tree is difficult. ON DELETE CASCADE modifier can be used.
* If the non-leaf node should be deleted without deleting the children, then all the parent_id needs to be modified.
* Some databases support `WITH` keyword to recursively query hierarchical data.

*Alternatives*

* *Path Enumeration*
	* Instead of storing parent_id, store the path to each node in unix file path like format in varchar column. E.g., 1/2/4/5.

```sql
CREATE TABLE Comment (
	id INT PRIMARY KEY
	path VARCHAR(1000), <------
	....
	FOREIGN KEY (parent_id) REFERENCES Comment (id)
)
```
**Pros**

* Querying ancestors and children is easy. E.g., `SELECT * FROM Comment c WHERE c.path like '1/4/'`

**Cons**

* Same problem as the Jaywalking antipattern.

* *Nested Sets*

	* Assigning a number to each node's left and right children. Kind of like balanced binary tree.

**Cons**

* Not easily understandable
* Does not support referential integrity
* Useful only when the tree is queried frequently, than modified

*Closure Table*

Creating a separate table to store the relationship of nodes. By far the versatile design for storing tree structures.

**Cons**

Requires additional table and hence increasing space consumption.

## Physical Database Anti-patterns

* ID Required
* Phantom Files
* FLOAT Antipattern
* ENUM Antipattern
* Readable Passwords

## Query Anti-patterns

* Ambiguous GROUP BY
* HAVING antipattern
* Poor Man's Search Engine
* Implicit columns in SELECT and INSERT

## Application Anti-patterns

* User-supplied SQL
* SQL Injection
* Parameter Façade
* Pseudokey Neat Freak
* Session Coupling
* Phantom Side Effects





# References

* Books
	* Refactoring Databases
	* SQL Anti-Patterns
	* Developing time-oriented database applications in SQL
	* Sybase Performance and Tuning Guide