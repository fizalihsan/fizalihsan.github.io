---
layout: page
title: "R Programming"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

## Data Types

### Basic Data Types
R has five basic or “atomic” classes of objects:

1. **character**
* **numeric** (real numbers) 
  * Numbers in R as numeric objects by default. (*Double precision real numbers*)
  * `Inf` represents infinity. 
  * `NA` & `NaN` represents an undefined value and not a number.
    * `is.na()` and `is.nan()` are used to test objects.
    * `NA` values have a class also, so there are integer `NA`, character `NA`, etc.
    * A `NaN` value is also `NA` but the converse is not true.
  * Attributes of an object like length and other metadata can be access using the `attributes()` function.
* **integer** -
 `1` is a numeric object. `1L` is an integer.
* **complex**
* **logical** (True/False)

### Complex Data Types

#### Vectors
The most basic object is a vector. 
*  A vector can only contain objects of the same class.
* BUT: The one exception is a list, which is represented as a vector but can contain objects of
different classes (indeed, that’s usually why we use them)
* Empty vectors can be created with the `vector()` function.
* Vector examples

```
> x <- c(0.5, 0.6) ## numeric
> x <- c(TRUE, FALSE) ## logical
> x <- c(T, F) ## logical
> x <- c("a", "b", "c") ## character
> x <- 9:29 ## integer
> x <- c(1+0i, 2+4i) ## complex
```

* Lists are a special type of vector that can contain elements of different classes.

```
> x <- list(1, "a", TRUE, 1 + 4i) 
> # mixed types allowed, lists are recursive, lists are vectors
> alist <- list(c("a", "b", "c"), c(1,2,3,4), c(8e6, 5.2e9, -9.3e7))
> alist[[1]] # return one column
> alist[1] # extracts a list
> alist[[3:2]] # gets 2nd element from 3rd vector of the list (5.2e9)
> is.list(alist) #TRUE
> is.vector(alist) #TRUE
```

* **Mixing Objects**  
When different objects are mixed in a vector, *coercion* occurs so that every element in the vector is
of the same class.

```
> y <- c(1.7, "a") ## character
> y <- c(TRUE, 2) ## numeric
> y <- c("a", TRUE) ## character
```

* **Explicit Coercion**  
Objects can be explicitly coerced from one class to another using the `as.*()` functions, if available.

```
> x <- 0:6
> class(x)
[1] "integer"
> as.numeric(x)
[1] 0 1 2 3 4 5 6
> as.logical(x)
[1] FALSE TRUE TRUE TRUE TRUE TRUE TRUE
> as.character(x)
[1] "0" "1" "2" "3" "4" "5" "6"
```

* **Nonsensical coercion results in NAs**

```
> x <- c("a", "b", "c")
> as.numeric(x)
[1] NA NA NA
Warning message:
NAs introduced by coercion
> as.logical(x)
[1] NA NA NA
> as.complex(x)
[1] 0+0i 1+0i 2+0i 3+0i 4+0i 5+0i 6+0i

```

* **Matrices**
Matrices are vectors with a *dimension* attribute. The dimension attribute is itself an integer vector of
length 2 (nrow, ncol).

```
> m <- matrix(nrow = 2, ncol = 3) 
> m
 [,1] [,2] [,3]
[1,] NA NA NA
[2,] NA NA NA
> dim(m)
[1] 2 3
> attributes(m)
$dim
[1] 2 3
```

* **cbind-ing and rbind-ing**
Matrices can be created by column-binding or row-binding with `cbind()` and `rbind()`.

```
> x <- 1:3
> y <- 10:12
> cbind(x, y)
 x y 
[1,] 1 10
[2,] 2 11
[3,] 3 12
> rbind(x, y) 
 [,1] [,2] [,3]
x 1 2 3
y 10 11 12
```

#### Factors
* Factors are nothing but enumeration data types used to represent categorical data.
* Can be ordered or unordered.
* Factor can be thought of as an integer vector where each integer has a *label*. 

```
> x <- factor(c("yes", "yes", "no", "yes", "no")) 
> x
[1] yes yes no yes no
Levels: no yes
> table(x) 
x
no yes 
2 3
> unclass(x)
[1] 2 2 1 2 1
attr(,"levels")
[1] "no" "yes"
```


#### Data Frames
* A special type of list where every list is of same length.
* All columns in data frame must have names
* * Unlike matrices, data frames can store different classes of objects in each column.
* To create - `read.table()` or `read.csv()`
* To convert to a matrix - `data.matrix()`

```
> read.table() # space is the default delimiter
> read.csv() # by default expects a file header
> read.csv2()
> read.delim()
> read.delim2()
> x <- data.frame(foo = 1:4, bar = c(T, T, F, F)) 
> x
 foo bar
1 1 TRUE
2 2 TRUE
3 3 FALSE
4 4 FALSE
> nrow(x)
[1] 4
> ncol(x)
[1] 2
```

* `data.frame()` # create data frame or table e.g., `test.data.frame<-data.frame(id=c(1,2,3,4,5),name=c("a","b","c","d","e"))`
* `edit(framename)` # edit the content of the table
* `str(frame)` # prints the structure and data types of the data frame
* `names(framename)` – prints the column names
* `dataframe[index.ROW, index.COLUMN]`
* `dataframe[[1]]` # returns the first column as a vector
* `dataframe[1]` # returns the first column wrapped in a data frame
* `dataframe[c(1,3)]` # returns the 1st and 3rd column wrapped in a data frame
* `dataframe[1:3,]` # displays all columns but first 1-3 rows only
* `is.data.frame(framename)` #checks if an object is a data frame


## Basics Statistic Functions
*	`mean(x)` # x is a vector
*	`median(x)`
*	`sd(x)`
*	`var(x)`
*	`cor(x,y)`
*	`cov(x,y)`
*	`lapply(dataframe, function)` # Apply function like mean/median over a list/dataframe

## Graphs
*	`plot(x,y)` # Scatter plot. Only numeric vectors or dataframes are allowed.
*	`barplot()` - Bar Chart
*	`boxplot()` - Box Plot. Provides a quick visual summary of a dataset. Thick line in middle is the median. Box identifies the 1st(bottom) and 3rd(top) quartiles.
* `hist(x)` -	Histogram. Groups data into bins


##Appendix

###Command Reference 
* `ls()` or `ls(all.names = TRUE)` # Lists all variables/objects defined in the * session
* `setwd(“c:/xyz”)` # sets working directory
* `getwd()` # Gets working directory
* `runif(8)` # generates 8 random numbers
* `x <- 9` # assigns 9 to object x in workspace
* `x` # prints the value of x
* `rm(x)` # removes the object x
* `rm(list=ls())` # removes all objects in workspace
* Save & Load (Binary)
  * `save()` # saves all objects to default file .RData. Objects still exist in * `memory` (binary format)
  * `save(obj1, obj2, file=”filename”)`
  * `load(“filename”)` # loads from file to memory
* Save & Load (Text)
  * `write.table(obj1, file=”filename”)` # only 1 obj at a time
  * `load.table()`

###Packages
* `install.packages(c("ggplot2", "devtools", "KernSmooth")` # install the collection of packages from CRAN
* `library()`        #list all available packages
* `library(package)` # loads package on to memory
* `require(package)` # loads package on to memory. Used in scripts. Returns loading status as boolean.
* `detach(package:name)` # unloads package from memory.

###Help 
* `?func`           # open help page on function 'func'
* `help(func)`      # same as above
* `apropos("foo")`  # list all functions containing string foo
* `example(foo)`    # show an example of function foo
* `vignette()`      # show available vignettes on installed packages
* `vignette("foo")` # show specific vignette
		

# Bibliography

* R Inferno
* Software for Data Analysis - Programming with R (http://www.springer.com/statistics/computational+statistics/book/978-0-387-75935-7)
* The R book (http://www.wiley.com/WileyCDA/WileyTitle/productCd-0470973927.html)
* The Art of R Programming 
* R in Action
* Ref Cards
  * http://cran.r-project.org/doc/contrib/Short-refcard.pdf
  * http://www.statmethods.net/interface/help.html
* Tutorials
  * http://www.johndcook.com/R_language_for_programmers.html
  * http://cran.r-project.org/doc/manuals/R-intro.pdf
  * http://www.decisionsciencenews.com/?p=261
  * http://www.r-tutor.com/r-introduction/data-frame
  * http://tryr.codeschool.com/levels/2/challenges/1
