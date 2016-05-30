---
layout: page
title: "SQL"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Variables

* Sybase
	* Local variables denoted as `@varname` 
	* Global variables
		* `@@rowcount` - Holds the number of rows returned by the last Transact-SQL statement. Be careful, almost any statement will set this. Even an "if" statement which checks it's value. For example:
		* `@@error` - Holds status of last statement executed. Zero is success. Once again almost any statement sets this, so use it's value immediately (or save it in a local variable).
		* `@@servername` - The name of the Sybase dataserver.
		* `@@version` - What version of the Sybase server you are using

```sql Example
select * from pubs where ....
if @@rowcount = 0 /* set to 1 after this */
print "no rows returned"
```



# FAQs

* What's the difference between DELETE TABLE and TRUNCATE TABLE commands? 
  * DELETE TABLE is a logged operation, so the deletion of each row gets logged in the transaction log, which makes it slow. 
  * TRUNCATE TABLE also deletes all the rows in a table, but it won't log the deletion of each row, instead it logs the de-allocation of the data pages of the table, which makes it faster. Of course, TRUNCATE TABLE can be rolled back. 
* Co-related subquery? Co-related query is a query in which subquery depends on execution of main query 

```sql
Select DeptNo,Ename,Sal From Emp e1 Where Sal=(Select Max(Sal) From Emp e2 Where e1.DeptNo=e2.DeptNo)
```

* [How to select first/last/max per group in SQL?](http://www.xaprb.com/blog/2006/12/07/how-to-select-the-firstleastmax-row-per-group-in-sql)
* SQL query to get 4th or 5th maximum value from a table 

``` sql
select max(id) from EMP A where N=(select count(id) From EMP B where B.ID>=A.ID) 
OR 
select * from (select rownum rn,id from (select distinct id From EMP order by id desc)) where rn between N-1 and N;
```

* Difference between `USING` & `ON` clause in joins?
  * `USING` clause allows you to specify the join key by name.
  * `ON` clause allows you to specify the column names for join keys in *both tables*.
  * `ON` clause preserves the columns from each joined table separately, which the `USING` clause merges the columns from the joined tables into a single column. `USING` may not be a good idea when using outer joins where you would want to see unmatched rows from a table.

```sql
select department_name, city from departments
JOIN locations USING (location_id); -- specify the same column name for both of the tables for the join

select department_name, city from departments dept
join locations loc on (d.location_id = l.id); -- specify different column name for the tables for the join.
```

* When we need to use USING clause in the sql? For example in this below: 

```sql
SELECT emp_name, department_name, city FROM employees e 
JOIN departments d USING (department_id) 
JOIN locations l USING (location_id) WHERE salary > 10000;
```

* How to delete duplicate records in a table? 

``` sql
DELETE FROM test t1 WHERE EXISTS ( SELECT * FROM test t2 WHERE t2.col1=t1.col1 AND t2.rowid <> t1.rowid);
```

* What will be the output of this query? 
  * `SELECT 1 FROM DUAL UNION SELECT 'A' FROM DUAL;` The query would throw an error. The two data types in the union set should be same. Out here it is a 1 and 'A', datatype mismatch and hence the error.

* What does `UNION` do? What is the difference between `UNION` and `UNION ALL`?
  * `UNION` merges the contents of two structurally-compatible tables into a single combined table. 
  * The difference between `UNION` and `UNION ALL` is that `UNION` will omit duplicate records whereas `UNION ALL` will include duplicate records.
  * Performance-wise `UNION ALL` is typically be better than `UNION`, since `UNION` requires the server to do the additional work of removing any duplicates.

* What will be the result of the query below? Explain your answer and provide a version that behaves correctly?

```sql
select case when null = null then 'Yup' else 'Nope' end as Result;
```

This query will actually yield “Nope”, seeming to imply that `null` is not equal to itself! The reason for this is that the proper way to compare a value to `null` in SQL is with the `is` operator, not with `=`.

* What will be the result of the query below?

`SELECT * FROM runners;`

| id | name         |
|----|--------------|
|  1 | John Doe     |
|  2 | Jane Doe     |
|  3 | Alice Jones  |
|  4 | Bobby Louis  |
|  5 | Lisa Romero  |
   
`SELECT * FROM races;`

| id | event          | winner_id |
|----|----------------|-----------|
|  1 | 100 meter dash |  2        |
|  2 | 500 meter dash |  3        |
|  3 | cross-country  |  2        |
|  4 | triathalon     |  NULL     |

`SELECT * FROM runners WHERE id NOT IN (SELECT winner_id FROM races)`

Answer:
Surprisingly, given the sample data provided, the result of this query will be an empty set. The reason for this is as follows: *If the set being evaluated by the SQL `NOT IN` condition contains any values that are `null`, then the outer query here will return an empty set, even if there are many runner ids that match winner_ids in the races table*.

Knowing this, a query that avoids this issue would be as follows:

```sql
SELECT * FROM runners WHERE id NOT IN (SELECT winner_id FROM races WHERE winner_id IS NOT null)
```

* Given a table SALARIES, such as the one below, that has m = male and f = female values. Swap all f and m values (i.e., change all f values to m and vice versa) with a single update query and no intermediate temp table.

Answer: 

```sql
UPDATE SALARIES SET sex = CASE sex WHEN 'm' THEN 'f' ELSE 'm' END
```

* Write a SQL query using `UNION ALL` (not `UNION`) that uses the `WHERE` clause to eliminate duplicates. Why might you want to do this?

Answer:
You can avoid duplicates using `UNION ALL` and still run much faster than `UNION` by running a query like this:

```sql
SELECT * FROM mytable WHERE a=X UNION ALL SELECT * FROM mytable WHERE b=Y AND a!=X
```

The key is the `AND a!=X` part. This gives you the benefits of the `UNION` command, while avoiding much of its performance hit.


* What are the `NVL` and the `NVL2` functions in SQL? How do they differ?

Both the `NVL(exp1, exp2)` and `NVL2(exp1, exp2, exp3)` functions check the value `exp1` to see if it is null.

With the `NVL(exp1, exp2)` function, if `exp1` is not null, then the value of `exp1` is returned; otherwise, the value of `exp2` is returned, but case to the same data type as that of `exp1`.

With the `NVL2(exp1, exp2, exp3)` function, if `exp1` is not null, then `exp2` is returned; otherwise, the value of `exp3` is returned.

