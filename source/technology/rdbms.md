---
layout: page
title: "RDBMS Concepts"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

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

* [Joining in DB2](http://etutorials.org/Misc/advanced+dba+certification+guide+and+reference/Chapter+6.+The+DB2+Optimizer/Joining+in+DB2+UDB/)
* [Join Methods and Strategies](http://pic.dhe.ibm.com/infocenter/db2luw/v9r7/index.jsp?topic=%2Fcom.ibm.db2.luw.admin.perf.doc%2Fdoc%2Fc0005311.html)
* [Getting the Most from Hash Joins](http://www3.software.ibm.com/ibmdl/pub/software/dw/dm/db2/0208zubiri/0208zubiri.pdf)

# FAQs

* What's the difference between DELETE TABLE and TRUNCATE TABLE commands? 
  * DELETE TABLE is a logged operation, so the deletion of each row gets logged in the transaction log, which makes it slow. 
  * TRUNCATE TABLE also deletes all the rows in a table, but it won't log the deletion of each row, instead it logs the de-allocation of the data pages of the table, which makes it faster. Of course, TRUNCATE TABLE can be rolled back. 
* Pivoting
* Co-related subquery? Co-related query is a query in which subquery depends on execution of main query 

```sql
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