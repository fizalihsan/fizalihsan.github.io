---
layout: page
title: "Amazon AWS"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

{% img /technology/aws-services.png %}

# AWS Fundamentals

* **Cloud Computing - Deployment Models**
	* *All-in cloud-based application* is fully deployed in the cloud, with all components of the app running in the cloud
	* *Hybrid deployment* is a common approach taken by many enterprises that connects infrastructure and apps between cloud-based resources and existing resources, typically in an existing data center.

{% img right /technology/aws-regions-availability-zones.jpg %}

* **Global Infrastructure**
	* Each *region* is a separate geographic area.
	* Each region has multiple, isolated locations known as *Availability Zones*.
	* Resources aren't replicated across regions unless organizations choose to do so.
	* For fault tolerance and stability, each region is completely isolated from each other.
	* Each Availability Zone is also isolated, but they are connected through low-latency links.
	* Each Availability Zone is located in lower-risk flood plains using a discrete UPS and on-site backup generators. They are each fed via different grids from independent utilities to reduce single points of failures further.
	* Organizations retain complete control and ownership over the region in which their data is physically located, allowed them to meet regional compliance and data residency requirements.
  * www.cloudping.info - to estimate the latency from your browser to each AWS region

* **Accessing the platform**
	* via Amazon console
	* via CLI
	* via SDK

---

# Storage and Content Delivery Service

## Storage Basics

* **Traditional Storage Types**
	* ***Block storage***:
		* operates at low-level - the raw storage device level - and manages data as a set of numbered, fixed-size blocks
		* accessed over a network in the form of a *Storage Area Network (SAN)* using protocols such as iSCSI or Fiber channel
		* very closely associated with the server and the OS
		* E.g., Amazon Elastic Block Storage (EBS)
	* ***File storage***:
		* operates at higher-level - the operating system level - and manages data as a named hierarchy of files and folders
		* accessed over a network as a *Network Attached Storage (NAS)* file server or "filer" using protocols such as *Common Internet File System (CIFS)* or *Network File System (NFS)*
		* very closely associated with the server and the OS
		* E.g., AWS Elastic File System (EFS)
* Cloud Storage
	* ***Object storage***
		* Independent of a server and is accessed over the Internet.
		* Instead of managing data as blocks or files using SCSI, CIFS or NFS protocols, data is managed as objects using REST API
		* E.g., Amazon S3

## S3 (Simple Storage Service)

### S3 Overview

* S3 is a highly-durable and highly-scalable cloud object store
* By default, every object is world-readable
* Scalability: S3 automatically partitions buckets to support very high request rates and simultaneous access by many clients

### S3 Buckets

* Buckets are a simple flat folder with no file system hierarchy.
* Limitations
	* It cannot have a sub-bucket within a bucket.
	* Bucket name: max 63 lowercase letters, numbers, hyphens and periods
	* Each bucket can hold an unlimited number of objects.
	* Max 100 buckets per account.

### S3 Objects

* Objects reside in containers called *buckets*
* An object can virtually store any kind of data in any formats
* Max object size = 5TB
* Each object has
	* data (the file itself)
	* metadata - set of name/value pairs
		* *System metadata* - created and used by Amazon S3. e.g., last modified date, MD5, object size, etc
		* *User metadata* - optional
* **Object Key**
	* Each object is identified by a unique *key* (similar to a file name).
	* Combination of `bucket + key + optional version ID` uniquely identifies an S3 object
	* Limitations
		* Max 1024 bytes of UTF-8 characters (including slashes, backslashes, dots, dashes)
		* Keys must be unique within a single bucket
* You cannot incrementally update portions of the object as you would with a file
* **ARNs (Amazon Resource Name)** uniquely identify AWS resources. (http://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html)
	* Object in an Amazon S3 bucket `arn:aws:s3:::my_bucket/exampleobject.png`
	* General formats
	  * `arn:partition:service:region:account-id:resource`
	  * `arn:partition:service:region:account-id:resourcetype/resource`
	  * `arn:partition:service:region:account-id:resourcetype:resource`

### S3 Durability & Availability

* *Durability*
	* answers the question *will my data still be there in the future?*
	* S3 provides 99.999999999% durability - meaning for 10K objects stored, you can on average expect to incur a loss of 1 object every 10,000,000 years
	* Durability achieved by
		* automatically storing data redundantly on multiple devices in multiple facilities within a region.
		* design to sustain concurrent loss of data in 2 facilities without loss of user data
		* highly durable infrastructure
* *Availability*
	* answers the question *can I access my data right now?*
	* S3 provides 99.99% availability
	* S3 is an *eventually consistent* system
		* S3 offers *read-after-write* consistency for `PUT`s to new objects
		* `PUT`s to existing objects and `DELETE`s are offered at *eventual consistency*
		* Updates to a single key are atomic - for eventual-consistency reads, you will get the new data or the old data, but never an inconsistent mix of data.

### S3 Storage Classes

* *Hot* - frequently accessed data
* *Warm* - less frequently accessed data as it ages
* *Cold* - long-term backup or archive data before eventual deletion

|  | **S3 Standard** | **S3 Standard - Infrequent Access (IA)** | **Reduced Redundancy Storage (RRS)** | **Amazon Glacier** |
| - | - | - | - | - |
| Well-suited for | short-term or long-term storage of frequently accessed data | long-lived, less frequently accessed data that is stored for longer than 30 days | derived data that can be easily reproduced (e.g., thumbnails) | data that does not require real-time access, such as archives and long-term backups,<br>where a retrieval time of several hours is suitable |
| Offers | high durability (99.999999999%),<br>high availability,<br>high performance,<br>first low-byte latency,<br>high throughput | same durability,<br>low latency,<br>high throughput | slightly lower durability (99.9999%) | secure,<br>high durability (99.999999999%)
| Cost | | Has lower per GB-month cost than Standard<br>Price model also includes a minimum object size (128KB), minimum duration (30 days), and per-GB retrieval costs.  | Reduced cost than Standard or Standard-IA | Extremely low-cost |

* Reduce storage costs by automatically transitioning data from one storage class to another or eventually deleting data after a period of time. For example,
	* Store backup data initially in S3 Standard
	* After 30 days, move to Standard-IA
	* After 90 days, transition to Glacier,
	* After 3 years, delete
* Lifecycle configurations are attached to bucket or specific objects

### S3 Data Protection

* Bucket-level permissioning - existing permissioning policies can be copied or generated using 'Bucket policy generator'
* By default, all S3 objects and buckets are private and can only be accessed by the owner.
* **Access Control**
	* *Coarse-grained access controls*
		* **S3 Access Control Lists (ACLs)**
			* legacy mechanism, created before IAM
			* Limited to read, write, or full-control at object/bucket level
			* Best used for enabling bucket logging or making a bucket that hosts a static website be readable
	* *Fine-grained access controls*
		* **S3 bucket policies**
			* Recommended access control mechanism
			* Can specify
				* who can access the bucket
				* from where (by *Classless Inter-Domain Routing (CIDR)* block or IP address)
				* at what time of the day
			* Bucket policies allows to assign cross-account access to S3 resources
			* Similar to IAM but
				* associated with bucket resource instead of an IAM principal
				* includes an explicit reference to the IAM principal in the policy. This principal can be associated with a different AWS account
		* AWS Identity and Access Management (IAM) policies
		* Query String Authentication
* **Encryption**
	* Encrypt data in-flight
		* Transmit data using HTTPS protocol to SSL API endpoints
	* Encrypt data at rest
		* ***Server-Side Encryption (SSE)***
			* S3 encrypts data at the object level as it writes it to disks and decrypts it for you when you access it
			* *SSE-S3 (AWS Managed Keys)*
				* AWS handles the key management and key protection
				* Every object is encrypted with a unique key
				* The object encryption key is then encrypted using a separate master key
				* A new master key is issued at least monthly with AWS rotating the keys.
				* Encrypted data, keys and master keys are all stored separately on secure hosts
			* *SSE-KMS (AWS KMS Keys)*
				* AWS handles management and protection of *your* key
				* SSE-KMS offers additional benefits
					* provides audit of who used the key to access, which object, when.
					* Allows to view failed attempts to access data from users who did not have permissions
			* *SSE-C (Customer Provided Keys)*
				* You maintain your own encryption keys, but don't want to manage or implement your own client-side encryption library
				* AWS will do the encryption/decryption of your objects while you maintain full control of the keys
		* ***Client-Side Encryption (CSE)***
			* You encrypt the data before sending it to S3
			* 2 options for using data encryption keys
			 	* Use an AWS KMS-managed customer master key
				* Use a client-side master key
* **Versioning**
	* If an object is accidentally changed/deleted, one can restore the object to its original state by referencing the version ID in addition to the bucket and object key
	* Versioning is turned on at the bucket level. Once enabled, versioning cannot be removed from a bucket; it can only be suspended.
* **Multi-Factor Authentication (MFA) Delete**
	* requires additional authentication in order to permanently delete an object version or change the versioning state of a bucket.
	* MFA delete can only be enabled by the root account
* **Pre-Signed URLs**
	* All S3 objects are by default private.
	* Owner can share objects with others by creating *pre-signed URL*, using their own security credentials to grant time-limited permission to download the objects.
	* To create a *pre-signed URL*, you must provide: your security credentials, bucket name, object key, the HTTP method (GET for download) and an expiration date and time.
	* Useful to protect against 'content scraping' of web content such as media files stored in S3

### Advanced Topics

* *Multipart Upload*
	* To support uploading/copying large objects
	* Allows to pause and resume. Has ability to upload objects where the size is initially unknown
	* Object size > 100 MB - you *should* use multipart upload
	* Object size > 5 GB - you *must* use multipart upload
	* Using high-level APIs and high-level S3 command in CLI (`aws s3 cp`, `aws s3 mv`, `aws s3 sync`), multipart upload is automatically performed for large objects
	* Using low-level APIs, you must break the file into parts and keep track of the parts.
	* If a multipart upload is incomplete after specified number of days, you can set an object lifecycle policy on a bucket to abort to minimize the storage costs.
* *Range GETs*
	* is used to download (GET) only a portion of an object in S3 or Glacier.
* *Cross-Region Replication*
	* allows to asynchronously replicate all *new* objects from one region to another.
	* Metadata and ACLs of the object also is replicated.
	* Only new objects are replicated. Existing objects must be copied via a separate command.
	* To enable *Cross-Region Replication*, versioning must be turned-on in both source and target buckets.
	* An IAM policy must be used to give S3 permission to replicate objects on your behalf.
	* Commonly used to reduce the latency to access objects by placing them closer to a set of users or store backup data at a certain distance from the original source data
* *Logging*
	* Logging is off by default. While enabling, you must choose the bucket where the logs will be stored.
* *Event Notifications*
	* Set up at bucket level to notify when an object is created, removed or lost in RRS
	* Notification messages can be sent to Amazon SQS or Amazon SNS or AWS Lambda

## Amazon Glacier

* Extremely low-cost storage service for data archiving and long-term backup. Optimized for infrequently accessed data where a retrieval time of several hours is suitable.
* To retrieve an object, issue a restore command using S3 API; 3 to 5 hours later, it is copied to S3 RRS. Restore simply creates a copy; the original data is retained in Glacier until explicitly deleted.
* **Archives**
	* Data is stored in *archives*
	* Max 40 TB of data per archive
	* Unlimited archives can be created
	* Each archive is assigned a unique archive ID at the creation time
	* Archives are automatically encrypted
	* Archives are immutable
* **Vaults**
	* Vaults are containers for archives.
	* Max 1000 vaults per account
	* Control access to vaults using IAM policies or vault access policies
	* *Vault lock policy*: can specify controls such as Write Once Read Many (WORM) in a vault local policy to lock the policy from future edits.
	* Retrieving up to 5% of stored data is free per month.

## Amazon Elastic Block Store (EBS)

{% img right /technology/aws-ebs.PNG 200 200 %}

* Persistent block-level storage volumes for use with EC2 instances. Each EBS volume is automatically replicated within its Availability Zone to protect from component failure, offering HA and durability.
* Each EBS volume is automatically replicated within its Availability Zone
* Each EBS volume can be attached to a single EC2 instances
* A single EC2 instance can be attached to one or more EBS volumes

### EBS Volume Types

|                | **Magnetic Volume** | **General-Purpose SSD** | **Provisioned IOPS SSD** | **Throughput-Optimized HDD Volumes** | **Cold HDD Volumes** |
| :------------- | :------------- | :------------- | :------------- | :------------- | :------------- |
| **Use Cases** |Workloads where data is accessed infrequently, Sequential reads, Situations where low-cost storage is a requirement  | System boot volumes, Virtual Desktops, small-to-medium size databases, Dev to Test environments | I/O intensive workloads, particularly large database workloads,<br>Critical business apps that require sustained IOPS performance or more than 10,000 IOPS or 160 MB of throughput per volume | Low-cost HDD volumes designed for frequent-access, throughput-intensive workloads such as big data, data warehouses, and log processing. | Designed for less frequently accessed workloads, such as colder data requiring fewer scans per day. |
| **Volume Size** | 1 GB to 1 TB | 1 GB to 16 TB | 4 GB to 16 TB | up to 16 TB | Max 16 TB |
| **Max throughput** | 40 - 90 MB | 160 MB |320 MB | 500 MB/s | 250 MB/s |
| **IOPS Performance** | Average 100 IOPS with the ability to burst to 100s of IOPS | Baseline performance of 3 IOPS/GB (max 10,000 IOPS) with the ability to burst to 3000 IOPS for volumes under 1000 GB | Consistently performs at provisioned level, up to 20,000 IOPS max | max 500 | Max 250 |
| **Cost** | Cheapest |  | Based on the volume size provisioned (not space used) + number of IOPS provisioned, whether they are consumed or not | significantly less expensive than general-purpose SSD volumes. | significantly less expensive than Throughput-Optimized HDD volumes |
| **Misc** | Lowest Performance |  | When you provision a *Provisioned IOPS SSD* volume, you should specify both the size and the desired number of IOPS<br>You can stripe multiple volumes together in a *RAID 0* configuration for larger size and greater performance |  |  |

**EBS-Optimized Instances**

* Uses an optimized configuration stack and provides additional, dedicated capacity for EBS I/O. This optimization provides the best performance for EBS volumes by minimizing contention between EBS I/O and other traffic from EC2 instance.

### EBS Snapshots

* Backup EBS volume data by taking snapshots through AWS console, CLI, API or setting up a schedule for regular snapshots
* Snapshots are incremental backups, which means that only the blocks on the device that have changed since your most recent snapshot are saved.
* Snapshot data is stored in S3.
* The action of taking a snapshot is free. You pay only the storage costs for the snapshot data.
* When you request a snapshot, the point-in-time snapshot is created immediately and the volume may continue to be used, but the snapshot may remain in pending status until all the modified blocks have been transferred to S3.
* Snapshots are stored in AWS-controlled S3 storage; not in your account’s S3 buckets. This means you cannot manipulate them like other Amazon S3 objects. Rather, you must use the EBS snapshot features to manage them.
* Snapshots are constrained to the region in which they are created, meaning you can use them to create new volumes only in the same region. If you need to restore a snapshot in a different region, you can copy a snapshot to another region.

**Creating a Volume from a Snapshot**
* To use a snapshot, you create a new EBS volume from the snapshot. When you do this, the volume is created immediately but the data is loaded lazily. This means that the volume can be accessed upon creation, and if the data being requested has not yet been restored, it will be restored upon first request. Because of this, it is a best practice to initialize a volume created from a snapshot by accessing all the blocks in the volume.
* Snapshots can also be used to increase the size of an EBS volume. To increase the size of an EBS volume
	* take a snapshot of the volume
	* create a new volume of the desired size from the snapshot
	* Replace the original volume with the new volume.

**Recovering Volumes**

* If an Amazon EBS-backed instance fails and there is data on the boot drive, it is relatively straightforward to detach the volume from the instance.
* Unless the `DeleteOnTermination` flag for the volume has been set to false, the volume should be detached before the instance is terminated.
* The volume can then be attached as a data volume to another instance and the data read and recovered.

**Encryption Options**

* Amazon EBS offers native encryption on all volume types
* When you launch an encrypted EBS volume, Amazon uses the *AWS KMS* to handle key management. A new master key will be created unless you select a master key that you created separately in the service.
* Data and associated keys are encrypted using the industry-standard *AES-256* algorithm.
* The encryption occurs on the servers that host EC2 instances, so the data is actually encrypted in transit between the host and the storage media and also on the media.
* Encryption is transparent, so all data access is the same as unencrypted volumes, and you can expect the same IOPS performance on encrypted volumes as you would with unencrypted volumes, with a minimal effect on latency.
* Snapshots that are taken from encrypted volumes are automatically encrypted, as are volumes that are created from encrypted snapshots.

## AWS Storage Gateway

* is a service connecting an on-premise s/w with cloud-based storage to provide seamless and secure integration. It provides low-latency performance by maintaining a cache of frequently accessed data on-premises while securely storing all of your data encrypted in S3 or Glacier.

## Amazon CloudFront

* is a content delivery web service - an easy way to distribute content with low-latency, high data transfer speeds - can be used to deliver websites including dynamic, static, streaming and interactive content, using a global network of edge locations. Request for content are automatically routed to the nearest edge location for best performance.

---

# Compute and Network Services

## Amazon EC2

### Instance Types

* 2 key concepts to an instance:
	* the amount of virtual hardware dedicated to the Instance
	* the software loaded on the instance
* Instance types vary in following dimensions:
	* Virtual CPUs (vCPUs)
	* Memory
	* Storage
	* Network performance
* Instance types are grouped into families
* The ratio of vCPUs to memory is constant as the size scale linearly
* The hourly price for each size scales linearly. e.g., `Cost(m4.xlarge) = 2 x Cost(m4.large)`
* Optimized Instance Type Family
	* `m4` family provides a balance of compute, memory and n/w resources
	* `c4` **compute optimized** for workloads requiring significant processing
	* `r3` **memory optimized** for memory-intensive workloads
	* `i2` **storage optimized** for workloads requiring high amounts of fast SSD storage
	* `g2` **GPU-based instances** for graphics and general-purpose GPU compute workloads
* Network performance
	* AWS publishes a relative measure of n/w performance: low, moderate, high
	* *Enhanced Networking*:
		* For workloads requiring greater n/w performance, use instance types supporting *enhanced networking*.
		* It reduces the impact of virtualization on n/w performance enabling a capability called ***Single Root I/O Virtualization (SR-IOV)***
		* This results in more *packets per second (PPS)*, lower latency and less jitter

**Amazon Machine Image (AMI)**

* defines the initial software that will be on an instance when it is launched: *OS + initial state of patches + application/system software*
* All AMIs are based on x86 OS (either Linux or Windows)
* **4 Sources of AMIs**
	* *Published by AWS*: you should apply patches upon launch
	* *AWS Marketplace*
	* *Generated from Existing instances*: published AMI + corporate standard software added
	* *Uploaded Virtual Servers*: Using AWS VM Import/Export to create images from formats: VHD, VMDK, OVA

**Addressing an Instance**

There are several ways that an instance may be addressed over the web upon creation:

* ***Public DNS Name***
	* DNS name is generated automatically and cannot be specified by the customer.
	* This DNS name persists only while the instance is running and cannot be transferred to another instance.
* ***Public IP***
	* This IP address is assigned from the addresses reserved by AWS and cannot be specified.
	* This IP address is unique on the Internet, persists only while the instance is running, and cannot be transferred to another instance.
* ***Elastic IP***
	* An elastic IP address is an address unique on the Internet that you reserve independently and associate with an instance.
	* This IP address persists until the customer releases it and is not tied to the lifetime or state of an individual instance.
	* Because it can be transferred to a replacement instance in the event of an instance failure, it is a public address that can be shared externally without coupling clients to a particular instance.

> Private IP addresses and Elastic Network Interfaces (ENIs) are additional methods of addressing instances that are available in the context of an Amazon VPC.

### Securing an Instance

**Initial Access**

* EC2 uses *public-key cryptography* to encrypt and decrypt login information.
* *Public-key cryptography* uses a public key to encrypt a piece of data and an associated private key to decrypt the data. These two keys together are called a *key pair*.
* Key pairs can be created through the AWS Management Console, CLI, or API, or customers can upload their own key pairs.
* AWS stores the public key in `~/.ssh/authorized_keys` folder
* Private keys are kept by the customer. The private key is essential to acquiring secure access to an instance for the first time.
* When launching a Windows instance, Amazon EC2 generates a random password for the local administrator account and encrypts the password using the public key. Initial access to the instance is obtained by decrypting the password with the private key, either in the console or through the API.

**Virtual Firewall Protection**

* AWS allows you to control traffic in and out of your instances through virtual firewalls called **security groups**.
* Security groups allow you to control traffic based on port, protocol, and source/destination.
* Security groups are applied at the instance level, as opposed to a traditional on-premises firewall that protects at the perimeter. To breach a single perimeter to access all instances, one has to breach the security groups repeatedly for each individual instances
* Security groups have different capabilities :
	* *EC2-Classic Security Groups* - Control outgoing instance traffic
  * *VPC Security Groups*	- Control outgoing and incoming instance traffic
* Every instance must have at least one security group but can have more
* *Changing Security Group*
	* If an instance is running in an Amazon VPC, you can change which security groups are associated with an instance while the instance is running.
	* For instances outside of an Amazon VPC (called EC2-Classic), the association of the security groups cannot be changed after launch.
* A security group is *default deny* - it does not allow any traffic that is not explicitly allowed by a security group rule.
* A *rule* is defined by 3 attributes:
	* Port
	* Protocol. e.g., HTTP, RDP, etc.
	* Source/Destination- can be defined in 2 ways:
  	* **CIDR block** — An x.x.x.x/x style definition that defines a specific range of IP addresses.
  	* Security group — Includes any instance that is associated with the given security group. This helps prevent coupling security group rules with specific IP addresses
* When an instance is associated with multiple security groups, the rules are aggregated and all traffic allowed by each of the individual groups is allowed. For example, if security group A allows RDP traffic from 72.58.0.0/16 and security group B allows HTTP and HTTPS traffic from 0.0.0.0/0 and your instance is associated with both groups, then both the RDP and HTTP/S traffic will be allowed in to your instance.
* A security group is a **stateful firewall**; that is, an outgoing message is remembered so that the response is allowed through the security group without an explicit inbound rule being required.

### Lifecycle of Instances

**Bootstrapping**

* Ability to configure instances and install applications programmatically when an instance is launched. The process of providing code to be run on an instance at launch is called *bootstrapping*.
* When an instance is launched for the first time, a string-valued parameter `UserData` is passed to the OS to be executed as part of the launch process. On Linux, this can be a shell script, performing tasks like
	* Applying patches and updates to the OS
	* Installing application software
	* Copying a longer script or program from storage to be run on the instance
	* Installing Chef or Puppet and assigning the instance a role so the configuration management software can configure the instance
* `UserData` is stored with the instance and is not encrypted. DO NOT include any secrets such as passwords or keys in it.

**VM Import/Export**

* Import VMs from your existing environment as an EC2 instance and export them back to your on-premises environment.
* You can only export previously imported EC2 instances. Instances launched within AWS from AMIs cannot be exported.

**Instance Metadata**

* Instance metadata is data about your instance that you can use to configure or manage the running instance. This is unique in that it is a mechanism to obtain AWS properties of the instance from within the OS without making a call to the AWS API.
* An HTTP call to http://169.254.169.254/latest/meta-data/ will return the top node of the instance metadata tree.
* Instance metadata includes:
	* The associated security groups
	* The instance ID
	* The instance type
	* The AMI used to launch the instance

**Instance Tags**

* Tags are key/value pairs you can associate with your instance or other service.
* Tags can be used to identify attributes of an instance like project, environment (dev, test, and so on), billable department, and so forth.
* Max 10 tags per instance.

**Modifying Instance Type**

* If the compute needs prove to be higher or lower than expected, the instances can be changed to a different size more appropriate to the workload.
* Stop instance -> Change instance type -> Restart instance

**Termination Protection**

* To prevent accidental termination, when *Termination Protection* is enabled, calls to terminate the instance will fail.
* It does not prevent termination triggered
	* by an OS shutdown command,
	* termination from an Auto Scaling group, or
	* termination of a Spot Instance due to Spot price changes

### Instance Pricing Options

* **On-Demand Instances**
	* Least cost-effective due to the flexibility it allows customers to save by provisioning a variable level of compute for unpredictable workloads
	* The price is per hour for each instance type
	* No up-front commitment, and the customer has control over when the instance is launched and when it is terminated
* **Reserved Instances**
	* 75% less cost compared to On-Demand hourly rate
	* When purchasing a reservation, the customer specifies the instance type and Availability Zone
	* Capacity in the data centers is reserved for that customer.
	* 2 factors determining the cost:
		* *Term commitment* - the duration of the reservation
		* *Payment option*
			* *All Upfront* —Pay for the entire reservation up front. There is no monthly charge for the customer during the term.
			* *Partial Upfront* —Pay a portion of the reservation charge up front and the rest in monthly installments for the duration of the term.
			* *No Upfront* —Pay the entire reservation charge in monthly installments for the duration of the term.
	* Modifying Reservation: You can modify your whole reservation, or just a subset, in one or more of the following ways:
		* Switch Availability Zones within the same region.
		* Change between EC2-VPC and EC2-Classic.
		* Change the instance type within the same instance family (Linux instances only).
	* One may purchase two Reserved Instances to handle the average traffic, but depend on On-Demand Instances to fulfill compute needs during the peak times.
* **Spot Instances**
	* offers the greatest discount
	* For workloads that are not time critical and are tolerant of interruption
	* With Spot Instances, when the customer’s bid price is above the current Spot price, the customer will receive the requested instance(s). These instances will operate like all other Amazon EC2 instances, and the customer will only pay the Spot price for the hours that instance(s) run.
	* The instances will run until:
		* The customer terminates them.
		* The Spot price goes above the customer’s bid price.
		* There is not enough unused capacity to meet the demand for Spot Instances.
		* If Amazon EC2 needs to terminate a Spot Instance, the instance will receive a termination notice providing a two-minute warning prior to Amazon EC2 terminating the instance.

### Tenancy options

* **Shared Tenancy**
	* a single host machine may house instances from different customers
	* Default model
	* AWS does not use overprovisioning and fully isolates instances from other instances on the same host, this is a secure tenancy model.
* **Dedicated Instance**
	* runs on hardware that's dedicated to a single customer.
* **Dedicated Host**
	* Dedicated Host is a physical server with EC2 instance capacity fully dedicated to a single customer’s use.
	* The customer has complete control over which specific host runs an instance at launch. This differs from Dedicated Instances in that a Dedicated Instance can launch on any hardware that has been dedicated to the account.
	* can help address licensing requirements and reduce costs by allowing to use existing server-bound software licenses.
* **Placement Groups**
	* is a logical grouping of instances within a single Availability Zone.
	* enable applications to participate in a low-latency, 10 Gbps network.
	* recommended for applications that benefit from low network latency, high network throughput, or both. This represents network connectivity between instances.
	* To fully use this network performance for your placement group, choose an instance type that supports enhanced networking and 10 Gbps network performance.

**Instance Stores**

* An instance store provides temporary block-level storage (*ephemeral storage*)
* Data in the instance store is lost when:
	* the underlying disk drive fails
	* the instance stops
	* the instance terminates


## AWS Lambda

* a zero-administration compute platform for back-end web developers that runs your code for you on the AWS cloud (for high availability)

## Auto Scaling

* allows to scale EC2 capacity up or down automatically according to conditions defined for the particular workload (for scaling in and out)

## Elastic Load Balancing (ELB)

* automatically distributes incoming application traffic across multiple EC2 instances. (for fault-tolerance)

## AWS Elastic Beanstalk

* Developers can simply upload their application code, and the service automatically handles all the details, such as resource provisioning, load balancing, Auto scaling, and monitoring.

## AWS Virtual Private Cloud (VPC)

* provides a logically isolated section of the AWS cloud to launch resources in a virtual n/w. Organizations have complete control over the virtual env including the selection of the IP address range, creation of subnets, configuration of route tables, n/w gateways, etc. Orgs can extend their corporate data center n/w to AWS by using h/w or s/w VPN connections or dedicated circuits by using AWS Direct Connect.

## AWS Direct Connect

* allows organizations to establish a dedicated n/w connection from their data center to AWS.

## Amazon Route 53

* is a highly available and scalable DNS web service. Also serves as domain registrar, allowing you to purchase and manage domains directly from AWS

---

# Database service

## Amazon DynamoDB

* document and key/value NoSQL DB service - single-digit millisecond latency at any scale

## Amazon Redshift

* columnar DB - petabyte-scale data warehouse service to analyze structured data - by leveraging columnar storage technology it can run parallelized queries across multiple nodes

## Amazon ElasticCache

* a web service that simplifies scaling of an in-memory cache in the cloud - supports Memcached and Redis cache engines

---

# Management Tools

## Amazon CloudWatch

* monitoring service for AWS cloud resources and the applications running on AWS

## AWS CloudFormation

* defines a JSON-based templating language that can be used to describe all the AWS resources needed for a workload. When templates are submitted to the AWS CloudFormation, it will take care of provisioning and configuring those resources in appropriate order

## AWS CloudTrail

* a web service that records AWS API calls for an account and delivers log files for audit and review.

## AWS Config

* With this, one can export an inventory of their AWS resources with all configuration details, and determine how a resource was configured at any point in time - enables compliance auditing, security analysis, resource change tracking, and troubleshooting.

---

# Security and Identity

## AWS Identity and Access Manager (IAM)

* enables organizations to create and manage AWS users and groups and use permissions to allow and deny their access to AWS resources.

## AWS Key Management Service (KMS)

* enables organizations to create and control the encryption keys used to encrypt their data and uses Hardware Security Modules (HSM) to protect the security of the keys.

## AWS Directory Service

* allows organizations to set up and run Microsoft Active Directory on the AWS cloud or connect their AWS resources with an existing on-premises Microsoft Active Directory.

## AWS Certificate Manager

* is a service that lets organizations easily provision, manage and deploy SSL/TLS certificates for use with AWS cloud services. It removes the time-consuming manual process of purchasing, uploading and renewing certificates - enables to quickly request a certificate, deploy it on AWS and let AWS Certificate Manager handle certificate renewals

## AWS Web Application Firewall (WAF)

* helps protect web apps from common attacks

---

# Application Services

## Amazon API Gateway

* a fully managed service that makes it easy to create, publish, maintain, monitor and secure APIs at any scale - handles all the tasks involved in accepting and processing up to hundreds of thousands of concurrent API calls, including traffic management, monitoring, authorization and access control, API version management.

## Amazon Elastic Transcoder

* media transcoder that converts media files from their source formats into versions that will play back on specific devices

## Amazon Simple Notification Service (SNS)

* is a web service that coordinates and manages the delivery of messages to recipients.

## Amazon Simple Email Service (SES)

## Amazon Simple Workflow Service (SWF)

* helps build, run and scale background jobs that have parallel or sequential steps - has fully managed state tracker and task coordinator on the cloud - provides ability to recover or retry if a task fails.

## Amazon Simple Queue Service (SQS)

* managed message queueing service

---

# Terminology

* Fault tolerance, High availability
* Data at Rest - EBS, S3, RDS
* Data at Transit - (in reference to encryption and security)
* Network perimeter - a boundary between two or more portions of a network. It can refer to the boundary between your VPC and your network, it could refer to the boundary between what you manage versus what AWS manages.
* WAF (Web Application Firewall)
* NAT (Network Address Translation)


# References

* Books
	* AWS Certified Solution Architect - Study Guide
* CloudAcademy.com
  * [AWS Technical Foundation 110](https://cloudacademy.com/amazon-web-services/aws-technical-fundamentals-aws-110-course)
  * AWS Technical Foundation 120
  * AWS Technical Foundation 140
  * AWS Technical Foundation 160
  * AWS Technical Foundation 180
  * AWS Technical Foundation 190
  * [Foundations for Solutions Architect Associate on AWS course](https://cloudacademy.com/amazon-web-services/foundations-for-solutions-architect-associate-on-aws-course/)
