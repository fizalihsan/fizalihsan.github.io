---
layout: page
title: "Security"
comments: true
sharing: true
footer: true
---

[TOC]

# Authentication

## Basic Authentication

It involves sending a Base64-encoded username and password within a request header to the server. The server checks to see if the username exists within its system and verifies the sent password. The client needs to send this Authorization header with each and every request it makes to the server.

```
GET /customers/333 HTTP/1.1
Authorization: Basic YmJ1cmtlOmdlaGVpbQ==
``` 
**Downside**: The problem with this approach is that if this request is intercepted by a hostile entity on the network, the hacker can easily obtain the username and password and use it to invoke its own requests. Using an encrypted HTTP connection, HTTPS, solves this problem. With an encrypted connection, a rogue programmer on the network will be unable to decode the transmission and get at the Authorization header. Still, security-paranoid network administrators are very squeamish about sending passwords over the network, even if they are encrypted within SSL packets.

## Digest Authentication

Digest authentication was invented so that clients would not have to send clear text passwords over HTTP. It involves exchanging a set of secure MD5 hashes of the username, password, operation, URI, and optionally the hash of the message body itself. It is a hash value generated with the following pseudocode:
 
```
H1 = md5("username:realm:password")
H2 = md5("httpmethod:uri")
response = md5("H1:nonce:nc:cnonce:qop:H2")
```

When the server receives this request, it builds its own version of the response hash using its stored, secret values of the username and password. If the hashes match, the user and its credentials are valid. 
One advantage of this approach is that the password is never used directly by the protocol. For example, the server doesn’t even need to store clear text passwords. It can instead initialize its authorization store with prehashed values. Also, since request hashes are built with a nonce value, the server can expire these nonce values over time. This, combined with a request counter, can greatly reduce replay attacks. 
The disadvantage to this approach is that unless you use HTTPS, you are still vulnerable to man-in-the-middle attacks, where the middleman can tell a client to use Basic authentication to obtain a password.

## X.509 certificates

?????

# Authorization

???