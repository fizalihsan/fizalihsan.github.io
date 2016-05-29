---
layout: page
title: "SDLC"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Build Automation Tools

## Gradle

### Dependency Management

* Dependency scope or Gradle Configuration
	* compile
	* testCompile
	* runtime
	* testRuntime
	* archives
	* default

New scopes/configurations could be introduced by plug-ins. E.g, 'groovy' plugin introduces 'groovy' configuration.

### Task Management
	
1. `task myTask //declaration only without configuration or action`
2. `task myTask { configure closure }`
3. `task myType << { task action }`
4. `task myTask(type: SomeType)`
5. `task myTask(type: SomeType) { configure closure }`

* How to create a simple task?

`task task1 << { println 'I'm a simple task}`

Executing `gradle task1` prints `Hello, world`

* How to create a simple task with additive blocks

``` groovy
	task task2 // task declaration only
	task2 << { println 'Hello,'}
	task2 << { println ' world'}
```

Executing `gradle -q task2` prints `Hello, world`

* How to create a simple task with configuration?

``` groovy
	task task3
	task3 << { println 'Hello,'}
	task3 << { println ' world'}
	task3 { println 'Closure with << is configuration for a task which is run during configuration lifecycle phase which runs before execution phase'}
```

Executing: `gradle -q task4` prints 

```
	Closure with << is configuration for a task which is run during configuration lifecycle phase which runs before execution phase
	:task3
	Hello, world
```

* How to create a simple task with additive configuration blocks?

``` groovy
	task task4
	task4 << { println 'Hello,'}
	task4 << { println ' world'}
	task4 { println 'Config1'}
	task4 { println 'Config2'}
```

Executing `gradle task4` prints

```
	Config1
	Config2
	:task4
	Hello,
	 world 
```

### Task dependencies

* If doFirst() and doLast() methods are defined in a task, then it is executed before and after the task execution.

``` groovy
	task task4
	task4 << { println 'world'}
	task4.doFirst { print 'Hello, '}
	task4.doFirst { println 'Good morning'} //repeated calls to doFirst() is additive
	task4.doLast {println 'Good bye'}
	task4.doLast {println 'Shutting down'} //repeated calls to doLast() is additive
```

Result: 

```	
	:task4
	Good morning
	Hello, world
	Good bye
	Shutting down
```

* Calling doFirst() and doLast() methods from configuration block

``` groovy
	task task4
	task4 << { println 'world'}
	task4 {
		doFirst {
			println 'Good morning'
			print 'Hello, '
		}
		doLast {
			println 'Good bye'
			println 'Shutting down'
		}
```

Result: 

```
	:task4
	Good morning
	Hello, world
	Good bye
	Shutting down
```

* How to disable a task? - `task4.enabled = false`
* How to find the path of a task?
	`task mytask << { println "Path of this task is ${path}" }`
	Results: `Prints Path of this task is :mytask`

# Continuous Integration
* Hudson / Jenkins
* TeamCity
* CruiseControl
* Ivy

# Code Analysis
* Emma
* Corbetura/Clover
* Fortify
* JDepend
* FindBugs
* SONAR

# Code Metrics

* Novel way to visualize whole project, package structure & lines of code - http://redotheweb.com/CodeFlower/
* Cyclomatic Complexity - 
  * http://www.onjava.com/lpt/a/4917
  * http://c2.com/cgi/wiki?CyclomaticComplexityMetric
  * http://www.guru99.com/cyclomatic-complexity.html



# Development Methodologies
http://en.wikipedia.org/wiki/List_of_software_development_philosophies

## Agile

## XP


## Scrum

* Product Backlogs
* Spring Backlogs
* 2 week sprints
* Meetings
	* Biweekly Sprint Planning
	* Daily Scrum calls (max 15 mins)
	* Sprint review meeting
	* Retrospectives (at the end of the sprint)
	* Backlog refinement (when needed)
* Roles
	* Product Owner
	* Scrum Master
	* Scrum Team
* Charts
	* Burndown chart @ sprint-level
	* Burndown chart @ release and product-level


## KanBan