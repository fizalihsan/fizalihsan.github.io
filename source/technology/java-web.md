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

* The jsp:include action element is like a function call. At runtime, the included file will be ‘executed’ and the result content will be included with the soure JSP page. When the included JSP page is called, both the request and response objects are passed as parameters. If there is a need to pass additional parameters, then jsp:param element can be used. If the resource is static, its content is inserted into the calling JSP file, since there is no processing needed.
* Each included page is executed as a separate servlet at run time. 
* Pages can conditionally be included at run time. This is often useful for templating frameworks that build pages out of includes. The parent page can determine which page, if any, to include according to some run-time condition. 
* The values of scriptlet variables need to be explicitly passed to the include page.
* The included page must be able to be run on its own. Request.getSession() request.getSession(true) only creates a session if one does not exist. request.getSession(false) retrieves a session only if it already exists. 

## Custom tag libs

* Your tag class should implement `Tag` interface or extend from `TagSupport` or `BodyTagSupport` class.
* Implement `doStartTag()` method - If your tag does not have a body, then this method should return SKIP_BODY constant. Otherwise return EVAL_BODY_INCLUDE which in turn would call 'doEndTag()' method.
* To make use of what's inside the body of the tag, implement `doEndTag()`. After processing the body content, if you want to continue processing the rest of the page, return EVAL_PAGE, else SKIP_PAGE.
* If your tag has an attribute 'attr1', then add the method `setAttr1()` to your tag class.
* To evaluate the contents of the body, your class should extend from `BodyTagSupport` class, and override 'doAfterBody()' method. This method normally returns SKIP_BODY meaning that no further body processing should be performed, else it returns EVAL_BODY_TAG to evaluate and handle the body again.

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

* Model 1 works well for GUI apps. Model 2 works well for web apps.
* Front Controller is the extra thing in Model 2. 
* --(incoming request)--> Front Controller --(delegates request)--> Controller --(handles request, creates model)--> Front Controller --(model)--> View Template --(renders response, returns control)--> Front Controller --(returns response)-->
* Front Controller is implemented as 
  * `javax.servlet.Servlet`
  * `ActionServlet` in Struts
  * `FacesServlet` in JSF
  * `DispatcherServlet` in Spring MVC

## Web MVC Application Layer

Layering leads to separation of concerns, easy testability, clean architecture.

### User Interface (Presentation)

* presents the application to the user rendering the response as requested by the client. e.g., HTML, XML, PDF, etc. 
* In Spring it is represented by a generic interface 'View' and it has no dependencies on a particular view technology like JSP, Velocity, Tiles, etc.

### Web (Presentation)
* Thin layer; no business logic; 
* In Spring it is represented by 'Controller' interface or classes with @Controller annotation.
* Responsible for (1) page navigation logic via Spring Web Flow, etc. (2) integrating service layer and HTTP.
* Converts HTTP request into service layer calls, and then transforms result from server into response for the user interface.
* Contains cookies, HTTP headers, HTTP sessions; responsible to manage these consistently and transparently.
* 2 types of web layer implementations:
  * (a) request-repsonse frameworks. e.g., Struts and Spring MVC. They operate on ServletRequest and ServletResponse objects and is not hiddent from the users.
  * (b) component-based frameworks. e.g., JSF, Tapestry. Hides the Servlet API from the user and offers a component-based programming model.

### Service layer

* only business logic (transactional boundary, security, etc.). 
* No persistence or presentation logic. 
* Coarse-API layer - funciton should represent a single unit of work that either succeeds of fails. User can user different clients (web, web service, desktop app, JMS) but the business logic is same.
* Services should be stateless and a good practice to keep it Singleton.
* Keeping the service layer clean also allows us to reuse the same services for different channels. For example, it enables us to add a web service or JMS-driven solution

### Data Access

Interface-based layer abstracts persistence framework (JDO, JDBC, JPA, etc.) No business logic.

### Domain 

(cuts across all layers) - Domain class names are nouns. Contains both state and behavior. In anemic domain model, it holds only state and no behavior.

Communication should be top-to-bottom except Domain layer. Data access shouldn't access Service layer. Circular dependencies is a sign of bad design. A rule of thumb is that, if a layer has too many dependencies with other layers, we might want to introduce another layer that incorporates all the dependencies. On the other hand, if we see a single layer throughout different layers, we might want to reconsider this layer and make it an aspect of the application (Spring AOP). 

## Definitions

### ModelMap 

### View 

* Out-of-the-box - JSP, JSTL, Tiles, Velocity, FreeMaker, etc.
* Special - redirect: and forward:

### ModelAndView 

An aggregator/container class which holds both a ModelMap and a View instance.

### Controller

* RequestMapping is defined both at class-level and method-level
* Types of mapping requests
  * by path - `@RequestMapping("/welcome")`
  * by HTTP method - `@RequestMapping("/welcome", method=RequestMethod.GET)`
  * by presence/value of query parameter - `@RequestMapping("find=ByMake", "form")`
  * by presence/value of request header  - `@RequestMapping("/welcome", header="accept=text/*")`
* Types of controller method return types (http://docs.spring.io/spring/docs/3.0.x/spring-framework-reference/html/mvc.html)
  * void
  * String 
  * logical view name ("car") 
  * physical view name (`/WEB-INF/jsp/car.jsp`)
  * special view names (`redirect:/cars/7`)
  * ModelAndView
  * Model / Map / ModelMap
  * View
  * `@ResponseBody` / `@ModelAttribute`

``` java Sample Controller 
public class ItemController implements Controller {
...
}
```

``` java Sample Controller - Declarative Style
@Controller
 public class ItemController {

     @RequestMapping(value="viewItem.htm", method=RequestMethod.GET)
     public Item viewItem(@RequestParam Long id){
         return itemservice.get(id);
     }   
}
``` 

* Additional annotations at controller level
  * `@ModelAttribute`
    * method parameter level - maps a model attribute to the specific method parameter
    * method level - provides the reference data to the model
  * `@SessionAttributes` - class level: list the names or types of model attributes which should be stroed in the session.
  * `@RequestHeader` - method parameter level - maps request header parameters to method parameters
  * `@CookieValue` - method parameter level - gets the JSESSIONID of the cookie
  * `@RequestBody` / `@ResponseBody`

#### FormController

* Override onSubmit() method to provide custom handling function
* Override formBackingObject() method to provide default values when the form is first rendered.

``` xml 
<bean name="/foo.htm" class="com.FooFormController">
    <property name="commandName" value="..."/>
    <property name="commandClass" value="..."/>
    <property name="validator" value="com.FooValidator"/>
    <property name="successView" value="baz.html"/>
</bean>
```

``` java Form Controller
class FooFormController extends SimpleFormController{
    void onSubmit(Object obj){
        return new ModelAndView(new RedirectView(getSuccessView())));
    }
}

class FooValidator implements Validator{
}
```

#### MultiActionController

* allows multiple request types to be handled by the same class. For example, when mapped *Foo.htm to FooController which extends MultiActionController. 
* Based on the request type, different methods on implementing class will be invoked; which method to invoke is decided by MethodNameResolver implementation which can be injected.
* `InternalPathMethodNameResolver` - maps file name in url to method name. e.g, requesting addFoo.htm and deleteFoo.htm would invoke methods addFoo() and deleteFoo() respectively. 
* `PropertiesMethodNameResolver` - maps url to method name based on a pre-configured map as follows.

``` xml PropertiesMethodNameResolver 
<bean class="org.springframework.web.servlet.mvc.multiaction.PropertiesMethodNameResolver">
   <property name="mappings">
      <value>
         /multiaction/add.dev=add
         /multiaction/remove.dev=remove
         /multiaction/listAll.dev=listAll
      </value>
   </property>
</bean>
```

* `ParameterNameMethodNameResolver` - maps a request parameter value to method name. e.g., `/Foo.html?action=add` invokes method add() after configuring 'action' as the parameter to look for.

``` xml ParameterNameMethodNameResolver
<bean class="org.springframework.web.servlet.mvc.multiaction.ParameterMethodNameResolver">
   <property name="paramName" value="action" />
</bean>
```

### HandlerMapping

* Maps incoming request to a handler/controller
* Default mapping classes
  * `BeanNameUrlHandlerMapping` - maps url to bean name in app context xml.
  * `DefaultAnnotationHandlerMapping` - maps url to classes with `@Controller` and `@RequestMapping` annotations.
* `SimpleUrlHandlerMapping` - maps url to a bean name in the app context.

### HandlerInterceptor

* intercepting requests before handed over to handlers to implement special functions like security, monitoring, etc.
* This interface defines three methods: 
  * `preHandle()` is called before the actual handler is executed; 
  * `postHandle()` - is called after the handler is executed; 
  * `afterProcessing()` - is called after the complete request has finished. 

### HandlerExecutionChain 
???

### HandlerAdapter

is the glue between the dispatcher servlet and the handler. It removes the actual execution logic from the dispatcher servlet, which makes the dispatcher servlet infinitely extensible. It executes the Handler identified from the HandlerMapping. It takes a Handler as input and returns ModelAndView. If there is no view in the returned ModelAndView, RequestToViewNameTranslator is consulted to generate a view name based on the incoming request.

### Resolvers

#### ViewResolver

UrlBasedViewResolver - controller returns "cars", resolver resolves it to "/WEB-INF/jsp/cars.jsp"
 
``` xml UrlBasedViewResolver
<bean id="viewResolver" class="org.springframework....UrlBasedViewResolver">
   <property name="viewClass" value="org.springframework...JstlView"/>
   <property name="prefix" value="/WEB-INF/jsp"/>
   <property name="suffix" value=".jsp"/>
</bean>
```

#### HandlerExceptionResolver


## DispatcherServlet Bootstrapping

4 ways to bootstrap a DispatcherServlet in a ServletContainer like Tomcat

1. `web.xml`
2. `web-fragment.xml` (since Servlet 3.0 spec)
3. `javax.servlet.ServletContextInitializer` (since Servlet 3.0 spec)

``` java ServletContainerInitializer 
public class BookstoreServletContainerInitializer implements ServletContainerInitializer {
   @Override
   public void onStartup(Set<Class<?>> classes, ServletContext servletContext) throws ServletException {
      ServletRegistration.Dynamic registration = servletContext.addServlet("dispatcher", DispatcherServlet.class);
      registration.setLoadOnStartup(1);
      registration.addMapping("/*");
   }
}
```

4. Spring's WebApplicationInitializer

Spring has an in-built implementation of ServletContextInitializer which scans classpath for WebApplicationInitializer implementations and invokes `onStartup()` on them.

``` java WebApplicationInitializer
public class BookstoreWebApplicationInitializer implements WebApplicationInitializer {}
   @Override
   public void onStartup(ServletContext servletContext) throws ServletException {
      ServletRegistration.Dynamic registration = servletContext.addServlet("dispatcher", DispatcherServlet.class);
      registration.addMapping("/*");
      registration.setLoadOnStartup(1);
   }
}
```

By default, the dispatcher servlet loads a file named [servletname]-servlet.xml from the WEB-INF directory.

### How to configure DispatcherServlet and ContextLoaderListener in Java?

In web, DispatcherServlet and ContextLoaderListener components bootstrap and configure an application context.

* Steps to create `DispatcherServlet` in Java
  * Spring 3.0 container automatically detects a FooWebAppInitializer class that extends WebApplicationInitializer.
  * FooWebAppInitializer overrides onStartUp(ServletContext) method.
  * Create new WebApplicationContext - new AnnotationConfigWebApplicationContext();
  * Create new DispatcherServlet - new DispatcherServlet(webappContext);
  * Add dispatcher servlet to ServletContext - servletContext.addServlet("dispatcher", dispatcherServlet);
* Steps to create `ContextLoaderListener` in Java 
  * Spring 3.0 container automatically detects a FooWebAppInitializer class that extends WebApplicationInitializer.
  * FooWebAppInitializer overrides onStartUp(ServletContext) method.
  * Create new WebApplicationContext - new AnnotationConfigWebApplicationContext();
  * Create new ContextLoaderListener - new ContextLoaderListener(webappContext);
  * Add listener to ServletContext - servletContext.addListener(contextLoaderListener);

### DispatcherServlet Request Processing Flow

{% img right /technology/springmvc-flow.png %}

* DispatcherServlet receives request.
* Before dispatching
  * Determines and exposes java.util.Locale of the current request using LocaleResolver.
  * Prepares and exposes current request in RequestContextHolder.
  * Constructs FlashMap using FlashMapManager. Map contains attributes from previous request when a redirect is made.
  * Request is checked if it is a multipart HTTP request. If so, request is wrapped in MultipartHttpServletRequest via MultipartResolver.
* Dispatching
  * DispatcherServlet consults 1 or more HandlerMapping implementations to determine the handler to handle the request. 
  * Check HandlerMapping
    * If found, HandlerMapping returns an HandlerExecutionChain which holds references to Handler and HandlerInterceptor[](optional). 
    * If no handler found, http 404 response is sent.
  * Check HandlerApapter
    * Servlet tries to find a HandlerAdapter, 
    * If not found, ServletException is thrown.
    * If found and if 1 or more HandlerInterceptor are defined, preHandle and postHandle methods in the interceptor are executed before and after the Handler execution.
    * If a view is selected, DispatcherServlet checks if the view reference is a String or View.
      * If a String is found, ViewResolvers are consulted to resolve it to a View implementation.
      * If not resolved, ServletException is thrown.
  * Handling Exceptions
    * If an exception is thrown during request handling, DispatcherServlet consults HandlerExceptionResolver to handle thrown exceptions. 
    * It resolves an exception to a view to show to the user. 
    * If an exception is unresolved, it is rethrown and handled by the servlet container which throws HTTP 500 error.
* After dispatching
  * DispatcherServlet uses the event mechanism in the Spring Framework to fire a RequestHandledEvent. ApplicationListener can be to receive and log these events.

# FAQs

* Servlets
  * Why is http stateless protocol? HttpServletRequest & HttpServletResponse? HttpSession? GET is idempotent, but POST is not.
  * What is a cookie? Is there any security breach involved cos of using cookies? 

# Bibliography

* Pro Spring MVC with WebFlows