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
		* S3 offers *read-after-write* consistency for `PUT`s to new objects. *Read-after-write* guarantees immediate visibility of new data to all clients.
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
				* from where (by *CIDR* block or IP address)
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

## EC2

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

> Private IP addresses and Elastic Network Interfaces (ENIs) are additional methods of addressing instances that are available in the context of an VPC.

### Securing an Instance

**Initial Access**

* EC2 uses *public-key cryptography* to encrypt and decrypt login information.
* *Public-key cryptography* uses a public key to encrypt a piece of data and an associated private key to decrypt the data. These two keys together are called a *key pair*.
* Key pairs can be created through the AWS Management Console, CLI, or API, or customers can upload their own key pairs.
* AWS stores the public key in `~/.ssh/authorized_keys` folder
* Private keys are kept by the customer. The private key is essential to acquiring secure access to an instance for the first time.
* When launching a Windows instance, EC2 generates a random password for the local administrator account and encrypts the password using the public key. Initial access to the instance is obtained by decrypting the password with the private key, either in the console or through the API.

**Virtual Firewall Protection**

* AWS allows you to control traffic in and out of your instances through virtual firewalls called **security groups**.
* Security groups allow you to control traffic based on port, protocol, and source/destination.
* Security groups are applied at the instance level, as opposed to a traditional on-premises firewall that protects at the perimeter. To breach a single perimeter to access all instances, one has to breach the security groups repeatedly for each individual instances
* Security groups have different capabilities :
	* *EC2-Classic Security Groups* - Control outgoing instance traffic
  * *VPC Security Groups*	- Control outgoing and incoming instance traffic
* Every instance must have at least one security group but can have more
* *Changing Security Group*
	* If an instance is running in an VPC, you can change which security groups are associated with an instance while the instance is running.
	* For instances outside of an VPC (called EC2-Classic), the association of the security groups cannot be changed after launch.
* A security group is *default deny* - it does not allow any traffic that is not explicitly allowed by a security group rule.
* A *rule* is defined by 3 attributes:
	* Port
	* Protocol. e.g., HTTP, RDP, etc.
	* Source/Destination- can be defined in 2 ways:
  	* CIDR block
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
	* With Spot Instances, when the customer’s bid price is above the current Spot price, the customer will receive the requested instance(s). These instances will operate like all other EC2 instances, and the customer will only pay the Spot price for the hours that instance(s) run.
	* The instances will run until:
		* The customer terminates them.
		* The Spot price goes above the customer’s bid price.
		* There is not enough unused capacity to meet the demand for Spot Instances.
		* If EC2 needs to terminate a Spot Instance, the instance will receive a termination notice providing a two-minute warning prior to EC2 terminating the instance.

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

* Advantage of deploying applications to the cloud is the ability to launch and then release servers in response to variable workloads.
* Provisioning servers on demand and then releasing when not needed can provide significant cost savings. E.g., an end-of-month data-input system, a retail shopping site supporting flash sales, etc.

* __Embrace the Spike__
	* Many web applications have unplanned load increases based on events outside of your control.
	* Setting up Auto Scaling in advance will allow to embrace and survive such fast increase in the number of requests. It will scale up your site to meet the increased demand and then scale down when the event subsides.

### Auto Scaling Plans

* __Maintain Current Instance Levels__
	* Configure your Auto Scaling group to maintain a minimum or specified number of running instances at all times.
	* To maintain the current instance levels, Auto Scaling performs a periodic health check on running instances within an Auto Scaling group.
	* When Auto Scaling finds an unhealthy instance, it terminates that instance and launches a new one.
	* Steady state workloads that need a consistent number of EC2 instances at all times can use Auto Scaling to monitor and keep that specific number of EC2 instances running.
* __Manual Scaling__
	* This is the most basic way to scale your resources. You just need to specify the change in the maximum, minimum, or desired capacity of your Auto Scaling group.
	* Auto Scaling manages the process of creating or terminating instances to maintain the updated capacity.
	* Manual scaling out can be very useful to increase resources for an infrequent event, such as movie release dates.
	* For extremely large-scale events, even the ELB load balancers can be pre-warmed by working with your local solutions architect or AWS Support.
* __Scheduled Scaling__
	* When you have a recurring schedule or a predictable schedule of when you will need to increase or decrease the number of instances in your group, e.g., end-of-month, or end-of-year processing, schedule scaling is useful.
	* Scaling actions are performed automatically as a function of time and date.
* __Dynamic Scaling__
	* Lets you define parameters that control the Auto Scaling process in a scaling policy. E.g., create a policy that adds more EC2 instances to the web tier when the network bandwidth, measured by CloudWatch, reaches a certain threshold.

### Auto Scaling Components

__Launch Configuration__

* A launch configuration is the template used to create new instances, and it has the following:
	* Name (e.g., _myLC_)
	* AMI (e.g., _ami-0535d66c_)
	* Instance type (e.g., _m3.medium_)
	* Security groups (e.g., _sg-f57cde9d_)
	* Instance key pair (e.g., _myKeyPair_)
* Each Auto Scaling group can have only one launch configuration at a time.
* Security groups for instances launched in EC2-Classic may be referenced by security group name or by security group IDs. Security group ID is recommended.
* _Limits_
	* Default limit for launch configurations = __100 per region__. If you exceed this limit, the call to create-launch-configuration will fail. To update this limit: `aws autoscaling describe-account-limits`
	* Auto Scaling may cause you to reach limits of other services, such as the default number of EC2 instances you can currently launch = __20 per region__.
	* When you run a command using the CLI and it fails,
		* check your syntax first. If that checks out,
		* verify the limits for the command you are attempting, and check to see that you have not exceeded a limit.
		* To raise the limits, in cases allowed, create a support case at the AWS Support Center online and then choose _Service Limit Increase under Regarding_.

__Auto Scaling Group__

* An Auto Scaling group is a collection of EC2 instances managed by the Auto Scaling service.
* Each Auto Scaling group contains configuration options that control when Auto Scaling should launch new instances and terminate existing instances.
* An Auto Scaling group must contain
	* a name
	* a minimum and maximum number of instances that can be in the group.
	* (optional) desired capacity, which is the number of instances that the group must have at all times. If not specified, the default desired capacity = the minimum number of instances.

```
Name: myASG
Launch configuration: myLC
Availability Zones: us-east-1a and us-east-1c
Minimum size: 1
Desired capacity: 3
Maximum capacity: 10
Load balancers: myELB
```

* An Auto Scaling group can use either On-Demand (default) or Spot instances, but not both.
* Spot Instances
	* Bid price can be modified
	* If instances are available at or below your bid price, they will be launched in your Auto Scaling group.

__Spot On!__

* Spot Instances can be useful when hosting sites to provide additional compute capacity but are price constrained. E.g., a “freemium” site model where some basic functionality to users are free and additional functionality is for premium users.
* It can be used for providing the basic functionality when available by referencing a maximum bid price in the launch configuration (`—spot-price "0.15"`) associated with the Auto Scaling group.

__Scaling Policy__

{% img right /technology/aws-auto-scaling.png %}

* CloudWatch alarms and scaling policies can be associated with an Auto Scaling group to adjust Auto Scaling dynamically.
* When a threshold is crossed, CloudWatch sends alarms to trigger changes (scaling in or out) to the number of EC2 instances currently receiving traffic behind a load balancer.
* After the CloudWatch alarm sends a message to the Auto Scaling group, Auto Scaling executes the associated policy to scale your group.
* The policy is a set of instructions that tells Auto Scaling whether to scale out, launching new EC2 instances referenced in the associated launch configuration, or to scale in and terminate instances.
* Various ways to configure a scaling policy:
	* increase or decrease by a specific number of instances, or
	* adjust based on a percentage.
	* scale by steps and increase or decrease the current capacity of the group based on a set of scaling adjustments that vary based on the size of the alarm threshold trigger.
* More than one scaling policy can be associated with an Auto Scaling group. E.g., One policy to scale out if CPU Load > 75% for 2 minutes. Another policy to scale in if CPU Load < 40% for 20 minutes.

* _Best Practice_
	* Scale out quickly and scale in slowly so you can respond to bursts or spikes but avoid inadvertently terminating EC2 instances too quickly, only having to launch more EC2 instances if the burst is sustained.
	* Auto Scaling also supports a _cooldown period_, which is a configurable setting that determines when to suspend scaling activities for a short time for an Auto Scaling group.
	* If you start an EC2 instance, you will be billed for one full hour of running time. Partial instance hours consumed are billed as full hours. This means that if you have a permissive scaling policy that launches, terminates, and re-launches many instances an hour, you are billing a full hour for each and every instance you launch, even if you terminate some of those instances in less than hour.
	* Bootstrapping new EC2 instances launched using Auto Scaling takes time to configure before the instance is healthy and capable of accepting traffic. Instances that start and are available for load faster can join the capacity pool more quickly.
	* Stateless instances can enter and exit gracefully than a stateful instance in an Auto Scaling group.

* _Rolling Out a Patch at Scale_
	* In large deployments of EC2 instances, Auto Scaling can be used to make rolling out a patch to your instances easy.
	* The launch configuration associated with the Auto Scaling group may be modified to reference a new AMI and even a new EC2 instance if needed. Then you can deregister or terminate instances one at a time or in small groups, and the new EC2 instances will reference the new patched AMI.

## Elastic Load Balancing (ELB)

* automatically distributes incoming application traffic across multiple EC2 instances. (for fault-tolerance)

* ELB allows to distribute traffic across a group of EC2 instances in one or more Availability Zones, to achieve high availability in your applications.
* ELB supports routing and load balancing of HTTP, HTTPS, TCP, and SSL traffic to EC2 instances.
* ELB provides a stable, single _Canonical Name record (CNAME)_ entry point for DNS configuration and supports both Internet-facing and internal application-facing load balancers.
* ELB supports health checks for EC2 instances to ensure traffic is not routed to unhealthy or failing instances. It can scale automatically based on collected metrics.
* Long-running applications will eventually need to be maintained and updated with a newer version of the application. When using EC2 instances running behind an ELB load balancer, you may deregister these long-running EC2 instances associated with a load balancer manually and then register newly launched EC2 instances that you have started with the new updates installed.
* __Advantages of ELB__
	* Because ELB is a managed service, it scales in and out automatically to meet the demands of increased application traffic and is highly available within a region itself as a service.
	* ELB helps you achieve high availability for your applications by distributing traffic across healthy instances in multiple Availability Zones.
	* ELB seamlessly integrates with the Auto Scaling service to automatically scale the EC2 instances behind the load balancer.
	* ELB is secure, working with VPC to route traffic internally between application tiers, allowing you to expose only Internet-facing public IP addresses.
	* ELB also supports integrated certificate management and SSL termination.

### Types of Load Balancers

#### Internet-Facing Load Balancers

* Takes requests from clients over the Internet and distributes them to EC2 instances that are registered with the load balancer.
* When you configure a load balancer, it receives a public DNS name that clients can use to send requests to your application. The DNS servers resolve the DNS name to your load balancer’s public IP address, which can be visible to client applications.
* Because ELB scales in and out to meet traffic demand, it is not recommended to bind an application to an IP address that may no longer be part of a load balancer’s pool of resources.
* Best practice: always reference a load balancer by its DNS name, instead of by the IP address, in order to provide a single, stable entry point.
* ELB in VPC supports IPv4 addresses only.
* ELB in EC2-Classic supports both IPv4 and IPv6 addresses.

#### Internal Load Balancers

* In a multi-tier application, it is often useful to load balance between the tiers of the application. For example, an Internet-facing load balancer might receive and balance external traffic to the presentation or web tier whose EC2 instances then send its requests to a load balancer sitting in front of the application tier.
* Internal load balancers can be used to route traffic to EC2 instances in VPCs with private subnets.

#### HTTPS Load Balancers

* Load balancer that uses the SSL/TLS protocol for encrypted connections (also known as ___SSL offload___).
* This feature enables traffic encryption between your load balancer and the clients that initiate HTTPS sessions, and for connections between your load balancer and your back-end instances.
* Elastic Load Balancing provides security policies that have predefined SSL negotiation configurations to use to negotiate connections between clients and the load balancer. In order to use SSL, you must install an SSL certificate on the load balancer that it uses to terminate the connection and then decrypt requests from clients before sending requests to the back-end EC2 instances.
* You can optionally choose to enable authentication on your back-end instances.
* ELB does not support _Server Name Indication (SNI)_ on your load balancer. This means that if you want to host multiple websites on a fleet of EC2 instances behind ELB with a single SSL certificate, you will need to add a _Subject Alternative Name (SAN)_ for each website to the certificate to avoid site users seeing a warning message when the site is accessed.

#### Listeners

* A listener is a process that checks for connection requests—for example, a CNAME configured to the A record name of the load balancer.
* Every load balancer must have one or more listeners configured.
* Every listener is configured with
	* a protocol and a port (client to load balancer) for a front-end connection
	* a protocol and a port for the back-end (load balancer to EC2 instance) connection.
* ELB supports protocols operating at two different Open System Interconnection (OSI) layers.
	* In the OSI model, Layer 4 is the transport layer that describes the TCP connection between the client and your back-end instance through the load balancer. Layer 4 is the lowest level that is configurable for your load
balancer.
	* Layer 7 is the application layer that describes the use of HTTP and HTTPS connections from clients to the load balancer and from the load balancer to your back-end instance.
* The SSL protocol is primarily used to encrypt confidential data over insecure networks such as the Internet. The SSL protocol establishes a secure connection between a client and the back-end server and ensures that all the data passed between your client and your server is private.

### ELB Configurations

#### Idle Connection Timeout

* For each request that a client makes through a load balancer, the load balancer maintains two connections.
	* Connection 1: with the client
	* Connection 2: to the back-end instance
* For each connection, the load balancer manages an idle timeout that is triggered when no data is sent over the connection for a specified time period. After the idle timeout period has elapsed, if no data has been sent or received, the load balancer closes the connection.
* Default idle timeout for both connections = 60 seconds. This can be modified.
* If an HTTP request doesn’t complete within the idle timeout period, the load balancer closes the connection, even if data is still being transferred.
* ___Keep-alive___
	* If you use HTTP and HTTPS listeners, we recommend that you enable the _keep-alive_ option for your EC2 instances. You can enable keep-alive in your web server settings or in the kernel settings for your EC2 instances.
	* Keep-alive, when enabled, allows the load balancer to reuse connections to your back-end instance, which reduces CPU utilization.
	* To ensure that the load balancer is responsible for closing the connections to your back-end instance, make sure that the value you set for the keep-alive time is greater than the idle timeout setting on your load balancer.

#### Cross-Zone Load Balancing

* To ensure that request traffic is routed evenly across all back-end instances for your load balancer, regardless of the Availability Zone in which they are located, you should enable _cross-zone load balancing_ on your load balancer.
* Cross-zone load balancing reduces the need to maintain equivalent numbers of back-end instances in each Availability Zone and improves your application’s ability to handle the loss of one or more back-end instances.
* However, it is still recommended that you maintain approximately equivalent numbers of instances in each Availability Zone for higher fault tolerance.
* For environments where clients cache DNS lookups, incoming requests might favor one of the Availability Zones. Using cross-zone load balancing, this imbalance in the request load is spread across all available back-end instances in the region, reducing the impact of misconfigured clients.

#### Connection Draining

* To ensure that the load balancer stops sending requests to instances that are deregistering or unhealthy, while keeping the existing connections open. This enables the load balancer to complete in-flight requests made to these instances.
* When you enable connection draining, you can specify a maximum time for the load balancer to keep connections alive before reporting the instance as deregistered.
* The maximum timeout value can be set between 1 and 3,600 seconds (the default is 300 seconds).
* When the maximum time limit is reached, the load balancer forcibly closes connections to the deregistering instance.

#### Proxy Protocol

* When you use TCP or SSL for both front-end and back-end connections, your load balancer forwards requests to the back-end instances without modifying the request headers.
* If you enable _Proxy Protocol_, a human-readable header is added to the request header with connection information such as the source IP address, destination IP address, and port numbers. The header is then sent to the back-end instance as part of the request.
* Before using Proxy Protocol, verify that your load balancer is not behind a proxy server with Proxy Protocol enabled. If Proxy Protocol is enabled on both the proxy server and the load balancer, the load balancer adds another header to the request, which already has a header from the proxy server. Depending on how your back-end instance is configured, this duplication might result in errors.

#### Sticky Sessions

* By default, a load balancer routes each request independently to the registered instance with the smallest load. However, you can use the sticky session feature (also known as session affinity), which enables the load balancer to bind a user’s session to a specific instance. This ensures that all requests from the user during the session are sent to the same instance.
* The key to managing sticky sessions is to determine how long your load balancer should consistently route the user’s request to the same instance. If your application has its own session cookie, you can configure ELB so that the session cookie follows the duration specified by the application’s session cookie.
* If your application does not have its own session cookie, you can configure ELB to create a session cookie by specifying your own stickiness duration.
* ELB creates a cookie named _AWSELB_ that is used to map the session to the instance.

#### Health Checks

* ELB supports health checks to test the status of the EC2 instances behind an ELB load balancer.
* If healthy, status = _InService_, else _OutOfService_.
* The load balancer performs health checks on all registered instances to determine whether the instance is in a healthy state or an unhealthy state.
* A health check is a ping, a connection attempt, or a page that is checked periodically.
* You can set the time interval between health checks and also the amount of time to wait to respond in case the health check page includes a computational aspect.
* Finally, you can set a threshold for the number of consecutive health check failures before an instance is marked as unhealthy.

## AWS Elastic Beanstalk

* Developers can simply upload their application code, and the service automatically handles all the details, such as resource provisioning, load balancing, Auto scaling, and monitoring.

## AWS Virtual Private Cloud (VPC)

{% img right /technology/aws-vpc-sample.png %}

* VPC is a custom-defined virtual network within AWS cloud
* VPC is the networking layer for EC2
* 2 networking platforms in AWS
	* EC2-Classic (old) - single, flat n/w shared with other customers
	* EC2-VPC
* VPC consists of
	* Subnets
	* Route tables
	* DHCP option sets
	* Security groups
	* Network ACLs
	* Internet Gateways (*optional*)
	* EIP addresses (*optional*)
	* Elastic Network Interfaces ENIs (*optional*)
	* Endpoints (*optional*)
	* Peering (*optional*)
	* NAT instances and NAT gateways (*optional*)
	* Virtual Private Gateways (VPGs), Customer Gateways (CGWs), VPNs
	* (*optional*)
* VPC allows to
	* select your own IP address range
	* create your own subnets
	* configure your own route tables, n/w gateways and security settings
* Within a region, you can create multiple VPCs. Each VPC is logically isolated even if it shared its IP address space
* VPC can span across Availability Zones
* To create a VPC, choose CIDR block
	* which cannot be changed after creation
	* As large as */16 (65,636 addresses)* or as small as */28 (16 addresses)*.
	* Should not overlap
* Every account has a default VPC created in each region with a default subnet created in each Availability Zone.
	* The assigned CIDR block of the VPC will be *172.31.0.0/16*
	* Default VPCs contain one public subnet in every Availability Zone with the region, with a netmask of */20*
* Orgs can extend their corporate data center n/w to AWS by using h/w or s/w VPN connections or dedicated circuits by using AWS Direct Connect.

### Subnets

* A subnet is a segment of VPC's IP address range where you can launch EC2 instances, RDS databases, etc.
* CIDR blocks defines subnets
* Smallest subnet you can create is a */28 (16 addresses)*.
	* AWS reserves the first 4 addresses and the last IP address of every subnet for internal networking purposes. So, `16-4-1 = 11` IP addresses is the smallest subnet.
* Subnets reside within one Availability Zone. CANNOT span across zones or regions.
* One Availability Zone can have multiple subnets
* Internal IP address range of the subnet is always _private_
* Subnets can be classified as one of the below
	* __Public__ : route table directs the subnet's traffic to VPC's IGW
	* __Private__: route table DOES NOT direct the traffic to VPC's IGW
	* __VPN-only__: route table DOES NOT direct the traffic to VPC's IGW, but to the VPC's VPG

### Route Tables

* contains a set of rules called _rules_ that are applied to subnets to determine where the network traffic is directed
* allows EC2 instances in different subnets within a VPC to communicate with each other
* Route tables can be used to specify
	* which subnets are public (by directing Internet traffic to IGW)
	* which subnets are private (by not having a route that directs to IGW)
* Each route table
	* has a default route called the _local route_, which enables communication within the VPC. This route cannot be modified or removed.
	* custom routes can be added to exit the VPC via IGW, VPG or the NAT instance
* Each VPC comes with a main router table that can be modified.
* Custom route tables can be added, and subsequent new subnets created will be automatically associated with this custom route table
* Each subnet must be associated with a route table
* Each route in a table specifies a destination CIDR.

### IGW (Internet Gateways)

{% img right /technology/aws-igw.png %}

* IGW allows communication between instances in VPC and the Internet.
* IGW is horizontally scaled, redundant, and highly available VPC component
* To route traffic subnets to Internet, route tables must have a route targeting the IGW
* To enable an EC2 instance to send/receive traffic from the Internet, assign a public IP address or EIP address
* IGW maintains the 1-to-1 map of the EC2 instance's private IP and public IP.
* EC2 instances within a VPC are only aware of their private IPs. When traffic is sent from the instance to the Internet, the IGW translates the reply address to the public IP address of the instance.
* To create a public subnet with Internet access
	* Attach an IGW to your VPC
	* Create a subnet route table  
		* rule to route all non-local traffic (_0.0.0.0/0_) to the IGW
		* (optional) rule to route all destinations not explicitly defined in the route table to IGW
	* Configure your n/w ACLs and security group rules to allow relevant traffic flow to and from your instance

### DHCP

* DHCP - a standard for passing configuration information to hosts on a TCP/IP n/w
* Following options can be configured within a DHCP message:
	* __DNS servers__ - IP addresses of up to 4 DNS servers.
	* __Domain name__ - e.g., _mycompany.com_
	* __ntp-servers__ - IP addresses of up to 4 NTP (Network Time Protocol) servers
	* __netbios-name-servers__ - IP addresses of up to 4 NetBIOS name servers
	* __netbios-node-type__ - set this to 2
* Upon a VPC creation, AWS automatically associates a DHCP option set to it, and sets 2 options
	* DNS servers (defaulted to _AmazonProvidedDNS_. This option enables DNS for instances that need to communicate over the VPC's IGW)
	* Domain name (defaulted to domain name of your region)
* To assign your own domain name to your instances, create a custom DHCP option set and assign it to your VPC
* Each VPC must have only one DHCP option set assigned to it.

### EIPs (Elastic IP Addresses)

* An Elastic IP Addresses (EIP) is a static, public IP address in the pool for the region that you can allocate to your account (pull from the pool) and release (return to the pool).
* EIPs allow you to maintain a set of IP addresses that remain fixed while the underlying infrastructure may change over time.
* You must first allocate an EIP for use within a VPC and then assign it to an instance.
* EIPs are specific to a region (that is, an EIP in one region cannot be assigned to an instance within an VPC in a different region).
* There is a one-to-one relationship between network interfaces and EIPs.
* You can move EIPs from one instance to another, either in the same VPC or a different VPC within the same region.
* EIPs remain associated with your AWS account until you explicitly release them.
* There are charges for EIPs allocated to your account, even when they are not associated with a resource.

### ENIs (Elastic Network Interfaces)

* An ENI is a virtual network interface that you can attach to an instance in an VPC.
* ENIs are only available within an VPC, and they are associated with a subnet upon creation.
* They can have 1 public IP address, 1 primary private IP and multiple non-primary private IPs.
* Assigning a second network interface to an instance via an ENI allows it to be _dual-homed_ (have network presence in different subnets).
* An ENI created independently of a particular instance persists regardless of the lifetime of any instance to which it is attached; if an underlying instance fails, the IP address may be preserved by attaching the ENI to a replacement instance.

### Endpoints

* An VPC endpoint enables you to create a private connection between your VPC and another AWS service without requiring access over the Internet or through a NAT instance, VPN connection, or AWS Direct Connect.
* Multiple endpoints can be created for a single service, and use different route tables to enforce different access policies from different subnets to the same service.
* To create an VPC endpoint:
	* Specify the __VPC__.
	* Specify the __service__. A service is identified by a prefix list of the form `com.amazonaws.<region>.<service>`.
	* Specify the __policy__. You can allow full access or create a custom policy. This policy can be changed at any time.
	* Specify the __route tables__. A route will be added to each specified route table, which will state the service as the destination and the endpoint as the target.

Below route table directs all Internet traffic (0.0.0.0/0) to an IGW. Any traffic destined to another service will also be sent to the IGW in order to reach that service.

| Destination | Target       |
| :---------- | :----------- |
| 10.0.0.0/16 | Local        |
| 0.0.0.0/0   | igw-1a2b3c4d |

Below route table adds the route to direct S3 traffic to the VPC Endpoint

| Destination     | Target            |
| :----------     | :-----------      |
| 10.0.0.0/16     | Local             |
| 0.0.0.0/0       | igw-1a2b3c4d      |
| **p1-1a2b3c4d** | **vpce-1a2b3c4d** |

### Peering

* An VPC peering connection is a networking connection between two VPCs that enables instances in either VPC to communicate with each other as if they are within the same network.
* Peering connection can be created
	* between your own VPCs or
	* with an VPC in another AWS account within a single region.
* A peering connection is neither a gateway nor an Amazon VPN connection and does not introduce a single point of failure for communication.
* Peering connections are created through a _request/accept_ protocol. The owner of the requesting VPC sends a request to peer to the owner of the peer VPC.
	* If the peer VPC is within the same account, it is identified by its _VPC ID_.
	* If the peer VPC is within a different account, it is identified by _Account ID_ and _VPC ID_.
* The owner of the peer VPC has one week to accept or reject the request before it expires.
* A VPC may have multiple peering connections, and peering is a one-to-one relationship between VPC.
* Peering connections DO NOT support _transitive routing_. In other words, if there are peering connections between VPC A & B, and VPC B & C, it does NOT mean VPC A & C can peer directly with each other.
* A peering connection CANNOT be created between VPCs that have matching or overlapping CIDR blocks.
* A peering connection CANNOT be created between VPCs in different regions.
* There CANNOT have more than one peering connection between the same two VPCs at the same time.

### Security Groups

* A security group is a virtual stateful firewall that controls inbound and outbound network traffic to AWS resources and EC2 instances.
* All EC2 instances MUST be launched into a security group.
* __Default Security Group__
	* If an SG is not specified at launch, then the instance will be launched into the _default SG_ for the VPC.
	* The default SG allows communication between all resources within the security group,
		* allows all outbound traffic, and
		* denies all other traffic.
	* Default SG CANNOT be deleted.
	* Rules in default SG can be changed.
* Up to 500 SGs can be created per VPC.
* Up to 50 inbound and 50 outbound rules can be added per SG.
* Up to 5 SGs can be associated per Network Interface.
* To apply more than 100 rules to an instance, associate multiple SGs.
* You can specify _allow rules_, but NOT _deny rules_. This is an important difference between SGs and ACLs.
* can specify separate rules for inbound and outbound traffic.
* By default, no inbound traffic is allowed until added.
* By default, new SGs have an outbound rule that allows all outbound traffic. You can remove the rule and add your custom rules.
* SGs are stateful. This means that responses to allowed inbound traffic are allowed to flow outbound regardless of outbound rules and vice versa. This is an important difference between security groups and network ACLs.
* Instances associated with the same security group CANNOT talk to each other unless you add rules allowing it (with the exception being the default security group).
* SGs associated with an instance can be changed after launch, and changes will take effect immediately.

__Sample Security Group__

__Inbound__

| Inbound | Source     | Protocol | Port Range | Comments |
| :-------| :----------| :------- | :----------| :--------|
|         | sg-xxxxxxxx| All      | All | Allow inbound traffic from instances within the same SG |
|         | 0.0.0.0/0  | TCP      | 8   | Allow inbound traffic from the Internet port 80 |

| Outbound | Destination | Protocol | Port Range | Comments |
| :------- | :-----------| :--------| :----------| :--------|
|          | 0.0.0.0/0   | All      | All | Allow all outbound traffic |


### Network ACLs (Access Control Lists)

* ACL is a stateless firewall on a subnet level.
* This is another layer of security in addition to SGs.
* A network ACL is a numbered list of rules that AWS evaluates in order, starting with the lowest numbered rule, to determine whether traffic is allowed in or out of any subnet associated with the network ACL.
* VPCs are created with a modifiable default network ACL associated with every subnet that allows all inbound and outbound traffic.
* When you create a custom network ACL, its initial configuration will deny all inbound and outbound traffic
* You may set up network ACLs with rules similar to your security groups in order to add a layer of security to your VPC, or you may choose to use the default network ACL that does not filter traffic traversing the subnet boundary.
* Overall, every subnet must be associated with a network ACL.

| Security Group | Network ACL     |
| :------------- | :------------- |
| Operates at the instance level (1st layer of defense) | Operates at the subnet level (2nd layer of defense) |
| Supports _allow_ rules only | Supports both _allow_ and _deny_ rules |
| Stateful firewall: Return traffic automatically allowed | Stateless firewall: Return traffic must be explicitly allowed by rules |
| AWS evaluates all rules before deciding whether to allow traffic | AWS processes rules in number order when deciding whether to allow traffic |
| Applied selectively to individual instances | Automatically applied to all instances in the associated subnets; this is a backup layer of defense, so you don't have to rely on someone specifying the security group |

### NAT Instances (Network Address Translation)

* NAT instances and NAT gateways allow instances deployed in private subnets to gain Internet access.
* By default, any instance that you launch into a private subnet in an VPC is not able to communicate with the Internet through the IGW.
* NAT instance is an Amazon Linux AMI designed to accept traffic from instances within a private subnet, translate the source IP address to the public IP address of the NAT instance, and forward the traffic to the IGW.
* In addition, the NAT instance maintains the state of the forwarded traffic in order to return response traffic from the Internet to the proper instance in the private subnet.
* These instances have the string `amzn-ami-vpc-nat` in their names, which is searchable in the EC2 console.
* To allow instances within a private subnet to access Internet resources through the IGW via a NAT instance, you must do the following:
	* Create a security group for the NAT with outbound rules that specify the needed Internet resources by port, protocol, and IP address.
	* Launch an Amazon Linux NAT AMI as an instance in a public subnet and associate it with the NAT security group.
	* Disable the Source/Destination Check attribute of the NAT.
	* Configure the route table associated with a private subnet to direct Internet-bound traffic to the NAT instance (for example, i-1a2b3c4d).
	* Allocate an EIP and associate it with the NAT instance.
	* This configuration allows instances in private subnets to send outbound Internet communication, but it prevents the instances from receiving inbound traffic initiated by someone on the Internet.

### NAT Gateways

* A NAT gateway is an Amazon managed resource that is designed to operate just like a NAT instance, but it is simpler to manage, requires less administrative effort and highly available within an Availability Zone.
* For common use cases, use a NAT gateway instead of a NAT instance.
* To allow instances within a private subnet to access Internet resources through the IGW via a NAT gateway, you must do the following:
	* Configure the route table associated with the private subnet to direct Internet-bound traffic to the NAT gateway (for example, nat-1a2b3c4d).
	* Allocate an EIP and associate it with the NAT gateway.
* Like a NAT instance, this managed service allows outbound Internet communication and prevents the instances from receiving inbound traffic initiated by someone on the Internet.
* To create an Availability Zone-independent architecture, create a NAT gateway in each Availability Zone and configure your routing to ensure that resources use the NAT gateway in the same Availability Zone.

### VPGs, CGWs and VPNs

{% img right /technology/aws-vpg-vpn.PNG %}

* VPC offers two ways to connect a corporate network to a VPC: VPG and CGW.
* __VPG (Virtual Private Gateway)__
	* is the virtual private network (VPN) concentrator on the AWS side of the VPN connection between the two networks.
	* The VPG is the AWS end of the VPN tunnel.
	* VPGs support both dynamic routing with _Border Gateway Protocol (BGP)_ and static routing.
* __Customer gateway (CGW)__
	* The CGW is a hardware or software application on the customer’s side of the VPN tunnel.
	* VPC will provide the information needed by the network administrator to configure the CGW and establish the VPN connection with the VPG.
	* VPC also supports multiple CGWs, each having a VPN connection to a single VPG (many-to-one design). In order to support this topology, the CGW IP addresses must be unique within the region.
* __Virtual Private Network (VPN)__
	* After these VPG and CGW are created, the last step is to create a VPN tunnel.
	* VPN tunnel MUST be initiated from the CGW to the VPG.
	* You must specify the type of routing that you plan to use when you create a VPN connection.
		* If the CGW supports _Border Gateway Protocol (BGP)_, then configure the VPN connection for dynamic routing.
		* Otherwise, configure the connections for static routing. If you will be using static routing, you must enter the routes for your network that should be communicated to the VPG. Routes will be propagated to the VPC to allow your resources to route network traffic back to the corporate network through the VGW and across the VPN tunnel.
	* The VPN connection consists of two _Internet Protocol Security (IPSec)_ tunnels for higher availability to the VPC.

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
* CloudWatch is a service that you can use to monitor your AWS resources and your applications in real time.
* With CloudWatch, you can collect and track metrics, create alarms that send notifications, and make changes to the resources being monitored based on rules you define.
* For example, you might choose to monitor CPU utilization to decide when to add or remove EC2 instances in an application tier. Or, if a particular application-specific metric that is not visible to AWS is the best indicator for assessing your scaling needs, you can perform a PUT request to push that metric into CloudWatch.
* You can then use this custom metric to manage capacity.
* You can specify parameters for a metric over a time period and configure alarms and automated actions when a threshold is reached. CloudWatch supports multiple types of actions such as sending a notification to an SNS topic or executing an Auto Scaling policy.
* CloudWatch offers either basic or detailed monitoring for supported AWS products. Basic monitoring sends data points to CloudWatch every five minutes for a limited number of preselected metrics at no charge.

* _Detailed monitoring_ sends data points to CloudWatch every minute and allows data aggregation for an additional charge. If you want to use detailed monitoring, you must enable it—basic is the default.

* __Read Alert__
	* You may have an application that leverages DynamoDB, and you want to know when read requests reach a certain threshold and alert yourself with an email. You can do this by using `ProvisionedReadCapacityUnits` for the DynamoDB table for which you want to set an alarm. You simply set a threshold value during a number of consecutive periods and then specify email as the notification type. Now, when the threshold is sustained over the number of periods, your specified email will alert you to the read activity.
* CloudWatch metrics can be retrieved by performing a GET request. When you use detailed monitoring, you can also aggregate metrics across a length of time you specify. CloudWatch does not aggregate data across regions but can aggregate across Availability Zones within a region.
* AWS provides a rich set of metrics included with each service, but you can also define custom metrics to monitor resources and events AWS does not have visibility into—for example, EC2 instance memory consumption and disk metrics that are visible to the operating system of the EC2 instance but not visible to AWS or application-specific thresholds running on instances that are not known to AWS. CloudWatch supports an API that allows programs and scripts to PUT metrics into CloudWatch as name-value pairs that can then be used to create events and trigger alarms in the same manner as the default CloudWatch metrics.
* CloudWatch Logs can be used to monitor, store, and access log files from EC2 instances, AWS CloudTrail, and other sources. You can then retrieve the log data and monitor in real time for events—for example, you can track the number of errors in your application logs and send a notification if an error rate exceeds a threshold. CloudWatch Logs can also be used to store your logs in S3 or Glacier. Logs can be retained indefinitely or according to an aging policy that will delete older logs as no longer needed.
* A CloudWatch Logs agent is available that provides an automated way to send log data to CloudWatch Logs for EC2 instances running Amazon Linux or Ubuntu. You can use the CloudWatch Logs agent installer on an existing EC2 instance to install and configure the CloudWatch Logs agent. After installation is complete, the agent confirms that it has started and it stays running until you disable it.
* CloudWatch has some limits that you should keep in mind when using the service. Each AWS account is limited to _5,000 alarms per AWS account_, and metrics data is retained for two weeks by default (at the time of this writing). If you want to keep the data longer, you will need to move the logs to a persistent store like S3 or Glacier. You should familiarize yourself with the limits for CloudWatch in the CloudWatch Developer Guide.

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

* IAM uses traditional identity concepts such as users, groups, and access control policies to control who can use, what services/resources, and how.
* Provides granular control to limit a single user to the ability to perform
	* a single action
	* on a specific resource
	* from a specific IP address
	* during a specific time window.
* Access can be granted whether they are running on-premises or in the cloud.

* __IAM is not an identity store/authorization system__
	* Permissions are to manipulate AWS infrastructure, not for your application.
	* This is not a replacement to your on-premises application authentication/authorization.
	* If your application identities are based on Active Directory, your on-premises Active Directory can be extended into the cloud.
	* _AWS Directory Service_ is an Active Directory-compatible directory service that can work on its own or integrate with on-premises Active Directory.
	* For mobile app, consider _Amazon Cognito_ for identity management
* __IAM is not operating system identity management__
	* Under the shared responsibility model, you are in control of your operating system console and configuration. Whatever mechanism you currently use to control access to your server infrastructure will continue to work on EC2 instances, whether that is managing individual machine login accounts or a directory service such as Active Directory or LDAP.
	* You can run an Active Directory or LDAP server on EC2, or you can extend your on-premises system into the cloud.
	* AWS Directory Service will also work well to provide Active Directory functionality in the cloud as a service, whether standalone or integrated with your existing Active Directory.

* Authentication Technologies
	* For OS Access - use	Active Directory LDAP Machine-specific accounts
	* For Application Access - use User Repositories
	* For Mobile apps - Amazon Cognito
	* For AWS Resources - use	IAM

* IAM is controlled through AWS Console, CLI and via AWS SDKs. In addition, the AWS Partner Network (APN) includes a rich ecosystem of tools to manage and extend IAM.

### Principals

* A principal is an IAM entity that is allowed to interact with AWS resources.
* A principal can be permanent or temporary, and it can represent a human or an application.
* 3 types of principals: root users, IAM users, and roles/temporary security tokens.

* __1. Root User__
	* Root user is automatically created when creating a new AWS account.
	* With single sign-in principal, root user has complete access to all AWS Cloud services and resources in the account.
	* Root user persists as long as the account is open
	* Root user can be used for both console and programmatic access to AWS resources.
	* Best practice: DO NOT use the root user for everyday tasks, even the administrative ones. Instead, use it only to create the first IAM user and then securely lock away the root user credentials.
* __2. IAM Users__
	* Users are persistent identities set up through the IAM service to represent individual people or applications.
	* IAM users can be created by principals with IAM administrative privileges.
	* Users are permanent entities until an IAM admin deletes them - no expiration period
	* Users are an excellent way to enforce the _principle of least privilege_; i.e., the concept of allowing a person or process interacting with AWS resources to perform exactly the tasks they need but nothing else.
	* Users can be associated with very granular policies that define permissions.
* __3. Roles/Temporary Security Tokens__
	* Roles are used to grant specific privileges to specific actors for a set duration of time.
	* Actors can be authenticated by AWS or some trusted external system.
	* When one of the actors assumes a role, AWS provides the actor with a temporary security token from the AWS Security Token Service (STS) that the actor can use to access AWS Cloud services.
	* Requesting a temporary security token requires specifying how long the token will exist before it expires. The range of a temporary security token lifetime is 15 minutes to 36 hours.
	* Roles and temporary security tokens enable a number of use cases:
	* ___3a. Amazon EC2 Roles___
		* Grant permissions to applications running on EC2 instance.
		* Granting permissions to an application is always tricky, as it usually requires configuring the application with some sort of credential upon installation. This leads to issues around securely storing the credential prior to use, how to access it safely during installation, and how to secure it in the configuration.
		* Suppose that an application running on an EC2 instance needs to access an S3 bucket.
			* A policy granting permission to read and write that bucket can be created and assigned to an IAM user, and the application can use the access key for that IAM user to access the S3 bucket.
			* The problem with this approach is that the access key for the user must be accessible to the application, probably by storing it in some sort of configuration file.
			* The process for obtaining the access key and storing it encrypted in the configuration is usually complicated and a hindrance to agile development.
			* Additionally, the access key is at risk when being passed around. Finally, when the time comes to rotate the access key, the rotation involves performing that whole process again.
		* Using IAM roles for Amazon EC2 removes the need to store AWS credentials in a configuration file.
		* Alternative solution
			* Create an IAM role that grants the required access to the S3 bucket.
			* When the Amazon EC2 instance is launched, the role is assigned to the instance.
			* When the application running on the instance uses the API to access the S3 bucket, it assumes the role assigned to the instance and obtains a temporary token that it sends to the API.
			* The process of obtaining the temporary token and passing it to the API is handled automatically by most of the AWS SDKs, allowing the application to make a call to access the S3 bucket without worrying about authentication.
			* This removes any need to store an access key in a configuration file.
			* Also, because the API access uses a temporary token, there is no fixed access key that must be rotated.
	* ___3b. Cross-Account Access___
		* Grant permissions to users from other AWS accounts, whether you control those accounts or not.
		* Common use case for IAM roles is to grant access to AWS resources to IAM users in other AWS accounts. These accounts may be other AWS accounts controlled by your company or outside agents like customers or suppliers.
		* Set up an IAM role with the permissions you want to grant to users in the other account, then users in the other account can assume that role to access your resources.
		* This is highly recommended as a best practice, as opposed to distributing access keys outside your organization.
	* ___3c. Federation___
		* Grant permissions to users authenticated by a trusted external system.
		* Many organizations already have an identity repository outside of AWS and would rather leverage that repository than create a new and largely duplicate repository of IAM users.
		* Similarly, web-based applications may want to leverage web-based identities such as Facebook, Google, or Login with Amazon.
		* _IAM Identity Providers_ provide the ability to federate these outside identities with IAM and assign privileges to those users authenticated outside of IAM.
		* __Identity Providers (IdP)__ IAM can integrate with 2 different types of outside Identity providers .
			* _OpenID Connect (OIDC)_
				* For federating web identities such as Facebook, Google, or Login with Amazon, IAM supports integration via OIDC.
				* This allows IAM to grant privileges to users authenticated with some of the major web-based IdPs.
			* _SAML 2.0 (Security Assertion Markup Language)_
				* For federating internal identities, such as Active Directory or LDAP, IAM supports integration via SAML.
				* A SAML-compliant IdP such as Active Directory Federation Services (ADFS) is used to federate the internal directory to IAM.
				* Federation works by returning a temporary token associated with a role to the IdP for the authenticated identity to use for calls to the AWS API.
				* The actual role returned is determined via information received from the IdP, either attributes of the user in the on-premises identity store or the user name and authenticating service of the web identity store.

### Authentication

3 ways that IAM authenticates a principal:

* __User Name/Password__
	* When a principal represents a human interacting with the console, the human will provide a user name/password pair to verify their identity.
	* IAM allows you to create a password policy enforcing password complexity and expiration.
* __Access Key__
	* `Access Key = Access Key ID (20 chars) + Access Secret Key (40 chars)`
	* When a program is manipulating the AWS infrastructure via the API, it will use these values to sign the underlying REST calls to the services.
	* The AWS SDKs and tools handle all the intricacies of signing the REST calls, so using an access key will almost always be a matter of providing the values to the SDK or tool.
* __Access Key/Session Token__
	* When a process operates under an assumed role, the temporary security token provides an access key for authentication.
	* In addition to the access key, the token also includes a session token. Calls to AWS must include both the two-part access key and the session token to authenticate.
	* It is important to note that when an IAM user is created, it has neither an access key nor a password, and the IAM administrator can set up either or both. This adds an extra layer of security in that console users cannot use their credentials to run a program that accesses your AWS infrastructure.

### Authorization

* The process of specifying exactly what actions a principal can and cannot perform is called authorization.
* Authorization is handled in IAM by defining specific privileges in policies and associating those policies with principals.

* __Policies__
	* A policy is a JSON document that fully defines a set of permissions to access and manipulate AWS resources.
	* Policy documents contain one or more permissions, with each permission defining:
		* _Effect_: A single word: Allow or Deny.
		* _Service_: For what service does this permission apply? Most AWS Cloud services support granting access through IAM, including IAM itself.
		* _Resource_:
			* The resource value specifies the specific AWS infrastructure for which this permission applies. This is specified as an ___Amazon Resource Name (ARN)___.
			* The format for an ARN varies slightly between services, but the basic format is: `arn:aws:service:region:account-id:[resourcetype:]resource`
			* For some services, wildcard values are allowed; for instance, an S3 ARN could have a resource of `foldername\*` to indicate all objects in the specified folder.
			* Sample ARN
				* Amazon S3 Bucket:	`arn:aws:s3:us-east-1:123456789012:my_corporate_bucket/*`
				* IAM User:	`arn:aws:iam:us-east-1:123456789012:user/David`
				* Amazon DynamoDB Table:	`arn:aws:dynamodb:us-east-1:123456789012:table/tablename`
		* _Action_:
			* The action value specifies the subset of actions within a service that the permission allows or denies. For instance, a permission may grant access to any read-based action for S3.
			* A set of actions can be specified with an enumerated list or by using wildcards (Read*).
		* _Condition_:
			* The condition value optionally defines one or more additional restrictions that limit the actions allowed by the permission.
			* For instance, the permission might contain a condition that limits the ability to access a resource to calls that come from a specific IP address range.
			* Another condition could restrict the permission only to apply during a specific time interval.
			* A sample policy is shown in the following listing. This policy allows a principal to list the objects in a specific bucket and to retrieve those objects, but only if the call comes from a specific IP address.

```js
{
	"Version": "2012–10–17",
	"Statement": [
		{
			"Sid": "Stmt1441716043000",
			"Effect": "Allow",
			"Action": [ "s3:GetObject", "s3:ListBucket"],
			"Condition": {
				"IpAddress": {
					"aws:SourceIp": "192.168.0.1"
				}
			},
			"Resource": [
				"arn:aws:s3:::my_public_bucket/*"
			]
		}
	]
}
```

__Associating Policies with Principals__

* A policy can be associated directly with an IAM user in one of two ways:
	* _User Policy_:
		* These policies exist only in the context of the user to which they are attached.
		* In the console, a user policy is entered into the user interface on the IAM user page.
	* _Managed Policies_:
		* Policies are created in the 'Policies' tab on the IAM page and exist independently of any individual user.
		* Same policy can be associated with many users or groups of users.
		* There are a large number of predefined managed policies on the Policies tab of the IAM page in the AWS Console.
		* You can write your own policies specific to your use cases.
		* * Using predefined managed policies ensures that when new permissions are added for new features, your users will still have the correct access.

__IAM Groups__

* Common method for associating policies with users is with the IAM groups feature.
* Groups simplify managing permissions for large numbers of users.
* After a policy is assigned to a group, any user who is a member of that group assumes those permissions.
* This is a much simpler management process than having to review what policies a new IAM user for the operations team should receive and manually adding those policies to the user.
* 2 ways a policy can be associated with an IAM group:
	* _Group Policy_
		* These policies exist only in the context of the group to which they are attached.
		* In the AWS Console, a group policy is entered into the user interface on the IAM Group page.
	* _Managed Policies_
		* can be associated with IAM users and IAM groups.
		* A good first step is to use the root user to create a new IAM group called “IAM Administrators” and assign the managed policy, “IAMFullAccess.”
		* Then create a new IAM user called “Administrator,” assign a password, and add it to the IAM Administrators group. At this point, you can log off as the root user and perform all further administration with the IAM user account.

__Assuming a role__

The final way an actor can be associated with a policy is by assuming a role. In this case, the actor can be:

* An authenticated IAM user (person or process). In this case, the IAM user must have the rights to assume the role.
* A person or process authenticated by a trusted service outside of AWS, such as an on-premises LDAP directory or a web authentication service. In this situation, an AWS Cloud service will assume the role on the actor’s behalf and return a token to the actor.

After an actor has assumed a role, it is provided with a temporary security token associated with the policies of that role. The token contains all the information required to authenticate API calls. This information includes a standard access key plus an additional session token required for authenticating calls under an assumed role.

### Other Key Features

Beyond the critical concepts of principals, authentication, and authorization, there are several other features of the IAM service that are important to understand to realize the full benefits of IAM.

__Multi-Factor Authentication (MFA)__

* MFA adds an extra layer of security to your infrastructure by adding a second method of authentication beyond just a password or access key.
* With MFA, authentication also requires entering a _One-Time Password (OTP)_ from a small device. The MFA device can be either a small hardware device you carry with you or a virtual device via an app on your smart phone (for example, the AWS Virtual MFA app).
* MFA requires you to verify your identity with both __something you know__ and __something you have__.
* MFA can be assigned to any IAM user account, whether the account represents a person or application.
* When a person using an IAM user configured with MFA attempts to access the AWS  Console, after providing their password they will be prompted to enter the current code displayed on their MFA device before being granted access. An application using an IAM user configured with MFA must query the application user to provide the current code, which the application will then pass to the API.

__Rotating Keys__

* It is a security best practice to rotate access keys associated with your IAM users.
* IAM facilitates this process by allowing two active access keys at a time.
* The process to rotate keys can be conducted via the console, CLI, or SDKs:
	* Create a new access key for the user.
	* Reconfigure all applications to use the new access key.
	* Disable the original access key (disabling instead of deleting at this stage is critical, as it allows rollback to the original key if there are issues with the rotation).
	* Verify the operation of all applications.
	* Delete the original access key.
* Access keys should be rotated on a regular schedule.

__Resolving Multiple Permissions__

Occasionally, multiple permissions will be applicable when determining whether a principal has the privilege to perform some action. These permissions may come from multiple policies associated with a principal or resource policies attached to the AWS resource in question. It is important to know how conflicts between these permissions are resolved:

* Initially the request is denied by default.
* All the appropriate policies are evaluated; if there is an explicit “deny” found in any policy, the request is denied and evaluation stops.
* If no explicit “deny” is found and an explicit “allow” is found in any policy, the request is allowed.
* If there are no explicit “allow” or “deny” permissions found, then the default “deny” is maintained and the request is denied.

The only exception to this rule is if an _AssumeRole_ call includes a role and a policy, the policy cannot expand the privileges of the role (for example, the policy cannot override any permission that is denied by default in the role).

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

* Network perimeter - a boundary between two or more portions of a network. It can refer to the boundary between your VPC and your network, it could refer to the boundary between what you manage versus what AWS manages.
* WAF (Web Application Firewall)


* NAT (Network Address Translation) instances and NAT Gateways - allows EC2 instances deployed in private subnets to gain Internet access


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
