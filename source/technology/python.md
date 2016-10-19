---
layout: page
title: "Python"
comments: false
sharing: false
footer: false
---

* list element with functor item
{:toc}

# Basics

* Semi-compiled to byte-code, executed by interpreter
* Type is associated with objects, not variables - dynamically typed?
* Python runtimes:Cython, Jython, IronPython, PyPy
* PEP 8: Python Enhancement Proposal #8

# Data types

## String

* In Python 2, a sequence of characters can be represented as
	* `str` - raw 8-bit values
	* `unicode` - unicode characters
* In Python 3, it is
	* `bytes` - raw 8-bit values
	* `str` - unicode characters

## List

### List Comprehension

* Python provides a compact syntax for deriving one list from another called *list comprehension*

```python
a =[1, 2, 3, 4]
squares = [x**2 for x in a]
print squares # [1, 4, 9, 16]
```

* Cons
	* More than 2 expressions in list comprehension becomes unreadable
	* Not scalable.

### Generator Expression

For example, say you want to read a file and return the number of characters on each line. Doing this with list comprehension would require holding the length of every line of the file in memory.

To solve this, Python provides ***generator expressions***, a generalization of list comprehensions and generators. Generator expressions don't materialize the whole output sequence when they're run. Instead, generator expressions evaluate to an iterator that yields one item at a time from the expression.

## Dict

### Dict Comprehension

## Set

### Set Comprehension

# Utilities

## Slicing

```python
a = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
a[:]      # ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
a[:5]     # ['a', 'b', 'c', 'd', 'e']
a[:-1]    # ['a', 'b', 'c', 'd', 'e', 'f', 'g']
a[4:]     # ['e', 'f', 'g', 'h']
a[-3:]    # ['f', 'g', 'h']
a[2:5]    # ['c', 'd', 'e']
a[2:-1]   # ['c', 'd', 'e', 'f', 'g']
a[-3:-1]  # ['f', 'g']
```
## Striding

Python has special syntax for the stride of a slice in the form `somelist[start:end:stride]`. This lets you take every nth item when slicing a sequence.

```python
a = ['red', 'orange', 'yellow', 'green', 'blue', 'purple']
odds = a[::2]
evens = a[1::2]
print(odds) # ['red', 'yellow', 'blue']
print(evens) # ['orange', 'green', 'purple']
```

The problem is that the stride syntax often causes unexpected behavior that can introduce bugs. For example, a common Python trick for reversing a byte string is to slice the string with a stride of -1.

## Zip

# Functions



# Modules

## itertools

## collections


# Others

* Exception handling
* What are these?
	* Jupyter

* How to read and understand Python docs
* How to print a tuple or list like this print("List = ", list)

* Performance: Python vs Java
