---
layout: page
title: "RDBMS Products"
comments: true
sharing: true
footer: true
---

[TOC]

# DB2

## Basics

### Special tables

* Global temporary tables - with or without logging - http://www.ibm.com/developerworks/data/library/techarticle/dm-0912globaltemptable/
* MDC Tables

### Views

* A view is an alternate way of representing data that exists in one or more tables. 
* A view can include some or all of the columns from one or more tables. It can also be based on other views. 
* A view is the result of a query on one or more tables. A view looks like a real table, but is actually just a representation of the data from one or more tables. 
* A view is a logical or virtual table that does not exist in physical storage. 
* It is an efficient way of representing data without needing to maintain it. When the data shown in a view changes, those changes were a result of changes made to the data in the tables themselves. 
* Views are used to see different presentations of the same data. Views are a way to control access to sensitive data. Different users can have access to different columns and rows based on their needs. 
* When the column of a view is directly derived from the column of a base table, that view column inherits any constraints that apply to the base table column. For example, if a view includes a foreign key of its base table, insert and update operations using that view are subject to the same referential constraints as is the base table. 
* Also, if the base table of a view is a parent table, delete and update operations using that view are subject to the same rules as are delete and update operations on the base table. 
* A view can derive the data type of each column from the result table, or base the types on the attributes of a user-defined structured type. This is called a typed view. Similar to a typed table, a typed view can be part of a view hierarchy. 
* A subview inherits columns from its superview. The term subview applies to a typed view and to all typed views that are below it in the view hierarchy. A proper subview of a view V is a view below V in the typed view hierarchy. 
* A view can become inoperative (for example, if the base table is dropped); if this occurs, the view is no longer available for SQL operations.
* Views CAN contain the following: Aggregate functions and groupings, Joins Other views, distinct clause 
* Views CANNOT contain the following: select into, compute clause, union, order by.

Types of Views
* Horizontal view - Slices the source table horizontally to create the view. All of the columns of the source table participate in the view, but only some of its rows are visible through the view. Horizontal views are appropriate when the source table contains data that relates to various organizations or users. They provide a "private table" for each user, composed only of the rows needed by that user. 
* Vertical view - TODO
* Indexed views - TODO 

## Command Line Options

* Enter command prompt by typing 'db2'
* To take input from a file and output to a file: `db2 -tvf db2input.txt > db2output.txt &`
* To connect to database: `CONNECT to NYCMRDI4 USER cmdrinfr USING s0mepassw0rd`
* Command to list the databases: `list db directory`
* Command to list the tables: `list db tables`
* Read input from file: `db2 -tvf filename`
* Db2advis - command to advice indexes on sql
* How to find out if statistics on a table or schema is up-to-date?
  * If CARD is -1 or STATS_TIME is null or far in the past, then statistics needs to be updated. Non-negative number on CARD denotes the number of rows on the table.

```
SELECT CARD, STATS_TIME FROM SYSCAT.TABLES WHERE TABNAME='MARGININFO'
```

  * If NLEAF, NLEVELS & FULLKEYCARD is -1 or STATS_TIME is null or far in the past, then statistics needs to be updated on that index

```
SELECT NLEAF, NLEVELS, FULLKEYCARD, STATS_TIME, i.* FROM SYSCAT.INDEXES i WHERE TABSCHEMA='CMDRPROD' and TABNAME='MARGININFO'
```
  * Via DB2 Command - `reorgchk update statistics on SCHEMA CMDRPROD`
* Reorg - TODO
* Runstats - Execute to collect statistics of the table and its indexes to help optimizer choose the best data-access plan

```
RUNSTATS ON TABLE schema.table WITH DISTRIBUTION AND DETAILED INDEXES ALL;
RUNSTATS ON TABLE schema.table; 
```

(If reorg is run, then execute runstats also)
Execute Runstats : after creating an index, after hanging the prefetch size, after executing reorg. Also execute it at regular intervals to keep the statistics current.

* Check transaction log usage : `call sp.xlogfull()`
* Row count on table without full table scan

```
SELECT tabname TableName, card RowCount FROM syscat.tables WHERE TABNAME='tableName'
```

* Truncate a table without transaction logging

```
LOAD FROM /dev/null of del REPLACE INTO YourTable
```

This operation is fully recoverable. Note that on Windows systems, you have to replace `/dev/null` by `NUL`.

OR

```
ALTER TABLE YourTable ACTIVATE NOT LOGGED INITIALLY WITH EMPTY TABLE
```

Causes all data currently in table to be removed. Once the data has been removed, it cannot be recovered except through use of the RESTORE facility. If the unit of work in which this alter statement was issued is rolled back, the table data will not be returned to its original state. 
When this action is requested, no DELETE triggers defined on the affected table are fired. Any indexes that exist on the table are also deleted.

* Dummy select

```
select current timestamp from sysibm.sysdummy1;
```

## Advanced Concepts

### Tablespaces

Table spaces are logical objects used as a layer between logical tables and physical containers. Containers are where the data is physically stored in files, directories, or raw devices. When you create a table space, you can associate it to a specific buffer pool (database cache) and to specific containers.

#### Default Tablespaces

There are 3 table spaces created automatically when a database is created: 

1. **Catalog (SYSCATSPACE)**: The catalog and the system temporary space can be considered system structures, as they are needed for the normal operation of your database. The catalog contains metadata (data about your database objects) and must exist at all times. 
* **System temporary space (TEMPSPACE1)**: is the work area for the database manager to perform operations, like joins and overflowed sorts. There must be at least one system temporary table space in each database. 
* **Default user table space (USERSPACE1)**: This is created by default, but you can delete it. 
To create a table in a given table space, use the CREATE TABLE statement with the IN table_space_name clause. If a table space is not specified in this statement, the table will be created in the first user created table space. If you have not yet created a table space, the table will be created in the USERSPACE1 table space. 

#### Tablespace Types

1. **System-managed space (SMS)**: This type of table space is managed by the operating system and requires minimal administration. This is the default table space type. 
2. **Database-managed space (DMS)**: This type of table space is managed by the DB2 database manager, and it requires some administration


### Buffer Pools 

A buffer pool is an area in physical memory that caches the database information most recently used. Without buffer pools, every single piece of data has to be retrieved from disk, which is very slow. Buffer pools are associated to tables and indexes through a table space. A buffer pool is an area in memory where all index and data pages other than LOBs are processed.DB2 retrieves LOBs directly from disk. Buffer pools are one of the most important objects to tune for database performance. 

### Concurrency

#### Issues
* Lost updates 
* Access to uncommitted data (only with UR) 
* Non-repeatable read (only with UR & CS) 
* Phantom read phenomenon (only wit UR, CS & RS) 

#### Isolation levels 
* Repeatable Read(RR)
* Read Stability (RS)
* Cursor Stability (CS)
* Uncommitted Read (UR)

#### Lock Escalation 
A lock escalation occurs when the number of locks held on rows and tables in the db equals the percentage of the locklist specified by the 'maxlocks' db config param. To reduce the no. of locks, db manager begins converting many small row/block level locks to table locks for all active tables, starting from any locks on LOBs or VARCHARs. Then the table with the next highest no. of locks and so on, until the no. of locks held is decreased to about half of the value specified by 'maxlocks' Exclusive Lock Escalation An exclusive lock escalation is a lock escalation in which the table lock acquired is an 'exclusive lock'. Lock escalations reduce concurrency. Conditions that might cause lock escalations should be avoided. 

### DB Federation

Database federated support in DB2 allows tables from multiple databases to be presented as local tables to a DB2 server. The databases may be local or remote; they can also belong to different. 

DB2 uses NICKNAME, SERVER, WRAPPER, and USER MAPPING objects to implement federation. 

#### DB Partitioning

* DPF(DB partioning feature) lets you partition your database across multiple servers or within a large SMP server. This allows for scalability, since you can add new machines and spread your database across them. That means more CPUs, more memory, and more disks from each of the additional machines for your database! Partitioning is a concept that applies to the database, not the instance; you partition a database, not an instance.
* In a partitioned environment SYSCATSPACE is not partitioned, but resides on one partition known as the catalog partition. The partition from which the CREATE DATABASE command is issued becomes the catalog partition for the new database. All access to system tables must go through this database partition.
* Each buffer pool in a DPF environment holds data only from the database partition where the buffer pool is located. 

#### Partitioning Types

* Row-wide partitioning - TODO
* Column-wide partitioning - TODO

#### DB Replication

HADR - High Availability Database Replication (from version 9.7) TODO


# Oracle
http://download-west.oracle.com/docs/cd/A87860_01/doc/server.817/a76992/toc.htm 

* **Optimizers CBO** (Cost-based optimizers) depends on the statistics stored in the Data Dictionary. This approach optimizes for best throughput **RBO** (Rule based optimizers) - This approach optimizes for best response time. 

**Data dictionary**- stores statistics about columns, tables, clusters, indexes, and partitions for the CBO. DBMS_STATS statement is used to gather the statistics

# Sybase

## Temporary Database: tempdb

The tempdb database is a special Sybase supplied database that comes in each server. Data in tempdb is not permanent. The tempdb database is cleared each time the server reboots. Any queries which do any sort of sort operation implicitly use tempdb. These queries include select statments with group by's or order by's. Be careful, if you select a large set of rows and use an order by or group by clause, you query may fail because tempdb isn't big enough. 

The system administrator can extend the size of tempdb Local variables denoted as `@varname` Global variables

* `@@rowcount` - Holds the number of rows returned by the last Transact-SQL statement. Be careful, almost any statement will set this. Even an "if" statement which checks it's value. For example:
```
select * from pubs where ....
if @@rowcount = 0 /* set to 1 after this */
print "no rows returned"
``

* `@@error` - Holds status of last statement executed. Zero is success. Once again almost any statement sets this, so use it's value immediately (or save it in a local variable).
* `@@servername` - The name of the Sybase dataserver.
* `@@version` - What version of the Sybase server you are using

## Locks

Sybase locks pages (2048 bytes) not rows. This is a trade off between the speed of managing locking and level of contention that occurs at runtime.

### Types of locking

1. All Page locking - locks data pages and index pages
* Data Page only locking (from v11.9)
* Row level locking (from v11.9)

How Data pages work in Sybase ASE? http://www.faqs.org/faqs/databases/sybase-faq/part5/ (Page Contention)

Heap Tables Tables with no clustered index.

Update statistics 'update statistics ' is the equivalent of runstats in db2 Suppose I have varying lengths of character strings none of which should exceed 50 characters. Is there any advantage of last_name varchar(50) over this last_name varchar (255)? That is, for simplicity, can I just define all my varying strings to bevarchar(255) without even thinking about how long they may actually be? Is there any storage or performance penalty for this. There is no performance penalty by doing this but as another netter pointed out: If you want to define indexes on these fields, then you should specify the smallest size because the sum of the maximal lengths of the fields in the index can't be greater than 256 bytes.

Repeatable Read By default, reads (select) are not locked. Sometimes, this is not appropriate. If you need to guarantee that a selected row doesn't change once read during a transaction, use the select with holdlock. eg.SELECT @lcl_au_id=au_id HOLDLOCK FROM authors sp_recompile One common problem occurs when stored procedures are first executed when the tables they will be accessing are largely empty. The query plans will generally prefer to scan the tables instead of using indexes. As the tables fill with data, performance can significantly degrade.

The "sp_recompile" command can be used to fix this problem: sp_recompile {table_name} This will set a flag in each stored procedure that needs to be recompiled (i.e, that references the specified table). The next time one of these stored procedures is invoked, it will automatically be recompiled Note 'truncate table' and 'bcp' commands bypass triggers.

* How to select first/last/max per group in SQL : http://www.xaprb.com/blog/2006/12/07/how-to-select-the-firstleastmax-row-per-group-in-sql/
* How to identify the performance order (Big-O notation) of a query
* How query execution order works when a SQL has sub-queries in it?

# Bibliography
* DB2
  * More details on : http://publib.boulder.ibm.com/infocenter/db2luw/v8/index.jsp?topic=/com.ibm.db2.udb.doc/core/r0010410.htm
  * Command line reference: ftp://ftp.software.ibm.com/ps/products/db2/info/vr8/pdf/letter/db2n0e80.pdf
  * DB2 System command: http://www3.software.ibm.com/ibmdl/pub/software/dw/dm/db2/dm-0406qi/systemCommands.pdf
* Sybase
  * http://www.faqs.org/faqs/databases/sybase-faq/part1/ 
  * http://www.lcard.ru/~nail/sybase/perf/66.htm 
  * http://www.benslade.com/tech/OldIntroToSybase/
