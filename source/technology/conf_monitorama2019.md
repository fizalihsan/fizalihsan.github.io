---
layout: page
title: "Monitorama Conference - Baltimore 2019"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc} 

# Monitorama Conference - Baltimore 2019

* __Dashboard Renaissance - Cory from Splunk__
    * Book: The Design of Everyday Things by Dan Norman
    * What's the goal/purpose of this dashboard?
    * what action to take?
    * most important things in your dashboard should be on the top left and least important on bottom right
    * What to include
        * RED and USE techniques
        * prefer symptoms over causes
    * Pre-attentive processing - position, angle/slope, size/length, volume, color/density
    * What chart type
        * Heatmaps show outliers
        * Saturation is low accuracy
        * Bar charts - better for comparison of a few values
    * Scales, Units, Norms, Labels
    * https://www.usability.gov/what-and-why/visual-design.html - accessibility

* __Before, During, and After Chaos - Nora Jones @nora_js__
    * Different phases of Chaos Engineering
    * Chaos Engineering
        * O'Reilly e-book
        * AWS re:Invent 2017 Nora Jones - Youtube video
    * obscure hindsight bias
    * Serial propensity effect -
    * https://www.oreilly.com/library/view/velocity-conference-2017/9781491976265/video311370.html

* __Logs, Metrics, endpoints - Bryan Liles -  Tanzu Build, VMWare__
    * Logging best practices
        * Best format: JSON. (Jsonnet?). slf4j for json format?
        * log to stdout
        * syslog - logs at scale
        * add context to your log messages
    * Metrics
        * USE (, saturation, ),
        * RED (rate, error, duration),
        * Four Golden Signals (latency, traffic, error, saturation) - this may work better at scale
        * Best practices
            * OpenMetrics/Prometheus
            * Keep the number of metrics to manageable size (may be 100s, not 1000s)
    * Endpoints
        * TCP, HTTP, Custom Reponse
        * Best practices - look at the deck
    * Traces
        * Distributed tracing (OpenTracing, Jaeger)
        * traces are composed of spans
    * OpenTelemetry - capture metrics and distributed traces
* Jeff from Netflix
   * Mantis - Open source streaming microservices monitoring solution
        * answers new questions that you forgot to log
        * low latency
        * cost-effective
* __Developing meaningful SLIs__ - Alex Hidalgo (Squarespace Engineering http://slidesgala.com)
    * Service Level Indicator
    * SLI (engineering) = User journey (product team) = KPI (business)
* __M.E.L.T. Level Up - Ron from NewRelic__
    * MELT
        * Metrics - Micrometer, Istio, Prometheus, OpenTelemetry, DropWizard
        * Events - alerts and deployments are example of events
        * Logs - json:api, fluentbit, cloudwatch,
        * Traces - Zipkin, OpenTelemetry, Istio
    * Platform - Zipkin, OpenTelemetry, Istio, Micrometer, DropWizard
* LightStep
    * Tech paper - Dapper, distributed tracing paper
* [Stackdriver](https://cloud.google.com/stackdriver/) monitoring from Google
* __Designing Alerts to Direct Attention - Ryan Frantz__
    * https://www.pbs.org/newshour/science/3-brain-technologies-to-watch-in-2018
    * Mental model of a system
* __Fitness Function-Driven Development - Rosemary WAng ThoughtWorks__
    * Evolutionary Architecture
    * Fitness function - borrowed from Genetrics algorithm
        * SLO can be a Fit func
    * Benefits
        * KonMari method for former assumptions, tools and telemetry
        * Highlights gaps in process, tooling and telemetry
        * open discussions for tech deby
        * develop mutual learning context
    * https://github.com/joatmon08/2019-monitorama

* __Presentation - Pete Cheslock @petecheslock__
    * http://lusislog.blogspot.com/2011/06/why-monitoring-sucks.html
    * https://mattturck.com/data2019/
    * Logging best practices
        * Log in JSON format
        * put everything in the json
        * send it all to your Data Lake (georgehart.com)
    * Presentation Material: https://pete.wtf/decks/MonitoramaBaltimore2019.pdf
* __How to interview__
    * Diversity
    * Preparation - get trained on interviewing. be comfortable
    * Read the job description. Find the right candidate for the job. This isn't about you
    * Read the CV. Don't Google - beware of legal issues
    * Pair up
    * Present yourself professionally - don't take phone calls
    * Colloborate, don't confront
* Adopting a Product mindset for SRE and Observability teams
* You can’t spell "monitoring" without "monoid" - Kevin from NewRelic
    * Easy is not the same as simple - Rich Hikey's talk - e.g., Writing simple code is not easy
    * What is Monoid? a single algebraic structure with a single
        * Temporal and dimensional aggregation

* __Observability Graph - Homin Lee from Datadog__
    * Corollary to Conway's Law: Observability follows your org chart.
    * Gore's hypothesis (Goretex fabric)
        * a.k.a. prequel to Dunbar's number
        * a.k.a. thing you heard about from The Tipping Point
    * Graph with ontology is Knowledge graph
* __Observing Observability__ - Philip O'Toole from Google Cloud
    * Why observability is difficult 

# Tools

* BigPanda
* Catchpoint.com
* Circonus
* Datadog
* Elastic APM
* Honeycomb.io
* InfluxDB
* Jaeger
* Loggly
* NewRelic.com
* OpenCensus
* OpenMetrics
* OpenTracing
* OpenTSDB
* Prometheus
* SignalFx
* Site24x7.com
* StackDriver from Google
* Zipkin

# Follow ups

* Mantis - perhaps to visualize the service mapping and reliability of services
* Define SLIs for services we depend on
* Fitness Function-Driven Development
* Evaluate
    * http://play.honeycomb.io
* Create a matrix of tools and their features (MELT, alerts, USP, SaaS, real-time, cost etc.)
* GUTS (Grand Unified Telemetry System) overview videos
* Learn about AIOps, Monoids
* Convert DAP logs to JSON format - Benefits - Implications
* https://slidesgala.com
* https://vimeo.com/monitorama
* https://speakerdeck.com/monitorama
* What is ScyllaDB?
* [Statistics for Engineers - Heinrich Hartmann](https://github.com/HeinrichHartmann/Statistics-for-Engineers)
* If CMDB is static, what's the alternative?