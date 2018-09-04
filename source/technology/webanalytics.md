---
layout: page
title: "Web Analytics"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Concepts

* __What is a Web Tag?__
    * A web tag is a `1x1` pixel-sized image beacon or JavaScript snippet that is embedded into the code of a web page to capture and report data. A web tag is triggered whenever a predetermined action occurs on a specified platform in the web. It captures the data and sends the information back to your preferred data collection system. A web tag is usually implemented to: track online user behavior for marketing analytics, instruct web browsers and implemented technologies to collect data, to set cookies and to integrate third-party content.

# Web Analytics 1.0

* Web analytics evolution
    * Web server logs parsing -> WebTrends
    * Javascript Tags
    * Site overlay or Click Density
        * display where visitors clicked
        * segments based on where users came from
* __Traditional Analytics KPI Metrics__
    * Page views
        * frustrating navigation means more page view, but no buy
        * better naviation means faster decision, and yet no buy
    * Hits
        * Pages with images & media has more hits to the server
        * With CDNs, servers receive lesser hits
        * `more hits != more visitors`
    * Top Exit Pages
        * Top Exit Pages does not mean pages are suboptimal or product is bad
        * Exit rates doesn't tell content is good or bad
    * Website Engagement
        * `Engagement = # of sessions / # of visitors`
        * Repeated visitors means they can't find what they want or the site is good?
    * Visitor screen resolution
        * Seldom this data changes. Instead of wasting time and money capturing this, use Forrestor Research/Gartner data

Traditional KPI can't accommodate for strategic business goals. We now have __KIA__ (_Key Insight Analysis_)

* __KIA__ (_Key Insight Analysis_)
    * Click Density Analysis
        * using the site overlay feature, it helps you walk in the shoes of your customer
        * segment your traffic and personalize content differently for visitors from Google vs. Facebook, increasing the customer engagement
    * Visitor Primary Purpose
        * ask customers why they are visiting your site
        * run a survey, do phone interviews, etc.
    * Task Completion Rates
        * Page views != users found what they were looking for
        * Do survey, lab usability, create tests, ...
    * Segmented Visitor Trends
        * old world embedded attributes in JS tags
        * new tools = Click Tracks, Visual Sciences
        * Reports on "Average time on site", "Top search keywords", "popular content"- based on real segmentation of data.
    * Multichannel Impact Analysis
        * Measuring the impact of non-web channels (like TV, newspaper) on your website
        * e.g. how many people use your site but buy your product via retail or phone channel?





# Web Analytics 2.0

| Web Analytics 2.0 | Multiplicity |
| -- | -- | 
| {% img /technology/web_analytics_2.0_demystified.png %} | {% img /technology/web_analytics_multiplicity.png %} | 


* Quantitative, Qualitative, Competetive analytics
* Paradox of Data
    * Lack of data -> cannot make complete decisions
    * Lots of data -> less insights

__Multiplicity__

* one tool from each layer/pillar for better insights

1. Clickstream data (WHAT)
    * click-level data
    * visits, visitors, source, time on site, page views, etc.
    * great at answering "WHAT", but not "WHY"
    * e.g, tools like WebTrends, Google Analytics
2. Multiple Outcome Analysis (HOW MUCH)
    * measuring outcome means connecting customer behavior to the bottom line of the company
    * outcome types of a webiste
        * increased revenue
        * reduced cost
        * improve customer satisfaction/loyalty
3. Experimentation and Testing (WHY)
    * Launch fast, fail/succeed fast `Experiment or Die`
    * A/B and multivariate testing
    * Tools: Google Website Optimizer, Adobe Analytics Target
4. Voice of Customer (WHY)
    * What customers wanted, but did not find
    * e.g., surveys, lab usability testing, remote usability testing, card sorts, etc.
5. Competitive Intelligence (WHAT ELSE)
    * compare your performance with your competitors
    * gether info on your direct and indirect competitors

> Knowing how you are performing is good; Knowing how your competitors are performing is priceless.


* Maxamine/ObservePoint
    * missing JavaScript tags, duplicative content, security & privacy compliance, black holes not crawled by search engine, broken links/forms.
* Coradiant
    * Why conversion rates are low? Pages are slow or missing?

# References

* Books
    * Web Analytics - An hour a day - Avinash Kaushik
    * Web Analytics 2.0 - Avinash Kaushik