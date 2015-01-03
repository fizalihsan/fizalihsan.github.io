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






