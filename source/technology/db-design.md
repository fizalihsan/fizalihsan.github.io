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
  * RAID stands for Redundant Array of Inexpensive Disks, used to provide fault tolerance to database servers. There are six RAID levels 0 through 5 offering different levels of performance, fault * tolerance.
* Mirroring
* Denormalization
* Security
  * Permissioning - Users & Groups

## Data Modelling

## Normalization

* http://dev.mysql.com/tech-resources/articles/intro-to-normalization.html 
* http://www.bkent.net/Doc/simple5.htm 
* http://publib.boulder.ibm.com/infocenter/dzichelp/v2r2/index.jsp?topic=%2Fcom.ibm.db2z10.doc.intro%2Fsrc%2Ftpc%2Fdb2z_denormalizationforperformance.htm

### What is?
* process to eliminate data redundancy, and to remove potential update inconsistencies which arise from inserting, modifying, and deleting data. 
* The goal of normalization is to create a set of relational tables that are free of redundant data and that can be consistently and correctly modified. This means that all tables in a relational database should be in the third normal form (3NF). 
* A relational table is in 3NF if and only if all non-key columns are (a) mutually independent and (b) fully dependent upon the primary key. Mutual independence means that no non-key column is dependent upon any combination of the other columns. The first two normal forms are intermediate steps to achieve the goal of having all tables in 3NF. In order to better understand the 2NF and higher forms, it is necessary to understand the concepts of functional dependencies and lossless decomposition.

### Types

* 1st Normal Form- A relational table, by definition, is in first normal form. 1NF requires all values of the columns to be atomic. That is, they contain no repeating values. Table in 1NF contains redundancy of data. Redundancy causes what is called as 'Update anomalies'
* 2nd Normal Form- The second normal form (or 2NF) any non-key columns must depend on the entire primary key. In the case of a composite primary key, this means that a non-key column cannot depend on only part of the composite key.
* 3rd Normal Form- Third Normal Form (3NF) requires that all columns depend directly on the primary key. Tables violate the 3NF when one column depends on another column, which in turn depends on the primary key (a transitive dependency). One way to identify transitive dependencies is to look at your table and see if any columns would require updating if another column in the table was updated. If such a column exists, it probably violates 3NF. 
* 4th Normal Form-
* 5th Normal Form- 
* Update Anomalies-Problems that arise when information is inserted, updated or deleted

# Patterns


* How do you implement 1-to-1, 1-to-many and many-to-many relationships while designing tables? 
* 1-to-1 relationship can be implemented as a single table and rarely as two tables with primary and foreign key relationships. 
* 1-to-Many relationships are implemented by splitting the data into two tables with primary key and foreign key relationships. 
* Many-to-Many relationships are implemented using a junction table with the keys from both the tables forming the composite primary key of the junction table.

## Bi-temporal milestoning

* Bi-temporal chaining – Database chaining mechanisms
* spatial and temporal locality

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
* Some databases support WITH keyword to recursively query hierarchical data.

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

* Querying ancestors and children is easy. E.g., SELECT * FROM Comment c WHERE c.path like '1/4/'

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

* Refactoring Databases
* SQL Anti-Patterns
* Sybase Performance and Tuning Guide