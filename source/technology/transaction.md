---
layout: page
title: "Transaction Management"
comments: true
sharing: true
footer: true
---

[TOC]



# Overview

* JTA & JTS
  * JTA is a high level, implementation-independent, protocol independent API that allows applications and application servers to access transactions. An API like JDBC implemented by vendors - typically by commercial servers or by open source txn managers such as JBoss Txn Service or JOTM.
  * JTS (Java Transaction Services) - JTS specifies the implementation of a Transaction Manager which supports JTA and implements the Java mapping of the OMG Object Transaction Service (OTS) 1.1 specification at the level below the API. JTS propagates transactions using the Internet Inter-ORB Protocol (IIOP).
* JTA interfaces
  * `UserTransaction` Interface
  * `javax.transaction.UserTransaction` - allows to programmatically begin, commit or rollback txns, or get status.
  * `TransactionManager` Interface
  * primarily used within the Declarative Txn Model.

# Transaction Properties

<span style="color:red">TODO </span>

## ACID property

* **Atomicity** - means a txn must either be a commit or rollback all updates as a single unit of work.
* **Consistency** - means during the course of the txn, the resource (db or EMS) will not be left in an inconsisten state.
* **Isolation** - During the course of the txn, intermittent status of various participants is not visible to the external world.
* **Durability** - means when the txn is committed, then it is guaranteed that the txn is complete and the db or JMS updates are permanent.

## BASE property

* Basically Available
* Soft state
* Eventual Consistency

## ACID vs. BASE

???

## CAP Theorem

distributed databases uses.

http://ivoroshilin.com/2012/12/13/brewers-cap-theorem-explained-base-versus-acid/

### Combination 1: CA 

* What does it mean?
* When to use this?
 
### Combination 2: CP 

* What does it mean?
* When to use this?
 
### Combination 3: AP 

* What does it mean?
* When to use this?

# Transaction Models

## Local transactions

* Txn is not managed by the framework, but by the local resource manager like db or messaging provider.
* Developer manages connection, not the txn.
* **Pros**
  * Simple code - All you have to do is to reset the auto commit on Connection to false
  * Works well for simple applications
* **Cons/limitations**
  * Error-prone. Plenty of room for developers to make mistakes which could be disastrous.
  * Works only on a single resource. Cannot co-ordinate a txn across global resources like Db and EMS.
  * Say if the txn code is split between different DAOs, the connection needs to be explicitly passed (called as connection passing strategy) which is typically error-prone.

## Programmatic transactions

* Leverages JTA API implementation
* Developer manages txn rather than the connection, using javax.transaction.UserTransaction

``` java EJB Example
UserTransaction txn = sessionCtx.getUserTransaction();
txn.begin();
try{
    myDAO.updateOne(...);
    myDAO.updateTwo(...);
    txn.commit();
} catch(...){
    txn.rollback();
    throw e;
}
```

``` java Spring Example
org.springframework.transaction.support.TransactionTemplate = new ...
transactionTemplate.execute(new TransactionCallback(){
    public Object doInTransaction(TransactionStatus status){
      try{
          myDAO.updateOne();
      }catch(...){
          status.setRollbackOnly();
          throw e;
      }
    }
  }
);
```

* In the above EJB example, txn context is propagated to the DAO. Unlike the local txn model, DAO need not manage connections/txns. All it needs to do is get connections from a pool.
* In the above Spring example, there is no need to explicitly invoke begin() or commit(). Also, the rollback is hinted via the txn status, and not on txn itself.
* Typically an instance of `UserTransaction` is obtained via JNDI look up. 

``` java
UserTransaction txn = (UserTransaction)new InitialContext()
					.lookup("javax.transaction.UserTransaction");
```

However, the look up string name could be different for app servers. To run the code outside of a container like for unit test cases, TransactionManager interface is used as below.

``` java Load the txn manager factory class
//Websphere EJB txn manager example
Class txnClass = Class.forName("com.ibm.ejs.jts.jta.TransactionManagerFactory"); 

TransactionManager mgr = (TransactionManager)txnClass
					.getMethod("getTransactionManager", null).invoke(null, null);

//Start the txn via txn manager
mgr.begin();
```

* When to use?
  * client-initiated transactions
  * Localized JTA transactions - If the process has multiple steps and if a txn is required only during a particular phase, then the only way to achieve this localized JTA txn is via programmatic model.
  * For performance reasons.
* Cons
  * Error-prone - since developer is handling txns, if exceptions are not handled properly in the code, it could be disastrous.
  * Transaction Context Problem: A txn context cannot be passed from a DAO that implements programmatic txn model into another DAO implementing the same txn model. Because, when one of them invoke the other, both will try to begin a new txn on separate threads. This violates the ACID principle since failure in other thread won't be visible to the other.

## Declarative transactions

* Framework or container manages the txn (which is why it is also called Container Managed Transactions or CMT)
* Txns are configured through configuration parameters. e.g., XML descriptors in EJB or bean definition file `ApplicationContext.xml` in Spring.
* Developer only says when to rollback. In Spring, rollback rules are specified via `TransactionAttributeSource` interceptor.

``` java EJB Example
@Stateless
@TransactionManagement(TransactionManagementType.CONTAINER)
public class MyDAO{
   @TransactionAttribute(TransactionAttributeType.REQUIRED) 
   public void update(){
      try{
          myDAO.updateOne(...);
          myDAO.updateTwo(...);
      }catch(...){
          sessionCtx.setRollbackOnly();
          throw e;
      }
   }
}
```

* As in the above EJB example, developer invokes only the setRollbackOnly method. At class level, we specify that it uses declarative transaction through the annotation. 
* In Spring, developer need not call the method explicitly. Instead the rollback rules of when to rollback is specified in the TransactionAttributeSource interceptor. We specify that it uses declarative transaction through TransactionProxyFactoryBean proxy - the txn bean is wrapped with a proxy.

### Transaction Attributes

In declarative txn, we must tell the container when to begin a txn, which methods should participate in a txn, etc. There are 6 transaction attributes 

* Transaction Attributes
  * can be specified at method-level and bean-level. 
  * bean-level setting applies for all the methods in the class, which can be overridden.
  * even if not specified, default attribute is applied to all the methods.
* Spring interface `Synchronization` provides callback methods for the `afterBegin()`, `beforeCompletion()`, and `afterCompletion()` of a JTA transaction.




| Attribute Value (For Spring prefix PROPAGATION_ ) | Txn is needed to execute the method?| What if a txn is already open?| What if no txn open?| When to use? | 
| -- | -- | -- | -- | -- |
| REQUIRED | Yes | Use it | Start a new one |    |
| MANDATORY | Yes | An open txn must always exist before invoking the method | Throws exception. Never starts a new one. |   |
| REQUIRESNEW | Yes. Always start a new txn. | Suspend existing txn, start new one and resume the previous one after completing the new one. | Start a new one | When an activity needs to be committed regardless of the surrounding txn. E.g. audit logging during trading operation |
| SUPPORTS | No | Use it. In fact, any uncommitted change made by the surrounding txn is also visible. | It works as it and doesn’t start a new txn. |   |
| NOTSUPPORTED | No | Suspend existing txn, complete the method invocation and resume the txn. |  | For example, invoking a stored proc containing a DDL within the context of an XA txn will throw exception. This attribute is useful in such cases. |
| NEVER | No. Never start a txn. | Throws exception | N/A | |
 

# Transaction Isolation Level


Transaction isolation is a function of db concurrency and db consistency. As we increase the level of txn isolation, we in effect lower the db concurrency but increase the db consistency. (Isolation­­­ & Consistency are inversely proportional to concurrency )

## Dirty Read / Read Uncommitted

* Allows transactions to read non-committed updates made by other transactions.
* Lowest level of isolation supported by EJB & Spring.

## Read Committed

* Allows multiple transactions to access the same data, hiding the non-committed updates from other transactions until they are committed.
* This is the default isolation setting for most of the databases.

## Repeatable Read

Ensures that once a set of values are read from the db for a particular txn, that same set of values will be read every time the select statement is executed, unless the txn holding the read and write locks modifies the data.

## Serializable

* Interleaving txns are stacked up so that only one txn is allowed access to data at a time.
* Lowest level of isolation supported by Java.

| Dirty Read / Uncommitted Read | Read Committed | Repeatable Read | Serializable | 
| ----------------------------- | -------------- | --------------- | ------------ | 
| {% img /technology/dirty-read.png %} | {% img /technology/read-committed.png %} | {% img /technology/repeatable-read.png %} | {% img /technology/serializable.png %} |

# Transaction Read Phenomena

Transaction Read Phenomena


http://docs.oracle.com/cd/B28359_01/server.111/b28318/consist.htm

## Dirty Read / Uncommitted Read

* One process (P1) modifies a row, and another process (P2) then reads that row before it is committed by P1. If P1 then rolls back the change, P2 will have read a row that was never committed and that may thus be considered to have never existed.
* Isolation Level: `READ UNCOMMITTED`

## Non-Repeatable Read

* Process P1 reads a row. Process P2 then modifies or deletes that rows and commits the change. If P1 re-reads the row it receives the modified value or discovers the row has been deleted.
* Isolation Level: `READ COMMITTED`

## Phantom Read

* Process P1 reads the set of rows N that satisfy some search condition. Process P2 then executes statements that generate one or more rows that satisfy the search condition. If P1 repeats the query it obtains a different collection of rows.
* Phantom Vs. Non-repeatable
  * The Non-Repeatable Read is a phenomena specific to a read of a single record. When data has changed in this record, and the record is read again, the changed data is returned. This is a non-repeatable read.
  * The Phantom Read is a phenomenon that deals with queries that return sets. The thing that’s changing in a phantom read is not the data in the records; it’s the set membership that has changed.
  * For records that have been deleted, if a transaction reads them (or rather fails to read them) it would seem that this is both a non-repeatable read and a phantom read. But for the purposes of the ISO/ANSI standard it is in fact considered a non-repeatable read.

## Serializable Vs. Snapshot

???

# Distributed Transaction Processing

Distributed txn is a txn that spans over 1 or more resources. It could be between 2 different dbs, or 2 different messaging channels, or db and a messaging queue/topic.

## XA Transaction Processing

{% img right /technology/xa-transaction.png %}

* The X/Open XA Interface is a bi-directional system-level interface that forms the communication bridge between a transaction manager and 1 or more resource managers. 
* The Transaction Manager manages the lifecycle of a txn, and co-ordinates resources. In JTA, txn manager is abstracted through the javax.transaction.TransactionManager interface and implemented through the underlying transaction service.
* The Resource Manager controls and manages the actual resource participating in the txn like db or JMS queue.
* XA txn should only be used when a transaction needs to be coordinated between multiple resources, i.e., databases, queues or topics. 

* What is the relation between XA and JTA?

???


### XA Resource

* Without XA, messages sent to a topic/queue are typically read by receivers immediately. With XA, the message in the queue would not be released until the txn is committed.
* To perform a XA txn between multiple resources, each participating resource should be an XA resource. (Some vendors support a feature where 1 resource could be a non-XA resource.### )

## 2-phase commit protocol

* Mechanism used by XA to coordinate multiple resources during a global transaction. 
* A txn manager coordinates txns between resource managers using a two-phase commit protocol. 
* The two-phase commit protocol provides the ACID properties of transactions across multiple resources. 
* In phase 1, 
  * the transaction manager tells each resource to "prepare" to commit; that is, to perform all operations for a commit and be ready either to make the changes permanent or to undo all changes. 
  * Each resource manager responds back with READY, READ_ONLY or NOT_READY. 
* In phase 2, if all resource managers respond back with READY, the transaction manager tells all resource managers to commit their changes; otherwise, it tells them all to roll back and indicates transaction failure to the application. Participants that respond with a READ_ONLY are removed from the 2nd phase. 
* 2-phase commit is possible due to the bi-directional communication capabilities of the XA interface.
* **Last Participant Support** / **Last Resource Commit**
  * Some commercial containers allow this feature where an non-XA resource to participate in a global txn. The non-XA resource participates only in the phase 1 of the txn.

| 2PC Commit Scenario | 2PC Rollback Scenario |
| ------------------- | --------------------- |
| {% img /technology/2pc-commit.png %} | {% img /technology/2pc-rollback.png %} |

## Heuristic Exceptions

During the 2-phase commit process a Resource Manager may use heuristic decision making and either commit or rollback its work independent of the Txn Mgr. Heuristic decision making is a process that involves making intelligent choices based on various internal and external factors. When a Resource Manager does this it is reported back to the client through Heuristic Exception.

They only occur under XA during the 2-phase commit process, specifically after a participant has responded in phase 1. The most common reason for this is a timeout condition between phase 1 and 2. When communication is lost or delayed, the resource managers might make a decision to commit or rollback its work in order to free up resources.

### Heuristic Exception Types

The 3 JTA Heuristic exceptions in JTA are

* HeuristicRollbackException - between phase 1 and 2, if *all the resource mgrs* decides to rollback the txn, then upon entering phase 2 of the commit request this exception is thrown back to the caller.
* HeuristicMixedException - same as above, but this is thrown if *one of the resource mgrs* decides to rollback.
* HeuristicCommitException

# Transaction Strategies

Two golden rules apply to all of the transaction strategies :

* The method that starts the transaction is designated as the transaction owner
* Only the transaction owner can roll back the transaction

## 1. API Layer Strategy

{% img right /technology/api-txn-strategy.png %}

* Transaction Owner: API Layer - this is where the begin, commit and rollback of a txn occurs
* When to apply this?
  * apps with coarse-grained API layer
  * apps with multiple client channels like webservice client, desktop client, web client, etc.
* Rules for implementing this strategy
  * only public methods in the API layer should have txn logic
  * all public write methods are marked with REQUIRED txn attribute
  * all public read method are marked with SUPPORTS
  * all public write methods should handle checked exceptions with a rollback logic
* Limitations/Restrictions
  * When a public write method calls another public write method in a txn, and if an exception occurs, the rollback logic could potentially be handled by the 2nd method instead of the txn owner.
  * Clients cannot make a multiple calls to API layer as a single unit of work.
  * Extra attention needed if the same public method is called by clients that act as a txn owner and clients does not start a txn. (see [IBM article](http://www.ibm.com/developerworks/java/library/j-ts3/index.html#restrictions) for more details)

## 2. Client Orchestration Strategy

* Transaction Owner: Client Layer. Though both client & API layer contains the txn logic, only the client layer begins, commits and rolls back the txn. API layer has only  txn attributes marked on the methods.
* When to apply this?
  * apps with complex and fine-grained API layer
  * cannot use with clients that cannot propagate txn to API layer, e.g., JMS clients, web service clients, etc.
* Rules for implementing this strategy
  * only client & API layer contains the txn logic. Client layer is the txn owner
  * typically with this strategy, programmatic model is used in client. The exception to this rule is if the client business delegate in the client layer controlling the transaction scope is managed as a Spring bean by the Spring Framework. In this case, you can use the declarative transaction model provided by Spring.
  * all public write methods in API layer are marked as MANDATORY - no rollback logic in them
  * all public read methods in API layer are marked as SUPPORT.
  * If the client layer is making remote calls to the API layer, the client layer must use a protocol and transaction manager that supports the propagation of a transaction context (such as RMI-IIOP).
* Limitations/Restrictions
  * Client layer must be able to start a txn and propagate it to the API layer. This is not possible with JMS client or web service client

## 3. High Concurrency Strategy

???

## 4. High Performance Strategy

???

# Open Items

* MVCC, Optimistic locking
* Paxos consensus protocol

# Bibliography

* Books
  * Java Transaction Management Strategies - Mark Richards
  * Java Transaction Processing: Design and Implementation - Mark Little, Jon Maron, Greg Pavlik
  * Principles of Transaction Processing - Philip A. Bernstein, Eric Newcomer
* Websites
  * IBM - Txn Mgmt Series - Mark Richards - http://www.ibm.com/developerworks/views/java/libraryview.jsp?site_id=1&contentarea_by=Java&sort_by=Date&sort_order=1&start=1&end=6&topic_by=&product_by=&type_by=All%20Types&show_abstract=true&search_by=transaction%20strategies:&industry_by=&series_title_by=
  * Spring Txn Mgmt - http://static.springsource.org/spring/docs/3.0.x/reference/transaction.html
  * http://www.jboss.org/jbosstm/resources/fundamentals.html
  * http://www.pjug.org/jta-j2ee-pjug-2003-07-22.ppt
  * [Nuts And Bolts Of TP](http://www.subbu.org/articles/transactions/NutsAndBoltsOfTP.html)
  * [Distributed transactions in Spring, with and without XA](http://www.javaworld.com/article/2077963/open-source-tools/distributed-transactions-in-spring--with-and-without-xa.html)
