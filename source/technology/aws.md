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

# AWS Fundamentals

* **Cloud Computing - Deployment Models**
	* *All-in cloud-based application* is fully deployed in the cloud, with all components of the app running in the cloud
	* *Hybrid deployment* is a common approach taken by many enterprises that connects infrastructure and apps between cloud-based resources and existing resources, typically in an existing data center.
* **Global Infrastructure**
* **Accessing the platform**
	* via Amazon console
	* via CLI
	* via SDK

## Compute and Network Services

* **Amazon EC2** - provides resizeable compute capacity in the cloud
* **AWS Lambda** - a zero-administration compute platform for back-end web developers that runs your code for you on the AWS cloud (for high availability)
* **Auto Scaling** - allows to scale EC2 capacity up or down automatically according to conditions defined for the particular workload (for scaling in and out)
* **Elastic Load Balancing (ELB)** automatically distributes incoming application traffic across multiple EC2 instances. (for fault-tolerance)
* **AWS Elastic Beanstalk** - Developers can simply upload their application code, and the service automatically handles all the details, such as resource provisioning, load balancing, Auto scaling, and monitoring.
* **AWS Virtual Private Cloud (VPC)** provides a logically isolated section of the AWS cloud to launch resources in a virtual n/w. Organizations have complete control over the virtual env including the selection of the IP address range, creation of subnets, configuration of route tables, n/w gateways, etc. Orgs can extend their corporate data center n/w to AWS by using h/w or s/w VPN connections or dedicated circuits by using AWS Direct Connect.
* **AWS Direct Connect** allows organizations to establish a dedicated n/w connection from their data center to AWS.
* **Amazon Route 53** is a highly available and scalable DNS web service. Also serves as domain registrar, allowing you to purchase and manage domains directly from AWS

## Storage and Content Delivery Services

* **Simple Storage Service (S3)** provides highly durable and scalable object storage that handles virtually unlimited amounts of data. Use cases: backup and recovery, nearline archive, big data analytics, disaster recovery, cloud apps, content distribution
* **Amazon Glacier** - extremely low-cost storage service for data archiving and long-term backup. Optimized for infrequently accessed data where a retrieval time of several hours is suitable.
* **Amazon Elastic Block Store (EBS)** - persistent block-level storage volumes for use with EC2 instances. Each EBS volume is automatically replicated within its Availability Zone to protect from component failure, offering HA and durability.
* **AWS Storage Gateway** is a service connecting an on-premise s/w with cloud-based storage to provide seamless and secure integration. It provides low-latency performance by maintaining a cache of frequently accessed data on-premises while securely storing all of your data encrypted in S3 or Glacier.
* **Amazon CloudFront** is a content delivery web service - an easy way to distribute content with low-latency, high data transfer speeds - can be used to deliver websites including dynamic, static, streaming and interactive content, using a global network of edge locations. Request for content are automatically routed to the nearest edge location for best performance.

## Database service

* **Amazon DynamoDB** - document and key/value NoSQL DB service - single-digit millisecond latency at any scale
* **Amazon Redshift** - columnar DB - petabyte-scale data warehouse service to analyze structured data - by leveraging columnar storage technology it can run parallelized queries across multiple nodes
* **Amazon ElasticCache** - a web service that simplifies scaling of an in-memory cache in the cloud - supports Memcached and Redis cache engines

## Management Tools

* **Amazon CloudWatch** - monitoring service for AWS cloud resources and the applications running on AWS
* **AWS CloudFormation** - defines a JSON-based templating language that can be used to describe all the AWS resources needed for a workload. When templates are submitted to the AWS CloudFormation, it will take care of provisioning and configuring those resources in appropriate order
* **AWS CloudTrail** - a web service that records AWS API calls for an account and delivers log files for audit and review.
* **AWS Config** - With this, one can export an inventory of their AWS resources with all configuration details, and determine how a resource was configured at any point in time - enables compliance auditing, security analysis, resource change tracking, and troubleshooting.

## Security and Identity

* **AWS Identity and Access Manager (IAM)** - enables organizations to create and manage AWS users and groups and use permissions to allow and deny their access to AWS resources.
* **AWS Key Management Service (KMS)** - enables organizations to create and control the encryption keys used to encrypt their data and uses Hardware Security Modules (HSM) to protect the security of the keys.
* **AWS Directory Service** - allows organizations to set up and run Microsoft Active Directory on the AWS cloud or connect their AWS resources with an existing on-premises Microsoft Active Directory.
* **AWS Certificate Manager** is a service that lets organizations easily provision, manage and deploy SSL/TLS certificates for use with AWS cloud services. It removes the time-consuming manual process of purchasing, uploading and renewing certificates - enables to quickly request a certificate, deploy it on AWS and let AWS Certificate Manager handle certificate renewals
* **AWS Web Application Firewall (WAF)** helps protect web apps from common attacks

## Application Services

* **Amazon API Gateway** - a fully managed service that makes it easy to create, publish, maintain, monitor and secure APIs at any scale - handles all the tasks involved in accepting and processing up to hundreds of thousands of concurrent API calls, including traffic management, monitoring, authorization and access control, API version management.
* **Amazon Elastic Transcoder** - media transcoder that converts media files from their source formats into versions that will play back on specific devices
* **Amazon Simple Notification Service (SNS)** is a web service that coordinates and manages the delivery of messages to recipients.
* **Amazon Simple Email Service (SES)**
* **Amazon Simple Workflow Service (SWF)** - helps build, run and scale background jobs that have parallel or sequential steps - has fully managed state tracker and task coordinator on the cloud - provides ability to recover or retry if a task fails.
* **Amazon Simple Queue Service (SQS)** - managed message queueing service

# EC2 (Elastic Compute Cloud)

## ELB (Elastic Load Balancer)

* A software load balance that is an integral part of building a fault tolerant, highly available system

## Elastic Beanstalk

* Allows you to quickly deploy and manage applications without having to worry about the underlying infrastructure

## Auto Scaling Groups

* Enables you to scale your instances based on load, time of day or a pre-defined schedule

# S3 (Simple Storage Service)

* File storage using buckets (like drives) and folders
* Scalable storage in the cloud
* Cheap and easy to use
* **Buckets**
	* Bucket-level permissioning - existing permissioning policies can be copied or generated using 'Bucket policy generator'
	* **ARNs (Amazon Resource Name)** uniquely identify AWS resources. (http://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html)
		* Object in an Amazon S3 bucket `arn:aws:s3:::my_corporate_bucket/exampleobject.png`
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
