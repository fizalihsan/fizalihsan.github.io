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

# Object-oriented Programming

* Each Python class definition has an implicit superclass: `object`
* The rules for the visibility of Python names are as follows:
	* Most names are public.
	* Names that start with `_` are somewhat less public. Use them for implementation details that are truly subject to change.
	* Names that begin and end with `__` are internal to Python.

## Naming Notations

* **Notations**
	* **Postfix notation** (object-oriented): `object.method()` or `object.attribute`.
	* **Prefix notation** (procedural programming): `function(object)`. The prefix notation `str(x)` is implemented as `x.__str__()` under the hood.
	* **Infix notation**: `object+other`. A construct such as `a+b` may be implemented as `a.__add__(b)` or `b.__radd__(a)` depending on the type of compatibility rules that were built into the class definitions for objects `a` and `b`.

## Categories

* **Attribute Access**: E.g., `object.attribute = value` or `del object.attribute`.
* **Callables**: This special method implements what we see as a function that is applied to arguments, much like the built-in `len()` function.
* **Collections**: These special methods implement the numerous features of collections. This involves methods such as `sequence[index]`, `mapping[key]`, and `set1|set2`.
* **Numbers**: These special methods provide arithmetic operators and comparison operators. We can use these methods to expand the domain of numbers that Python works with.
* **Contexts**: There are two special methods we'll use to implement a context manager that works with the `with` statement.
* **Iterators**: There are special methods that define an iterator. This isn't essential since generator functions handle this feature so elegantly.

## Special methods

* `__str__()` - The `print()` function will use `str()` to prepare an object for printing.
* `__repr__()`- The `format()` method of a string can also access these methods. When we use `%r` or `%s` formatting, we're requesting `__repr__()` or `__str__()`, respectively.
* `__hash__()` -
* `__bool__()` -
* `__bytes__()` -
* `__lt__()`, `__le__()`, `__eq__()`, `__ne__()`, `__gt__()`, and `__ge__()` -
* `__new__()` -
* `__del__()` -

# Others

* Exception handling
* What are these?
	* Jupyter

* How to read and understand Python docs
* How to print a tuple or list like this print("List = ", list)

# Notes

* Docstring. RST (ReStructured Text) markup.





# References

* Books
	* Learning Python the hard way
	* Think Python
	* Mastering object-oriented Python
