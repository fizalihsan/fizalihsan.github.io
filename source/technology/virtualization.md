---
layout: page
title: "Virtualization"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

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


# Docker

* __Images__
	* Images are the basis of the containers - Images are pulled from the registry
	* Base & Child Images
		* ***Base*** images are images that have no parent image, usually images with an OS like ubuntu, busybox or debian.
		* ***Child*** images are images that build on base images and add additional functionality.
	* Official and User Images
		* ***Official*** images are images that are officially maintained and supported by the folks at Docker. These are typically one word long. In the list of images above, the python, ubuntu, busybox and hello-world images are base images.
		* ***User*** images are images created and shared by users like you and me. They build on base images and add additional functionality. Typically, these are formatted as user/image-name.
	* Onbuild images
* `Docker File --input---> Docker Client --output--> Docker image`

## Command Reference

* `docker help`
* `docker version`
* `docker-machine version`
* `docker-compose version`
* `docker run hello-world`
* `docker pull busybox`
	* pulls the `busybox` image from Docker Registry and saves it in the system. Since the `TAG` name is not provided it pulls the `latest` by default
	* to pull a particular tag version `docker pull ubuntu:12.04`
* `docker images` to view the images
* `docker run busybox`
	* Docker client finds the image locally. If not found, pulls from registry
	* loads up the container
	* runs a command in that container (command not provided here)
	* exited
* `docker run busybox echo 'Welcome to Docker'`
* `docker run -it busybox sh` - `it` starts an interactive tty terminal to the container
* `docker ps` shows all the containers that are running
	* `docker ps -a` shows containers that exited in the past
* `docker rm <container_id>` clean up the container
	* `docker rm $(docker ps -a -q -f status=exited)` clean up all the exited containers
* `docker rmi` to delete an image
* `docker run -d -P --name <container_name> prakhar1989/static-site`
	* `-d` detaches the container from the terminal from which it was started
	* `-P` publishes all exposed ports to random ports
	* `--name` name of the container
* `docker port <container>` - to see the ports
* `docker run -p 8888:80 prakhar1989/static-site` - to specify custom ports
* `docker stop <container_id>` - to stop a detached container
* `docker search <image>` searches the Docker Hub for given image name
* `docker login` - stores the login credentials to http://hub.docker.com in `~/.docker/config.json`
* `docker push <user/image>` - publishes your image to Docker hub. Once published, it can be viewed at https://hub.docker.com/r/<user>/<image>/

## Vocabulary

* __Images__ - The blueprints of our application which form the basis of containers.
* __Containers__ - Created from Docker images and run the actual application.
* __Docker Daemon__ - The background service running on the host that manages building, running and distributing Docker containers. The daemon is the process that runs in the operation system to which clients talk to.
* __Docker Client__ - The command line tool that allows the user to interact with the daemon. More generally, there can be other forms of clients too - such as ***Kitematic*** which provide a GUI to the users.
* __Docker Hub__ - A registry of Docker images. You can think of the registry as a directory of all available Docker images. If required, one can host their own Docker registries and can use them for pulling images.

## Docker flow explained

{% img /technology/docker-flow.png right %}

This sections explains what happens when user enters the command `docker run hello-world` in the terminal.

* The Docker client contacts the Docker daemon.
* The Docker daemon pulls the "hello-world" image from the Docker Hub. 
* If not available in Hub, then it is pulled from Docker Store
* The Docker daemon creates a new container from that image within the Docker machine. It then runs the executable that produces the output.
* The Docker daemon streams that output to the Docker client, which sent it to your terminal.

## Questions

* When we build docker images, where are the images stored?
* 

# References

* Books
	* Mastering Docker
	* Using Docker