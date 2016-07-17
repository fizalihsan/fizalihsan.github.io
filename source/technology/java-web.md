---
layout: page
title: "Java Web Technologies"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Servlets

{% img right /technology/servlet-class-diagram.png %}

## Servlet Life Cycle

* Load the servlet class
* `GenericServlet.init()` - invoked only once in servlet's lifecycle
* `GenericServlet.service()` - for each request, this method is invoked in a separate thread
* `GenericServlet.destroy()` - invoked only once in servlet's lifecycle

## Servlet Key/Value Stores

### ServletConfig

* used to access deploy-time configurations from web.xml.
* 1 per servlet.
* Key and value should be strings
* How to access: `this.getServletConfig();`

``` xml Servlet Config
<web-app>
   <servlet>
       ...
       <init-param>
          <param-name>key</param-name>
          <param-value>value</param-value>
       </init-param>
   </servlet>
</web-app>
```

### ServletContext

* used to access deploy-time configurations from web.xml
* 1 per web app
* Key and value should be strings
* How to access: `this.getServletConfig().getServletContext();`

``` xml Servlet Context
<web-app>
   <servlet>
       ...
   </servlet>

   <context-param>
      <param-name>key</param-name>
      <param-value>value</param-value>
   </context-param>
</web-app>
```

### HttpRequest	 

* Parameters (thread-safe)
  * set by client request.
  * servlet can set new parameters
* Attributes (thread-safe)
  * used by servlet to set additional key-value pairs before forwarding the request.

### HttpSession

* Parameters
* Attributes
* sessionId is set by the servlet on cookie in a response

## Listeners

* `ServletContextListener` - callback interface that is invoked after the ServletContext is initialized.

``` xml
<listener>
     <listener-class>com.test.Foo<listener-class>
</listener>
```

* `ServletContextAttributeListener`
* `ServletRequestAttributeListener`
* `HttpSessionListener`
* `HttpSessionBindingListener`
* `HttpSessionActivationListener`

## Redirect Vs Forwarding / Request Dispatch

### Request Redirect	 

* client requests url1 to server -> server redirects to a new url -> request makes a round trip back to client -> browser sends a new request to the new url
* url in the client browser is changed to the new url
* redirect is visible to the client

###  Request Forwarding / Request Dispatch

* client request url1 to server -> server redirects to a new url directly without round trip
* url in the client browser is not changed
* redirect is not visible to the client

## Deployment Descriptor (web.xml)

3 names of a servlet

* File path name: path to an actual class file. e.g., /classes/registration/SignUpServlet.class
* Deployment name: a logical internal name that doesn't have to be the same as the class name. e.g., EnrollServlet
* Public URL name: the name the client knows about from HTML link.

``` xml web.xml
 <servlet>
 <!-- end user nevers sees the 2 names below -->
 <servlet-name>Internal Name</servlet-name>
 <servlet-class>com.mfi.Servlet1</servlet-class>
 <!-- loads and initializes the servlet when the server starts. If multiple servlets are configured, they are loaded as per the number priority number provided -->
 <load-on-startup>1</load-on-startup>
 </servlet>

 <servlet-mapping>
 <servlet-name>Internal Name</servlet-name>
 <!-- this is the name the client sees.-->
 <url-pattern>/public1</url-pattern>
 </servlet-mapping>
```

## Servlet chaining / inter-servlet communication 

Calling another servlet from inside a servlet. Achieved by using RequestDispatcher.forward(req, res) and RequestDispatcher.include(req, res). 

# JSP

JSP

* Scriplets - `<% %>`. `<% out.println("Hello"); %>`
* Expressions - `<%= %>` - no semicolons needed. `<%= Counter.getCount()%>`
* Comments
  * `<%-- JSP comment: visible only to developer --%>`
  * `<!-- HTML comment: visible to client -->`
* Declarations - `<%! %>` - to declare methods and instance variables 
* Directives
  * Directives give special instructions to the container on page translation time.
  * Types
    * page directives - `<%@ page import="java.util.Date, java.util.List" %>`
    * include directives - To include external JSP/HTML files into another JSP. `<%@ include file="x.html" %>`
    * taglib directives - to include custom tag libraries. `<%@ taglib tagdir="/WEB-INF/lib" prefix="c" %>`
* Implicit Objects
  * `out - JspWriter`
  * `request - HttpServletRequest`
  * `response - HttpServletResponse`
  * `session - HttpSession`
  * `application - ServletContext`
  * `config - ServletConfig`
  * `exception - JspException`
  * `pageContext - PageContext`
  * `page - Object`
* Scopes
  * `app` - application
  * `request` - request
  * `session` - session
  * `page` - pageContext

## EL - Expression Language

* EL was introduced non-Java web developers
* `${applicationScope.mail}` is equivalent to `<%= application.getAttribute("mail")%>`
* To enable or disable scripting. `<scripting-invalid>true/false</scripting-invalid>` in web.xml
* To enable or disable EL. `<el-ignored>true/false</el-ignored>` in web.xml or using page directive `<%@ page isELIgnore="true" %>`

## Lifecycle methods of JSP

* JSP page (extends) `javax.servlet.jsp.HttpJspPage` extends `javax.servlet.jsp.JspPage` extends `javax.servlet.Servlet`
* The generated servlet class thus implements all the methods of these three interfaces. 
* The `JspPage` interface declares only two methods - `jspInit()` and `jspDestroy()` that must be implemented by all JSP pages regardless of the client-server protocol. However the JSP specification has provided the `HttpJspPage` interface specifically for the JSP pages serving HTTP requests. This interface declares one method `_jspService()`. 
* The `jspInit()` - The container calls the jspInit() to initialize the servlet instance.It is called before any other method, and is called only once for a servlet instance. 
* The `_jspservice()` - The container calls the _jspservice() for each request, passing it the request and the response objects. Should not be overridden.
* The `jspDestroy()` - The container calls this when it decides take the instance out of service. It is the last method called n the servlet instance.

## Custom Tags

Include Action Element - <jsp:include page="x.html" />

Difference between include directive and include custom tag?

### Include directive 

* At JSP page translation time, the content of the file given in the include directive is ‘pasted’ as it is, in the place where the JSP include directive is used. Then the source JSP page is converted into a java servlet class. The included file can be a static resource or a JSP page. Generally JSP include directive is used to include header banners and footers. The JSP compilation procedure is that, the source JSP page gets compiled only if that page has changed. If there is a change in the included JSP file, the source JSP file will not be compiled and therefore the modification will not get reflected in the output.
* Only one servlet is executed at run time. 
* Scriptlet variables declared in the parent page can be accessed in the included page (remember, they are the same page). 
* The included page does not need to able to be compiled as a standalone JSP. It can be a code fragment or plain text. The included page will never be compiled as a standalone. The included page can also have any extension, though .jspf has become a conventionally used extension. 
* One drawback on older containers is that changes to the include pages may not take effect until the parent page is updated. Recent versions of Tomcat will check the include pages for updates and force a recompile of the parent if they're updated.

### Include Action

* The `jsp:include` action element is like a function call. At runtime, the included file will be ‘executed’ and the result content will be included with the soure JSP page. When the included JSP page is called, both the request and response objects are passed as parameters. If there is a need to pass additional parameters, then jsp:param element can be used. If the resource is static, its content is inserted into the calling JSP file, since there is no processing needed.
* Each included page is executed as a separate servlet at run time. 
* Pages can conditionally be included at run time. This is often useful for templating frameworks that build pages out of includes. The parent page can determine which page, if any, to include according to some run-time condition. 
* The values of scriptlet variables need to be explicitly passed to the include page.
* The included page must be able to be run on its own. 
* `Request.getSession()`
  * `request.getSession(true)` - only creates a session if one does not exist. 
  * `request.getSession(false)` retrieves a session only if it already exists. 

## Custom tag libs

* Your tag class should implement `Tag` interface or extend from `TagSupport` or `BodyTagSupport` class.
* Implement `doStartTag()` method - If your tag does not have a body, then this method should return SKIP\_BODY constant. Otherwise return EVAL\_BODY_INCLUDE which in turn would call 'doEndTag()' method.
* To make use of what's inside the body of the tag, implement `doEndTag()`. After processing the body content, if you want to continue processing the rest of the page, return EVAL\_PAGE, else SKIP\_PAGE.
* If your tag has an attribute 'attr1', then add the method `setAttr1()` to your tag class.
* To evaluate the contents of the body, your class should extend from `BodyTagSupport` class, and override 'doAfterBody()' method. This method normally returns SKIP\_BODY meaning that no further body processing should be performed, else it returns EVAL\_BODY\_TAG to evaluate and handle the body again.

## Filters

* Filter - can intercept and process requests before and after servlet execution. e.g., of **Intercepting Filter pattern**. Filters can be chained.
* Request Filters can 
  * perform security checks
  * reformat request headers or bodies
  * audit or log requests
* Response Filters can
  * compress the response stream
  * append or alter the response
  * create a different response altogether

``` java Filter interface
public interface Filter {
   public void init(FilterConfig config);
   public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException;
   public void destroy();
}
```

``` xml Filter settings in web.xml
<filter>
   <filter-name>FilterName</filter-name>
   <filter-class>com.test.Foo<filter-class>
   <init-param>
      <param-name>name</param-name>
      <param-value>value</param-value>
   <init-param>
</filter>

<filter-mapping>
   <filter-name>FilterName</filter-name>
   <servlet-name>YourServletName<servlet-name> or <url-mapping>/*.do</url-mapping>
</filter-mapping>
```

* Starting Servlet 2.4 version, filters can be applied to request dispatchers - forwards and redirects.

## Wrappers

Wrapper classes in Servlet API

* ServletRequestWrapper
* HttpServletRequestWrapper
* ServletResponseWrapper
* HttpServletResponseWrapper

Whenever you want to create a custom request or response object, just subclass one of the convenience request or response "wrapper" classes

# Spring MVC

{% img right /technology/mvc-model.png %}

## MVC Model 1 & 2

* MVC Model 1 works well for GUI apps, whereas MVC Model 2 works well for web apps.
* Front Controller is the extra thing in Model 2. 

   --(incoming request)--> Front Controller
   Front Controller --(delegates request)--> Controller
   Controller --(handles request, creates model)--> Front Controller
   Front Controller --(model)--> View Template
   View Template --(renders response, returns control)--> Front Controller --(returns response)-->

* Front Controller is implemented as 
  * `javax.servlet.Servlet`
  * `ActionServlet` in Struts
  * `FacesServlet` in JSF
  * `DispatcherServlet` in Spring MVC

# Bibliography

* Pro Spring MVC with WebFlows
