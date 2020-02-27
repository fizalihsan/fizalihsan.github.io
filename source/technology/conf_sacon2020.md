---
layout: page
title: "O'Reilly Software Architecture Conference 2020"
comments: false
sharing: false
footer: false
---
* list element with functor item
{:toc}

# Day 1: Service Mesh training (Linkerd)

* Control plane and data plane (proxy side car) are separated
* Tenants
    * Observability
    * Security: encryption traffic b/w services
    * Reliability
    * Traffic Management: routing between services
* Service Mesh Interface Spec (???)
* https://github.com/cpretzer/linkerd-traffic-split

## Linkerd features

* __Reliability__
    * __Automatic retries & timeouts__
        * for gracefully handling partial or transient application failures.
        * Timeouts work hand in hand with retries. Once requests are retried a certain number of times, it becomes important to limit the total amount of time a client waits before giving up entirely.
        * A _service profile_ may define certain routes as retryable or specify timeouts for routes. This will cause the Linkerd proxy to perform the appropriate retries or timeouts when calling that service. Retries and timeouts are always performed on the outbound (client) side
        * _Retry budget_: Rather than specifying a fixed maximum number of retry attempts per request, Linkerd keeps track of the ratio between regular requests and retries and keeps this number below a configurable limit. For example, you may specify that you want retries to add at most 20% more requests. Linkerd will then retry as much as it can while maintaining that ratio.
* __Security__
    * __mTLS__
        * By default, Linkerd automatically enables mutual Transport Layer Security (mTLS) for most HTTP-based communication between meshed pods, by establishing and authenticating secure, private TLS connections between Linkerd proxies.
        * Linkerd control plane also runs on the data plane, this means that communication between Linkerd's control plane components are also automatically secured via mTLS.
        * Linkerd's control plane issues TLS certificates to proxies, which are scoped to the Kubernetes ServiceAccount of the containing pod and automatically rotated every 24 hours. The proxies use these certificates to encrypt and authenticate most HTTP traffic to other proxies.
* __Traffic Management__
    * Proxy all connections (http, http/2, grpc) and automatically collect metrics, load balance, retries, etc.
    * capable of proxying all TCP traffic, including TLS'd connections, WebSockets, and HTTP tunneling.
    * __Ingress__
        * Linkerd does not provide its own ingress controller. Instead, Linkerd is designed to work alongside your ingress controller of choice.
* __Observability__

```bash
export KUBECONFIG=/Users/maryam/.kube/fizal-k8s-cluster-kubeconfig.yaml
kubectl apply -f module1/booksapp.yml
kubectl config set-context --current --namespace=booksapp
kubectl get po -w
kubectl get svc -w # wait for the external IP to show up after the service is up and access http://<ip>:7000

# to access it via http://localhost:7000, run port forward
kubectl port-forward svc/webapp 7000

# install linkerd client (https://github.com/linkerd/linkerd2/releases/tag/stable-2.7.0)
curl https://run.linkerd.io/install | sh
export PATH=$PATH:/Users/maryam/.linkerd2/bin

linkerd check --pre                     # validate that Linkerd can be installed
linkerd install > linkerd-install.yaml  # to save the yaml file
linkerd install | kubectl apply -f -    # install the control plane into the 'linkerd' namespace
linkerd check                           # validate everything worked!
linkerd dashboard                       # launch the dashboard

kubectl get po -n linkerd       # view the linkerd pods
kubectl get deploy -n linkerd   # view the linkerd deployments
kubectl get svc -n linkerd      # view the linkerd services

kubectl get ns booksapp -oyaml # view namespace before annotation injection
kubectl annotate ns booksapp linkerd.io/inject=enabled # update the booksapp namespace to enable automatic proxy injection

kubectl rollout restart deploy
kbuectl 
kubectl get po -w

``` 


* Linkerd does auto-injection based on K8s annotations

* Ingress controller
    * it is like a reverse proxy for your services
    * NGINX is used here
    * Instead of kubeproxy based load balancing, Linkerd takes over and uses EWMA algorithm to load balance.
    * Allows to add mTLS between ingress controller and the services. What is mTLS or mutual TLS?
    * Monitor the golden metrics at endpoint level
    * Linkerd control plane is also injected with linkerd proxy to collect its health metrics
* Routes
    * 
* Service profiles
    * retry if a svc call fails
    * timeouts
    * get notifications if P99 latency went up, for example
* Edges: shows all the edges (graph) or connections between services
* Taps: monitors the tcp traffic b/w svcs

* Mac watch command?


# Day 1: Building APIs with Contract Driven Development

* https://github.com/jpgough/api-workshop
* https://github.com/jpgough/api-workshop-solution

* Spring Cloud Contracts spec?
    * supports Spock??
* You can generate stubs from contracts
* See ATDD (Acceptance testing driven development)
* 2 entities: producer, consumer
* types:
    * producer-driven contract - producer creates their own contract
    * consumer-driven contract, 
* [Pact](https://pacti.io)
    * Pact is for testing the contract used for communication, and not for testing particular UI behaviour or business logic
    * Contract Broker: application for sharing of contracts. Pact provides a broker.
    * Supports GraphQL
* Open API specification
    * only defines the shape and structure, not the behavior
    * Why?
        * documentation
        * generate code  (in any language)
    * XSD, CORBA, WSDL, WADL, gRPC
    * supports GraphQL???
    * Spring-fox - an OS project scans annotations and generates the spec
    * Swagger
        * Swagger request validator.
* 2 approaches
    * Contract driven development
    * API Specification first
        * Create client and server code using Swagger codegen (`brew install swagger-codegen`) - https://github.com/swagger-api/swagger-codegen

# Day 2 & 3

- Spring cloud pipeline
- Blog "[How we build code at Netflix](https://netflixtechblog.com/how-we-build-code-at-netflix-c5d9bd727f15)"
- Fitness functions - continually evaluating architecture effectiveness
- user story, Architecture story, technical debt stories
- value stream mapping
- SLI, SLO, 
- Remove GOD objects
- Reduce cyclomatic complexity
- AWS API gateway is serverless?
- AWS dynamo dB is serverless?
- Exploring DDD conference Denver
- Data operators in Java?
- Software - must stay on top of complexity. Reduce cognitive complexity
- Keep intellectual testing high
    - Culture of good and simple design
    - Property based testing
    - Model based testing
- Micro service - shared dB- number of connections can exponentially grow and cause latency and connection timeouts
- Service locator vs. service discovery
- Why microservices
    - Agility
    - Testabilty
    - Deployability
    - Scalability
    - Fault tolerance
    - Maintainability
- Kustomize or Openshift template
- K8s operator 
- Microservices DDD 
    - Decomposition strategies
        - Bounded contexts
        - Subdomains
        - Business entities and processes

