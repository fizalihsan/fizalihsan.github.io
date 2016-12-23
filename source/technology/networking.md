---
layout: page
title: "Networking Basics"
comments: false
sharing: false
footer: true
---

* list element with functor item
{:toc}

# ACLs

# DHCP (Dynamic Host Configuration Protocol)

# DNS servers

## CNAME record

CNAME stands for Canonical Name. CNAME records can be used to alias one name to another.

For example, if you have a server where you keep all of your documents online, it might normally be accessed through `docs.example.com`. You may also want to access it through `documents.example.com`. One way to make this possible is to add a CNAME record that points `documents.example.com` to `docs.example.com`. When someone visits `documents.example.com` they will see the exact same content as `docs.example.com`.

# Subnet

## Why Subnet?

* Why not just use separate IP addresses and not worry so much about splitting things into smaller chunks. Unfortunately, we quickly run into problems when an IP address in NY needs to talk to another IP address in Sydney. It’s practically impossible for the Internet routers to maintain an entire table of everyone’s individual IP address; the lookup process would be painfully slow, and the amount of memory needed to maintain such a massive list would be impractical.
* Instead, most routers have a much smaller table that contains groups of networks, or _subnets_. These network routing tables provide routers with the information they need to pass the packets along in the right direction.
* _Telephone Switch_: This is similar to old-school telephone systems. The entire county is split into “area codes,” and we have individual “exchanges” within a single area code. If 212-555-1212 needs to call 305-555-1212, the telephone switches in the 212 area code simply pass the request to the telephone switches in the 305 area code. The 212 phone switches don’t have a list of every possible phone number in the 305 area, and they don’t need to. The 305 phone switches transfer the call to the local 555 exchange, which then can direct the phone call to the local 1212 number.

* One of the address ranges RFC 1918 provides is `10.0.0.0/8`, which means practically over a 16 million different IP addresses are available in a single network. It is not practical for any network to manage this, so the network must be split up into smaller chunks called _subnets_

* **Subnet Masks**
  * A subnet mask of `255.255.255.0` means 255 IP addresses are available for the private network.
  * Subnet mask `255.255.0.0` means `255 * 255 = 65,025` addresses are available.
  * Unlike IP addresses, the subnet mask isn’t transmitted in the traffic flow between devices. The subnet mask is only used by the local computer, and it’s only used to help the computer determine which network it belongs to.
  * In the below example, the combination of our computer’s IP address of 10.25.6.25 with our subnet mask of 255.255.255.0 means that the computer knows to send local network traffic directly to devices in the IP address range of 10.25.6.1 through 10.25.6.255. If the IP address of a destination computer is ever anything different, the computer knows that the traffic needs to leave the local network and it will send the packet to the default gateway of 10.25.6.1. The default gateway is IP address of the local router, and the router has the all of the information it needs to send packets from the local network to other networks (and perhaps the Internet).

```
IP address: 10.25.6.55
Subnet mask: 255.255.255.0
Default gateway: 10.25.6.1
```

## CIDR (Classless Inter-Domain Routing)

* An IPV4 address is a combination of 4 octets _XX.XX.XX.XX_ where XX is a number between 0 and 255 (2 ^ 8 = 256). A combination 8 x 4 = 32 bits.
* To express a range of addresses between 10.0.0.0 and 10.0.0.255 in CIDR format is _10.0.0.0/24_.  This denotes that the first 24 of the 32 bits remain constant, but the last 8 can be incremented.
* In early days of Internet, subnets were classified as Class A, B and C. This practice has been antiquated since 1993.
* As the Internet grew, we realized that we would need a more precise way to split our networks apart. Hence the move from class-based addressing to a more flexible addressing scheme called _Classless Inter-Domain Routing_ (pronounced cider)
* CIDR makes it easy to store IP ranges in routers and DNS servers


## NAT (Network Address Translation)

* When you get Internet connection for first from your ISP, they provide you with a single IP address.
* Internally, you can create a private network with multiple private IP addresses. Practically the private network can have as many IPs as they'd like.
* RFC 1918 provides blocks of private IPs that can be used for internal or private networks. These private IP addresses are not routable over the Internet. Even if you tried, the Internet routers would drop your packets immediately.
* One of the address ranges RFC 1918 provides is `10.0.0.0/8`, which means practically over a 16 million different IP addresses are available in a single network. It is not practical
* NAT is used to translate internal IP addresses to a single public IP address.

# Network Interfaces

* NIC - Network Interface Card

# NTP (Network Time Protocol) Servers

# NetBIOS Name Servers

# References

* [CIDR Explained](http://software77.net/cidr-101.html)
* [What's with all this Subnet stuff](http://www.professormesser.com/after-class/whats-with-all-this-subnet-stuff/)
