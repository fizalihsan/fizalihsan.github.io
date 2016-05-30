---
layout: page
title: "Algorithms"
comments: false
sharing: false
footer: true
---

* list element with functor item
{:toc}

Grokking Algorithms - [http://adit.io/](http://adit.io/)


# Big-O Notation


{% img right /technology/big-o-complexity.png 600 600 %}

* **O(1)/Constant Complexity**: 
	* Constant.  Irrespective of the size of the data set the algorithm will always take a constant time. 
	* Example: `HashMap.get()` operation
* **O(log n)/Logarithmic Complexity**: 
	* Not as good as constant, but still pretty good.  The time taken increases with the size of the data set, but not proportionately so. This means the algorithm takes longer per item on smaller datasets relative to larger ones.   1 item takes 1 second, 10 items takes 2 seconds, 100 items takes 3 seconds. This makes log n algorithms very scalable.
	* Example: Binary search 
* **O(n)/Linear Complexity**: 
	* The larger the data set, the time taken grows proportionately.  1 item takes 1 second, 10 items takes 10 seconds, 100 items takes 100 seconds.
	* Example: To find an element T which is the last item in the `LinkedList`
* **O(n log n)**: 
	* A nice combination of the previous two.  Normally there’s 2 parts to the sort, the first loop is O(n), the second is O(log n), combining to form O(n log n) 1 item takes 2 seconds, 10 items takes 12 seconds, 100 items takes 103 seconds.
{% img right /technology/merge-sort-example.gif %}
	* *Example*: MergeSort. To explain why this is `O(n log n)` is a bit more complex.  In the below example of 8 numbers, we have 3 levels of sorting:
		* 4 list sorts when the list sizes are 2
		* 2 list sorts when the list sizes are 4
		* 1 list sort when the list size is 8
Now consider if I were to double the number of elements to 16: this would only require one more level of sorting. This is a `log n` scale. However, on each level of sorting a total of `n` operations takes place (look at the red boxes in the diagram above).  this results in `(n * log n)` operations.

* **O(n^2)/Polynomial or Quadratic Complexity**: 
	* Things are getting extra slow. 1 item takes 1 second, 10 items takes 100, 100 items takes 10000.
	* Example: Bubble Sort. If you need a reminder; we go through the list and compare each element with the one next to it, swapping the elements if they are out of order. At the end of the first iteration, we then start again from the beginning, with the caveat that we now know the last element is correct. 
* **O(2^n)/Exponential Growth**: 
	* The algorithm takes twice as long for every new element added.  1 item takes 1 second, 10 items takes 1024 seconds, 100 items takes 1267650600228229401496703205376 seconds.
	* Example: Take for example trying to find combinations; imagine a list of 150 people and to find every combination of groupings; everyone by themselves, all of the groups of 2 people, all of the groups of 3 people etc. Using a simple program which takes each person and loops through the combinations,  if I add one extra person then it’s going to increase the processing time exponentially. Every new element will double processing time.


* [Informal Introduction to BigO notation](http://www.perlmonks.org/?node_id=227909) 

## How to find Big-O in interviews?

Break down the loops and processing.

* Does it have to go through the entire list? There will be an `n` in there somewhere.
* Does the algorithms processing time increase at a slower rate than the size of the data set? Then there’s probably a `log n` in there.
* Are there nested loops? You’re probably looking at `n^2` or `n^3`.
* Is access time constant irrelevant of the size of the dataset?? `O(1)`

# General

* [Find second highest number in an array](https://gist.github.com/fizalihsan/5f6a3ff0621dda0314260ac819d453fa)

# Strings

* [Non repeated character detector](https://gist.github.com/fizalihsan/08ae8480d24ff7f2d43b7dd61168ceaa)
* [Reverse order of the words in a sentence](https://gist.github.com/fizalihsan/6b40241b406b6655c96b78d45a1c1195)
* [Remove given characters from the input string](https://gist.github.com/fizalihsan/66683c9433e06e84b357aecd8abc881e)
* [Convert decimal to binary, octal or hexadecimal or vice-versa](https://gist.github.com/fizalihsan/33672035611017483fe40f61df0d80c9)

# Linked List

* [Reverse a singly linked list](https://gist.github.com/fizalihsan/7486b574cefe11fe31c6da136b8bdb6b)

# Sorting

* Heap sort visualization - http://www2.hawaii.edu/~copley/665/HSApplet.html
* Sorting

# Searching

* Search types
	* exact search
	* range search
* Search algorithm types
	* Sequential
	* Direct access (hashing)
	* Tree indexing methods

* Binary Search
* Dictionary/Interlpolation Search
* Quadratic Binary Search

# Hashing

* Hashing Functions
	* Perfect hashing

* Collision Resolution Policy
	* Open Hashing/Separate Chaining
	* Closed Hashing / Open Addressing
		* Bucket Hashing
		* Linear Probing

**Cons**

* Not good for duplicate keys
* Not good for Range searches
* good only for in-memory and disk-based searching

* [Guide - An Extensive Examination of Data Structures Using C# 2.0](http://msdn.microsoft.com/en-US/library/ms379570(v=vs.80).aspx)
* [1](http://www.mpi-inf.mpg.de/~mehlhorn/Toolbox.html)
* [2](http://www.cs.auckland.ac.nz/software/AlgAnim/ds_ToC.html)

# Reference

* [Idiot's guide to BigO](http://www.corejavainterviewquestions.com/idiots-guide-big-o/)
* Books
	* Algorithms 4th Edition - Robert Sedgewick and Kevin Wayne
	* Algorithms in a Nutshell
	* ACE the programming interview