---
layout: page
title: "Cloud Computing"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}


# Benefits & Risks

* **Benefits**
	* Cost effective
	* No software installation required
	* High efficiency, reliability & flexibility
	* On-demand self-service
	* Online development & deployment
* **Risks**
	* *Security & Privacy* - any security breach may compromise sensitive customer data
	* *Lock-In* - difficult for clients to switch from one Cloud Service Provider (CSP) to another
	* *Isolation Failure* - failure of isolation mechanism that separates storage, memory, and routing between the different tenants.

# Deployment Models

* **Public Cloud**
	* The public cloud allows systems and services to be easily accessible to the general public. Public cloud may be less secure because of its openness.
* **Private Cloud**
	* The private cloud allows systems and services to be accessible within an organization. It is more secured because of its private nature.
* **Community Cloud**
	* The community cloud allows systems and services to be accessible by a group of organizations.
* **Hybrid Cloud**
	* The hybrid cloud is a mixture of public and private cloud, in which the critical activities are performed using private cloud while the non-critical activities are performed using public cloud.

# Service Models

{% img right /technology/cloud-computing-service-models.jpg %}

## Infrastructure-as–a-Service (IaaS)

* IaaS is the most basic level of service. Each of the service models inherit the security and management mechanism from the underlying model, as shown in the following diagram
* E.g., physical machines, virtual machines, virtual storage, etc.

## Platform-as-a-Service (PaaS)

* PaaS provides the runtime environment for applications, development and deployment tools, etc.

## Software-as-a-Service (SaaS)

* SaaS model allows to use software applications as a service to end-users.
* E.g., Gmail, Google Docs
* Modes of SaaS
	* Software as a Service provides cloud application platform on which user can create application with the tools provided. 
	* The modes of software as a service are defined as:
		* **Simple multi-tenancy**: in this each user has its own resources that are different from other users. It is an inefficient mode where the user has to put more time and money to add more infrastructure if the demand rises in less time to deliver. 
		* **Fine grain multi-tenancy**: in this the functionality remains the same that the resources can be shared to many. But it is more efficient as the resources are shared not the data and permission within an application.

## Anything-as-a-Service (XaaS)

Anything-as-a-Service (XaaS) is yet another service model, which includes *Network-as-a-Service*, *Business-as-a-Service*, *Identity-as-a-Service*, *Database-as-a-Service* or *Strategy-as-a-Service*.

# Characteristics

* **On Demand Self Service**
	* Cloud Computing allows the users to use web services and resources on demand. One can logon to a website at any time and use them.
* **Broad Network Access**
	* Since cloud computing is completely web based, it can be accessed from anywhere and at any time.
* **Resource Pooling**
	* Cloud computing allows multiple tenants to share a pool of resources. One can share single physical instance of hardware, database and basic infrastructure.
* **Rapid Elasticity**
	* It is very easy to scale the resources vertically or horizontally at any time. Scaling of resources means the ability of resources to deal with increasing or decreasing demand.
	* The resources being used by customers at any given point of time are automatically monitored.
* **Measured Service**
	* In this service cloud provider controls and monitors all the aspects of cloud service. Resource optimization, billing, and capacity planning etc. depend on it.

# VMs Vs Containers

## Hypervisor

* The hypervisor sits in between the physical machine and virtual machines and provides virtualization services to the virtual machines. It intercepts the guest operating system operations on the virtual machines and emulates the operation on the host machine's operating system.
* The hypervisor handles creating the virtual environment on which the guest virtual machines operate. 
* It supervises the guest systems and makes sure that resources are allocated to the guests as necessary. 
* The rapid development of virtualization technologies has driven the use of virtualization further by allowing multiple virtual servers to be created on a single physical server with the help of hypervisors, such as Xen, VMware Player, KVM, etc., and incorporation of hardware support in commodity processors, such as Intel VT and AMD-V.


{% img right /technology/vm-vs-container.jpg %}

Virtualization improves system utilization, decoupling applications from the underlying hardware, and enhancing workload mobility and protection.


Hypervisors and VMs are just one approach to virtual workload deployment. Container virtualization is quickly emerging as an efficient and reliable alternative to traditional virtualization, providing new features and new concerns for data center professionals.

## VMs

* VMs is primarily in the location of the virtualization layer and the way that OS resources are used.
* VMs rely on a hypervisor which is normally installed atop the actual *bare metal* system hardware. This has led to hypervisors being perceived as operating systems in their own right. Once the hypervisor layer is installed, VM instances can be provisioned from the system’s available computing resources. Each VM can then receive its own unique operating system and workload (application).
* *Isolation* - A full virtualized system gets its own set of resources allocated to it, and does minimal sharing. You get more isolation, but it is much heavier (requires more resources). VMs are fully isolated from one another – no VM is aware of (or relies on) the presence of another VM on the same system – and malware, application crashes and other problems impact only the affected VM. 
* VMs can be migrated from one virtualized system to another without regard for the system’s hardware or operating systems.

## Containers

* With containers, a host operating system is installed on the system first, and then a container layer (such as LXC or libcontainer) is installed atop the host OS which is usually a Linux variant.
* Once the container layer is installed, container instances can be provisioned from the system’s available computing resources and enterprise applications can be deployed within the containers. However, every containerized application shares the same underlying operating system (the single host OS).
* *Isolation* - With containers (like Docker using LXC) you get less isolation, but they are more lightweight and require less resources. So you could easily run 1000's on a host, and it doesn't even blink.
* Containers are regarded as more resource-efficient than VMs because the additional resources needed for each OS is eliminated – the resulting instances are smaller and faster to create or migrate. This means a single system can potentially host far more containers than VMs. Cloud providers are particularly enthusiastic about containers because far more container instances can be deployed across the same hardware investment. However, the single OS presents a single point of failure for all of the containers that use it. For example, a malware attack or crash of the host OS can disable or impact all of the containers. In addition, containers are easy to migrate, but can only be migrated to other servers with compatible operating system kernels (potentially limiting migration options).


# FAQs

* Difference between scalability and elasticity?
	* Scalability is a characteristic of cloud computing through which increasing workload can be handled by increasing in proportion the amount of resource capacity. It allows the architecture to provide on demand resources if the requirement is being raised by the traffic. 
	* Whereas, elasticity is being one of the characteristic provide the concept of commissioning and decommissioning of large amount of resource capacity dynamically. It is measured by the speed by which the resources are coming on demand and the usage of the resources. Elasticity is reversible scability
* Cloudbursting
	* A hybrid approach where many compute resources are kept private internally but when additional demand is needed, a public cloud is called upon to provide those temporary resources. This is called “Cloudbursting”
* What are the things to do to migrate an application to cloud? or How do you design an application to be cloud-native?

# Tools

* [Simian Army](http://techblog.netflix.com/2011/07/netflix-simian-army.html)
  * [Chaos monkey](http://techblog.netflix.com/2012/07/chaos-monkey-released-into-wild.html) - Self-healing system

