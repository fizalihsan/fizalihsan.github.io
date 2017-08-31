---
layout: page
title: "Virtualization"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}


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