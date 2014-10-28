---
layout: page
title: "Java Performance"
comments: true
sharing: true
footer: true
---

[TOC]

# Terminology

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
