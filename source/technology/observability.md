---
layout: page
title: "Monitoring & Observability"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

> Monitoring is the action of observing and checking the behavior and outputs of a system and its components over time.
> Monitoring doesn't _fix_ anything. You need to fix things after they break.

# Overview

Monitoring != Logging != Tracing != Instrumentation

|.|__Logging__|__Tracing__|__Monitoring__|
|-|-|-|-|
|Purpose|represents state transformation or events within an app. When things go wrong, logs are helpful to identify what event caused the error.|represents a single user's journey through an entire stack of an application. Often used for optimization purposes.|Instrumenting an application and monitoring the results represents the use of a system. Often used for diagnostic purposes. Monitor apps to detect problems and anomalies. Basic fitness tests like the app is up or down, and more proactive health checks. Provides insights into capacity requirements.|
|Pros and Cons|Obtaining, transferring, storing and parsing logs is expensive. Log only important and actionable information.|Tracing libraries are often more complicated than the code they are serving. So tracing tends to be expensive|Instrumentation is often cheap to compute. Metrics take nanoseconds to update and some monitoring systems operate on a “pull” model, which means that the service is not affected by monitoring load.|
|Tools and Frameworks|depends on the technology. e.g, logback, log4j, etc. Splunk|OpenTracing|Prometheus, DynaTrace, Wily|


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
* M.E.L.T. are the essential data types of observability.

* __Events__
  * An event is a discrete action happening at a moment in time. Events are just about “something happened at some time.”
  * Example: _At 3:34pm on 2/21/2019 a bag of BBQ chips was purchased for 1 dollar._
  * There’s no hard and fast rule about what data an event can contain—you define an event as you see fit. Events become more powerful when you add more metadata to them. e.g., Event type, ItemCategory and PaymentType, etc.
  * Since events are basically a history of every individual thing that happened in your system, you can roll them up into aggregates to answer more advanced questions on the fly.
  * Pros
    * Include individual data points
    * allow you to ask whatever questions you want at any point
    * can be computed on the fly
  * Cons
    * Every event takes some amount of computational energy to collect and process. They also take up space in your database—potentially lots of space. For example, you could store an event for every minuscule, sub-degree shift in temperature, which would quickly fill up even the largest databases. Or you could instead take a sample of the temperature at a regular interval. This kind of data is better stored as a _metric_.
    * Expensive to store high volumes of event data
    * May hit bandwidth constraints within the source system while collecting and sending the event data
    * Can be time-consuming to query
* __Metrics__
  * Metrics are an aggregated set of measurements grouped or collected at regular intervals. 
  * Unlike events, metrics are not discrete — they represent aggregates of data over a given time span. 
  * Types of metric aggregation are diverse (e.g., average, total, minimum, maximum, sum-of-squares) but all metrics generally share the following traits:
    * A timestamp (note that this timestamp represents a timespan, not a specific time)
    * A name
    * One or more numeric values representing some specific aggregated value
    * A count of how many events are represented in the aggregate
  * Example: _For the minute of 3:34-3:35pm on 2/21/2019 there was a total of three purchases totaling $2.75._
    * Notice, we’ve lost some data here compared to an event. We no longer know what the specific three purchases were, nor do we have access to their individual values (and this data cannot be recovered). However, this data requires significantly less storage but still allows us to ask certain critical questions like, “What were my total sales during any given minute?”
    * Example metrics: error rate, response time, throughput, etc.
  * Metrics come in different representations
    * _Counter_ is an ever-increasing metric. e.g., Odometer in a car, number of visits to a site.
    * _Gauge_ is a point-in-time value. e.g., Speedometer n a car.
      * The nature of gauge has one big shortcoming: it doesn't tell anything about previous values and provides no hint of future values. Storing gauges in a TSDB can do such things as plot on a graph, predict future trends, etc.
  * Pros
    * Store significantly less data
    * Less time to compute roll-ups
  * Cons
    * Required to make decisions ahead of time on which you want to analyze the data
* __Logs__
  * Logs are essentially strings of text with a timestamp associated with them.
  * Like events, log data is discrete
  * Logs come in 2 types
    * _Unstructured Logs_
    * _Structured Logs_: most common example is JSON format. 
  * One can event produce multiple logs. e.g., one customer purchase event in a vending machine could potentially have multiple log messages like coin inserted, buttons pressed, dispensed, etc.
* __Traces__
  * Traces—or more precisely, “distributed traces”—are samples of causal chains of events (or transactions) between different components in a microservices ecosystem. And like events and logs, traces are discrete and irregular in occurrence.
  * Traces stitched together form special events called __“spans”__; spans help you track a causal chain through a microservices ecosystem for a single transaction. To accomplish this, each service passes correlation identifiers, known as _“trace context,”_ to each other; this trace context is used to add attributes on the span.

{% img /technology/melt-distributed-tracing-sample.jpg %}

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
* An __alert__ should evoke a sense of urgency and require action from the person receiving that alert. Everything else can essentially be a log entry, a message dropped in your internal chat room, or an auto-generated ticket.
* __3 alert categories__
  * Response/action required immediately - send these to SMS, PagerDuty
  * Awareness needed, but immediate action not required - send these to internal chat rooms
  * Record for historical/diagnostic purposes - send it to log file and analyze later

__6 alerting best practices__

* _Stop using email for alerts_
* _Write runbooks_ - A runbook is for when human judgement and diagnosis is necessary to resolve something.
* _Arbitrary static thresholds aren't the only way_
  * Alerting on things like "datapoint has crossed X" isn't useful. A static threshold set to alert at "free space under 10%" isn't going to alert when a disk quickly growing in usage from 11% to 80% overnight.
  * Using a _percent change/derivative_ would handle our disk usage problem by reporting us "disk usage has grown by 50% overnight"
  * Few such approaches: _moving averages_, _confidence bands_, _standard deviation_
* _Delete and tune alerts_
  * _Alert fatigue_ occurs when you are so exposed to alerts that you become desensitized to them. Alerts should cause a small adrenaline rush.
* _Use maintenance periods_
  * If you need to do work on a service or app, and you expect it to trigger an alert (e.g., due to it being down), then set that alert into maintenance period.
* _Attempt self-healing first_

__On-Call__

Effective strategies for On-Call

* Make it the duty of on-call to work on systems resiliency and stability during their on-call shift when they aren't fighing fires.
* Explicitly plan for systems resiliency and stability work during the following week's sprint planning/team meeting, based on the information collected from the previous on-call week.
* Start the on-call rotation during the workweek instead of calendar week. This allows the team to do an on-call handoff.
* _Follow-The-Sun (FTS) Rotations_ allow to have full on-call coverage with no one being on-call during nights. One big downside to FTS rotations is the significant increase in communication overhead.
* Only when you have a large team, have a backup on-call person to the primary on-call person. For smaller teams, this means the same person being on-call every 2-3 weeks.
* How many people do you need for an effective on-call rotation schedule? It depends on 2 factors: how busy your on-call tends to be and how much time you want to give people between on-call shifts.
* Software engineers should be on-call. Avoid the _"throw-it-over-the-wall_ version of software engineering. If software engineers are aware of the struggles that come up during the on-call, then they are incentivized to build better software.

Tools: PagerDuty, VictorOps, OpsGenie

> PagerDuty's Incident Response Documentation [https://response.pagerduty.com/](https://response.pagerduty.com/)


## Monitoring at various tiers


### Business Monitoring

TBD

### Frontend Monitoring

* 2 approaches for frontend monitoring
  * RUM (real use monitoring)
    * uses actual user traffic for the monitoring data
    * e.g., Google Analytics
  * Synthetic monitoring
    * create fake requests under a variety of test conditions to generate the data
    * e.g., WebpageTest.org, Dynatrace Gomez scripts
* DOM (Document Object Model)
  * _Synchronous loading_: By default, scripts in a webpage are loaded synchronously. i.e., if the DOM parsing encounters a `<script>` tag, then the browser will stop parsing the DOM and load the script.
  * _Asynchronous loading_: HTML5 supports `async` attribute on `<script>` tags which allows the scripts to be downloaded in background while the DOM continues to be loaded, executing the script when it's finished downloading. This improves the page performance greatly.
* Performance Metrics
  * _Navigation Timing API_
    * Browsers expose page performance metrics via [Navigation Timing API](https://www.w3.org/TR/navigation-timing). 
    * This API exposes 21 metrics. Consistently useful among them are `navigationStart`, `domLoading`, `domInteractive`, `domContentLoaded`, `domComplete`
  * _User Timing API_
    * While Navigation Timing API's metrics are browser set, User Timing API allows you to create your metrics and events.
* Tools
  * WebPageTest.org
  * __SpeedIndex__
    * calculates the user-perceived completeness
    * Whereas Navigation Timing metrics ruly on accurate reporting by the browser, [Speed Index](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/metrics/speed-index) uses video capture at a rate of 10 frames per second to determine exactlly when a page is finised loading from a visual perspective.
    * Speed Index Algorithm produces a single number as output - lower is better.

{% img /technology/navigation-timing-overview.PNG %}

### Application Monitoring

* __StatsD__
  * tool created by Etsy in 2011 to add metrics inside of your code - originally designed for a Graphite backend
  * A network daemon that runs on the Node.js platform and listens for statistics, like counters and timers, sent over UDP or TCP and sends aggregates to one or more pluggable backend services (e.g., Graphite, OpenTSDB, InfluxDB)
* Monitor CI/CD pipeline
  * capture metrics like deployment start time, end time, etc.
  * Deployment metrics along with application performance metrics together can help identify issues caused by a particular deployment.
* __Health Endpoint Pattern__
  * `/health` endpoint pattern or _canary endpoint_ or _status endpoint_ is an HTTP endpoint to provide basic health metrics about the app - e.g., app version, configuration used, status of dependencies, etc.
  * Benefits
    * can be used as the health check for a load balancer or for service discovery tools
    * helpful for debugging: exposing build information helps with determining what is running in the environment easily
  * Downsides
    * involves a lot more engineering work to implement than a simple push-based metrics approach
    * need tooling to consistently check the endpoint
* Monitoring Serverless Apps
  * TBD


### Server Monitoring

* __CPU usage__: `/proc/stat` metrics via `top` command
* __Memory usage__: `/proc/meminfo` metrics via `free -m` command
  * also monitor the _OOMKiller_ spawning in the logs
* __Network usage__: `/proc/net/dev` metrics via `ifconfig`, `ip`(from the `iproute2` package)
* __Disk usage__: `/proc/diskstats` metrics via `iostat -x` (from the `sysstat` package)
  * _iowait_ represents the amount of time the CPU was idle due to waiting on the disk to complete operations.
  * `iostat` without `-x` returns _tps (transfers per second)_ or _IOPS (I/O per second)_. Noticing a sudden drop in IOPS may indicate a disk performance problem.
* __Load__: `/proc/loadavg` metrics via `uptime` command.
  * Load is a measurement of how many processes are waiting to be served by the CPI. It's represented by 3 numbers: a 1 m average, a 5 m average, a 15 m average ([Brendan Gregg's article to learn more](http://www.brendangregg.com/blog/2017-08-08/linux-load-averages.html))
* __SSL Certificates__
  * For external site monitoring, use tools like Pingdom, StatusCake, etc.
  * For internal site monitoring, create custom shell scripts. 
* __Web Servers__
  * _Requests per second (req/sec)_:Golden metric for assessing web server performance or throughput.
  * _open connections_ or _keepalives_
    * connections are _not_ requests. Prior to the use of keepalives, each request required its own connection. Since a web page may have multiple objects to request for the page to load, this led to a whole lot of connections. 
    * Opening a connection requires going through the full TCP handshake, setting up a connection, moving data, and tearing down the connection - dozens of times for a single page. 
    * Thus, _HTTP keepalives_ were born: the web server holds open the connection for a client rather than tearing it down, to reuse the connection for the client which allows many requests to be made over a single connection. Of course, the connection can't be held open forever, so keepalives are governed by a timeout on the webserver side. 
    * There is also a keepalive configuration on the browser side called _persistent connection_ with their own timeout values. All modern browsers use persistent connections by default.
  * _request time_
* __Database Servers__
  * _open connections_
  * _queries per second_
  * _IOPS_
* __Caching__
  * _# of evicted items_: high evictions are a good signal for a cache being too small, causing too many items to be evicted in order to make room for new items.
  * _Hit/miss ratio_ or _cache-hit ratio_
* __NTP server__
  * `ntpstat`

### Network Monitoring

TBD

### Security Monitoring

* __HIDS (Host Intrusion Detection System)__
  * detects bad actors or _rootkits_ on a particular host
  * Rootkits can be anything from mass-installed webshells to stealthy recompiled binaries and everything in-between.
  * Due to their stealthy nature, rootkits can be rather difficult to detect.
  * Tools: _rkhunter_, [OSSEC](https://ossec.github.io).
* __NIDS (Network Intrusion Detection System)__
  * detects threats on the network itself.
  * works by listening in on the raw traffic on the wire using one or more _network taps_ placed throughout the network.
  * A _Network tap_ is a piece of hardware that sits inline on your network, intercepting all traffic that passes through it and forwarding a copy to another system.
  * The networks tap traffic are sent for analysis into a tool called __security information and event management (SIEM)__. e.g., [Zeek](https://www.zeek.org/), [Snort](https://www.snort.org/).

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
* [Jaeger](https://jaegertracing.io/) - open-source distributed tracing system
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
* [Zipkin](http://zipkin.io/)
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

# Logging

* Structured Logging - https://stackify.com/what-is-structured-logging-and-why-developers-need-it/

## slf4j

* Meta logging Frameworks - http://www.slf4j.org
* NDC, MDC statements - http://stackoverflow.com/questions/7404435/conditional-logging-with-log4j?
* What are the classloader issues that plague JCL?
* what is meant by 'static binding approach' in sl4j?
* Marker objects
* NOPLogger?


# Tracing

* Distributed Tracing is a methodology and toolchain for monitoring the complex interactions inherent in a microservice architecture. 
* e.g. Google Dapper, Zipkin
* How it works?
  * for every request that ocmes in, "tag" it with a unique request ID. 
  * this request ID stays with the request and resulting requests throughout its life, allowing to see what services a request touches and how much time is spent in each service.
* Tracing is more concerned with individual requests than aggregated metrics

## OpenTracing

* [OpenTracing](https://opentracing.io/) is a vendor neutral specification for instrumentation APIs.
* It offers consistent, expressive, vendor-neutral APIs for popular platforms, making it easy for developers to add (or switch) tracing implementations with an `O(1)` configuration change. 
* OpenTracing also offers a lingua franca for OSS instrumentation and platform-specific tracing helper libraries.
* [Tutorials](https://github.com/yurishkuro/opentracing-tutorial)
* CNCF [Jaeger](https://jaegertracing.io/), a Distributed Tracing UI Platform 

# References

* Books
  * [Mastering Distributed Tracing](https://www.shkuro.com/books/2019-mastering-distributed-tracing/)
  * Distributed Systems Observability - Cindy Sridharan
  * Logging and Log Management - Anton Chuvakin, Kevin Schmidt
  * O'Reilly Book - [Practical Monitoring](https://www.practicalmonitoring.com/)