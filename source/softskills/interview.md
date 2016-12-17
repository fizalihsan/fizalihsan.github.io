---
layout: page
title: "Interview Preparation"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}


# Topics to cover

* Java
    * GC - serial, parallel, CMS, G1
    * Reference Types - soft, weak, phantom
  * Collections
    * Covariance, invariance, contravariance
    * Latest concurrent collections uses techniques like: *copy-on-write, compare-and-swap, Lock interface*
    * Iterators: *Fail-fast & Fail-safe (snapshot & weakly consistent)*
    * Map:
      * general maps use equals(or hashCode)
      * IdentityHashMap use identity
      * SortedMap (TreeMap & ConcurrentSkipListMap) use Comparable or Comparator
    * Comparable vs. Comparator
  * Concurrency
    * Atomicity (check-then-act, read-modify-write), 64-bit read/write is not atomic
    * Visibility (synchronized & volatile force to cross memory barrier)
    * Synchronization models (mutex, read-write locks, condition, semaphore)
    * Monitor (No shared object, No Lock)
    * Volatile (cross memory barrier, prevent reordering, guarantee atomic 64-bit read/writes, arrays)
    * Problems (race condition, lock-ordering deadlock, thread starvation deadlock, starvation, livelocks)
    * Future, Timer, TimerTask, ScheduledThreadPool
    * Synchronizers (FutureTask, Semaphore, Latches, CyclicBarrier, Exchanger)
    * Fork-Join pool (work-stealing)
* Database
  * PK, FK, PK & Unique key diff
  * Cursors (implicit, explicit, forward, refcursor data type, static, dynamic)
  * Joins (full outer join, exception join)
  * Join Algos
    * nested loop join - when one table is small and other is large with an index on joined columns
    * merge join or sort-merge join - when both tables are large. Faster when data being joined is already sorted by an index
    * hash join - when table is large but data needed is small.
  * Normalization
  * Indexes - types, properties (visibility, usability, unique/non-unique, composite)
  * Views - horizontal, vertical, indexed
  *   MDC table
* Design Patterns - adapter, builder, chain of responsibility, command, decorator, facade, factory, mediator, observer, singleton, strategy, template, visitor
* SOA
  * Safe operations, Idempotent operations, post-once-exactly-pattern, request-response, request-acknowledge-poll, request-acknowledge-callback, routing expressions, reduce load by service interceptor or reverse proxies
  * REST
    * Principles - addressable resources, uniform & constrained interface, representation-oriented, stateless communication, hateoas
    * async request - client-side api future & callback, server-side api AsyncResponse
    * exception mappers, jaxb, security, versioning
    * scalability - browser & proxy caches, http caching(expires, cache-control), revalidation(last-modified, etag)
  * JMS - MEPs
* Spring
  * Core - Autowiring, profiles
  * JDBC - JdbcTemplate, RowMapper, RowCallback
  * MVC - lifecycle
* Transaction -
  * acid, base,
  * txn models(local, programmatic, declarative)
  * txn types (flat, with save point, chained, nested, distributed, long-lived)
  * 4 isolation levels (read uncommitted, read committed, repeatable read, serializable, snapshot)
  * read phenomena - dirty read, non-repeatable read, phantom read
  * 2PC protocol, heuristic exceptions
  * Concurrency control - 2-Phase Locking, MVCC, Optimistic Concurrency Control,
* Distributed computing - CAP, strong vs weak consistency
* Data Structures & Algorithms
  * Arrays & Strings
  * Tree - Traversals, BST, 2-3 tree, Red-Black Tree
  * Queue - Queue using stack(s)

# Data Structures & Algorithms

* Algorithm basics and approach (Ref GIB03 ch03)
* Arrays and Strings  - (Ref GIB03 ch06)
* String - http://tekmarathon.wordpress.com/2013/05/14/algorithm-to-find-substring-in-a-string-kmp-algorithm/
* Linked List  - (Ref GIB03, GIB01 ch03, GIB03 ch04)
* Trees  - (Ref GIB03 ch05, GIB04, )
* Graphs  - (Ref GIB03 ch05,)
* Recursion  - (Ref GIB03 ch07, GIB01 ch04)
* Sorting  - (Ref GIB03 ch08)
* Bit Manipulation - (Ref GIB02, GIB01 ch04, GIB03 ch13,)
* Graphical and Spatial puzzles  - (Ref GIB03)
* Counting, Measuring and Ordering puzzles  - (Ref GIB03)
* System Design and Memory Limits - (Ref GIB02)
* General programs - (Ref GIB01)
	* Base M to N conversion
	* Replace blanks in a string - Ref GIB01 Pg45,
  * Write a generic program to take an nxn array and print

# General Tech Questions

* What are some of the challenges you faced in your project?
	* Multi-instance model for scalability, risk management. Managing s/w versions across those instances.
	* Reverse engineer business logic from mainframe statements working closing with business
	* Global team presence in 5 different time zones.
* Why are you leaving the current job?
* What are your strengths and weaknesses?
	* Strengths: Technical knowledge, Communication and presentation skills, Well-organized

# Behavioral Questions


* What do you enjoy about going to work?
* What do you dislike about being a developer?
* Why are you leaving your current job?
* If you could change one thing about your current team what would it be?
* What does a good team good like?
* What makes a good developer?
* Tell me about a time you had a conflict at work. How did you deal with it?
  * War on naming conventions, checked vs. unchecked exceptions
* Tell me about the biggest mistake you made at work?
* What are your strenths and weaknesses?
* What motivates you?
* What makes you the ideal candidate for this job?
* Demonstrate your leadership, teamwork, ability to overcome obstacles and challenges
* What bothers you most about other people?
  * No response to emails. Lack of accountability
  * Email communication - lack of punctuations
* Tell me about a day when everything went wrong
* Tell me about a colleague you really got along with and why you think you did
  * (Don't make it too formal. Keep it humorous)
*  What's something that you can teach me?
  * (Test for patience, body language, communication skills)
*  Tell me about someone you admire and why you do
  * (Tests if interviewee is a people person) Kal & Nik - vision, tech savviness
*  What's one thing you're really proud of and why? What is your biggest accomplishment to date?
  * (Give credit to others like family, friends, colleagues) Perseverance and consistency
*  What project or task have you recently completed that you are proud of?
*  If you ran your own company, what kinds of people would you hire and why?
  * 2 qualities I look - strength and trustworthy
*  Test for personal fashion - Can you tell me a goal that you have outside of work and family?  What do you do for fun?
*  Test for initiative hunger - Tell me about something you've started?
  * Book club within and outside of work
*  Test for honesty - Tell me about time you've bent the rules?
*  Test for motivation and priority - who in your life would you least want to disappoint?
*  Test for drive and passion - Where do you want to see yourself in 5 yrs?
*  What's the last awesome thing you learned?
*  What did you not like about your last job?
*  What is your biggest pet peeve?
*  What is the best mistake that you have ever made?
*  What did you want to be when you were a kid?  Why?
*  What event in your life has taught you the most about yourself?
*  Have you ever had a job that you hated?  What did you hate about it?
*  Describe a challenge you have faced and how you overcame that?
*  In hindsight, what steps would you have taken to avoid that challenge?
*  If given a new project that you were unfamiliar with, what would be your strategy to kick-start the project?
* About the company
  * What is the vision of the company
  * What do you know about the culture of our company
  * Company's stock price last time you checked

# Questions to the interviewer

* Please can you tell me a bit more about the team? What size is it? What experience levels?
* Is the team based in one region or geographically split?
* How does the team work? Do you use agile?
* What's your biggest frustration in your current job?
* What's your favorite part of working at the company and in the team?
* What does an average day look like?
* How hard is it to use new technologies in your company?
* What training exists?

# Useful links

* *Resume*
	* http://jobs.rubynow.com/create-a-great-rails-resume
	* [JobScan.co - CV Optimization](https://www.jobscan.co/)
	* [HTML CV Templates](http://idesignow.com/template-2/40-great-html-cv-resume-templates.html#.Uj-C3oZ02Sp)
	* [Sarah Sellers' podcast on resume writing](http://www.corejavainterviewquestions.com/podcast5)
* *Technical Interview Questions*
	* [algorithmist.com](http://www.algorithmist.com)
  * [codechef.com](http://www.codechef.com)
  * [Gainlo.co](http://blog.gainlo.co/index.php/index/) - Mock interviews with employees from Google, Amazon, Twitter, etc.
  * [geeksforgeeks.org](http://www.geeksforgeeks.org)
  * [hackerrank.com](http://www.hackerrank.com)
  * [hiredintech.com](http://www.hiredintech.com)
	* [intearview.com](http://intearview.com/)
  * [interviewbit.com](https://www.interviewbit.com)
  * [interviewcake.com](http://www.interviewcake.com)
	* [katemats.com](http://katemats.com/interview-questions/)
  * [leetcode.com](http://www.leetcode.com)
  * [simplicable.com](http://www.simplicable.com)
  * [spoj.com](http://www.spoj.com)
  * [topcoder.com](http://www.topcoder.com)
* *Background check*
	* [Background check](https://pipl.com/)
* *Behavioral Questions*
	* [Cultural Fit Questions](https://hackpad.com/Interview-questions-to-test-cultural-fit-PS3ytaage0O)
	* [mockquestions.com](https://www.mockquestions.com)

# Recruiters

* Tech Company Recruiters
  * Google - Technical Lead/Manager - https://www.google.com/about/careers/search#!t=jo&jid=34165&
  * https://underdog.io - Start up recruiters
  * Bamboo Talent
  * Clutch Talent
  * NACE Partners
  * http://www.msearchllc.com
  * [ingenium.agency](http://www.ingenium.agency)
* FinTech Recruiters
  * [ikasinternational.com](http://www.ikasinternational.com)
  * [bahpartners.com](http://www.bahpartners.com/)

# References

* [GIB01] Coding Interviews
* [GIB02] Cracking the coding interview
* [GIB03] Programming Interview Exposed, Algorithms (Robert Sedgewick)
* [GIB04] An Introduction to the Analysis of Algorithms
* [GIB05] 101 Great Answers to the Toughest Interview Questions
