---
layout: page
title: "VCS"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Overview

* Difference between VCS and DVCS. 
* What is the advantage of having a distributed VCS?
  * no single point of failure in the event of a crash or corruption
* Principles and best practices when it comes to branching


# Git

* Distributed VCS developed by Linus Torvalds
* <span style="color:red">Why Git?</span>
* What is the advantage of having a staging area in Git?
* Git Vs SVN

## How Git works?

{% img /technology/git-local-remote.png %}

## Workflow models

* **SVN-style centralized workflow** 
  * A very common Git workflow, especially from people transitioning from a centralized system, is a centralized workflow. Git will not allow you to push if someone has pushed since the last time you fetched, so a centralized model where all developers push to the same server works just fine.
* **Integration Workflow**
  * a single person who commits to the 'blessed' repository, and then a number of developers who clone from that repository, push to their own independent repositories and ask the integrator to pull in their changes. This is the type of development model you often see with open source or GitHub repositories.
* **Dictator and Lieutenants Workflow**
  * For more massive projects, you can setup your developers similar to the way the Linux kernel is run, where people are in charge of a specific subsystem of the project ('lieutenants') and merge in all changes that have to do with that subsystem. Then another integrator (the 'dictator') can pull changes from only his/her lieutenants and push those to the 'blessed' repository that everyone then clones from again.


| Centralized workflow | Integration Workflow |
| -------------------- | -------------------- |
| {% img /technology/git-centralized-workflow.png %} | {% img /technology/git-integration-workflow.png %} |

## Advantages

* Distributed, not centralized: 
  * With Git, you have a local copy/clone of the entire repository which could be used offline. Due to this, there is no single point of failure in case of a crash or corruption. Every developer has his own copy of the repository. 
* Smaller & Faster - To save space and transfer time, the data is stored after applying compression.
* Branching and merging is easier
* Atomic transactions: Like SVN, transactions are atomic - ensures that the version control database is not left in a partially changed or corrupted state while an update or commit of number of unrelated changes is happening.
* Content-Addressable file store - SHA1 hash value is generated out of the file contents to identify a file.

## Basic concepts

* Checkout vs clone, Commit Vs Push
* Branching vs Forking
  * Branches are light-weight and merging is easy.
  * In SVN, each file & folder can come from a different revision or branch. This leads to confusion in case of a failure.
* Workflows
  * Unlike other VCS systems, Git does not impose any particular workflow.
  * Well-suited for open source community development. 
  * Git-SVN Bridge - The central repository is a Subversion repo, but developers locally work with Git and the bridge then pushes their changes to SVN.
* Clean command - what does it do?
* Bisect command - what does it do?
* Revision or version numbers
* Unlike SVN which creates .svn directories in every single folder, Git only creates a single .git folder.
* Stashing - ???
* Sparse checkouts.
* Git tracks content rather than file - renaming a file, moving it to a different location
* Command line, TortoiseGit, 
* version control outside of source code


https://git.wiki.kernel.org/index.php/GitSvnComparsion

## Advanced Concepts

### Content-Addressable Names

The Git object store is organized and implemented as a content-addressable storage system. Specifically, each object in the object store has a unique name produced by applying SHA1 to the contents of the object, yielding an SHA1 hash value. Because the complete contents of an object contribute to the hash value and the hash value is believed to be effectively unique to that particular content, the SHA1 hash is a sufficient index or name for that object in the object database. Any tiny change to a file causes the SHA1 hash to change, causing the new version of the file to be indexed separately. SHA1 values are 160-bit values that are usually represented as a 40-digit hexadecimal number, such as 9da581d910c9c4ac93557ca4859e767f5caf5169. Sometimes, during display, SHA1 values are abbreviated to a smaller, unique prefix. Git users speak of SHA1, hash code, and sometimes object ID interchangeably.

An important characteristic of the SHA1 hash computation is that it always computes the same ID for identical content, regardless of where that content is. In other words, the same file content in different directories and even on different machines yields the exact same SHA1 hash ID. Thus, the SHA1 hash ID of a file is an effective globally unique identifier. A powerful corollary is that files or blobs of arbitrary size can be compared for equality across the Internet by merely comparing their SHA1 identifiers.

### Pack files

Efficient file storage mechanism. If you were to just change or add one line to a file, Git might store the complete, newer version and then take note of the one line change as a delta and store that in the pack too.

The main points I like about DVCS are those :

You can commit broken things. It doesn't matter because other peoples won't see them until you publish. Publish time is different of commit time.
Because of this you can commit more often.
You can merge complete functionnality. This functionnality will have its own branch. All commits of this branch will be related to this functionnality. You can do it with a CVCS however with DVCS its the default.
You can search your history (find when a function changed )
You can undo a pull if someone screw up the main repository, you don't need to fix the errors. Just clear the merge.
When you need a source control in any directory do : git init . and you can commit, undoing changes, etc...
It's fast (even on Windows )