---
layout: page
title: "Brain Teasers"
comments: false
sharing: false
footer: true
---

* list element with functor item
{:toc}


* **Bacteria in a bottle** - Bacteria multiples every minute.  You place a bacteria into an empty cup at 12.  By 1pm, it's full.  At what time was it half full?

*Solution* = 12:59pm

* **Poison Bottle & Rats** - There are 8 bottles and 3 rats. One bottle is poisoned. Once poisoned each rat has 5 minutes to live. Within 5 min, how can you use all 3 rats to figure out which bottle was poisoned. 

*Solution*

```
Bottle 7 - 1 1 1 - R1, R2, R3 rats drank off of this bottle
Bottle 6 - 1 1 0 - R1, R2 rats drank off of this bottle
Bottle 5 - 1 0 1 - R1, R3 rats drank off of this bottle
Bottle 4 - 1 0 0 - R1 rats drank off of this bottle 
Bottle 3 - 0 1 1 - R2, R3 rats drank off of this bottle
Bottle 2 - 0 1 0 - R2 rats drank off of this bottle
Bottle 1 - 0 0 1 - R3 rat drank off of this bottle
Bottle 0 - 0 0 0 - None drank off of this bottle
```

Now if Bottles 1-7 contain poison, then the killing of rats combination will tell us the answer. And If no rat gets killed, Bottle 0 has the poison.

* **Identify heavier ball out of 8** - One ball is slightly heavier out of 8 balls.  How many times do you need to use a scale to determine which is heavier?

*Solution* - 2 steps max
Break the balls into the following groups: (1,2,3),(4,5,6),(7,8)

Step 1: Weigh (1,2,3) against (4,5,6)

Case A: If both are equal, in step 2, compare 7 and 8
Case B: If one of (1,2,3) or (4,5,6), then in step 2, out of the heavier group, take 2 out of 3 and weigh again.

* **Light switch combination** - There are 10 light switches.  How many different combinations can you have of on/off?

*Solution*: 2 states: on and off. So, 2^10 combinations

* **** - There are 2 cars at a railroad track 100 miles apart.  Each car is moving at 10mph towards each other and there is a flying bird that flies back and forth at 20mph and turns around whenever it hits a car. How far did the car travel before it hit both trains?
