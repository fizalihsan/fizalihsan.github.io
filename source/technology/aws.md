---
layout: page
title: "Amazon AWS"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Overview

* Data size and solution
	* Small - RDBMS
	* Medium - NoSQL
	* Large/Huge - Hadoop ecosystem
	* Complex - NewSQL
* Data storage Types
	* Warm storage
		* S3
	* Cold storage
		* Glacier
  * EC2 storage
    * Single - EBS (Elastic Block Storage)
    * Multiple - EFS (Elastic File Storage)
* CDN - Amazon CloudFront
* Regions & Availability Zones
  * Geographic proximity to your users
  * Regional affinity
  * www.cloudping.info - to estimate the latency from your browser to each AWS region
  * Availability zones are like data centers. Each AWS region has at least 2 availability zones. e.g.,



# S3 (Simple Storage Service)

* File storage using buckets (like drives) and folders
* Scalable storage in the cloud
* Cheap and easy to use
* **Buckets**
	* Bucket-level permissioning - existing permissioning policies can be copied or generated using 'Bucket policy generator'
	* **ARNs (Amazon Resource Name)** uniquely identify AWS resources. (http://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html)

```
  	<!-- Object in an Amazon S3 bucket -->
		arn:aws:s3:::my_corporate_bucket/exampleobject.png
```

* General formats
  * `arn:partition:service:region:account-id:resource`
  * `arn:partition:service:region:account-id:resourcetype/resource`
  * `arn:partition:service:region:account-id:resourcetype:resource`


# Terminology

* Fault tolerance, High availability
* Data at Rest - EBS, S3, RDS
* Data at Transit - (in reference to encryption and security)
* Network perimeter - a boundary between two or more portions of a network. It can refer to the boundary between your VPC and your network, it could refer to the boundary between what you manage versus what AWS manages.
* WAF (Web Application Firewall)
* NAT (Network Address Translation)

# References

* CloudAcademy.com
  * [AWS Technical Foundation 110](https://cloudacademy.com/amazon-web-services/aws-technical-fundamentals-aws-110-course)
  * AWS Technical Foundation 120
  * AWS Technical Foundation 140
  * AWS Technical Foundation 160
  * AWS Technical Foundation 180
  * AWS Technical Foundation 190
  * [Foundations for Solutions Architect Associate on AWS course](https://cloudacademy.com/amazon-web-services/foundations-for-solutions-architect-associate-on-aws-course/)
