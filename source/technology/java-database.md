---
layout: page
title: "Java & Database"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# JDBC

* Types of drivers? 
* BLOB, CLOB(singlebyte LOB), 
* DBCLOB(doublebyte LOB) 
* Scrollable resultsets 
* Rowsets http://java.sun.com/developer/Books/JDBCTutorial/chapter5.html 
* Is it good? conn.getHoldability()?  the holdability, one of ResultSet.HOLD_CURSORS_OVER_COMMIT or ResultSet.CLOSE_CURSORS_AT_COMMIT 

`javax.sql.rowset.WebRowSet`

# ORM

* Define ORM
* Why ORM is required? 
* What other ORM tools are available? How is Hibernate better?
* [Dance You Imps!](http://blog.8thlight.com/uncle-bob/2013/10/01/Dance-You-Imps.html)
* [Vietname of Computer Science](http://blogs.tedneward.com/post/the-vietnam-of-computer-science)
* [Martin Fowler on ORM Hate](http://java.dzone.com/articles/martin-fowler-orm-hate)

## Hibernate

* Challenges in migrating Hibernat 2 to 3? 
* http://www.deepakgaikwad.net/index.php/2009/03/14/complete-hibernate-tutorial-with-example.html?goback=%2Egde_43888_member_255672872
* http://www.hibernate-alternative.com/

# JPA

JPA specification - Apache open JPA

# Connection Pooling

Open-source softwares:

* [Apache Commons DBCP](http://jakarta.apache.org/commons/dbcp)
* [c3p0](http://sourceforge.net/projects/c3p0/)
* [BoneCP](http://jolbox.com/)
