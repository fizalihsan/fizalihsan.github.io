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
* Skiplist (invented by William Pugh - look paper on alternative to Binary Tree - learn the Java implementations - when to prefer this over Maps)

## Queues

* [Queue implementation using single and double stacks](https://gist.github.com/fizalihsan/26acf7f6be1c33c121a8471b2a47892b)

## Trees 

[Trees Basics](http://webdocs.cs.ualberta.ca/~holte/T26/top.realTop.html)

### Binary Tree

> **Definition**: A binary search tree (BST) is a binary tree where each node has a `Comparable` key (and an associated value) and satisfies the restriction that the key in any node is larger than the keys in all nodes in that node’s left subtree and smaller than the keys in all nodes in that node’s right subtree

* [Binary Tree Problems](/technology/BinaryTrees.pdf)
* [Tree-List Recursion Problems](/technology/TreeListRecursion.pdf)
* **Full Binary Tree** - Each node in a *full binary tree* is either (1) an internal node with exactly two non-empty children or (2) a leaf
* **Complete Binary Tree** - has a restricted shape obtained by starting at the root and filling the tree by levels from left to right. In the complete binary tree of height *d*, all levels except possibly level *d-1* are completely full. The bottom level has its nodes filled in from the left side.

{% img right /technology/full_complete_binarytrees.png %}

* **Traversals**
  * Preorder traversal - *Parent node, left child, right child*. 
  * Inorder traversal - *Left child, Parent node, right child* - An inorder traversal first visits the left child (including its entire subtree), then
visits the node, and finally visits the right child (including its entire subtree).
  * Postorder traversal - *Left child, right child, Parent node*
  * [Binary Tree Traversal - Java Code](https://gist.github.com/fizalihsan/cc21a12af3d751baf7ec8dac57ea8775)

#### Binary search tree (BST)

* [Check if a given tree is a Binary Search Tree](https://gist.github.com/fizalihsan/73f5326f45b0f9f438496fc12634a1a0)
* A BST is a binary tree that conforms to the following condition, known as the **Binary Search Tree Property**.
	* All nodes stored in the left subtree of a node whose key value is `K` have key values less than `K`. 
	* All nodes stored in the right subtree of a node whose key value is `K` have key values greater than or equal to `K`.
* If the BST nodes are printed using an inorder traversal, the resulting enumeration will be in sorted order from lowest to highest.

**Balanced tree**

* If a binary tree is balanced, then the height for a tree of *n* nodes is approximately *log n*. However, if the tree is completely unbalanced, then the height for a tree with *n* nodes can be as great as *n*.
* a balanced BST will in the average case have operations costing `O(log n)`, while a badly unbalanced BST can have operations in the worst case costing `O(n)`.
* While the BST is simple to implement and efficient when the tree is balanced, the possibility of its being unbalanced is a serious liability. There are techniques for organizing a BST to guarantee good performance: like AVL tree and the splay tree.

**Height-balanced binary search tree (OR) AVL tree** (after their Russian inventors  *Adelson-Velskii and Landis*)

### Red-Black Tree

* A red-black tree storing `n` values has height at most `2logn`.
* The `add(x)` and `remove(x)` operations on a red-black tree run in `O(logn)` worst-case time.
* The amortized number of rotations performed during an `add(x)` or `remove(x)` operation is constant.

**Uses**

* Used in `java.util.TreeMap`
* C++ Standard Template Library
* Linux Kernel

* B+ tree & Balanced B+ tree - used in DB indexes
* Self-balanced tree
* M-way trees
* B trees: Perfectly Height-balanced M-way search trees
* 2-3-4 trees
* Tries

### Tree Algorithms

* Insertion, Deletions
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

