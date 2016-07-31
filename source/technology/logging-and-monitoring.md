---
layout: page
title: "Logging & Monitoring"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

* What is write-ahead logging? Used in HBase.
* Metric identity name: k-tuple
* Metrics values
  * counters, gauges, percentiles, nominal, ordinal, interval, ratio, derived
* How can we monitor?
  * Resolution: how frequent to collect the metrics? every 6-10secs?
  * Latency: how long before we act on them?
  * Diversity: are we collecting different metrics?

# Monitoring Components

https://www.usenix.org/sites/default/files/conference/protected-files/dickson.pdf 

1. Sensing/Measurement: Creation of metrics
  * various systems gather data at various speeds.
  * various systems have various concepts of a unit of a metric identity
  * no consistent interface
  * e.g., `top`, `np`, `netstats`, `sar`, `nagios`.
* Storage
* Collection
* Analysis
* Alerting/Escalation
* Visualization - should be actionable items. Avoid pie charts for disk usage metrics. Think of visual graphs which can predict the disk size after 6 months.
* Configuration
* Configuration and Storage are cross-cutting concerns.

#Monitoring Tools

1. sar
* trace
* [MRTG](http://oss.oetiker.ch/mrtg/)
  * acronym for Multi Router Traffic Grapher
  * free software for monitoring and measuring the traffic load on network links.
  * gets its data via SNMP agents every few minutes
  * results are plotted in graphs
  * has alerting mechanism
* [RRDTool](http://oss.oetiker.ch/rrdtool/)
  * acronym for Round-Robin Database Tool 
  * aims to handle time-series data like n/w bandwidth, CPU load, etc. 
  * The data are stored in a round-robin circular buffer/database, thus the system storage footprint remains constant over time. 
  * It has tools to display the data in graphical format.
* [Nagios](http://www.nagios.com/)
* [Ganglia](http://ganglia.info/)
  * a scalable distributed system monitor tool for high performance computing systems such as clusters and grids.
  * typically used with Nagios. 
* [Cacti](http://www.cacti.net/) (mrtg++) 
  * Network Graphing solution designed to harness the power of RRDTool's storage and graph functionality
* [Sensu](http://www.sensuapp.org/) 
  * open source monitoring framework
* LogStash
  * Redis for storage
  * RabbitMQ, grok
  * Typical implementation: logstash + redis + elasticsearch
* Splunk
* [FluentD](http://www.fluentd.org/)
  * an open-source tool to collect events and logs and store as JSON
  * built on CRuby.
  * plugins enables to store the massive data for Log Search (like ElasticSearch), Analytics and Archiving (MongoDB, S3, Hadoop)
* [GrayLog2](http://www.graylog2.com/)
  * an open source data analytics system 
  * search logs, create charts, create alerts
  * leverages Java and ElasticSearch. Communication via REST API
* [OpenTSDB](http://opentsdb.net/)
  * pure storage solution
  * a free distributed time-series database written on top of HBase.
  * was written to store, index and serve metrics collected at a large scale, and make it easily accessible and graphable.
* D3.js - Pure visualization solution
* [Statsd](https://github.com/etsy/statsd/)
  * listens to anything and everything
  * written in node.js. There are alternative implementations in groovy, C, etc.
  * listens to statistics (counters and timers) and sends aggregates to backend services like Graphite
* [Graphite](http://graphite.wikidot.com/)
  * this open-source tool written on Python does 2 things: store numeric time-series data and render graphs of this data on demand
  * does not collect data.
  * 3 components
    * carbon - a [Twisted](https://twistedmatrix.com/trac/) daemon that listens for time-series data
    * whisper - a simple database library for storing time-series data
    * graphite-webapp - A [Django](https://www.djangoproject.com/) webapp that renders graphs on-demand using [Cairo](http://www.cairographics.com/).
* [Shinken](http://www.shinken-monitoring.org/)
  * open-source Nagios like tool, redesigned and rewritten from scratch.
  * Nagios + Graphite + Configuration
* [Kibana](http://www.elasticsearch.org/overview/kibana/)
  * web interface for viewing logstash records stored in elasticsearch
* [ElasticSearch](http://www.elasticsearch.org/)
* Zenoss
* Shippers
  * lumberjack
  * beaver
  * syslog
  * woodchuck
* AppDynamics
* New Relic
* Other tools
  * monigusto
  * collectd
  * jmxtrans
  * tasseo
  * gdash
  * librato


## Splunk

* is a time-series indexer - a product that takes care of the three Vs very well.
* 3 main functionalities
    * **Data collection** 
      * from static source 
      * from real-time source
      * from log files, rolling log files
      * from databases
    * from script results
  * **Data indexing** - index of above data
  * **Search and Analysis** - Using Splunk Processing Language to search and extract results in the form of charts, events, etc.
* Splunk breaks down log file entries into different events based on the associated timestamp. If no timestamp is found, then all the lines in the log file is considered as a single event.

### Components 

1. Search Head
2. Forwarders

### Queries

* Top browsers: `sourcetype="access_combined_wcookie" | top useragent`
* Bottom 3 browsers: `sourcetype=access_combined_wcookie | rare useragent limit=3`
* Top 5 IP address: `sourcetype="access_combined_wcookie" | top clientip limit=5`
* Top Referers without percent field: `sourcetype=access_combined_wcookie referer != *MyGizmo* | top referer | fields - percent`
* Count of 404 errors grouped by `source: sourcetype=access_combined_wcookie status=404 | stats count by source`
* Top purchases by product: `sourcetype=access* | timechart count(eval(action="purchase")) by productId usenull=f`
* Pages views and purchases: `sourcetype=access_* | timechart per_hour(eval(method="GET")) AS Views, per_hour(eval(action="purchase")) AS Purchases`
* Geo location of IPs (Google Maps): `sourcetype=access* | geoip clientip`

### Analytics

* also known as Business Intelligence / Data Mining / OLAP
* Traditional analytics are based on 'Early Structure Binding', where you need to know beforehand what questions are going to be asked of the data.
  * The typical development steps can be summarized as follows:
    * Decide what questions to ask
    * Design the data schema
    * Normalize the data
    * Write database insertion code
    * Create the queries
    * Feed the results into an analytics tool
* Late Structure Binding, which has these simple steps:
  * Write data (or events) to log files
  * Collect the log files
  * Create searches, graphs, and reports using Splunk
* Operational Intelligence refers to the information collected and processed 
* Semantic logging as data or events that are written to log files explicitly for the purpose of gathering analytics.

# Java Logging

## slf4j

* Meta logging Frameworks - http://www.slf4j.org
* NDC, MDC statements - http://stackoverflow.com/questions/7404435/conditional-logging-with-log4j?
* What are the classloader issues that plague JCL?
* what is meant by 'static binding approach' in sl4j?
* Marker objects
* NOPLogger?

## logback
