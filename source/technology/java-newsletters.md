---
layout: page
title: "Java Specialist Newsletters"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Best Practices
* [Issue 039](http://www.javaspecialists.eu/archive/Issue039.html) Why I don't read your code comments ...
* [Issue 050] Commenting out your code?
* [Issue 116] Closing Database Statements Don't Repeat Yourself. The mantra of the good Java programmer. But database code often leads to this antipattern. Here is a neat simple solution from the Jakarta Commons DbUtils project.
* [Issue 051] Java Import Statement Cleanup

# Collections
* [Issue 015] Implementing a SoftReference based HashMap
* [Issue 016] Blocking Queue
* [Issue 024] Self-tuning FIFO Queues
* [Issue 027] Circular Array List
* [Issue 031] Hash, hash, away it goes! When I first started using Java in 1997, I needed very large hash tables for matching records as quickly as possible. We ran into trouble when some of the keys were mutable and ended up disappearing from the table, and then reappearing again later.
* [Issue 040] Visiting your Collection's Elements
* [Issue 054] HashMap requires a better hashCode() - JDK 1.4 Part II
* [Issue 054b] Follow-up to JDK 1.4 HashMap hashCode() mystery
* [Issue 073] LinkedHashMap is Actually Quite Useful
* [Issue 111] What is faster - LinkedList of ArrayList?
* [Issue 133] Safely and Quickly Converting EJB3 Collections When we query the database using EJB3, the Query object returns an untyped collection. In this newsletter we look at several approaches for safely converting this to a typed collection.
* [Issue 178] WalkingCollection We look at how we could internalize the iteration into a collection by introducing a Processor interface that is applied to each element. This allows us to manage concurrency from within the collection.
* [Issue 178b] WalkingCollection Generics Generics can be used to further improve the WalkingCollection, shown in our previous newsletter.
* [Issue 193] Memory Usage of Maps In this newsletter we measure the memory requirements of various types of hash maps available in Java. Maps usually need to be threadsafe, but non-blocking is not always the most important requirement.
* [Issue 212] Creating Sets from Maps Maps and Sets in Java have some similarities. In this newsletter we show a nice little trick for converting a map class into a set.\n[issue 211] Unicode Redux (2 of 2) We continue our discussion on Unicode by looking at how we can compare text that uses diacritical marks or special characters such as the German Umlaut.

# Concurrency
* [Issue 001] Deadlocks
* [Issue 056] Shutting down threads cleanly
* [Issue 061] Double-checked locking
* [Issue 076] Asserting Locks
* [Issue 093] Automatically Detecting Thread Deadlocks
* [Issue 101] Causing Deadlocks in Swing Code
* [Issue 101b] Causing Deadlocks in Swing Code (Follow-up)
* [Issue 104] EDT Lockup Detection
* [Issue 130] Deadlock Detection with new Locks Java level monitor deadlocks used to be hard to find. Then along came JDK 1.4 and showed them in CTRL+Break. In JDK 1.5, we saw the addition of the ThreadMXBean, which made it possible to continually monitor an application for deadlocks. However, the limitation was that the ThreadMXBean only worked for synchronized blocks, and not the new java.util.concurrent mechanisms. In this newsletter, we take a fresh look at the deadlock detector and show what needs to change to make it work under JDK 1.6. Also, we have a look at what asynchronous exceptions are, and how you can post them to another thread.
* [Issue 146] The Secrets of Concurrency (Part 1) Learn how to write correct concurrent code by understanding the Secrets of Concurrency. This is the first part of a series of laws that help explain how we should be writing concurrent code in Java.
* [Issue 147] The Law of the Distracted Spearfisherman Learn how to write correct concurrent code by understanding the Secrets of Concurrency. This is the second part of a series of laws that help explain how we should be writing concurrent code in Java. We look at how to debug a concurrent program by knowing what every thread in the system is doing.
* [Issue 149] The Law of the Overstocked Haberdashery Learn how to write correct concurrent code by understanding the Secrets of Concurrency. This is the third part of a series of laws that help explain how we should be writing concurrent code in Java. In this section, we look at why we should avoid creating unnecessary threads, even if they are not doing anything.
* [Issue 150] The Law of the Blind Spot In this fourth law of concurrency, we look at the problem with visibility of shared variable updates. Quite often, "clever" code that tries to avoid locking in order to remove contention, makes assumptions that may result in serious errors.
* [Issue 151] The Law of the Leaked Memo In this fifth law of concurrency, we look at a deadly law where a field value is written early.
* [Issue 154] ResubmittingScheduledPoolExecutor Timers in Java have suffered from the typical Command Pattern characteristics. Exceptions could stop the timer altogether and even with the new ScheduledPoolExecutor, a task that fails is cancelled. In this newsletter we explore how we could reschedule periodic tasks automatically.
* [Issue 160] The Law of the Uneaten Lutefisk Imagine a very stubborn viking father insisting that his equally stubborn child eat its lutefisk before going to sleep. In real life one of the "threads" eventually will give up, but in Java, the threads become deadlocked, with neither giving an inch. In this newsletter we discover how we can sometimes escape from such deadlocked situations in Java and learn why the stop() function should never ever ever be called.
* [Issue 165] Starvation with ReadWriteLocks In this newsletter we examine what happens when a ReadWriteLock is swamped with too many reader or writer threads. If we are not careful, we can cause starvation of the minority in some versions of Java.
* [Issue 172] Wonky Dating The DateFormat produces some seemingly unpredictable results parsing the date 2009-01-28-09:11:12 as "Sun Nov 30 22:07:51 CET 2008". In this newsletter we examine why and also show how DateFormat reacts to concurrent access.
* [Issue 176] The Law of the Xerox Copier Concurrency is easier when we work with immutable objects. In this newsletter, we define another concurrency law, The Law of the Xerox Copier, which explains how we can work with immutable objects by returning copies from methods that would ordinarily modify the state.
* [Issue 184] Deadlocks through Cyclic Dependencies A common approach to ensuring serialization consistency in thread safe classes such as Vector, Hashtable or Throwable is to include a synchronized writeObject() method. This can result in a deadlock when the object graph contain a cyclic dependency and we serialize from two threads. Whilst unlikely, it has happened in production.
* [Issue 188] Interlocker - Interleaving Threads In this newsletter, we explore a question of how to call a method interleaved from two threads. We show the merits of lock-free busy wait, versus explicit locking. We also discuss an "unbreakable hard spin" that can cause the JVM to hang up.
* [Issue 190] Automatically Unlocking with Java 7 In this newsletter we explore my favourite new Java 7 feature "try-with-resource" and see how we can use this mechanism to automatically unlock Java 5 locks.
* [Issue 190b] Automatically Unlocking with Java 7 -- Follow-up In this newsletter we discuss why we unfortunately will not be able to use the try-with-resource mechanism to automatically unlock in Java 7.
* [Issue 192] Implicit Escape of "this" We should never allow references to our objects to escape before all the final fields have been set, otherwise we can cause race conditions. In this newsletter we explore how this is possible to do.
* [Issue 192b] How Does "this" Escape? A quick follow-up to the previous newsletter, to show how the ThisEscape class is compiled, causing the "this" pointer to leak.
* [Issue 194] trySynchronize Did you know that it possible to "try" to synchronize a monitor? In this newsletter we demonstrate how this can be used to avoid deadlocks and to keep the wine coming.
* [Issue 200] On Learning Concurrency Every Java programmer I have met knows that they should know more about concurrency. But it is a topic that is quite hard to learn. In this newsletter I give some tips on how you can become proficient in concurrency.
* [Issue 201] Fork/Join With Fibonacci and Karatsuba The new Java 7 Fork/Join Framework allows us to define our algorithms using recursion and then to easily parallelize them. In this newsletter we describe how that works using a fast Fibonacci algorithm that uses the sum of the squares rather than brute force. We also present a faster algorithm for multiplying two large BigInteger numbers, using the Fork/Join Framework and the Karatsuba algorithm.
* [Issue 206] Striped Executor Service We present a new type of ExecutorService that allows users to "stripe" their execution in such a way that all tasks belonging to one stripe are executed in-order.
 
# Database
* [Issue 047] Lack of Streaming leads to Screaming
* [Issue 118] A Simple Database Viewer A simple database viewer written in Java Swing that reads the metadata and shows you all the tables and contents of the tables, written in under 100 lines of Java code, including comments.
* [Issue 136] Sneaking in JDBC Drivers In this newsletter, we look at a technique of how we can replace an existing database driver with our own one. This could be used to migrate an application to a new database where you only have the compiled classes. Or it could be used to insert a monitoring JDBC connection that measures the length of database queries.

# Design Patterns
* [Issue 005] Dynamic Proxies - Short Tutorial
* [Issue 034] Generic Types with Dynamic Decorators
* [Issue 052] J2EE Singleton
* [Issue 074] GoF Factory Method in writing GUIs
* [Issue 108] Object Adapter based on Dynamic Proxy
* [Issue 109] Strategy Pattern of HashCode Equality
* [Issue 123] Strategy Pattern with Generics The Strategy Pattern is elegant in its simplicity. With this pattern, we should try to convert intrinsic state to extrinsic, to allow sharing of strategy objects. It gets tricky when each strategy object needs a different set of information in order to do its work. In this newsletter, we look at how we can use Java 5 Generics to pass the correct subtype of the context into each strategy object.
* [Issue 180] Generating Static Proxy Classes - 1/2 In this newsletter, we have a look at how we can create new classes in memory and then inject them into any class loader. This will form the basis of a system to generate virtual proxies statically.
* [Issue 181] Generating Static Proxy Classes - 2/2 In this newsletter, we show how the Generator described in our previous issue can be used to create virtual proxy classes statically, that is, by generating code instead of using dynamic proxies.
 
# Enums
* [Issue 107] Making Enumerations Iterable
* [Issue 113] Enum Inversion Problem A problem that I encountered when I first started using enums was how to serialize them to some persistent store. My initial approach was to write the ordinal to the database. In this newsletter, I explore some ideas of a more robust approach. It will also show you some applications of Java generics.
* [Issue 141] Hacking Enums Enums are implemented as constant flyweights. You cannot construct them. You cannot clone them. You cannot make copies with serialization. But here is a way we can make new ones in Java 5.
* [Issue 161] Of Hacking Enums and Modifying "final static" Fields The developers of the Java language tried their best to stop us from constructing our own enum instances. However, for testing purposes, it can be useful to temporarily add new enum instances to the system. In this newsletter we show how we can do this using the classes in sun.reflect. In addition, we use a similar technique to modify static final fields, which we need to do if we want the switch statements to still work with our new enums.

# Exceptions
* [Issue 032] Exceptional Constructors - Resurrecting the dead
* [Issue 033] Making Exceptions Unchecked
* [Issue 081] Catching Exceptions in GUI Code
* [Issue 089] Catching Uncaught Exceptions in JDK 1.5
* [Issue 208] Throwing Exceptions from Fields How can you set a field at point of declaration if its constructor throws a checked exception?
* [Issue 120] Exceptions From Constructors What do you do when an object cannot be properly constructed? In this newsletter, we look at a few options that are used and discuss what would be best. Based on the experiences of writing the Sun Certified Programmer for Java 5 exam.
* [Issue 129] Fast Exceptions in RIFE One of the tricks that Java allows us to employ is to change the control flow of the application using exceptions. This is generally strongly discouraged, since it makes the code hard to decipher. In addition, exceptions are notoriously bad at performance. Here is a trick used in RIFE to make this work faster.
* [Issue 138] Better SQLExceptions in Java 6 Java 6 has support for JDBC 4, which, amongst other things, gives you better feedback of what went wrong with your database query. In this newsletter we demonstrate how this can be used.
* [Issue 162] Exceptions in Java In this article, we look at exception handling in Java. We start with the history of exceptions, looking back at the precursor of Java, a language called Oak. We see reasons why Thread.stop() should not be used and discover the mystery of the RuntimeException name. We then look at some best practices that you can use for your coding, followed by some worst practices, in the form of exception anti-patterns.
* [Issue 171] Throwing ConcurrentModificationException Early One of the hardest exceptions to get rid of in a system is th ConcurrentModificationException, which typically occurs when a thread modifies a collection whilst another is busy iterating. In this newsletter we show how we can fail on the modifying, rather than the iterating thread.
* [Issue 187] Cost of Causing Exceptions Many years ago, when hordes of C++ programmers ventured to the greener pastures of Java, some strange myths were introduced into the language. It was said that a "try" was cheaper than an "if" - when nothing went wrong.
* [Issue 196] Uncaught AWT Exceptions in Java 7 Java 7 removes the Swing Event Dispatch Thread (EDT) hack that allowed us to specify an uncaught exception handler for the EDT using a system property sun.awt.exception.handler.
 
# GC & Memory
* [Issue 060] Nulling variables and garbage collection
* [Issue 078] MemoryCounter for Java 1.4
* [Issue 092] OutOfMemoryError Warning System
* [Issue 098] References
* [Issue 115] Young vs. Old Generation GC A few weeks ago, I tried to demonstrate the effects of old vs. new generation GC. The results surprised me and reemphasized how important GC is to your overall program performance.
* [Issue 173] Java Memory Puzzle In this newsletter we show you a puzzle, where a simple request causes memory to be released, that otherwise could not. Solution will be shown in the next newsletter.
* [Issue 174] Java Memory Puzzle Explained In this newsletter, we reveal the answer to the puzzle from last month and explain the reasons why the first class sometimes fails and why the second always succeeds. Remember this for your next job interview ...
* [Issue 179] Escape Analysis Escape analysis can make your code run 110 times faster - if you are a really really bad programmer to begin with :-) In this newsletter we look at some of the places where escape analysis can potentially help us.
* [Issue 191] Delaying Garbage Collection Costs The garbage collector can cause our program to slow down at inappropriate times. In this newsletter we look at how we can delay the GC to never run and thus produce reliable results. Then, instead of actually collecting the dead objects, we simply shut down and start again.

# I/O
* [Issue 020] Serializing Objects Into Database
* [Issue 023] Socket Wheel to handle many clients
* [Issue 046] "The compiler team is writing useless code again ..."
* [Issue 058] Counting bytes on Sockets
* [Issue 088] Resetting ObjectOutputStream
* [Issue 166] Serialization Cache Java's serialization mechanism is optimized for immutable objects. Writing objects without resetting the stream causes a memory leak. Writing a changed object twice results in only the first state being written. However, resetting the stream also loses the optimization stored in the stream.
* [Issue 183] Serialization Size of Lists What has a larger serializable size, ArrayList or LinkedList? In this newsletter we examine what the difference is and also why Vector is a poor candidate for a list in a serializable class.

# Logging
* [Issue 003] Logging part 1
* [Issue 004] Logging part 2
* [Issue 177] Logging Part 3 of 3 After almost nine years of silence, we come back to bring the logging series to an end, looking at best practices and what performance measurements to log.

# Performance
* [Issue 042] Speed-kings of inverting booleans
* [Issue 064] Disassembling Java Classes
* [Issue 070] Too many dimensions are bad for you
* [Issue 070b] Multi-Dimensional Arrays - Creation Performance
* [Issue 090] Autoboxing Yourself in JDK 1.5
* [Issue 105] Performance Surprises in Tiger
* [Issue 195] Performance Puzzler With a Stack Trace In this newsletter, we present a little performance puzzler, written by Kirk Pepperdine. What is happening with this system? There is only one explanation and it can be discovered by just looking at the stack trace.
* [Issue 202] Distributed Performance Tuning In this newsletter, it is up to you to figure out how we improved the performance of our previous Fibonacci newsletter by 25%.
* [Issue 134] DRY Performance As developers we often hear that performance often comes at the price of good design. However when we have our performance tuning hats on, we often find that good design is essential to help achieve good performance. In this article we will explore one example of where a good design choice has been essential in an effort to improve performance.
* [Issue 157] Polymorphism Performance Mysteries Late binding is supposed to be a bottleneck in applications - this was one of the criticisms of early Java. The HotSpot Compiler is however rather good at inlining methods that are being called through polymorphism, provided that we do not have very many implementation subclasses.
* [Issue 158] Polymorphism Performance Mysteries Explained In this newsletter, we reveal some of the polymorphism mysteries in the JDK. The HotSpot Server Compiler can distinguish between mono-morphism, bi-morphism and poly-morphism. The bi-morphism is a special case which executes faster than poly-morphism. Mono-morphism can be inlined by the compiler in certain circumstances, thus not costing anything at all.

# Misc
* [Issue 035] Doclets Find Bad Code
* [Issue 038a] Counting Objects Clandestinely
* [Issue 038b] Counting Objects Clandestinely - Follow-up
* [Issue 049] Doclet for finding missing comments
* [Issue 053] Charting unknown waters in JDK 1.4 Part I
* [Issue 055] Once upon an Oak ...
* [Issue 057] A Tribute to my Dad, Hans Rudolf Kabutz
* [Issue 059] When arguments get out of hand...
* [Issue 059b] Follow-up to Loooong Strings
* [Issue 063] Revisiting Stack Trace Decoding
* [Issue 069] Treating Types Equally - or - Life's Not Fair!
* [Issue 069b] Results of last survey
* [Issue 072] Java and Dilbert
* [Issue 077] "Wonderfully disgusting hack"
* [Issue 080] Many Public Classes in One File
* [Issue 083] End of Year Puzzle
* [Issue 083b] End of Year Puzzle Follow-up

# OOPS & Basics
* [Issue 002] Anonymous Inner Classes
* [Issue 006] Implementation code inside interfaces
* [Issue 008] boolean comparisons
* [Issue 009] Depth-first Polymorphism
* [Issue 014] Insane Strings
* [Issue 017a] Switching on Object Handles
* [Issue 017b] Follow-up
* [Issue 018] Class names don't identify a class
* [Issue 021] Non-virtual Methods in Java
* [Issue 025] Final Newsletter
* [Issue 028] Multicasting in Java
* [Issue 036] Using Unicode Variable Names
* [Issue 062] The link to the outer class
* [Issue 062b] Follow-up and Happy New Year!
* [Issue 067] BASIC Java
* [Issue 068] Appending Strings
* [Issue 071] Overloading considered Harmful
* [Issue 079] Generic toString()
* [Issue 086] Initialising Fields before Superconstructor call
* [Issue 086b] Initialising Fields before Superconstructor call (Follow-up)
* [Issue 094] Java Field Initialisation
* [Issue 095] Self-reloading XML Property Files
* [Issue 095b] Follow-up: Self-reloading XML Property Files
* [Issue 096] Java 5 - "final" is not final anymore
* [Issue 110] Break to Labeled Statement
* [Issue 127] Casting like a Tiger Java 5 adds a new way of casting that does not show compiler warnings or errors. Yet another way to shoot yourself in the foot?
* [Issue 203] GOTO in Java It is possible to use the break statement to jump out to the end of a labelled scope, resulting in some strange looking code, almost like the GOTO statement in C.
* [Issue 210] Calling Methods from a Constructor In this newsletter we investigate what can go wrong when we call methods from constructors, showing examples from the JDK, Glassfish, Spring Framework and some other well known frameworks..



# Systems
* [Issue 011] Hooking into the shutdown call
* [Issue 022] Classloaders Revisited: "Hotdeploy"
* [Issue 026] Package Versioning
* [Issue 029] Determining Memory Usage in Java
* [Issue 037] Checking that your classpath is valid
* [Issue 043] Arrgh, someone wants to kill me!
* [Issue 087] sun.reflect.Reflection
* [Issue 091] Controlling Machines Remotely with Java

 
# UI
* [Issue 007] java.awt.EventQueue
* [Issue 010] Writing GUI Layout Managers
* [Issue 012] Setting focus to second component of modal dialog
* [Issue 013a] Serializing GUI Components Across Network
* [Issue 013b] Follow-up
* [Issue 019] Finding Lost Frames
* [Issue 030] What do you Prefer?
* [Issue 041] Placing components on each other
* [Issue 045] Multi-line cells in the JTable
* [Issue 065] Wait, Cursor, Wait!
* [Issue 075] An Automatic Wait Cursor: WaitCursorEventQueue
* [Issue 082] TristateCheckBox based on the Swing JCheckBox
* [Issue 106] Multi-line cells in JTable in JDK 1.4+
* [Issue 143] Maths Tutor in GWT Google Web Toolkit (GWT) allows ordinary Java Programmers to produce highly responsive web user interfaces, without needing to become experts in JavaScript. Here we demonstrate a little maths game for practicing your arithmetic. Included is an Easter egg.
* [Issue 148] Snappy JSliders in Swing Recent versions of Swing do a good job of mimicking the underlying platform, with a few caveats. For example, the JSlider only snaps onto the correct tick once you let go of the mouse. Here I present a fix for this problem with a non-intrusive one-liner that we can add to the application code.


# Web Services
* [Issue 084] Ego Tripping with Webservices

# Book Reviews
*  [Issue 044] Review: Object-Oriented Implementation of Numerical Methods In our first book review, we look at an interesting book that talks about implementing numerical methods in Java. Although not primarily a Java book, it gives us some insight as to the performance of Java versus other languages like C or Smalltalk.
*  [Issue 048] Review: The Secrets of Consulting How much do your customers love you? How should you give and receive advice? In this excellent book, we learn why it is so important to understand your customer. I use the principles daily in my work with code reviews, performance tuning and dealing with customers or clients.
*  [Issue 066] Book Review: Java Performance Tuning by Jack Shirazi In this book, Jack outlines the process used to make Java systems run faster. He gives lots of tips on how to find your bottlenecks and then also gives specific tricks to make your code just that bit faster. A must-have for Java programmers who care about the speed of their programs.
*  [Issue 085] Book Review: Pragmatic Programmer One of my favourite software development books, this one takes a good hard look at how to be a programmer in the real world. Surprisingly thin for a book with this much substance, I refer to the ideas in here all the time. The pragmatic bunch have built an entire industry around their software pragmatism.
*  [Issue 112] Book Review: Head First Design Patterns This book is a fantastic introduction to Design Patterns, probably the best available. In this newsletter, I look at some of the winning formulae used in the book, and explain why they work. I also give some tips of where I disagree with the book and some additional information that will be useful to you.
*  [Issue 119] Book Review: "Wicked Cool" Java The book "Wicked Cool Java" contains a myriad of interesting libraries, both from the JDK and various open source projects. In this review, we look at two of these, the java.util.Scanner and javax.sql.WebRowSet classes.
*  [Issue 125] Book Review: Java Concurrency in Practice We review Java Concurrency in Practice by Brian Goetz. Brian's book is the most readable on the topic of concurrency in Java, and deals with this difficult subject with a wonderful hands-on approach. It is interesting, useful, and relevant to the problems facing Java developers today.
*  [Issue 140] Book Review: Java Generics and Collections Java Generics and Collections is the "companion book" to The Java Specialists' Newsletter. A well written book that explains generics really nicely, including some difficult concepts. In addition, they cover all the new collection classes up to Java 6 Mustang.
*  [Issue 144] Book Review: Java Puzzlers Experienced Java programmers will love the Java Puzzlers book by Josh Bloch and Neal Gafter, both well known Java personalities. In this newsletter, we look at two of the puzzles as a teazer for the book.
*  [Issue 163] Book Review: Effective Java 2nd Edition Joshua Bloch has at long last published an updated version of Effective Java. An essential guide for professional Java programmers who are interested in producing high quality code, this book is also very readable. In this newsletter we describe some of the nuggets found in the book.
*  [Issue 185] Book Review: Java: The Good Parts In his latest book, Jim Waldo describes several Java features that he believes make Java "good". A nice easy read, and I even learned a few new things from it.
*  [Issue 204] Book Review: The Well-Grounded Java Developer Ben Evans and Martijn Verburg explain to us in their new book what it takes to be a well-grounded Java developer. The book contains a section on the new Java 7 features and also vital techniques that we use for producing robust and performant systems.
* 

* [Issue 097] Mapping Objects to XML Files using Java 5 Annotations
* [Issue 099] Orientating Components Right to Left
* [Issue 100] Java Programmers aren't Born
* [Issue 102] Mangling Integers
* [Issue 103] New for/in loop gymnastics
* [Issue 114] Compile-time String Constant Quiz When we change libraries, we need to do a full recompile of our code, in case any constants were inlined by the compiler. Find out which constants are inlined in this latest newsletter.
* [Issue 117] Reflectively Calling Inner Class Methods Sometimes frameworks use reflection to call methods. Depending how they find the correct method to call, we may end up with IllegalAccessExceptions. The naive approach of clazz.getMethod(name) is not correct when we send instances of non-public classes.
* [Issue 121] How Deep is Your Hierarchy? Someone asked me yesterday what the maximum inheritance depth is in Java. I guessed a value of 65535, but for practical purposes, not more than 5. When I asked performance guru Kirk Pepperdine to estimate, he shot back with 63. In this newsletter, we look at the limitations in the JVM and examine some existing classes.
* [Issue 122] Copying Files from the Internet Sometimes you need to download files using HTTP from a machine that you cannot run a browser on. In this simple Java program we show you how this is done. We include information of your progress for those who are impatient, and look at how the volatile keyword can be used.
* [Issue 124] Copying Arrays Fast In this newsletter we look at the difference in performance between cloning and copying an array of bytes. Beware of the Microbenchmark! We also show how misleading such a test can be, but explain why the cloning is so much slower for small arrays.
* [Issue 126] Proxy equals() When we make proxies that wrap objects, we have to remember to write an appropriate equals() method. Instead of comparing on object level, we need to either compare on interface level or use a workaround to achieve the comparisons on the object level, described in this newsletter.
* [Issue 128] SuDoKu Madness In this Java Specialists' Newsletter, we look at a simple Java program that solves SuDoKu puzzles.
* [Issue 131] Sending Emails from Java In this newsletter, we show how simple it is to send emails from Java. This should obviously not be used for sending unsolicited emails, but will nevertheless illustrate why we are flooded with SPAM.
* [Issue 132] Thread Dump JSP in Java 5 Sometimes it is useful to have a look at what the threads are doing in a light weight fashion in order to discover tricky bugs and bottlenecks. Ideally this should not disturb the performance of the running system. In addition, it should be universally usable and cost nothing. Have a look at how we do it in this newsletter.
* [Issue 135] Are you really Multi-Core? With Java 5, we can measure CPU cycles per thread. Here is a small program that runs several CPU intensive tasks in separate threads and then compares the elapsed time to the total CPU time of the threads. The factor should give you some indication of the CPU based acceleration that the multi cores are giving you.
* [Issue 137] Creating Loggers DRY-ly A common idiom for logging is to create a logger in each class that is based on the class name. The name of the class is then duplicated in the class, both in the class definition and in the logger field definition, since the class is for some reason not available from a static context. Read how to solve that problem.
* [Issue 139] Mustang ServiceLoader Mustang introduced a ServiceLoader than can be used to load JDBC drivers (amongst others) simply by including a jar file in your classpath. In this newsletter, we look at how we can use this mechanism to define and load our own services.
* [Issue 142] Instrumentation Memory Counter Memory usage of Java objects has been a mystery for many years. In this newsletter, we use the new instrumentation API to predict more accurately how much memory an object uses. Based on earlier newsletters, but revised for Java 5 and 6.
* [Issue 145] TristateCheckBox Revisited The Tristate Checkbox is widely used to represent an undetermined state of a check box. In this newsletter, we present a new version of this popular control, retrofitted to Java 5 and 6.
* [Issue 152] The Law of the Corrupt Politician Corruption has a habit of creeping into system that do not have adequate controls over their threads. In this law, we look at how we can detect data races and some ideas to avoid and fix them.
* [Issue 153] Timeout on Console Input In this newsletter, we look at how we can read from the console input stream, timing out if we do not get a response by some timeout.
* [Issue 155] The Law of the Micromanager In good Dilbert style, we want to avoid having Pointy-Haired-Bosses (PHBs) in our code. Commonly called micromanagers, they can make a system work extremely inefficiently. My prediction is that in the next few years, as the number of cores increases per CPU, lock contention is going to be the biggest performance problem facing companies.
* [Issue 156] The Law of Cretan Driving The Law of Cretan Driving looks at what happens when we keep on breaking the rules. Eventually, we might experience a lot of pain when we migrate to a new architecture or Java Virtual Machine. Even if we decide not to obey them, we need to know what they are. In this newsletter, we point you to some essential reading for every Java Specialist.
* [Issue 159] The Law of Sudden Riches We all expect faster hardware to make our code execute faster and better. In this newsletter we examine why this is not always true. Sometimes the code breaks on faster servers or executes slower than on worse hardware.
* [Issue 164] Why 0x61c88647? Prior to Java 1.4, ThreadLocals caused thread contention, rendering them useless for performant code. In the new design, each thread contains its own ThreadLocalMap, thus improving throughput. However, we still face the possibility of memory leaks due to values not being cleared out of the ThreadLocalMap with long running threads.
* [Issue 167] Annotation Processing Tool In this newsletter we answer the question: "How do we force all subclasses to contain a public no-args constructor?" The Annotation Processing Tool allows us to check conditions like this at compile time, rather than only at runtime.
* [Issue 168] The Delegator In this newsletter we show the reflection plumbing needed for writing a socket monitor that sniffs all the bytes being sent or received over all the Java sockets. The Delegator is used to invoke corresponding methods through some elegant guesswork.
* [Issue 169] Monitoring Sockets In this newsletter, we show two approaches for listening to bytes on sockets. The first uses the Delegator from our previous newsletter, whereas the second uses AspectJ to intercept the call to Socket.getInput/OutputStream. We also write an MBean to publish this information in JConsole.
* [Issue 170] Discovering Objects with Non-trivial Finalizers It is well known that implementing a non-trivial finalize() method can cause GC and performance issues, plus some subtle concurrency bugs. In this newsletter, we show how we can find all objects with a non-trivial finalize() method, even if they are not currently eligible for finalization.
* [Issue 175] Creating Objects Without Calling Constructors De-Serialization creates objects without calling constructors. We can use the same mechanism to create objects at will, without ever calling their constructors.
* [Issue 182] Remote Screenshots In this newsletter, we describe how we can generate remote screen shots as compressed, scaled JPGs to build a more efficient remote control mechanism.
* [Issue 186] Iterator Quiz Most of the northern hemisphere is on holiday, so here is a quick quiz for those poor souls left behind manning the email desk. How can we prevent a ConcurrentModificationException in the iterator?
* [Issue 189] Fun and Games with Java Lego NXT 2.0 It is almost Christmas time, which gives us an excuse to invest in all sorts of toys. I found that the most ridiculously priced ones are those that promise to have an added benefit besides fun. "Educational", "Good for hand-eye coordination", etc. In this Java newsletter we look at one of these "toys", the Lego Mindstorms NXT 2.0
* [Issue 197] What is the Meaning of Life? In this newsletter we try to calculate the meaning of life, with surprising results.
* [Issue 198] Pushing the Limits in Java's Random What is the largest double that could in theory be produced by Math.random()? In this newsletter, we look at ways to calculate this based on the 48-bit random generator available in standard Java. We also prove why in a single-threaded program, (int)(Random.nextDouble() + 1) can never be rounded up to 2.
* [Issue 199] Hacking Java Surreptitiously Surreptitious: stealthy, furtive, well hidden, covert. In this newsletter we will show two Java puzzles written by Wouter Coekaerts that require a surreptitious solution. You cannot do anything to upset the security manager.
* [Issue 205] How to Make Your Own Rules Rule Based Programming, a declarative programming paradigm, is based on logical patterns to select data and associate it with processing instructions. This is a more indirect method than the sequential execution steps of an imperative programming language.
* [Issue 207] Final Parameters and Local Variables The trend of marking parameters and local variables as "final" does not really enhance your code, nor does it make it more secure.
* [Issue 209] Unicode Redux (1 of 2) Unicode is the most important computing industry standard for representation and handling of text, no matter which of the world's writing systems is used. This newsletter discusses some selected features of Unicode, and how they might be dealt with in Java.