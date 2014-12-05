---
layout: page
title: "Operating Systems"
comments: false
sharing: false
footer: true
---

* list element with functor item
{:toc}

# UNIX

## Frequently used commands

* Find and copy files created today
`find /home/clstest -ctime -1 -exec cp {} /home/mohammo/CSW \;`
* Suppress error message from 'find' command
`find . -name "*" -print 2>/dev/null`
* Tar & untar directories with permissions intact
```
tar -cvpf test.tar /home/mohammo/test
tar -xvpf test.tar /home/mohammo/test
```
* Exclude certain files in 'find' command
```
find . -name "*" -not -name "*.jar" -print
find . -name "*" -not \( -name "*.jar" -o -name "*.tar" \) -print
```
* Search and replace with no hassle of escaping characters
`echo "/home/mohammo" | sed -e "s#/home/mohammo#/home/test#/g"`
* Search for text but only display their file names
`find . -name "*" -type f -exec grep -l "searchtext" {} \; -print`
* Set operations - Complement (A-B)- below command prints all entries in file1 that are not in file2
`comm -23 file1 file2`
* Sorting files
```
 sort file1 file2 | uniq  //Union of unsorted files 
 sort file1 file2 | uniq -d  //Intersection of unsorted files 
 sort file1 file1 file2 | uniq -u //Difference of unsorted files 
 sort file1 file2 | uniq -u  //Symmetric Difference of unsorted files 
```
* When a JVM process is running in Unix/Windows, how do I check how much memory is being currently used by that JVM?

## VI Tips

> Note: Anything between [ and ] denotes a command executed from within vi.

* `[ !wc % ]` - opens a command shell and runs 'wc' on the current file open in vi. `%` means current file & `!` is called 'Bang'. Bang works best with non-interactive commands
* `[ qa ]` close all files open
* `[ ga ]` Show character info 
* `[ ls ]` List buffers
* `[ % ]` Bracket matching
