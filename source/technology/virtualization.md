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

## Benefits

* Ability to restrict resource utilization by using cgroups technology provided by the Linux Kernel

## Docker flow explained

{% img right /technology/docker-flow.png right 50 50 %}

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
	* *Base* images are images that have no parent image, usually images with an OS like ubuntu, busybox or debian.
	* *Child* images are images that build on base images and add additional functionality.
	* *Official* images are images that are officially maintained and supported by the folks at Docker. These are typically one word long. In the list of images above, the python, ubuntu, busybox and hello-world images are base images.
	* *User* images are images created and shared by users like you and me. They build on base images and add additional functionality. Typically, these are formatted as user/image-name.
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

* Each instruction in a Dockerfile results in a new image layer, which can also be used to start a container. 
* The new layer is created by starting a container using the image of the previ‐ous layer, executing the Dockerfile instruction and saving a new image.
* When a Dockerfile instruction successfully completes, the intermediate container will be deleted, unless the `--rm=false` argument was given.
* Since each instruction results in an static image—essentially just a filesystem and some metadata—all running processes in the instruction will be stopped. This means that while you can start long-lived processes, such as databases or SSH daemons in a `RUN` instruction, they will not be running when the next instruction is processed or a container is started. If you want a service or process to start with the container, it must be launched from an `ENTRYPOINT` or `CMD` instruction.

* DO NOT create containers with passwords baked in
* Files that are removed by subsequent layers in the system are actually still present in the images; they’re just inaccessible
* Each layer is an independent delta from the layer below it. Every time you change a layer, it changes every layer that comes after it. Changing the preceding layers means that they need to be rebuilt, repushed, and repulled to deploy your image to development.

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

# Kubernetes


* For local single node cluster, use minikube
* Kubernetes client
* Kubernetes API server


* Deployments
* Services

## Benefits

* co-location
* resource isolation
* self-healing
* declarative configuration (desired state is defined)
* pods from same application are distributed onto different machines for reliability
* graceful termination of pods for reliability (active requests are completed up to 30 secs)
* effective utilization of the compute nodes in the cluster
* user can define lower and upper limit of resources needed for his app


## Concepts

* Namespaces
	* Kubernetes uses namespaces to organize objects in the cluster. 
	* By default, the kubectl command-line tool interacts with the `default` namespace. It can be overridden by `kubectl --namespace=mystuff`.
* Context
	* To change the default namespace permanently, you can use context.
* Deployment is a way to create an array of Pods
* kubectl
	* command-line utility to interact with the Kubernetes API
	* Everything in Kubernetes is represented by a RESTful resource (also known as _Kubernetes objects_). The kubectl command makes HTTP requests to access the objects. e.g., https://your-k8s.com/api/v1/namespaces/default/pods/my-pod 
	* `kubectl get <resource-name> <object-name>`
	* `kubectl describe <resource-name> <object-name>`
	* configuration file is located at `$HOME/.kube/config` - stores the information on how to find and authenticate to a cluster

## Pods

* Pods represent the atomic unit of work in a Kubernetes cluster. 
* Pods arecomprised of one or more containers working together symbiotically. 
* To create a Pod, you write a Pod manifest and submit it to the Kubernetes API server by using the command-line tool or (less frequently) by making HTTP and JSON calls to the server directly.
* Pods are described in a Pod manifest file - in yaml or json format. They are stored in etcd (persistent storage)
* All containers in a pod always land on the same machine
* Each container within a Pod runs in its own cgroup, but they share a number of Linux namespaces.
* Applications running in the same Pod 
	* share the same IP address and port space (network namespace), 
	* have the same hostname (UTS namespace), 
	* and can communicate using native interprocess communication channels over System V IPC or POSIX message queues (IPC namespace). 
	* Containers in different Pods running on the same node might as well be on different servers.
* Pods don’t move and must be explicitly destroyed and rescheduled.
* ___When to create a pod?___
	* Will these containers work correctly if they land on different machines? If yes, then don't group them in a prod. Else, put them together in a pod. e.g., if all the containers want to share the file system.
* __How a pod is created?__
	* User creates a pod from command-line via kubectl or submitting a manifest file
	* The Kubernetes API server accepts and processes Pod manifests before storing them in persistent storage (etcd). 
	* The scheduler uses the Kubernetes API to find Pods that haven’t been scheduled to a node. 
	* The scheduler then places the Pods onto nodes depending on the resources and other constraints expressed in the Pod manifests. 
	* Multiple Pods can be placed on the same machine as long as there are sufficient resources.
	* `kubelet` daemon is responsible for creating and performing health checks on the pod


__To create a pod directly__

```
# to create a pod
kubectl run kuard --image=gcr.io/kuar-demo/kuard-amd64:1

kubectl get pods

kubectl describe pods kuard

# to access the web server in a container
# a secure tunnel is created from your local machine through the Kubernetes master to the instance of the pod running on one of the worker nodes
kubectl port-forward kuard 8080:8080

# to delete a pod
kubectl delete deployments/kuard
```

__To create a pod via manifest file__

```
# to start a pod
kubectl apply -f manifest.yaml

# to delete a pod by name
kubectl delete pods/pod-name

# to delete a pod by file
kubectl delete -f manifest.yaml

```


__Sample Pod Manifest YAML file__

```
apiVersion: v1
kind: Pod
metadata:  
  name: kuard
  spec:  
    containers:    
      - image: gcr.io/kuar-demo/kuard-amd64:1      
        name: kuard      
        ports:        
          - containerPort: 8080          
            name: http          
            protocol: TCP
```



### Health Check

* __Process health check__
	* Kubernetes _process health check_ ensures that your container is always running. If it isn't K8S restarts it.
	* A simple process check alone is insufficient. If the process is deadlocked, it won't server any requests. To address this, liveness and readiness probes are available.
* __HTTP health check__
	* __Liveness probe__
		* Liveness determines if an application is running properly. 
		* Containers that fail liveness checks are restarted.  
	* __Readiness probe__
		* Readiness describes when a container is ready to serve user requests. 
		* Containers that fail readiness checks are removed from service load balancers. 
* __TCP health check__
	* For non-HTTP based APIs and databases
* __Exec probes__
	* execute a script or program in the context of the container. If this script returns a zero exit code, the probe succeeds; otherwise, it fails. 
	* `exec` scripts are often useful for custom application validation logic that doesn’t fit neatly into an HTTP call.


__Pod manifest sample__

```
apiVersion: v1
kind: Pod
metadata:  
  name: kuard
spec:  
  containers:    
    - image: gcr.io/kuar-demo/kuard-amd64:1      
      name: kuard      
      livenessProbe:        
        httpGet:          
          path: /healthy          
          port: 8080        
        initialDelaySeconds: 5        
        timeoutSeconds: 1        
        periodSeconds: 10        
        failureThreshold: 3      
      ports:         
        - containerPort: 8080          
          name: http          
          protocol: TCP
```


### Resource Management

To ensure the resources are maximally utilized, you can specifiy resource metrics in the manifest. _Requests_ specificy the minimum resource need and _limits_ specify the maximum.


* Minimum required resources
	* With Kubernetes, a Pod requests the resources required to run its containers. Kubernetes guarantees that these resources are available to the Pod. 
	* Resources are requested per container, not per Pod. The total resources requested by the Pod is the sum of all resources requested by all containers in the Pod. The reason for this is that in many cases the different containers have very different CPU requirements
	* Requests are used when scheduling Pods to nodes. The Kubernetes scheduler will ensure that the sum of all requests of all Pods on a node does not exceed the capacity of the node. 
	* K8S supports requested resources like CPU, memory, GPUs and more.
	* CPU request
		* In a 4 CPU core machine, if a container requests for 1 CPU and if that is the only Pod running in that machine, then all the 4 cores are used. If another container of the same request type is added, then each container use 2 CPUs each. When 2 more containers of the same request type is added, then each container get 1 CPU each.
		* CPU requests are implemented using the `cpu-shares` functionality in the Linuxkernel.
	* Memory request
		* Memory requests are handled similarly to CPU, but there is an important difference. 
		* If a container is over its memory request, the OS can’t just remove memory from the process, because it’s been allocated. Consequently, when the system runs out of memory, the kubelet terminates containers whose memory usage is greater than their requested memory. These containers are automatically restarted, but with less available memory on the machine for the container to consume.
* Maximum resource limit
	* Limits specify the maximum limit of resources to use

__Pod manifest sample__

```
apiVersion: v1
kind: Pod
metadata:  
  name: kuard
spec:  
  containers:    
    - image: gcr.io/kuar-demo/kuard-amd64:1      
      name: kuard      
      resources:
        requests:
          cpu: "500m"
          memory: "128Mi"
        limits:
          cpu: "1000m"
          memory: "256Mi"
      ports:         
        - containerPort: 8080          
          name: http          
          protocol: TCP
```

### Persistent Storage

* Many applications are stateful, and as such we must preserve any data and ensure access to the underlying storage volume regardless of what machine the application runs on. This can be achieved using a persistent volume backed by network-attached storage.
* `emptDir` volume
	* An `emptyDir` volume is scoped to the Pod's lifespan, but can be shared between two containers. Useful for caching thumbnails, etc.
* `hostDir` volume
	* Some applications don’t actually need a persistent volume, but they do need some access to the underlying host filesystem. For example, they may need access to the `/dev` filesystem in order to perform raw block-level access to a device on the system. For these cases, Kubernetes supports the hostDir volume, which can mount arbitrary locations on the worker node into the container.
* _Remote network storage volumes_
	* Sometimes you will use a volume for truly persistent data that is independent of the lifespan of a particular Pod, and should move between nodes in the cluster if a node fails or a Pod moves to a different machine for some reason. 
	* To achieve this, Kubernetes supports a wide variety of remote network storage volumes, including widely supported protocols like NFS or iSCSI as well as cloud provider network storage like Amazon’s Elastic Block Store, Azure’s Files and Disk Storage, as well as Google’s Persistent Disk.
* _Persistent Data using Remote Disks_
	* Oftentimes, you want the data a Pod is using to stay with the Pod, even if it is restarted on a different host machine.
	* To achieve this, you can mount a remote network storage volume into your Pod. 
	* When using network-based storage, Kubernetes automatically mounts and unmounts the appropriate storage whenever a Pod using that volume is scheduled onto a particular machine.
	* Kubernetes includes support for standard protocols such as NFS and iSCSI as well as cloud provider–based storage APIs for the major cloud providers (both public and private). In many cases, the cloud providers will also create the disk for you if it doesn’t already exist.

## Labels & Annotations

* __Labels__ 
	* are key/value pairs that can be attached to Kubernetes objects such as Pods and ReplicaSets. 
	* They can be arbitrary, and are useful for attaching identifying information to Kubernetes objects. 
	* Labels are used to identify and optional group objects in a cluster.
* __Annotations__ 
	* annotations are key/value pairs designed to hold non-identifying information that can be leveraged by tools and libraries.
	* While labels are used to identify and group objects, annotations are used to provide extra information about where an object came from, how to use it, or policy around that object.  
	* There is overlap, and it is a matter of taste as to when to use an annotation or a label.  When in doubt, add information to an object as an annotation and promote it to a label if you find yourself wanting to use it in a selector.
	* Where to use?
		* Kubernetes uses this primarily for rolling deployments to track rollout status and provide the necessary information required to roll back a deployment to a previous state.
		* Keep track of a “reason” for the latest update to an object.
		* Extend data about the last tool to update the resource and how it was updated (used for detecting changes by other tools and doing a smart merge).
		* Build, release, or image information that isn’t appropriate for labels (may include a Git hash, timestamp, PR number, etc.).
		* Provide extra data to enhance the visual quality or usability of a UI.  For example, objects could include a link to an icon (or a base64-encoded version of an icon).
	* Where not to use?
		* Users should avoid using the Kubernetes API server as a general-purposedatabase.  Annotations are good for small bits of data that are highlyassociated with a specific resource.  If you want to store data in Kubernetes but you don’t have an obvious object to associate it with, consider storing that data in some other, more appropriate database.



## Cluster components

* All components run in the `kube-system` namespace

* Types
	* __kube-proxy__
		* The Kubernetes proxy is responsible for routing network traffic to load-balanced services in the Kubernetes cluster. 
		* must be present on every node in the cluster. 
		* Kubernetes has an API object named `DaemonSet`, that is used in many clusters to accomplish this. 
	* __kube-dns__
		* Kubernetes also runs a DNS server, which provides naming and discovery for the services that are defined in the cluster. 
		* This DNS server also runs as a replicated service on the cluster. Depending on the size of your cluster, you may see one or more DNS servers running in your cluster. 
		* The DNS service is run as a Kubernetes deployment, which manages these replicas.
		* There is a also a Kubernetes service that performs load-balancing for the DNS server.
		* Check `/etc/resolv.conf` file in a container
	* __kube-dashboard__
		* The UI is run as a single replica, but it is still managed by a Kubernetes deployment for reliability and upgrades.


	* The __controller-manager__ is responsible for running various controllers that regulate behavior in the cluster: for example, ensuring that all of the replicas of a service are available and healthy. 
	* The __scheduler__ is responsible for placing different pods onto different nodes in the cluster. 
	* The __etcd server__ is the storage for the cluster where all of the API objects are stored.
	* Pods running in the cluster
		* _kube-dns_: supplies DNS services for the cluster

* __Node Types__
	* Master node 
		* has containers like the API server, scheduler, etc., which manage the cluster
		* Kubernetes won’t generally schedule work onto master nodes to ensure that user workloads don’t harm the overall operation of the cluster.
	* Worker nodes 
		* where the application containers will run. 

## Services

* A `Service` object is a way to create a named label selector. 
* The `kubernetes` service is automatically created for you so that you can find and talk to the Kubernetes API from within the app.
* How to expose a service?
	* `kubetctl expose <depl>` 
	* creates a new service from a deployment
	* assigns a new type of virtual IP called _cluster IP_ which is a special address the system will load-balance across all of the pods that are identified by the selector.
* Types
	* `Cluster IP` - 
	* `NodePort` - 
	* `LoadBalancer` - 


## Command Reference

* `kubectl version`
* `kubectl cluster-info` - displays the cluster information
* __Get__
	* `kubectl get componentstatuses` - view a simple diagnostic of the cluster
	* `kubectl get nodes` - list out all the nodes in the cluster
	* `kubectl get daemonSets  --namespace=kube-system kube-proxy` - to view proxy
	* `kubectl get services --namespace=kube-system kube-dns` - to view the service that performs load-balancing for the DNS servers
	* `kubectl get deployments --namespace=kube-system kubernetes-dashboard` - to view the UI server
	* `kubectl get services --namespace=kube-system kubernetes-dashboard` - to view the service that performs load-balancing for the dashboard
* __Config__
	* `kubectl config set-context my-context --namespace=mystuff` - To create a new namespace
	* `kubectl config use-context my-context` - to set the default namespace in context
* __Object management__
	* `kubectl apply -f object.yaml` - to create/update an object
	* `kubectl delete -f object.yaml` - to delete an object
	* `kubectl edit <resource-name> <object-name>` - to edit object state interactively
* __Deployments__
	* `kubectl run <deployment-name> --image <name> --replicas=<number> --labels="k1=v1,k2=v2"` - create a deployment
	* `kubectl get deployments --show-labels` - get deployments with their label
	* `kubectl get deployments --namespace=kube-system kube-dns` - to view the dns servers
	* `kubectl edit deployment/<depl-name>` - to view/edit deployment manifest
* __Labels__
	* `kubectl label pods <pod-name> <key=value>` - to add a label to a pod
	* `kubectl label pods <pod-name> -<key>` - to remove a label from a pod
	* `kubectl get pods -L -<label>` - to view all pods with a label
	* `kubectl label deployments <depl-name> <key=value>` - to add a label to a deployment
	* `kubectl label deployments <depl-name> -<key>` - to remove a label from a deployment
	* `kubectl get deployments -L -<label>` - to view all deployments with a label
	* `kubectl get deployments --selector="k1=v1,k2=v2"` - to view all deployments with all the labels specified
* __Services__
	* `kubectl expose deployment <depl-name>` - to expose a deployment as a service
	* `kubectl get services -o wide` - to view all the services
	* `kubectl describe service <svc>`
* __Debugging__
	* `kubectl describe nodes <node_name>` - to get more information about a specific node
	* `kubectl logs <pod-name>` - to view the logs from all the containers in a pod
	* `kubectl logs <pod-name> -c <container>` - to view the logs from a particular container
	* `kubectl exec -it <pod-name> --bash` - to execute a command in a running container
	* `kubectl cp <remote-file> <local-file>` - to copy a file to and from a container




# OpenShift

* _Pod_ 
	* A pod is one or more containers guaranteed to be running on the same host. The containers within a pod share a unique IP address. They can communicate with each other via the “localhost” and also all share any volumes (persistent storage).
* _Replication Controller_
	* When scaled up, an application will have more than one copy of itself, and each copy will have its own local state. Each copy corresponds to a different instance of a pod with the pods being managed by the replication controller.  
* _Service_
	* As each pod has a unique IP, we need an easy way to address the set of all pods as a whole. This is where a service comes into play. 
	* A Service groups pods and provides a common DNS name and an optional, load-balanced IP address to access them
	* The service gets its own IP and a DNS name. When making a connection to a service, OpenShift will automatically route the connection to one of the pods associated with that service.
	* Although a service has a DNS name, it is still only accessible within the OpenShift cluster and is not accessible externally. 
	* To make a service externally accessible, a route needs to be created. 
	* Creating a route automatically sets up __haproxy__ or a hardware-based router, with an externally addressable DNS name, exposing the service and load-balancing inbound traffic across the pods.
* _Build_
* _Deployment_
	* A deployment is an update to your application, triggered by a changed image or configuration
	* There are 2 deployment strategies: rolling and recreate
	* _Rolling Strategy_
		* This is the default deployment strategy in OpenShift
		* A rolling deployment slowly replaces instances of the previous version of an application with instances of the new version of the application. 
		* A rolling deployment can wait for new pods to become ready via a readiness check before scaling down the old instances. Rolling deployment can be aborted if a problem occurs.
		* It runs old and new instances of the application in parallel and balances traffic across them as new instances are deployed and old instances shut down. It enables an update with no down time.
		* _When to use?_: 
			* not suitable strategy where multiple instances of the same application cannot be run at the same time
			* where instances of both old and new code cannot be run at the same time.
	* _Recreate Strategy_
		* shuts down all running instances of the old app, before starting up the new instances
		* _When to use?_: 
			* where more than one instance of the app cannot run at the same time.
			* where old and new code of the app cannot be run at the same time. e.g., apps running a traditional relational db
	* _Custom strategy_
		* Complicated custom strategies like Blue-Green or A/B deployment strategies can be implemented by using multiple deployment configurations and reconfiguring what pods are associated with the exposed service for an app using labels
* _Scaling_
	* The number of pods can be scaled up or down via the web console
	* Reducing the number replicas to zero is same as taking the app offline. Users trying to connect will get http 503 error.
	* Before scaling up, make sure the app is cloud-native (in other words, 12-factor methodology compliant) app and is safe to scaling
	* Database cannot scaled up in a traditional ways since only the primary instance should have the ability to update data. Scaling can still be performed, but usually on read-only instances of the DB
	* Automatic scaling
		* can be configured by defining the upper and lower thresholds of CPU usage by pod. 
		* If the upper threshold is consistently exceeded by the pods, a new instance of the app is started. 
		* If the CPU drops below lower threshold, then the replicas are scaled down.
* _Health check_
	* Types
		* _Readiness probe_: used to determine if the new instance of the app is running properly before reconfiguring the router to send traffic to it
		* _Liveness probe_: runs periodically once traffic has been switched to an instance to ensure it is still behaving correctly. If the liveness probe fails, then the instance of the app is automatically shutdown by OpenShift and a new one is created.
	* Both probes can be implemented in 3 different ways
		* _HTTP check_: a container is considered healthy if a HTTP request against a defined url returns status 200 or 399
		* _Container check_: a container is considered healthy if a defined command returns with a zero exit status
		* _TCP socket check_: a container is considered healthy if a connection can be established to the exposed port of the app


## Commands

* `oc types` - quick summary of OpenShift concepts and definitions
* `oc whoami`
* `oc cluster up` - to start the OpenShift cluster
* `oc new-app <base_image> <sourcecode_git_url> --name='<app-name>'` - to create a new app from source code
* `oc expose service <routename>` - to expose a route
* `oc get routes` - to view all the routes 
* `oc status`
* `oc start-build <app>`
* `oc get pods` - get all running instances
	* `oc get pods --selector key=value` - selectively query pods with label
* `oc describe pod/<instance_name>` - details about an instance
* `oc get builds` - list all builds
* __Logs__
	* `oc logs build/<buildname>` - show build logs
	* `oc logs <podname>` - show application logs
		* `oc logs --follow <podname>` - tail the logs while the app is running
		* `oc logs --previous <podname>` - to view the logs from last attempt. This is useful when app fails to start after successive failures.
* __Environment settings__
	* `oc set env <deploymentconfig>/<container> --list` - list the env variables exported to a container
	* `oc set env <deploymentconfig>/<container> key1=val1 key2=val2` - note: each configuration change triggers a redeployment of the app.
	* `oc set env <buildconfig>/<container> key1=val1` - setting the build config env variables. Note: any env variable set for build will also be used for containers
	* `oc env dc <app_name> -e key1=val1 -e key2=val2` - adding environment variables to deployment config of an app
	* `oc explain` - gets the list of what can be set in a configuration
* __Debugging__
	* `oc rsh <app>` - to remote shell into the running pod
	* `oc exec <app> <command>` - run a command and exit immediately with results
	* `oc debug dc/<app>` - when app starts to fail, run this cmd. This will start up an instance of the image for the app, but instead of running the normal app command, it will run an interactive shell instead
* __Deleting__
	* `oc delete project <name>`
	* `oc delete all --selector key=val` - deletes bc, dc, route, service, pod associated with the label
The following service(s) have been created in your project: postgresql.

       Username: insult
       Password: insult
  Database Name: insults
 Connection URL: postgresql://postgresql:5432/
 
 oc env dc insults -e POSTGRESQL_USER=insult  -e PGPASSWORD=insult POSTGRESQL_DATABASE=insults


# References

* Books
	* Mastering Docker
	* O'Reilly - Using Docker
	* O'Reilly - OpenShift for Developers
	* O'Reilly - Kubernetes - Up & Running
	