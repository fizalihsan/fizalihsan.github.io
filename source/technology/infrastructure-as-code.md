---
layout: page
title: "Infrastructure as Code"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}


# Infrastructure as Code

* Iron age -> Cloud age
  * A fundamental difference between the iron age and cloud age is the move from unreliable software, which depends on the hardware to be very reliable, to software that runs reliably on unreliable hardware.
  * In the cloud age, routine provisioning and change management is automated.
  * In cloud world, disappearing server is a feature, not a bug
* __What is Infrastructure as Code__
  * an approach to infrastructure automation based on software development practices
  * treating infrastructure as software and data and apply software development tools (VCS) and practices (TDD, CI, CD)
* __Principles of Infrastructure as Code__
  * Systems can be easily reproduced
  * Systems are disposable (Treat your servers like cattle, not pets)
  * Systems are consistent
  * Processes are repeatable
  * Antifragility
    * Exercise puts stress on muscles and bones, essentially damaging them, causing them to become stronger. Protecting the body by avoiding physical stress actually weakens it, making it more likely to fail in the face of extreme stress.
    * Similarly, protecting an IT system by minimizing the number of changes made to it will not make it more robust. Constant changing and improving will make it more ready to handle disasters.

* Configuration tooling should run continuously, not ad hoc.
* If automation broke on some edge case, we would either change the automation to handle it, or else fix the design of the service so it was no longer an edge case.
* _Dynamic Infrastructure_ refers to the ability to create and destroy servers programmatically;
  * Issues of dynamic infrastructure
    * Configuration drift
    * Snowflake servers (Pets Vs Cattle) - can't be touched, much less reproduced.
    * Fragile infrastructure
    * Erosion
* _Bare-metal cloud_: Hardware can be automatically provisioned so that it can be used in a fully dynamic fashion. This is sometimes referred to as 'bare-metal cloud'

# Server Provisioning

## Terraform

__Concepts__

* Terraform configuration files are saved as *.tf files
* Resources representinfrastructure components  e.g. server, virtual machine, container, network port.
* Providers are components that let you manage a resource on a particular platform e.g. OpenStack, AWS, Google Cloud, DigitalOcean
* Provisioners provide the ability to execute commands e.g. copy a file into the VM
* Infrastructure as a Code - Tool Categories
  * Configuration Management Tools 
    * Chef, Ansible, Puppet, Salt Stack
    * Designed to install and manage software on existing servers
    * Pros: coding convention, idempotent code, distribution to several servers
  * Server Templating Tools
    * Docker, Packer, Vagrant
    * Instead of launching a bunch of servers and configuring them by running the same code on each one, the idea behind server templating tools is to create an image of a server that captures a fully self-contained “snapshot” of the operating system, the software, the files, and all other relevant details.
    * Server templating is a key component of the shift to immutable infrastructure. This idea is inspired by functional programming, where variables are immutable.
  * Server provisioning tools
    * Terraform, AWS CloudFormation, OpenStack Heat
    * Responsible for creating the servers themselves. Can also be used to create databases, caches, load balancers, queues, monitoring, subnet configurations, firewall settings, routing rules, SSL certificates, and almost every other aspect of your infrastructure

__Commands__

* `terraform init``
* `terraform state show`
* `terraform list`
* `terraform plan`
* `terraform apply -var name="Fizal Terraform Instance"`
* `terraform apply`
* `terraform refresh`


* __Links__
  * https://www.terraform.io/docs/providers/openstack/r/compute_keypair_v2.html
  * https://www.terraform.io/docs/provisioners/chef.html


# Configuration Management

* Why Configuration Management?
  * Consistency
  * Efficient Change Management
  * Automated deployments
  * Quick recovery from a disaster
* Well-known softwares: CFEngine, Puppet, Ansible, SaltStack, Chef

## Vagrant

* `vagrant login` - create login at https://app.vagrantup.com/
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

```
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

* template, package, service: 3 types of resources built into the Chef DSL
* __package__: Installs a package using the appropriate platform-native installer/package manager (yum, apt, pacman, etc.).
* __service__: Manages the lifecycle of any daemons or services installed by the package resource.
* __cookbook_file__: to transfer cookbook files from `/<cookbook>/files/` to the node.
* __template__: A variant of the cookbook_file resource that lets you create file content from variables using an Embedded Ruby (ERB) template.


### Chef Client

* Chef client operates in 3 modes: local, client, and ?
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
* To create a file in cookbook: `chef generate ​file <filename>`

```
    ├── Berksfile
    ├── chefignore​ <----- list of files to ignore when uploading cookbook to a Chef server.​
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
    └── templates​​  <--- Embedded Ruby template files
        └── default
    └── test
        └── smoke
            └── default
                └── default_test.rb
```

### Run list

* A run list contains a list of recipes to execute on the target node.
* Real-world chef runs typically involve dozens of cookbooks with possibly hundreds of recipes and associated files. There needs to be a succinct way of referring to all the files in a cookbook. That’s the purpose of a run list.
* A run list is used to specify the cookbook recipes to be evaluated on a node.  
* A run list specifies recipes in the form `recipe['<cookbook_name>::<recipe_name>'];` for example, `recipe['motd::default']` (or `recipe['motd']` when the Chef code is contained in the `recipes/default.rb` file).
* ​​Run list is specified in the chef-client command or stored on a Chef server.
* For each node, Chef evaluates only recipe files that are specified on the node's run list.​

## SaltStack

* States are stored in text files on the master and transferred to the minions on demand via the master's File Server.
* The collection of state files make up the _State Tree_


Open Questions
--------------

* How to start the salt master/minion?
* How to check if master/minion is running?
* How to sync the changes from master to all minions?
* how to check if the changes are all synced up to all minions?

After making a change to `/etc/salt/master`, restart the master daemon running, `pkill salt-master`,
`salt-master -d`

```
salt-master
sudo salt '*' saltutil.sync_all
sudo salt '*' mine.update
sudo
```


* `salt '*' state.apply` to instruct all minions to run _state.apply_.

* `salt-key -L` - to view salt authentication keys


# References

* Books
  * Chef Cookbook
  * Learning Chef - O'Reilly
  * Infrastructure as Code - O'Reilly
  * Terraform - Up & Running - O'Reilly
* Sites
  * https://learn.chef.io
