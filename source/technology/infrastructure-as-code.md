---
layout: page
title: "Infrastructure as Code"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

* Infrastructure as code means that your infrastructure is versionable, repeatable, testable

# Containerization

## Docker

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

### Command Reference

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

### Vocabulary

* __Images__ - The blueprints of our application which form the basis of containers. 
* __Containers__ - Created from Docker images and run the actual application. 
* __Docker Daemon__ - The background service running on the host that manages building, running and distributing Docker containers. The daemon is the process that runs in the operation system to which clients talk to.
* __Docker Client__ - The command line tool that allows the user to interact with the daemon. More generally, there can be other forms of clients too - such as ***Kitematic*** which provide a GUI to the users.
* __Docker Hub__ - A registry of Docker images. You can think of the registry as a directory of all available Docker images. If required, one can host their own Docker registries and can use them for pulling images.

# Configuration Management

* Why Configuration Management?
  * Consistency
  * Efficient Change Management
  * Automated deployments
  * Quick recovery from a disaster
* Well-known softwares: CFEngine, Puppet, Ansible, SaltStack, Chef

## Vagrant

* Download : `vagrant box add bento/centos-7.2 --provider=virtualbox`
* creates a configuration file with CPU, memory, etc.: `vagrant init bento/centos-7.2`
* Uses the configuration file to create a virtual machine instance: `vagrant up`
* Connect to the instance: `vagrant ssh`
* Stop/shutdown an instance: `vagrant halt`
* Destroy vagrant instance: `vagrant destroy --force`

## Chef

* A recipe is a collection of resources
* A cookbook is a collection of recipes

* install Chef DK `curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable -v 0.18.30`
* `mkdir ~/chef-repo`
* `cd ~/chef-repo`
* Create recipe file
* Execute recipe file: `chef-client --local-mode hello.rb`
* create a cookbook: `chef generate cookbook cookbooks/learn_chef_httpd`
* Run the cookbook: `sudo chef-client --local-mode --runlist 'recipe[learn_chef_httpd]'`


* __Sample recipe to install and start a httpd service__

```ruby
# automatically installs httpd package
package 'httpd'

# enable and start the service
service 'httpd' do
    action [:enable, :start]
end

# configure homepage
file '/var/www/html/index.html' do
  content '<html>
  <body>
    <h1>hello world</h1>
  </body>
</html>'
end

# creates a tmp file and sets permissions
file '/etc/motd' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
```

### Common Resources

* template, package, service - 3 types of resources built into the Chef DSL
​* __package__: Installs a package using the appropriate platform-native installer/package manager (yum, apt, pacman, etc.).

```ruby
package 'ntp' do
   action :upgrade
end
​```

* __service__: Manages the lifecycle of any daemons/services installed by the package resource.

```ruby
service 'apache2' do
   restart_command '/etc/init.d/apache2 restart'​
​end
​```

* __​file__
*​ __cookbook_file__: to transfer cookbook files from /<cookbook>/files/ to the node.
* __template__: A variant of the cookbook_file resource that lets you create file content from variables using an Embedded Ruby (ERB) template.

​```ruby
​template /etc/resolv.conf do
   source 'my_resolv.conf.erb'
   owner  'root'  
   group  'root'  
   mode   '0644'
end
```


### Chef Client​

​* Chef-client operates in 3 modes - client, local
  * __local__
    * simulates a full Chef Server instance in memory. ​
    * Any data that would have been saved to a server is written to the local directory (/nodes). 
    * The process of writing server data locally is called _writeback_. 
    * designed to support a rapid Chef recipe development by using Chef Zero, the in-memory, fast-start Chef server
  * __client__
    * chef-client is an agent (or service/daemon) that runs locally on a machine managed by Chef. 
    * when chef-client is running in client mode, it assumes you have a Chef Server running on some other system on your network. 
* ​Chef client constructs 'node' object in memory providing access to information about the node. It runs `ohai` command and gathers all the node's automatic attributes such as hostname, fqdn, ip, etc.​ Ohai exposes this collection of node information to Chef as a set of automatic attributes.

### ​Cookbook​

* To create a cookbook: `chef generate cookbook <bookname>`
​* To create a file in cookbook: `chef generate ​file <filename>`

```
    ├── Berksfile
    ├── chefignore​ <----- list of files to ignore when uploading cookbook to a Chef server.​
    ├── .delivery
    │   ├── build_cookbook
    │   │   ├── Berksfile
    │   │   ├── chefignore
    │   │   ├── data_bags
    │   │   │   └── keys
    │   │   │       └── delivery_builder_keys.json
    │   │   ├── .kitchen.yml
    │   │   ├── LICENSE
    │   │   ├── metadata.rb
    │   │   ├── README.md
    │   │   ├── recipes
    │   │   │   ├── default.rb
    │   │   │   ├── deploy.rb
    │   │   │   ├── functional.rb
    │   │   │   ├── lint.rb
    │   │   │   ├── provision.rb
    │   │   │   ├── publish.rb
    │   │   │   ├── quality.rb
    │   │   │   ├── security.rb
    │   │   │   ├── smoke.rb
    │   │   │   ├── syntax.rb
    │   │   │   └── unit.rb
    │   │   ├── secrets
    │   │   │   └── fakey-mcfakerton
    │   │   └── test
    │   │       └── fixtures
    │   │           └── cookbooks
    │   │               └── test
    │   │                   ├── metadata.rb
    │   │                   └── recipes
    │   │                       └── default.rb
    │   ├── config.json
    │   └── project.toml
    ├── files​ <---- centralized file store in the cookbook to be distributed to the nodes using 'cookbook_file' resource​
    │   └── default​    <----- controls whether files are copied to particular nodes​
    │       └── motd
    ├── .git
    ├── .gitignore
    ├── .kitchen
    │   └── logs
    │       └── kitchen.log
    ├── .kitchen.yml
    ├── metadata.rb​    <------ metadata information about the cookbook (name, version, dependencies, etc.)​
    ├── README.md
    ├── recipes​       <------ custom recipe files go here​
    │   └── default.rb
    ├── spec
    │   ├── spec_helper.rb
    │   └── unit
    │       └── recipes
    │           └── default_spec.rb
    └── t​emplates​​  <--- Embedded Ruby template files 
        └── default
    └── test
        └── smoke
            └── default
                └── default_test.rb
```

### Run list

* A run list contains a list of recipes to execute on the target node.
​* Real-world chef runs typically involve dozens of cookbooks with possibly hundreds of recipes and associated files. There needs to be a succinct way of referring to all the files in a cookbook. That’s the purpose of a run list.
* A run list is used to specify the cookbook recipes to be evaluated on a node.  
* A run list specifies recipes in the form `recipe['<cookbook_name>::<recipe_name>'];` for example, `recipe['motd::default']` (or `recipe['motd']` when the Chef code is contained in the `recipes/default.rb` file).
* ​​Run list is specified in the chef-client command or stored on a Chef server.
* For each node, Chef evaluates only recipe files that are specified on the node's run list.​


# References

* Books
  * Chef Cookbook
  * Learning Chef - O'Reilly
* Sites
  * https://learn.chef.io