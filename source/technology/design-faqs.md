---
layout: page
title: "Design FAQs"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}


# Design a URL shortening service

* Store given url in a database assigning a unique interger id to it.
* convert the integer to character string that is at most 6 characters long. This problem can basically seen as a base conversion problem where we have a 10 digit input number and we want to convert it into a 6 character long string.
* The long url should also be uniquely identifiable from short url. So we need a [Bijective Function](http://en.wikipedia.org/wiki/Bijection). This is necessary so that you can find a inverse function *g('abc') = 123* for your *f(123) = 'abc'* function. This means:

	* There must be no *x1*, *x2* (with *x1 ≠ x2*) that will make *f(x1) = f(x2)*,
	* and for every *y* you must be able to find an *x* so that *f(x) = y*.

**How to convert an integer to a 6 character string**

A URL character can be one of the following

* 1) A lower case alphabet [‘a’ to ‘z’], total 26 characters
* 2) An upper case alphabet [‘A’ to ‘Z’], total 26 characters
* 3) A digit [‘0′ to ‘9’], total 10 characters

There are total 26 + 26 + 10 = 62 possible characters.

So the task is to convert a decimal number to base 62 number. [Check the base-62 conversion program in Github](https://github.com/fizalihsan/FunPrograms/blob/master/src/main/java/com/algos/numbers/BaseConversion.java)