---
layout: page
title: "Backend for Frontend"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Overview

## Characteristics

- The defining characteristics of a BFF are
    - the API used by a client application is part of said application, 
    - owned by the same team that owns it,
    - and it is not meant to be used by any other applications or clients.
- The BFF is tightly coupled to a specific user-experience or an application. 
- BFF isn't an API used by the application, but it is part of the application.

## Why BFF?

- easier to define and adapt the API as the UI requires.
- simplifies the process of lining up release of both the client and server components.
- backends tend to live longer than the UI. With a general purpose API, you may have to keep older versions of API or endpoints around just to satisfy a small subset of experiences.
- aggregate data from multiple downstream services - especially when the team building the UI is different than the downstream services.
- handle failures elegantly and partial failures.
- allows the app team to optimize the API (BFF) specific to their use cases
    - _API payload_ - e.g., Android team can use Protocol Buffers instead of JSON for their API payload.
    - _RPC flavor_ - allows the app team to use any flavor of RPC like REST, gRPC, GraphQL, SOAP or any other combination of wire protocol or architecture style.

## Downsides of BFF

- multiple API layers can potentially add latency
- duplication of code between the BFFs which can lead to accidental divergences between experiences. e.g., same type of aggregation of downstream services, same or similar code for interfacing with downstream services.
    - __Counter Arguments__
        - duplication in such cases are better than creating a general purpose Edge API with highly bloated code with multiple concerns squashed together.
        - duplication in such cases are better than tightly coupling multiple experiences to the services which increases the cost of testing and release.
    - __Alternatives__
        - cheapest option is to extract shared code and create a shared library. However, shared libraries are a prime source of coupling. ___AVOID THIS___
        - extract shared code and create a new service
        - using GraphQL
    
## BFF vs. API Gateway

- A BFF is a single-purpose API for a specific type of client or user-experience
- API Gateway is general-purpose - it acts as an abstraction/aggregation layer for multiple clients. Implement an API gateway that is the single entry point for all clients.

## BFF vs. GraphQL

- these 2 are related but not mutually exclusive technologies
- you can build your GraphQL APIs as many BFFs or as an OSFA (one-size-fits-all) API
- BFFs are not about the shape of your endpoints - but about giving your client applications autonomy
- GraphQL literature insists that this new technology gives so much freedom to the client by allowing them to perform ad-hoc queries that you can safely have a single OSFA API without the drawbacks from REST-based approaches. However, it is hard to believe that you can combine the needs of many different applications, owned by different teams, with different users and use cases in a single schema (also called '__schema stitching__').
- invest in RESTful BFFs, keep their APIs separate, and migrate them to GraphQL - instead of trying to jump to an OSFA GraphQL API.

# References

- BFF overview - https://samnewman.io/patterns/architectural/bff/
- GraphQL vs. BFF - https://philcalcado.com/2019/07/12/some_thoughts_graphql_bff.html
- Schema stitching 101 - https://artsy.github.io/blog/2018/12/11/GraphQL-Stitching/
