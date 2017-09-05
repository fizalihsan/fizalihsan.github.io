---
layout: page
title: "Virtualization"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Overview

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

* Containers are an encapsulation of an application with its dependencies.
* Containers share resources with the host OS and hence lighter than VMs.
* Containers can be started and stopped in a fraction of a second.
* Containers eliminate a whole class of bugs caused by environment changes- 'it runs in my machine' 

# Docker

## Docker flow explained

{% img /technology/docker-flow.png right %}

What happens when `docker run hello-world` is executed.

* The Docker client contacts the Docker daemon.
* The Docker daemon pulls the "hello-world" image from the Docker Hub. 
* If not available in Hub, then it is pulled from Docker Store
* The Docker daemon creates a new container from that image within the Docker machine. It then runs the executable that produces the output.
* The Docker daemon streams that output to the Docker client, which sent it to your terminal.

## Concepts

* `Docker File --input---> [Docker Client] --output--> Docker image`
* __Images__
	* Images are the basis of the containers - Images are pulled from the registry
	* ***Base*** images are images that have no parent image, usually images with an OS like ubuntu, busybox or debian.
	* ***Child*** images are images that build on base images and add additional functionality.
	* ***Official*** images are images that are officially maintained and supported by the folks at Docker. These are typically one word long. In the list of images above, the python, ubuntu, busybox and hello-world images are base images.
	* ***User*** images are images created and shared by users like you and me. They build on base images and add additional functionality. Typically, these are formatted as user/image-name.
* __Containers__ - Created from Docker images and run the actual application.
* __Docker Daemon__ - The background service running on the host that manages building, running and distributing Docker containers. The daemon is the process that runs in the operation system to which clients talk to.
* __Docker Client__ - The command line tool that allows the user to interact with the daemon. More generally, there can be other forms of clients too - such as ***Kitematic*** which provide a GUI to the users.
* __Docker Hub__ - A registry of Docker images. You can think of the registry as a directory of all available Docker images. If required, one can host their own Docker registries and can use them for pulling images.

### Union File System

{% img right /technology/union-file-system.jpg %}

* Docker uses a union file system (UFS) for containers, which allows multiple filesystems to be mounted in a hierarchy and to appear as a single filesystem. 
* The filesystem from the image has been mounted as a read-only layer, and any changes to the running container are made to a read- write layer mounted on top of this. Because of this, Docker only has to look at the topmost read-write layer to find the changes made to the running system.
* Docker images are made up of multiple layers. Each of these layers is a read-only filesystem. A layer is created for each instruction in a Dockerfile and sits on top of the previous layers. When an image is turned into a container, the Docker engine takes the image and adds a read-write filesystem on top (as well as initializing various settings such as the IP address, name, ID, and resource limits).

### Image Layers

New Docker users are often thrown by the way images are built up. Each instruction in a Dockerfile results in a new image layer, which can also be used to start a con‐ tainer. The new layer is created by starting a container using the image of the previ‐ ous layer, executing the Dockerfile instruction and saving a new image. When a Dockerfile instruction successfully completes, the intermediate container will be deleted, unless the --rm=false argument was given.1 Since each instruction results in an static image—essentially just a filesystem and some metadata—all running pro‐ cesses in the instruction will be stopped. This means that while you can start long- lived processes, such as databases or SSH daemons in a RUN instruction, they will not be running when the next instruction is processed or a container is started. If you want a service or process to start with the container, it must be launched from an ENTRYPOINT or CMD instruction.

### Volumes

* Volumes are files or directories that are directly mounted on the host and not part of the normal UFS. This means they can be shared with other containers and all changes will be made directly to the host filesystem. 
* First way of initializing volume
	* `docker run -it --name container-test -h CONTAINER -v /data debian /bin/bash`
	* This will make the directory `/data` inside the container into a volume. 
	* Any files the image held inside the `/data` directory will be copied into the volume. 
	* We can find out where the volume lives on the host by running this on the host from a new shell: `docker inspect -f {{.Mounts}} container-test`
* Second way
	* `VOLUME /directory`: By default, the directory or file will be mounted on the host inside your Docker installation directory (normally `/var/lib/docker/`).
* Third way
	* `docker run -d -v /host/dir:/container/dir <image>`
	* specifies the host directory to use as the mount. This is not possible from a Dockerfile due to portability and security reasons (the file or directory may not exist in other systems, and containers shouldn’t be able to mount sensitive files like `/etc/passwd` without explicit permission).
	* `docker run -v /home/adrian/data:/data debian ls /data`
		* will mount the directory `/home/adrian/data` on the host as `/data` inside the container. This is commonly known as __bind mount__.
		* Any files already existing in the `/home/adrian/data` directory will be available inside the container. 
		* If the `/data` directory already exists in the container, its contents will be hidden by the volume. 
		* Unlike the first method, no files from the image will be copied into the volume, and the volume won’t be deleted by Docker (i.e., `docker rm -v` will not remove a volume that is mounted at a user-chosen directory).
* Sharing data: `docker run -it -h NEWCONTAINER --volumes-from container-test debian /bin/bash`. 
	* This allows to share the volumes from `container-test` to be shared with the NEWCONTAINER.
	* this works whether or not the container holding the volumes (container-test in this case) is currently running. 
	* As long as at least one existing container links to a volume, it won’t be deleted.


### Plugin Architecture

* Registry
	* Docker Hub, CoreOS Enterprise Registry, Artficatory
* Networking solution
	* Creating network of containers that spans across hosts
	* Solutions: Overlay (integrated solution), Weave, Apache Calico
* Service Discovery
	* Docker containers need to find a way to communicate with other services which could be running on other containers. As containers are dynamically assigned IPs, this is a complex problem.
	* Solutions: etcd, Consul, Registrator, SkyDNS
* Orchestration and cluster management
	* Solutions: Docker Swarm, Google Kubernetes, Marathon (a framework for Mesos), CoreOS’s Fleet, and OpenShift.
* Volumes
	* For integration with other storage systems
	* Solutions: Flocker (a multihost data management and migration tool), and GlusterFS (for distributed storage)
* Operating System
	* minimal and easy-to-maintain distributions that are focused entirely on running con‐ tainers (or containers and VMs), especially within a context of powering a data- centre or cluster.
	* Solutions: Project Atomic, CoreOS, and RancherOS.
* PaaS
	* Solutions: Deis, Flynn, Paz

## Command Reference

__General__

* `docker help`
* `docker version`
* `docker-machine version`
* `docker-compose version`
* `docker login` - stores the login credentials to http://hub.docker.com in `~/.docker/config.json`

__Images__

* `docker images` to view the images
* `docker pull <user/image:tag>`
	* `docker pull busybox` pulls the `busybox` image from Docker Registry and saves it in the system. When 'user' is not provided, it defaults to `root` which is controlled by Docker Inc. When 'tag' name is not provided, it defaults to `latest`.
	* to pull a particular tag version `docker pull ubuntu:12.04`
* `docker rmi` to delete an image
* `docker search <image>` searches the Docker Hub for given image name
* `docker commit <container> <new_image_name>` - to convert a container (stopped/running) into an image
* `docker build <image_name> <Dockerfile_dir>` - to convert a Dockerfile to an image
* `docker push <user/image:tag>` - publishes your image to Docker hub. Once published, it can be viewed at https://hub.docker.com/r/<user>/<image>/
* `docker history <image>` - to view the full set of layers that make up an image

__Containers__

* `docker run hello-world`
	* `docker run busybox`
		* Docker client finds the image locally. If not found, pulls from registry
		* loads up the container
		* runs a command in that container (command not provided here)
		* exited
	* `docker run busybox echo 'Welcome to Docker'`
	* `docker run -it busybox sh` - `it` starts an interactive tty terminal to the container
	* Pass `--rm` flag to delete the container and associated file system when the container exits. 
* `docker logs <container>`
* `docker port <container>` - to see the ports
* `docker ps` shows all the containers that are running
	* `docker ps -a` shows containers that exited in the past
* `docker inspect <container>` - to get the container's details like status, IP addr, etc.
	* `docker inspect <container> --format {{.NetworkSettings.IPAddress}}` - to parse out IP
* `docker diff <container>` - to view the files changed from within the container 
* `docker rm <container_id>` clean up the container
	* `docker rm $(docker ps -a -q -f status=exited)` clean up all the exited containers
* `docker stop <container_id>` - to stop a container. A stopped container retains changes to its settings, meta‐ data, and filesystem, including runtime configuration such as IP address. 
* `docker start <container_id>` - to start a stopped container

__Volumes__

* `docker volume ls` - list the volumes
* `docker run -d -v /host/dir:/container/dir <image>` - to attach a volume to a container
* `docker volume rm $(docker volume ls -qf dangling=true)` - to delete the dangling volumes

## Docker Compose

* Docker Compose is designed to quickly get Docker development environments up and run‐ ning. 
* It uses YAML files to store the configuration for sets of containers, saving developers from repetitive and error-prone typing or rolling their own solution. 
* Compose will free us from the need to maintain our own scripts for orchestration, including starting, linking, updating, and stopping our containers.
* Bunch of containers is called 'services' in Compose lingo

## Questions

* When we build docker images, where are the images stored?
* Best practices
	* combine commands in RUN to reduce image size
	* always use a user in Dockerfile

# References

* Books
	* Mastering Docker
	* Using Docker