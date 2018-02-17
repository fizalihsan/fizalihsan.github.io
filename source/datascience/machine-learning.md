---
layout: page
title: "Machine Learning"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}



# Types of Machines Learning

* __Predictive or supervised learning__
	* the goal is to learn a mapping from inputs `x` to outputs `y`, given a labeled set of input-output pairs $ D = \\{ (x _{i}, y _{i}) \\} _{i=1}^N $. 
	* Here D is called the ***training set***, and `N` is the number of training examples.
	* In the simplest setting, each training input $x _{i}$ is a D-dimensional vector of numbers, representing, say, the height and weight of a person. These are called ***features, attributes or covariates***. 
	* In general, $x _{i}$ could be a complex structured object, such as an image, a sentence, an email message, a time series, a molecular shape, a graph, etc.
	* Similarly the form of the **output or response variable** can be anything.
		* When $y _{i}$ is a categorical or nominal variable from some finite set, $y _{i}$ ∈ {1, . . . , C} (such as male or female), the problem is known as **classification or pattern recognition**.
			* Document classification - e.g., email spam filtering, ad targeting
			* Image classification - e.g., photo is vertical or horizontal, detect the person in picture is male/female, face detection in Google street view
		* When $y _{i}$ is a real-valued scalar (such as income level) or continuous, the problem is known as **regression**. *Ordinal regression* occurs where label space Y has some natural ordering, such as grades A–F.
			* Predict tomorrow’s stock market price given current market conditions and other possible side information.
			* Predict the age of a viewer watching a given video on YouTube.
			
* __Descriptive or unsupervised learning__
	* Here we are only given inputs, $ D = \\{ (x _{i}) \\} _{i=1}^N $, and the goal is to find “interesting patterns” in the data. This is sometimes called __knowledge discovery__. 
	* This is a much less well-defined problem, since we are not told what kinds of patterns to look for, and there is no obvious error metric to use (unlike supervised learning, where we can compare our prediction of y for a given x to the observed value).
	* Discovering clusters
		* e.g., In e-commerce, it is common to cluster users into groups, based on their purchasing or web-surfing behavior, and then to send customized targeted advertising to each group
	* Discovering graph structure
		* Sometimes we measure a set of correlated variables, and we would like to discover which ones are most correlated with which others. This can be represented by a graph G, in which nodes represent variables, and edges represent direct dependence between variables. 
		* e.g., predicting traffic jams in freeway
	* Matrix completion
		* Sometimes we have missing data, that is, variables whose values are unknown. For example, we might have conducted a survey, and some people might not have answered certain questions. Or we might have various sensors, some of which fail. The corresponding design matrix will then have “holes” in it; these missing entries are often represented by NaN, which stands for “not a number”. The goal of imputation is to infer plausible values for the missing entries. This is sometimes called matrix completion. 
		* Image inpainting - The goal is to “fill in” holes (e.g., due to scratches or occlusions) in an image with realistic texture.
		* Collaborative filtering - Netflix predicting which movies a user is likely to watch based on his past view history.
	
* __Reinforcement Learning__
	* is somewhat less commonly used. This is useful for learning how to act or behave when given occasional reward or punishment signals. (For example, consider how a baby learns to walk.) 


# Algorithms

* 

# Taxonomy class

* Decision tree
* Kernel

# Data set

* [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/index.php)

# Tools

* [Weka UI](https://www.cs.waikato.ac.nz/ml/weka/downloading.html)
* R
* Scikit-learn

# Questions

* What is targeted practice?
* Univariate probability model

# References

* http://www.cs.ubc.ca/~murphyk/MLbook/pml-intro-22may12.pdf