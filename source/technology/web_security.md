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

## SQL Injection

...

## XSS (Cross Site Scripting)

* XSS is a case of a browser trusting JavaScript from the server too much.
* Dynamic data can be inserted into HTML element attributes like this:
    * `<script>alert('hello')</script>`
    * `<img src="picture.jpg" alt="blah" onload="alert('Hello from alt text!');" />`
* With some imagination, hackers can inject JS code to read the victim's browser details include cookies, headers, etc.
* For an interesting case study of what XSS can do, consider the case of the [Samy worm](https://en.wikipedia.org/wiki/Samy_(computer_worm)). Samy Kamkar, the author of the worm, introduced a little bit of JavaScript onto his home page on Myspace. When a logged-in victim visited Samy’s page, Samy’s JavaScript would execute in the victim’s browser. This JavaScript would programmatically click all the buttons that were required to add Samy as a friend and copy itself onto the victim’s home page. Then, when yet another victim visited the first victim’s home page, they too would add Samy as a friend and copy the JavaScript onto their home page. This worm quickly went viral and in less than a day more than one million friends had been added to Samy’s account.

* __How to prevent?__
    * Use HTML Encoding as defense. Always encode the user input using well-known client libraries. 
    * [https://www.google.com/about/appsecurity/learning/xss/](https://www.google.com/about/appsecurity/learning/xss/)

| Rendered Character | Named Character | Decimal Numeric Character | Hex Numeric Character |
| & | `&amp;`  | `&#38;` | `&#x26;` |
| < | `&lt;`   | `&#60;` | `&#x3C;` |
| > | `&gt;`   | `&#62;` | `&#x3E;` |
| ” | `&quot;` | `&#34;` | `&#x22;` |

## CSRF (Cross-Site Request Forgery)

* XSRF is a case of a server trusting a browser too much
* Normal Scenario
    * Say www.myblog.com is a site where users can publish articles. A user named 'John Snow' logins legitimately creating a sessionid that is stored in a cookie.
    * When an article is published, the POST request would look like the one below. 
    * A valid session id is passed, so the server successfully publishes the article on his behalf.

```
POST /blog/create HTTP/1.1
Host: www.myblog.com
Accept-Encoding: gzip, deflate
Accept: */*
Cookie: sessionid=Re9ljf4uObKk9mSFqBlusxamUKw
Connection: keep-alive
Content-Type: application/x-www-form-urlencoded; charset=utf-8
Content-Length: 57
	
body=It+was+the+best+of+posts.+It+was+the+worst+of+posts.&submit=Publish
```

* Hack Scenario
    * A malicious user creates an HTML page or a website to which John Snow happens to visit.
    * The malicious site happens to have an HTML form like the one below which reads John's browser cookie and submit the form on page load - without his knowledge. 
    * The POST request would exactly like the above, and the server wouldn't be able to tell the difference.
    * The browser’s same-origin policy (SOP) won’t help here either. SOP only says that JavaScript from one site can’t see responses sent back from other sites. But this attack doesn’t require the JavaScript from the malicious site to see a response from the blogging site. This attack only requires that the JavaScript from the malicious site be able to POST a request to the blog site, which it can.

```html
<!DOCTYPE html>​
​ 	<html lang=​"en"​>
​ 	<body>
​ 	  <form action=​"http://myblog.com/post/create"​ method=​"POST"​>
​ 	    <input
​ 	      name=​body​
​ 	      value=​"Arbitrary Attacker-Controlled Content. I love evilxsrf.com"​/>
​ 	    <input type=​submit​ id=​submit​ name=​submit​ value=​Publish​ />');
​ 	  </form>
​ 	
​ 	  <script>
​ 	   document.getElementById(​'submit'​).click();
​ 	  </script>
​ 	</body>
```

__How to prevent?__

* <u>Method 1: Prevention with hidden form input</u>
    * The server cannot rely on sessionID or cookie alone as we saw above. 
    * The browser needs to submit a little bit of secret data with every _state-modifying request_ that only myblog.com knows. This secret can’t be stored in a cookie though, because cookie values will be sent regardless of whether the request was initiated by a logged-in user or a malicious site operator. This leaves the form itself.
    * The defense against this is the __XSRF hidden form input__. When a user logs into the blog site, the server should set a large (say 128 bits, base64-encoded) cookie valid only for the duration of the session. Every page that contains a form that will `POST` back to the blog server needs to put that same value into a hidden form input. Only the blog site and the browser have this value. So when the user submits a valid `POST` to the blog site, this request will contain the anti-XSRF value in both the cookie and the body, like this.
    * The malicious website wouldn’t be able to guess the value of the anti-XSRF cookie, and so it would not be able to replicate that value in the body of the request. If the server doesn’t see the value in both places, the server can reject the request as a fake. At a minimum, requests like this should be denied and logged for later review.
    * Cons
        * If the site is vulnerable to XSS, then this defense won't work, since the hacker can write a script to read the cookie value.
* <u>Method 2: Prevention with 'SameSite' cookie setting</u>
    * Create a cookie from web application with `SameSite` setting enabled. This tells the browser to send the cookie ONLY for requests originating from the site that created the cookie. 
        * `Set-Cookie: SessionId=sfVZ1yx68LD51I; SameSite=Strict;`
            * Adding `SameSite=Strict` to a cookie definition tells a browser to never send that cookie for any request to our site unless the request originated from our site. 
            * Downside: With `SameSite=Strict`, other legitimate sites won’t be able to link successfully to our web application because the initial request to our web application won’t include the SessionId cookie since it originated from another site. If a user clicks on a link from another website to our web application, that first request would not include the SessionId cookie, so the user would probably be prompted to log in, even if they had already logged in. This would be an appropriate choice if you know that you don’t need to support other sites linking to your web application, .
        * `Set-Cookie: SessionId=sfVZ1yx68LD51I; SameSite=Lax;`
            * By doing this, all safe requests (`GET`, `HEAD`, `OPTIONS`, `TRACE`) will send the cookie, even if the request originates from another site. This way, the initial link from an external site to our web application will send the SessionId cookie since clicking on the link will result in a GET request. But a malicious site that wants to exploit XSRF by constructing a form and getting a user to submit a POST request would fail because the `SameSite` attribute on the SessionId cookie wouldn’t get sent because the request originated on another site.

```
​POST / HTTP/1.1
​Host: localhost:1234
​Accept-Encoding: gzip, deflate
​Accept: */*
​Connection: keep-alive
​Cookie: antixsrf=XKRYopsd8jXj5DqgfNpHmA
​Content-Type: application/x-www-form-urlencoded; charset=utf-8
​Content-Length: 94
​
​body=It+was+the+best+of+posts.+It+was+the+worst+of+posts.&submit=Publish&antixsrf=XKRYopsd8jXj5DqgfNpHmA
```

## CORS (Cross Origin)

...


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

* Book - Practical Security