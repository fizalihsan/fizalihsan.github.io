---
layout: page
title: "Java Performance"
comments: true
sharing: true
footer: true
---
* list element with functor item
{:toc}

# Memory

Any Java object occupies at least 16 bytes, 12 out of which are occupied by a Java object header. Besides that, all Java objects are aligned by 8 bytes boundary. It means that, for example, an object containing 2 fields: int and byte will occupy not 17 (12 + 4 + 1), but 24 bytes (17 aligned by 8 bytes).

Each Object reference occupies 4 bytes if the Java heap is under 32G and `XX:+UseCompressedOops` is turned on (it is turned on by default in the recent Oracle JVM versions). Otherwise, Object references occupy 8 bytes.

* http://java-performance.info/memory-introspection-using-sun-misc-unsafe-and-reflection/
* http://java-performance.info/overview-of-memory-saving-techniques-java/
* [Top Java Memory Problems - Part 1](http://apmblog.compuware.com/2011/04/20/the-top-java-memory-problems-part-1/)
* [Garbage Collection](http://docs.oracle.com/javase/6/docs/technotes/guides/management/jconsole.html#gddzt)

Understand the implications of moving b/w 32-bit and 64-bit JVMs especially in terms of memory usage and allocation.

## JVM Architecture

{% img right /technology/jvm-architecture.png %}

[Understanding JVM Internals](http://www.cubrid.org/blog/dev-platform/understanding-jvm-internals/)

### Class loader subsystem

Responsible for loading classes and interfaces

### Execution engine

Responsible for the execution of the instructions specified in the classes.

### Native interface

interacts with the native libraries.

### Runtime data areas

Mechanism to hold all kinds of data items such as instructions, object data, local variable data, return values & intermediate results. How runtime data are stored in the runtime data areas depends on the implementation of the JVM. Some implementation may enjoy the availability of memory and some others may not. The abstract nature of runtime data area specification allows the implementation of JVM in different machines easier. Some runtime data areas are shared among all the threads in the application, while some others are too specific to an active thread.

#### Runtime data areas shared among all threads

* **Method area**: holds the details of each class loaded by the class loader subsystem. 
* **Heap**: holds every object being created by the threads during execution

#### Thread-specific runtime data areas

* **Program counter register**: points to the next instruction to be executed.
* **Java stack**: hold the state of each method (java method, not a native method) invocations for the thread such as the local variables, method arguments, return values, intermediate results. Each entry in the Java stack is called “stack frames“. Whenever a method is invoked a new stack frame is added to the stack and corresponding frame is removed when its execution is completed.
* **Native method stack**: holds the state of each native method call in an implementation dependent way.

## Garbage Collection

{% img /technology/java-gc1.png %}

{% img right /technology/java-gc2.png %}

* Definition: process of looking at heap memory, identifying which objects are in use and which are not, and deleting the unused objects.
* [Tuning GC](http://www.oracle.com/technetwork/java/gc-tuning-5-138395.html)
* [How to tune GC](http://architects.dzone.com/articles/how-tune-java-garbage)


### Phases

* Mark phase - garbage collector identifies which pieces of memory are in use and which are not. Unused memory is cleaned up.
* Normal deletion removes unreferenced objects leaving referenced objects and pointers to free space.
* Compact phase - To further improve performance, in addition to deleting unreferenced objects, you can also compact the remaining referenced objects. By moving referenced object together, this makes new memory allocation much easier and faster.

### JVM Generations

* Young Generation
  * all new objects are allocated and aged. 
  * causes a minor GC when this fills up.
  * relatively quicker to collect than other generations
  * Stop the World event: All minor GCs are "Stop the World" events which means all the app threads are stopped until the GC completes.
* Old Generation
  * stores long surviving objects. 
  * a threshold is set for young generation objects and when the age is met, the objects gets moved to old generation.
  * causes a major GC when this fills up. Also, a "Stop the World" event.
* Permanent Generation
  * stores metadata required by the JVM to describe the classes and methods used in the app. Java SE library classes and method may be stored here.
  * class may get collected/unloaded if they are no longer needed. Causes a Full GC

### Generational GC Process

* 1st minor GC
  * New objects are allocated in eden space. Both survivor spaces start out empty.
  * When eden space fills up, a minor GC is triggered.
  * referenced objects are moved to 1st survivor space (S0)
  * Eden space is cleared.
* 2nd minor GC
  * When eden space fills up, a minor GC is triggered.
  * referenced objects are moved to 2nd survivor space (S1). 
  * In addition, objects from 1st survivor space (S0) have their age incremented and get moved to S1.
  * Eden & S0 space is cleared.
* 3rd minor GC
  * When eden space fills up, a minor GC is triggered.
  * referenced objects are moved to S0.  
  * In addition, objects from S1 have their age incremented and get moved to S0.
  * Plus, objects that reached the threshold age are moved to old generation.
  * Eden & S1 space are cleared.
* 1st major GC
  * When tenure space fills up, a major GC is triggered. It cleans up and compacts that space.

### Garbage Collection Algorithms

* The Serial GC
  * default collector for client style machines in Java SE 5 & 6.
  * Both minor & major GCs are done serially using a single virtual CPU.
  * Uses a mark-compact collection method.
  * Option: `-XX:+UserSerialGC`.
  * Usages: 
  * For longer apps with no low pause time requirements
  * For apps which run on machine that hosts more JVMs than available processors.In such environment, GC of one app shouldn't affect all other JVMs.
* The Parallel GC
  * uses multiple threads  to perform the young generation GC.
  * By default, on a host with 'N' CPUs, the parallel GC uses N GC threads in the collection. The number of GC threads can be controlled: `-XX:ParallelGCThreads=<num>`
  * Parallel GC is also called a throughput collector.
  * Usages:
  * apps where high throughput is required and long pauses are accepted.
  * 2 flavors of Parallel GC
  * Option: `-XX:+UseParallelGC` - does multi-threaded young generation GC, single-threaded old generation collection and compaction.
  * Option: `-XX:+UseParallelOldGC` - does multi-threaded young, multi-thread old generation collection and compaction. (HotSpot does compaction only in the old generation)
* The Concurrent Mark Sweep (CMS) Collector
  * Also called Concurrent Low Pause Collector.
  * For younger generation, uses the same algorithm as Parallel GC
  * For older generation, it minimizes the pauses by doing GC concurrently with the application threads.
  * Does not copy or compact the live objects. If fragmentation becomes an issue, allocate larger heap.
  * Option: `-XX:+UseConcMarkSweepGC`
* The G1 collector
  * Also called Garbage First Collector.
  * Replacement for CMS collector.
  * G1 is a parallel, concurrent, and incrementally compacting low-pause collector that has a different layout from other collectors above.
  * More details here
  * Option: `-XX:+UserG1GC`

## Reference Types

### WeakReference

Weak reference objects, which do not prevent their referents from being made finalizable, finalized, and then reclaimed. Weak references are most often used to implement canonicalizing mappings.

Suppose that the garbage collector determines at a certain point in time that an object is weakly reachable. At that time it will atomically clear all weak references to that object and all weak references to any other weakly-reachable objects from which that object is reachable through a chain of strong and soft references. At the same time it will declare all of the formerly weakly-reachable objects to be finalizable. At the same time or at some later time it will enqueue those newly-cleared weak references that are registered with reference queues.

### SoftReference

Soft reference objects, which are cleared at the discretion of the garbage collector in response to memory demand. Soft references are most often used to implement memory-sensitive caches.

Suppose that the garbage collector determines at a certain point in time that an object is softly reachable. At that time it may choose to clear atomically all soft references to that object and all soft references to any other softly-reachable objects from which that object is reachable through a chain of strong references. At the same time or at some later time it will enqueue those newly-cleared soft references that are registered with reference queues.

All soft references to softly-reachable objects are guaranteed to have been cleared before the virtual machine throws an OutOfMemoryError. Otherwise no constraints are placed upon the time at which a soft reference will be cleared or the order in which a set of such references to different objects will be cleared. Virtual machine implementations are, however, encouraged to bias against clearing recently-created or recently-used soft references.

Direct instances of this class may be used to implement simple caches; this class or derived subclasses may also be used in larger data structures to implement more sophisticated caches. As long as the referent of a soft reference is strongly reachable, that is, is actually in use, the soft reference will not be cleared. Thus a sophisticated cache can, for example, prevent its most recently used entries from being discarded by keeping strong referents to those entries, leaving the remaining entries to be discarded at the discretion of the garbage collector.

### PhantomReference

Phantom reference objects, which are enqueued after the collector determines that their referents may otherwise be reclaimed. Phantom references are most often used for scheduling pre-mortem cleanup actions in a more flexible way than is possible with the Java finalization mechanism.

If the garbage collector determines at a certain point in time that the referent of a phantom reference is phantom reachable, then at that time or at some later time it will enqueue the reference.

In order to ensure that a reclaimable object remains so, the referent of a phantom reference may not be retrieved: The get method of a phantom reference always returns null.

Unlike soft and weak references, phantom references are not automatically cleared by the garbage collector as they are enqueued. An object that is reachable via phantom references will remain so until all such references are cleared or themselves become unreachable. Automatically cleared references Soft and weak references are automatically cleared by the collector before being added to the queues with which they are registered, if any. Therefore soft and weak references need not be registered with a queue in order to be useful, while phantom references do. An object that is reachable via phantom references will remain so until all such references are cleared or themselves become unreachable


---

# Performance Metrics

* Responsiveness
  * Refers to how quickly an app responds with a requested piece of data. e.g., how quickly a website returns a page.
  * The focus is on responding in short period of time and long pause times are not acceptable. 
* Throughput
  * focus is on maximizing the amount of work done by an app in a specific period of time. e.g., no. of transactions in a given time
  * The focus is on high throughput over longer periods of time and long pause times are acceptable. Quick response is not a consideration.

# Profiling

* What is profiling?
  * Measurement of program behavior
  * Gathering of statistics about program execution
* What can profiling tell you?
  * How your program is spending time
    * Which methods were called? How often?
    * How long did those methods take to return?
  * How your program is allocating space
    * Which objects were created? How many?
    * How much memory are those objects using?
* Difference between Profiling & Benchmarking
  * Profiling
    * Aims to identify how an application executes
    * Does not accurately measure execution time
  * Benchmarking
    * Aims to accurately measure execution time
    * Does not identify ways to improve code
* Types
  * Sample-based: sample relevant statistics at intervals during execution
    * Less overhead
    * Less accuracy
  * Instrumentation-based: modify application execution to generate detailed traces
    * More overhead
    * More accuracy

# Benchmarking

* https://code.google.com/p/caliper/wiki/JavaMicrobenchmarks
* http://www.ibm.com/developerworks/java/library/j-benchmark1/index.html
* https://code.google.com/p/javamelody/ - To capture SQL calls
* [CodeHale](https://github.com/dropwizard/metrics) <span style="color:red">TODO</span>

* Benchmarking issues
  * What are you trying to test?
  * Optimization requires warm-up
  * Timing API accuracy
  * GC latency
* The right way
  * Simulate production (dataset, hardware, etc)
  * Run for an extended period of time
  * Warm up HotSpot™ with 10,000 iterations of benchmark code
  * Calculate scores based on average execution time
  * Identify outliers
* Never micro-benchmark. E.g.,

```java
long start = System.nanoTime();
for (int i = 0; i < count; i++)
Math.sqrt(1234);
long stop = System.nanoTime();
System.out.println("time " + (stop - start)/1000);
```

# JVM Profiling Tools

## HPROF

Command-line tool for heap and CPU profiling
Not the most convenient or usable tool
Process to be profiled must be started with flags
Interface is purely text-based
A reasonable instructional tool
Heap and CPU profiling
Sample- and instrumentation-based approaches

```java HPROF (heap=sites)
javac -J-agentlib:hprof=heap=sites Hello.java

TRACE 301926: java.util.zip.ZipEntry.<init>(ZipEntry.java:101) java.util.zip.ZipFile+3.nextElement(ZipFile.java:417) com.sun.tools.javac.jvm.ClassReader.openArchive(ClassReader.java:1374) com.sun.tools.javac.jvm.ClassReader.list(ClassReader.java:1631)
TRACE 301927: com.sun.tools.javac.util.List.<init>(List.java:42) com.sun.tools.javac.util.List.<init>(List.java:50) com.sun.tools.javac.util.ListBuffer.append(ListBuffer.java:94) com.sun.tools.javac.jvm.ClassReader.openArchive(ClassReader.java:1374)
 
SITES BEGIN (ordered by live bytes) Wed Oct 4 13:13:42 2006
percent live alloc'ed stack class rank self accum bytes objs bytes objs trace name
1 44.13% 44.13% 1117360 13967 1117360 13967 301926 java.util.zip.ZipEntry
2 8.83% 52.95% 223472 13967 223472 13967 301927 com.sun.tools.javac.util.List
3 5.18% 58.13% 131088 1 131088 1 300996 byte[]
4 5.18% 63.31% 131088 1 131088 1 300995 com.sun.tools.javac.util.Name[]
```

```java HPROF (cpu=samples)
javac -J-agentlib:hprof=cpu=samples Hello.java

CPU SAMPLES BEGIN (total = 462) Wed Oct 4 13:33:07 2006
rank self accum count trace method
1 49.57% 49.57% 229 300187 java.util.zip.ZipFile.getNextEntry
2 6.93% 56.49% 32 300190 java.util.zip.ZipEntry.initFields
3 4.76% 61.26% 22 300122 java.lang.ClassLoader.defineClass2
4 2.81% 64.07% 13 300188 java.util.zip.ZipFile.freeEntry
5 1.95% 66.02% 9 300129 java.util.Vector.addElement
6 1.73% 67.75% 8 300124 java.util.zip.ZipFile.getEntry
7 1.52% 69.26% 7 300125 java.lang.ClassLoader.findBootstrapClass
```

```java HPROF (cpu=times)
javac -J-agentlib:hprof=cpu=times Hello.java
CPU TIME (ms) BEGIN (total = 2082665289) Wed oct 4 13:43:42 2006
rank self accum count trace method
1 3.70% 3.70% 1 311243 com.sun.tools.javac.Main.compile
2 3.64% 7.34% 1 311242 com.sun.tools.javac.main.Main.compile
3 3.64% 10.97% 1 311241 com.sun.tools.javac.main.Main.compile
4 3.11% 14.08% 1 311173 com.sun.tools.javac.main.JavaCompiler.compile
5 2.54% 16.62% 8 306183 com.sun.tools.javac.jvm.ClassReader.listAll
6 2.53% 19.15% 36 306182 com.sun.tools.javac.jvm.ClassReader.list
7 2.03% 21.18% 1 307195 com.sun.tools.javac.comp.Enter.main
```

## VisualVM

* http://java.dzone.com/announcements/visualvm-12-great-java
* JVM diagnostics
* CPU and heap profiling
* JMX console (with MBeans plugin)
* Integrates a number of tools for JVM diagnostics
  * jmap, jhat, jstack, jstat, and jinfo
  * JConsole
  * Netbeans profiler (JFluid)
* Requires Java 6
  * Included with Java 6 Update 7+
  * Available as a separate download for lower versions
* Runs locally or remotely (except profiler)

## MAT

* Detailed heap analysis
* Memory leak identification
* Memory usage optimization
* Eclipse Memory Analyzer
  * Integrated into Eclipse 3.5 Galileo
  * Plugin for earlier versions of Eclipse
  * Standalone RCP app
* Good performance characteristics
  * Loads heap dump files incrementally
  * Generated indexes
* Feature-rich (if not intuitive) user interface
  * Well, it is an Eclipse application after all
  * Multitude of pre-canned reports

## BTrace

* Targeted, programmable profiling
* Live tracing and debugging
* Dynamic tracing tool for Java
  * Declare probe points: locations at or events on which to trace
  * Program trace actions to execute when a probe fires
* Key differentiators:
  * Targeted nature incurs minimal performance overhead
  * Programmability enables correlation of metrics to application state and method parameters
  * Restricted programming model “guarantees” safety
* BTrace scripts cannot:
  * Create objects or arrays
  * Throw or catch exceptions
  * Call arbitrary static or instance methods
  * Assign to static or instance variables of the target program
  * Contain synchronized blocks or methods
  * Loop (for, while, or do…while)
  * Assert
  * Extend arbitrary classes or implement arbitrary interfaces
  * Have outer, inner, nested, or local classes

Apache JMeter - http://jmeter.apache.org/


## Tools shipped with Java

* jmap
  * Prints heap memory details of a given process, core, or remote debug server
  * Usage:
  * `jmap –histo:live <pid>`
  * `jmap –dump:live,format=b <pid>`
  * TIP: prefer JMX-triggered heap dumps
  * JConsole or VisualVM with MBeans plugin
  * Safer than jmap
* jhat
  * Parses heap dumps and launches server for heap browsing and query
  * Usage: `jhat <binary heap dump file>`
  * TIP: prefer Eclipse MAT for heap analysis
  * Vastly better performance
  * Vastly better usability
* jstack
  * Prints stack traces of executing threads for a given process, core file, or remote debug server
  * Usage: `jstack [-l] <pid>`
  * The [-l] option (Java 6+) includes information on java.util.concurrent locks in addition to monitors
  * TIP: on *nix systems, prefer kill –QUIT (or kill –3)
  * Safer than jstack
  * Multiple calls will quickly provide insight into execution
* jstat
  * Displays performance statistics for the targeted process
  * Class loader
  * HotSpot™ compiler
  * Garbage collector
  * Usage: `jstat [output options] <pid> [interval]`
  * TIP: a reasonable way to view individual statistics…
  * …if the command line is all that’s available
  * Otherwise, JConsole and VisualVM provide far more context
* jps
  * Lists all java processes on the given server
  * Usage: `jps [<hostname>]`
* jinfo
  * Prints system properties and JVM startup options for the given process, core, or remote debug server
  * Usage: `jinfo <pid>`

## HP JTune


## HP JMeter

# Bibliography

* Books
  * Java - The Good Parts
  * Inside the Java Virtual Machine - Bill Venners
* http://www.codinghorror.com/blog/2008/12/hardware-is-cheap-programmers-are-expensive.html
* http://www.infoq.com/articles/9_Fallacies_Java_Performance?utm_source=infoq&utm_medium=popular_links_homepage
* http://www.javacodegeeks.com/2012/09/visualvm-monitoring-remote-jvm-over-ssh.html
* http://www.javacodegeeks.com/resources#Profilers
* http://blog.javabenchmark.org/2013/03/write-your-own-profiler-with-jee6.html
* http://hype-free.blogspot.com/2010/01/choosing-java-profiler.html
* http://psy-lob-saw.blogspot.com/2013/04/writing-java-micro-benchmarks-with-jmh.html
* [The Value and Perils of Performance Benchmarks in the Wake of TechEmpower’s Web Framework Benchmark](http://theholyjava.wordpress.com/2013/04/01/the-value-and-perils-of-performance-benchmarks-in-the-wake-of-techempowers-web-framework-benchmark/)
* Programmers Need To Learn Statistics Or I Will Kill Them All
* 5 things you didn't know about Java Performance - [Part 1](http://www.ibm.com/developerworks/java/library/j-5things7/index.html), [Part 2](http://www.ibm.com/developerworks/java/library/j-5things8/index.html)
