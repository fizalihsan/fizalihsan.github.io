---
layout: page
title: "Concurrency & Parallelism"
comments: false
sharing: false
footer: true
---

* list element with functor item
{:toc}


# Parallelism

## Types of Parallelism

* **Bit-level parallelism**
	* (hardware-level) improvement from 8-bit processors to 16, 32 and now 64 bits. Performing a 32 bit operation in 32-bit machines is much faster than 8-bit machine.
* **Instruction-level parallelism**
	* (hardware-level) Modern CPUs are highly parallel, using techniques like pipelining, out-of-order 
	* execution, and speculative execution.
* **Data Parallelism**
	* Data-parallel (sometimes called SIMD, for “single instruction, multiple data”) architectures are capable of performing the same operations on a large quantity of data in parallel.
	* Used in: To increase the brightness of an image, for example, we increase the brightness of each pixel. For this reason, modern GPUs (graphics processing units) have evolved into extremely powerful data-parallel processors.
* **Task-Level Parallelism**
	* This is where multiple processors come into picture. The distinguishing feature of a multiprocessor architecture is the memory model, specifically whether it’s shared or distributed.
	* *Shared-memory multiprocessor*
		* Each processor can access any memory location, and interprocessor communication is primarily through memory. 
		* Communicating via memory is typically faster and simpler, and hence writing code for shared memory-multiprocessors is generally easier.
		* Beyond a certain number of processors, shared memory becomes a bottleneck. To scale beyond that, distributed memory is needed.
		<add picture here>
	* *Distributed-memory multiprocessor*
		* Each processor has its own local memory and where interprocessor communication is primarily via the network.
		* Distributed memory is also unavoidable to write fault-tolerant systems that use multiple machines to cope with hardware failures.
		<add picture here>
* **Data Parallelism**
	* Multiple computing units perform the same operations on different items of data in parallel.
	* A modern GPU is a powerful data-parallel processor, capable of eclipsing the CPU when used for number-crunching, a practice that is commonly referred to as general-purpose computing on the GPU or GPGPU programming. Although they were originally designed with graphics alone in mind, their capabilities have evolved to the point that they’re useful for a much wider range of applications.
	* Pipelining
	* Multiple ALUs (arithmetic logic unit)

# Concurrency

* Concurrency is about a great deal more than just exploiting parallelism—used correctly, it allows your software to be responsive, fault tolerant, efficient, and simple.
* Concurrency is the key to responsive systems. E.g., by handling multiple connections concurrently, a web server ensures that a single slow request doesn’t hold up others.
* Distributed software: Sometimes geographical distribution is a key element of the problem you’re solving. Whenever software is distributed on multiple computers that aren’t running in lockstep, it’s intrinsically concurrent.
* Concurrency enables resilient, or fault-tolerant, software through independence and fault detection. Independence is important because a failure in one task should not be able to bring down another. 
* Fault detection is critical so that when a task fails (because it crashes or becomes unresponsive, or because the hardware it’s running on dies), a separate task is notified so that it can take remedial action.

## Factors affecting concurrency

* Number of threads

```
	**Formula to compute the number of threads**
	Number of threads = Number of Available Cores / (1 - Blocking Coefficient)

	where the blocking coefficient is between 0 and <1.
	A computation-intensive task has a blocking coefficient of 0. 
	For an IO-intensive task has a value close to 1. A fully blocked task is doomed, so we don’t have to worry about the value reaching 1.
```

* Number of partitions
	* Although the number of threads affects performance, it is not the only thing. The workload of each part and how much time each part takes to complete relative to others both affect performance. 
	* For computation-intensive tasks, we need to have at least as many partitions as the number of cores.


## Concurrency & State

* **Shared Mutable Design**
	* Shared state is accessed and mutated by multiple threads. We must ensure that no two threads modify the state at the same time and that changes are consistent. This leads to many issues when not programmed correctly.
* **Isolated Mutable Design**
	* State is mutable but are never seen by more than one thread, ever. Anything that's shared between threads is immutable. No synchronization concerns in this approach.
* **Pure Immutable Design**
	* Nothing is ever allowed to change.
	* While avoiding changing state, if we copy large objects over and over, that'll lead to poor performance. Persistent data structures come to the rescue here.

## Concurrency Models

* Threads - Java 2 Thread, Runnable, etc.
* Organized Threads - Java 5 Executors, etc.
* Fork-Join Framework
* CompletableFuture
* Actor Model
	* The Actor model isn’t really a functional approach to concurrency, but it fits our general goal of managing state mutation in principled ways. In the Actor model of concurrency, work is coordinated by message passing between “actors.” Each actor has a queue, sometimes called a mailbox, for incoming messages. The actor processes each message, one at a time.
* Fibers
* Software Transaction Memory (STM)
	* STM brings transactions to locations in memory that are referenced by variables. STM can’t provide durability, because memory isn’t durable (e.g., if the power is lost), but STM can provide the ACI (atomicity, consistency, and isolation) in ACID.
	* Persistent Data Structures are exactly what STM needs.


Questions
	Advantage of CompletionService over Future?

## Persistent Data Structures

* Persistent data structures version their values, so older and newer values stay around or persist over time without degrading performance. Persistent here does not have anything to do with storage; it's about data being preserved over time.
* **Identity or State** - A variable in an imperative language interconnects 'identity' and 'state'. A single identity can only ever have a single value, making it easy to lose sight of the fact that the state is really a sequence of values over time. Persistent data structures separate identity from state. If we retrieve the current state associated with an identity, that state is immutable and unchanging, no matter what happens to the identity from which we retrieved it in the future.
* Some of the well-known persistent data structures - immutable list, tries, 

# Lambda Architecture

* The Lambda Architecture is a particular approach to Big Data popularized by Nathan Marz.
* Like GPGPU programming, the Lambda Architecture leverages data parallelism. The difference is that it does so on a huge scale, distributing both data and computation over clusters of tens or hundreds of machines. Not only does this provide enough horsepower to make previously intractable problems tractable, but it also allows us to create systems that are fault tolerant against both hardware failure and human error.
* Layers
	* Batch Layer
		* MapReduce, Hadoop (Lambda architecture is not tied to MapReduce though. Any distributed batch-processing system can be used.)
	* Serving Layer
		* Databases like ElephantDB, Voldemort
	* Stream Layer
		* Apache Storm, Apache Spark

Refer *"Big Data - Principles and best practices of scalable realtime data systems" by Nathan Marz* for more details

# References

* Seven Concurrency Models in Seven Weeks
* Programming Concurrency in JVM