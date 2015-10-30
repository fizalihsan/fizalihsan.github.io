---
layout: page
title: "Data Structures"
comments: false
sharing: false
footer: true
---

* list element with functor item
{:toc}

# Data Types

## Lists

* Array
* LinkedList
  * [Basics](/technology/LinkedListBasics.pdf)
  * [Problems](/technology/LinkedListProblems.pdf)
* Skiplist (invented by William Pugh - look paper on alternative to Binary Tree - learn the Java implementations - when to prepare this over Maps)

## Trees 

### Tree Types
[Trees Basics](http://webdocs.cs.ualberta.ca/~holte/T26/top.realTop.html)

* Binary Tree
  * [Binary Tree Problems](/technology/BinaryTrees.pdf)
  * [Tree-List Recursion Problems](/technology/TreeListRecursion.pdf)
* Binary search tree (BST)
* B trees: Perfectly Height-balanced M-way search trees
* Balanced tree
* Height-balanced binary search tree (OR) AVL tree (after their Russian inventors  * Adelson-Velskii and Landis.)
* B+ tree & Balanced B+ tree - used in DB indexes
* Self-balanced tree
* M-way trees
* 2-3-4 trees
* Red-Black trees
  * implemented in java.util.TreeMap

### Tree Algorithms

* Insertion, Deletions
* Traversals - inorder, pre-order, post-order
* Tree Rotation

## Graphs

### Graph Types 

Directed, Undirected, Weighted

### Graph Algorithms


# Algorithms

## Algorithm Basics

* Space-time complexity

### Efficiency and Big-O notation

A good algorithm is economical in its use of two resources: time and space. The O-notation is a way of describing the performance of an algorithm in an abstract way, without the detail required to predict the precise performance of a particular program running on a particular machine. Main reason for using it is that it gives us a way of describing how the execution time for an algorithm depends on the size of its data set, provided the data set is large enough.

* How to calculate the BigO values?
* Diff use cases - best case, worst case, amortized, probablistic???
* [Informal Introduction to BigO notation](http://www.perlmonks.org/?node_id=227909) 
* **Common Big-O functions**

| # | Time | Common Name     |Effect on running time if N is doubled|Example|
| - | -----|-----------------|--------------------------------------|-------  |
| 1 | O(1) |**Constant Time**|unchanged | insertion into a hash table |
| 2 | O(log N) | **Logarithmic Time** | increased by a constant amount | insertion into a tree |
| 3 | O(N) | **Linear Time** | Doubled e.g. linear search ||
| 4 | O(N log N) | | doubled plus an amount proportional to N | merge sort|
| 5 | O(N2) | **Quadratic Time** | Increases fourfold. | bubble sort |
| 6 | | **Amortized Constant Time** | adding an element to the end of an ArrayList can normally be done in constant time, unless the ArrayList has reached its capacity. In that case, a new and larger array must be allocated, and the contents of the old array transferred into it. The cost of this operation is linear in the number of elements in the array, but it happens relatively rarely. In situations like this, we calculate the amortized cost of the operation—that is, the total cost of performing it n times divided by n, taken to the limit as n becomes arbitrarily large. In the case of adding an element to an ArrayList, the total cost for N elements is O(N), so the amortized cost is O(1). ([Wiki link](http://en.wikipedia.org/wiki/Big_O_notation#Orders_of_common_functions) for more examples)||

* Download algorithms and solutions from book site : Cracking coding interviews

## Sorting

* Heap sort visualization - http://www2.hawaii.edu/~copley/665/HSApplet.html
* Sorting
* Hashing

## Searching

* [Guide - An Extensive Examination of Data Structures Using C# 2.0](http://msdn.microsoft.com/en-US/library/ms379570(v=vs.80).aspx)
* [1](http://www.mpi-inf.mpg.de/~mehlhorn/Toolbox.html)
* [2](http://www.cs.auckland.ac.nz/software/AlgAnim/ds_ToC.html)

# Pointers and Memory

* [Pointers and Memory](/technology/PointersAndMemory.pdf)