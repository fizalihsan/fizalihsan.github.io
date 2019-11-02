---
layout: page
title: "Monitoring & Observability"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Overview

Monitoring != Logging != Tracing != Instrumentation

|.|__Logging__|__Tracing__|__Monitoring__|
|-|-|-|-|
|Purpose|represents state transformation or events within an app. When things go wrong, logs are helpful to identify what event caused the error.|represents a single user's journey through an entire stack of an application. Often used for optimization purposes.|Instrumenting an application and monitoring the results represents the use of a system. Often used for diagnostic purposes. Monitor apps to detect problems and anomalies. Basic fitness tests like the app is up or down, and more proactive health checks. Provides insights into capacity requirements.|
|Pros and Cons|Obtaining, transferring, storing and parsing logs is expensive. Log only important and actionable information.|Tracing libraries are often more complicated than the code they are serving. So tracing tends to be expensive|Instrumentation is often cheap to compute. Metrics take nanoseconds to update and some monitoring systems operate on a “pull” model, which means that the service is not affected by monitoring load.|
|Tools and Frameworks|depends on the technology. e.g, logback, log4j, etc. Splunk|OpenTracing|Prometheus, DynaTrace, Wily|

# Logging

* Structured Logging - https://stackify.com/what-is-structured-logging-and-why-developers-need-it/

## slf4j

* Meta logging Frameworks - http://www.slf4j.org
* NDC, MDC statements - http://stackoverflow.com/questions/7404435/conditional-logging-with-log4j?
* What are the classloader issues that plague JCL?
* what is meant by 'static binding approach' in sl4j?
* Marker objects
* NOPLogger?

# Monitoring

> [Monitorama Videos](https://vimeo.com/monitorama/videos)

* Metric identity name: k-tuple
* Metrics values
  * counters, gauges, percentiles, nominal, ordinal, interval, ratio, derived
* How can we monitor?
  * Resolution: how frequent to collect the metrics? every 6-10secs?
  * Latency: how long before we act on them?
  * Diversity: are we collecting different metrics?
* What is write-ahead logging? Used in HBase.

## Anti-patterns

* __Tool Obsession__
  * there is no such things as the single-pane-of-glass tool that will suddenly provide you with perfect visibility into your network, servers, and applications, all with little to no tuning or investment of staff. Many monitoring software vendors sell this idea, but it's a myth.
  * Monitoring isn't a single problem, so it stands to reason that it can't be solved with a single tool either.
  * Agentless monitoring is extraordinarily inflexible and will never give you the amount of control and visibility you desire.
  * _How many tools is too many?_ - If there are 3 tools to monitor your DB and they all provide the same information, you should consider consolidating. On the other hand, if all three provide different information, you're probably fine.
  * _Avoid Cargo-culting tools_ - Adopting tools and procedures of more successful teams and companies in the misguided notion that the tools and procedures are what made those teams successful, so they will also make your own team successful in the same ways. Sadly, the cause and effect are backward: the success that team experienced led them to create the tools and procedures, not the other way around.  
* __Monitoring-as-a-Job__
  * Strive to make monitoring a first-class citizen when it comes to building and managing services. Remember, it's not ready for production until it's monitored.
  * _Observability team_ is the team whose job is to build self-service monitoring tools as a service to another team. However, this team is not responsible for instrumenting the apps, creating alerts, etc. The anti-pattern is to caution against having your company shirk the responsibility of monitoring at all by resting it solely on the shoulders of a single person.
* __Checkbox Monitoring__
  * This antipattern is when you have monitoring systems for the sole sake of saying you have them. This is ineffective, noisy, untrustworthy, and probably worse than having no monitoring at all.
  * Common signs of this antipattern
    * recording metrics like CPU usage, system load, and memory utilization, but the service still goes down.
    * find yourself consistently ignoring alerts, as they are falst alarms more often than not.
    * checking systems for metrics every 5 mins.
    * not storing historical metric data.
  * Fix
    * OS metrics aren't very useful for alerting. If CPU usage is above 90% that is no reason to alert, if the server is still doing what it's supposed to do.
    * Collect your metrics more often and look for patterns.
  * __Alerting as a Crutch__
    * Avoid the tendency to learn on monitoring as a crutch. Monitoring is great for alerting problems, but don't forget the next step: fixing the problems.

## Design Patterns

* 1) __Composable Monitoring__: _Use multiple specialized tools and couple them loosely together, forming a monitoring platform_. Similar to the UNIX philosophy, _Write a program that do one thing and do it well. Write programs to work together._
* 2) __Monitor from the user perspective__: One of the most effective things to monitor is simply HTTP response codes (especially of the HTTP 5xx variety) followed by request times (aka latency). Always ask yourself, _"How will these metrics show me the user impact?"_.

## Telemetry Data

* [M.E.L.T. (Metrics, Events, Logs and Traces)](https://newrelic.com/platform/telemetry-data-101)

* __Metrics__
  * Metrics come in different representations
  * _Counter_ is an ever-increasing metric. e.g., Odometer in a car, number of visits to a site.
  * _Gauge_ is a point-in-time value. e.g., Speedometer n a car.
    * The nature of gauge has one big shortcoming: it doesn't tell anything about previous values and provides no hint of future values. Storing gauges in a TSDB can do such things as plot on a graph, predict future trends, etc.
* __Events__
* __Logs__
  * Logs are essentially strings of text with a timestamp associated with them.
  * Logs come in 2 types
    * _Unstructured Logs_
    * _Structured Logs_: 
* __Traces__


## Components

https://www.usenix.org/sites/default/files/conference/protected-files/dickson.pdf 

A monitoring service has 5 primary facets

### 1) Data collection

* _Pull-based_ 
  * SNMP, Nagios. 
  * use of `/health` endpoint pattern in app monitoring which exposes metrics and health information about an app which can be polled by a monitoring service, service discovery tool like Consul and etcd or by a load balancer.
  * Pull model can be difficult to scale, as it requires central systems to keep track of all known clients, handle scheduling, and parse returning data.
* _Push-based_
  * Push model is easier to scale in a distributed architecture such as cloud, due to the lack of a central poller. Nodes pushing data need to only know where to send it, and don't need to worry about underlying implementation of the receiving end.
* various systems gather data at various speeds.
* various systems have various concepts of a unit of a metric identity
* no consistent interface
* e.g., `top`, `np`, `netstats`, `sar`, `nagios`.

### 2) Data storage

* __Metrics Storage__
  * Metrics, being time series, as usually stored in a _Time Series Database (TSDB)_. e.g., Round Robin Database (RRD), Graphite's Whisper, OpenTSDB.
  * Many TSDBs __roll up__ or __age out__ data after a certain time period. This means that as the data gets older, multiple datapoints are summarized into a single datapoint. A common roll up method is _averaging_, though some tools support other methods such as _summing datapoints_.
  * Metric rollup occurs as a result of compromises: storing native resolution of metrics gets very expensive for disks - both in storage and in the time it takes to read all those datapoints from disk for use in a graph.
* __Log Storage__
  * 2 flavors
    * Store the log data as flat files. e.g., `rsyslog`
    * Store the log files in a search engine. e.g., ElasticSearch
  * Metric storage is inexpensive. Log storage can get expensive.

### 3) Visualization

> Edward Tufte's _The Visual Display of Quantitive Information_ and Stephen Few's _Information Dashboard Design_.

* A driving principle behind great monitoring is that you should be building things in a way that works best for your environment.
* Common visualization for time series data is the _line graph_ (also called a _strip data_).
* Visualization should be actionable items. Avoid pie charts for disk usage metrics. Think of visual graphs which can predict the disk size after 6 months.

### 4) Analytics and reporting

* SLA, SLO, SLI
  * Service Level Agreement 
  * Service Level Objective
* SLA & SLO are important for reporting
* __Availability__
  * Availability of an application/service is commonly referred to by the number of _nines_. 99.99% is four nines.
  * `Availability = uptime / (downtime + uptime)`
  * _Why High Availability is difficult?_: According to [_Nyquist-Shannon sampling theorem_](http://bit.ly/2i2kBmv), to measure an outage of 2 minutes, you must be collecting data in minute-long intervals. Thus, to measure availability down to 1 second, you must be collecting data at sub-second intervals. This is just one reason why achieving accurate SLA reporting better than 99% is so difficult.
  * An oft-overlooked point about availability is when your app has dependent components: your service can ony be as available as the underlying components on which it is built. e.g, AWS S3 provides 99.95% SLA. An app depending on S3 can never be >99.95% SLA.
  * Similarly, if the underlying network is unreliable, the servers and application higher in the stack can't possibly be more reliable than the network.
  * Each additional nine of availability has significantly more cost associated with it, and the investment often isn't worth it: many customers can't tell the difference between 99% and 99.9%.

### 5) Alerting

* Monitoring doesn't exist to generate alerts: alerts are just one possible outcome. With this in mind, remember that every metric you collect and graph does not need to have a corresponding alert.


# Tools

* AppDynamics
* [Cacti](http://www.cacti.net/) (mrtg++) - Network Graphing solution designed to harness the power of RRDTool's storage and graph functionality
* [Consul](https://www.consul.io)
* [ElasticSearch](http://www.elasticsearch.org/)
* [etcd](https://coreos.com/etcd)
* [FluentD](http://www.fluentd.org/) - an open-source tool to collect events and logs and store as JSON - built on CRuby - plugins enables to store the massive data for Log Search (like ElasticSearch), Analytics and Archiving (MongoDB, S3, Hadoop)
* [Ganglia](http://ganglia.info/) - a scalable distributed system monitor tool for high performance computing systems such as clusters and grids. - typically used with Nagios. 
* [Grafana](https://grafana.com) - Visualization tool
* [Graphite](http://graphite.wikidot.com/)
  * this open-source tool written on Python does 2 things: store numeric time-series data and render graphs of this data on demand
  * does not collect data.
  * 3 components
    * carbon - a [Twisted](https://twistedmatrix.com/trac/) daemon that listens for time-series data
    * whisper - a simple database library for storing time-series data
    * graphite-webapp - A [Django](https://www.djangoproject.com/) webapp that renders graphs on-demand using [Cairo](http://www.cairographics.com/).
* [GrayLog2](http://www.graylog2.com/) - an open source data analytics system - search logs, create charts, create alerts - leverages Java and ElasticSearch. Communication via REST API
* LogStash - Redis for storage - RabbitMQ, grok - Typical implementation: logstash + redis + elasticsearch
* InfluxDB
* [Kibana](http://www.elasticsearch.org/overview/kibana/) - web interface for viewing logstash records stored in elasticsearch
* Librato - Commercial tool
* Loggly - Commercial tool
* [MRTG](http://oss.oetiker.ch/mrtg/) - acronym for Multi Router Traffic Grapher - free software for monitoring and measuring the traffic load on network links. - gets its data via SNMP agents every few minutes - results are plotted in graphs - has alerting mechanism
* [Nagios](http://www.nagios.com/)
* NewRelic
* [OpenTSDB](http://opentsdb.net/) - pure storage solution - a free distributed time-series database written on top of HBase - was written to store, index and serve metrics collected at a large scale, and make it easily accessible and graphable.
* Pingdom - Commercial tool
* [Prometheus](https://prometheus.io)
* [RRDTool](http://oss.oetiker.ch/rrdtool/) - acronym for Round-Robin Database Tool  - aims to handle time-series data like n/w bandwidth, CPU load, etc.  - The data are stored in a round-robin circular buffer/database, thus the system storage footprint remains constant over time. - It has tools to display the data in graphical format.
* sar
* [Sensu](http://www.sensuapp.org/) - open source monitoring framework
* [Shinken](http://www.shinken-monitoring.org/)
  * open-source Nagios like tool, redesigned and rewritten from scratch.
  * Nagios + Graphite + Configuration
* [Smashing](https://github.com/Smashing/smashing) - Visualization tool
* Splunk
* [Statsd](https://github.com/etsy/statsd/)
  * listens to anything and everything
  * written in node.js. There are alternative implementations in groovy, C, etc.
  * listens to statistics (counters and timers) and sends aggregates to backend services like Graphite
* trace
* Zenoss
* Shippers
  * lumberjack
  * beaver
  * syslog
  * woodchuck
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

# Tracing

## OpenTracing

* [OpenTracing](https://opentracing.io/) is a vendor neutral specification for instrumentation APIs.
* It offers consistent, expressive, vendor-neutral APIs for popular platforms, making it easy for developers to add (or switch) tracing implementations with an O(1) configuration change. 
* OpenTracing also offers a lingua franca for OSS instrumentation and platform-specific tracing helper libraries.
* [Tutorials](https://github.com/yurishkuro/opentracing-tutorial)
* CNCF [Jaeger](https://jaegertracing.io/), a Distributed Tracing UI Platform 

# References

* Books
  * [Mastering Distributed Tracing](https://www.shkuro.com/books/2019-mastering-distributed-tracing/)
  * Distributed Systems Observability - Cindy Sridharan
  * Logging and Log Management - Anton Chuvakin, Kevin Schmidt
  * O'Reilly Book - [Practical Monitoring](https://www.practicalmonitoring.com/)