---
layout: page
title: "RDBMS Products"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}


### Concurrency


### Performance

* [Distribution statistics uses with the DB2 Optimizer](https://www.ibm.com/developerworks/data/library/techarticle/dm-0606fechner/)

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

``` sql
select * from pubs where ....
if @@rowcount = 0 /* set to 1 after this */
print "no rows returned"
```

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

The `sp_recompile` command can be used to fix this problem: sp_recompile {table_name} This will set a flag in each stored procedure that needs to be recompiled (i.e, that references the specified table). The next time one of these stored procedures is invoked, it will automatically be recompiled Note 'truncate table' and 'bcp' commands bypass triggers.

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
