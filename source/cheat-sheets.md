---
layout: page
title: "Cheat Sheets"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Octopress Cheat Sheet

## Installation

* Download & Install 
  * **Ruby 1.9.3-p550**
  * Devkit for Ruby 1.9.3
    * Execute below commands
      * `ruby dk.rb init`
      * Enter the ruby home path in `config.yml` file here
      * `ruby dk.rb review`
      * `ruby dk.rb install`
	* Python27
* Execute below commands from folder where Octopress GemFile is
  * `gem install bundler`
  * `bundle install`
  * `gem install hitimes -v '1.2.2'​`


## Getting Started

* `gem update` # updates all ruby gems
* `rake new_page[name]` #To create a new page 
* How to start the local server
	`rake generate` # generates the static site 
	`rake preview` # starts server on localhost:4000

## Site changes

[http://octopress.org/docs/theme/styles/](http://octopress.org/docs/theme/styles/)

* To override styles `sass/custom/_styles.scss`
* To change colors in the site `/sass/base/_theme.scss`
* To customize your color scheme edit `sass/custom/_colors.scss` and override the colors in `sass/base/_theme.scss`.
* To change fonts `/source/_includes/custom/head.html`
* To change header `/source/_includes/custom/header.html`
* To change sidebar edit `default_asides` section in `_config.yml`
* To change navigation `/source/_includes/custom/navigation.html`
* To change navigation link on the side bar `/source/_includes/asides/recent_posts.html`

## Github commands

To clone the site to a new machine

```
# To clone the branch 'source' to local under folder 'knowledgeshop'
$ git clone -b source git@github.com:username/username.github.com.git knowledgeshop
$ cd ./_deploy
$ git clone git@github.com:username/username.github.com.git _deploy 
```

To deploy the Octopress site to Github. Note the source files go to source branch and the static site to be hosted goes to master branch.

```
$ rake generate
$ git add .
$ git commit -am "Some comment here." 
$ git push origin source  # update the static site in remote source branch 
$ rake deploy             # update the _deploy/ folder in remote master branch
```

To update the changes from remote

```
$ cd knowledgeshop
$ git pull origin source  # update the local source branch
$ cd ./_deploy
$ git pull origin master  # update the local master branch
```

# Amazon EC2 Cheat Sheet

Instance Id: i-55f0535b
Public DNS: ec2-54-152-49-108.compute-1.amazonaws.com

User: Nasrin
  Access Key ID: AKIAIQYPAAODJJP4OFFQ
  Secret Access Key: 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


*Set up instructions*

* Create an instance from AMI
* Create security group
* Create new user from IAM console
* To connect to EC2 instance via AWS CLI
  * Download AWS CLI
  * Configure AWS CLI - http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
* To test if the AWS instance is working
  * `aws ec2 get-console-output --instance-id instance_id`
* To connect via PuTTY - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html
* To connect via ssh in windows CLI
    `ssh -i C:\Fizal\ImportantDocuments\AmazonAWS\salaamah.pem ubuntu@54.191.204.118`
* To configure FileZilla for ftp
* To install Java 7 in Ubuntu
  `sudo add-apt-repository ppa:webupd8team/java`
  `sudo apt-get update`
  `sudo apt-get install oracle-java7-installer`

  To automatically set up the Java 7 environment variables JAVA_HOME and PATH
    `sudo apt-get install oracle-java7-set-default`
* To install Tomcat 8 on Ubuntu
  `wget --no-check-certificate http://apache.arvixe.com/tomcat/tomcat-8/v8.0.17/bin/apache-tomcat-8.0.17.tar.gz`




