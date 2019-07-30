---
layout: page
title: "Web Security"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Vulnerabilities

## XSS (Cross Site Scripting)

* 
* e.g., an input field allowing JS code like `<script>alert('hello')</script>`

__How to prevent?__

* [https://www.google.com/about/appsecurity/learning/xss/](https://www.google.com/about/appsecurity/learning/xss/)

# HTTP Security Headers

* [https://github.com/twitter/secure_headers](https://github.com/twitter/secure_headers)

## Content-Security-Policy

* used to prevent cross site scripting by specifying which resources are allowed to load
* it is enabled by setting the `Content-Security-Policy` HTTP response header.

```
# Default to only allow content from the current site
# Allow images from current site and imgur.com
# Don't allow objects such as Flash and Java
# Only allow scripts from the current site
# Only allow styles from the current site
# Only allow frames from the current site
# Restrict URL's in the <base> tag to current site
# Allow forms to submit only to the current site
Content-Security-Policy: default-src 'self'; img-src 'self' https://i.imgur.com; object-src 'none'; script-src 'self'; style-src 'self'; frame-ancestors 'self'; base-uri 'self'; form-action 'self';
```

* [https://content-security-policy.com/](https://content-security-policy.com/)
* [https://csp.withgoogle.com/](https://csp.withgoogle.com/)
* [Mozilla Observatory](https://observatory.mozilla.org)
* [Mozilla Laboratory-Browser Extension](https://addons.mozilla.org/en-US/firefox/addon/laboratory-by-mozilla/)

# References

* 