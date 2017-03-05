---
layout: page
title: "Infrastructure as Code"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Configuration Management

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

# References

* Books
  * Chef Cookbook
* Sites
  * https://learn.chef.io