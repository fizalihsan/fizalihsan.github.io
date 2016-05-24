---
layout: page
title: "Spring MVC"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}


# Request Lifecycle

1. HTTP Request reaches Spring's `DispatcherServlet`.
2. `DispatcherServlet` uses one or more handler mappings to figure out the controller to the handle the request
3. Controller calls the service classes to perform a business function. Optionally returns a business *model* class.
4. Controller returns a logical *view* name
5. `DispatcherServlet` consults a view resolver to map the logical view name to a specific view implementation, which couild be JSP, Apache Tiles, Thymeleaf, etc.
6. View uses the model data to render the output.
7. `DispatcherServlet` sends the output as HTTP response back to client.

# Components

## 2 ways to enable Spring MVC

1. Add `<mvc:annotation-driven>` element in XML (*which XML*)
2. Add `@EnableWebMvc` annotation in configuration class

```java
@Configuration
@EnableWebMvc
@ComponentScan("com.test.web") // automatically scans controllers from this package
public class WebConfig {

}
```

## Application Contexts

> Spring web applications have 2 application contexts. 
> `DispatcherServlet` loads beans containing web components such as controllers, view resolvers, handler mappings, etc.
> `ContextLoaderListener` loads the other beans in the application that are typically used by service and data access layers.

## DispatcherServlet

* `DispatcherServlet` is the `Front Controller` for Spring MVC. This is the single servlet that delegates responsibility to other *controllers* to perform the actual processing.
* When `DispatcherServlet` starts up, it creates a Spring application context and loads it with beans declared in 
	* the configuration file or 
	* the classes given via `getServletConfigClasses()` method in `AbstractAnnotationConfigDispatcherServletInitializer`

**4 ways to configure `DispatcherServlet`**

1) *Via `web.xml` with XML-based context files*

```xml Setting up Spring MVC in web.xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="2.5"
	xmlns="http://java.sun.com/xml/ns/javaee"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://java.sun.com/xml/ns/javaee
	http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd">
	
	<!-- location of the file that defines the root application context loaded by ContextLoaderListener -->
	<context-param>
		<param-name>contextConfigLocation</param-name>
		<param-value>/WEB-INF/spring/root-context.xml</param-value>
	</context-param>
	
	<listener>
		<listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
	</listener>
	
	<!-- DispatcherServlet loads its application context with beans defined in a file whose name is based on servlet name. E.g., if servlet name is 'blah', then an XML file /WEB-INF/blah-context.xml -->
	<servlet>
		<servlet-name>appServlet</servlet-name>
		<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
		<load-on-startup>1</load-on-startup>
	</servlet>
	
	<servlet-mapping>
		<servlet-name>appServlet</servlet-name>
		<url-pattern>/</url-pattern>
	</servlet-mapping>
</web-app>
```

If you’d rather specify the location of the `DispatcherServlet` configuration file,
you can set a `contextConfigLocation` initialization parameter on the servlet as follows.

```xml
<servlet>
	<servlet-name>appServlet</servlet-name>
	<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
	<init-param>
		<param-name>contextConfigLocation</param-name>
		<param-value>/WEB-INF/spring/appServlet/servlet-context.xml</param-value>
	</init-param>
	<load-on-startup>1</load-on-startup>
</servlet>
```

2) *Via `web.xml` with Java-based context classes annotated with `@Configuration`*

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="2.5"
	xmlns="http://java.sun.com/xml/ns/javaee"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://java.sun.com/xml/ns/javaee
	http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd">

	<context-param>
		<param-name>contextClass</param-name>
		<param-value>	org.springframework.web.context.support.AnnotationConfigWebApplicationContext</	param-value>
	</context-param>
	<context-param>
		<param-name>contextConfigLocation</param-name>
		<param-value>com.habuma.spitter.config.RootConfig</param-value>
	</context-param>
	
	<listener>
		<listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
	</listener>

	<servlet>
		<servlet-name>appServlet</servlet-name>
		<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
		<init-param>
			<param-name>contextClass</param-name>
			<param-value>.springframework.web.context.support.AnnotationConfigWebApplicationContext</param-value>
		</init-param>
		<init-param>
			<param-name>contextConfigLocation</param-name>
			<param-value>com.habuma.spitter.config.WebConfigConfig</param-value>
		</init-param>
		<load-on-startup>1</load-on-startup>
	</servlet>
	
	<servlet-mapping>
		<servlet-name>appServlet</servlet-name>
		<url-pattern>/</url-pattern>
	</servlet-mapping>
</web-app>
```

3) *Implement `WebApplicationInitializer`* (From Spring 3.0, container automatically detects an implementation of this interface)

```java Manually registering DispatcherServlet
public class MyServletInitializer implements WebApplicationInitializer {
	@Override
	public void onStartup(ServletContext servletContext) throws ServletException {
		Dynamic myServlet = servletContext.addServlet("myServlet", MyServlet.class);
		myServlet.addMapping("/custom/**");

		ServletRegistration.Dynamic dispatcher = servletContext.addServlet("dispatcher", new DispatcherServlet());
		dispatcher.addMapping("/");
		dispatcher.setLoadOnStartup(1);
	}
}
```

4) *Extend abstract class `AbstractAnnotationConfigDispatcherServletInitializer`* (which implements `WebApplicationInitializer` and invoked by `SpringServletContainerInitializer`). It creates both a `DispatcherServlet` and a `ContextLoaderListener`. (*works only in containers supporting Servlet 3.0*)

```java Example 1 - Sample WebAppInitializer
package spittr.config;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class SpittrWebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {
	@Override
	protected String[] getServletMappings() {
		return new String[] { "/" };
	}

	// Returns @Configuration beans to load into the DispatcherServletContext
	@Override
	protected Class<?>[] getServletConfigClasses() {
		return new Class<?>[] { WebConfig.class };
	}
	
	// Returns @Configuration beans to load into the ContextLoaderListener
	@Override
	protected Class<?>[] getRootConfigClasses() {
		return new Class<?>[] { RootConfig.class };
	}
}
```

## ContextLoaderListener

* Spring web applications have 2 application contexts. 
	* `DispatcherServlet` loads beans containing web components such as controllers, view resolvers, handler mappings, etc.
	* `ContextLoaderListener` loads the other beans in the application that are typically used by service and data access layers.
* loads the beans for the application (not web related beans)

## Controller

* Just classes annotated with `@Controller` and methods annotated with `@RequestMapping`

```java Handles requests for / and renders the home page
@Controller
public class HomeController {
	@RequestMapping(value="/", method=GET)
	public String home() {
		return "home";
	}
}
```

* Various input types to request handler method in controller
	* No input parameter
	* `Model`
	* `java.util.Map`
	* Parameters annotated with `@RequestParam`
	* Parameters annotated with `@PathVariable`
	* POJO populated with form parameters
	* `Errors` - used for form validation

* Various output/return types from request handler method in controller
  * `void`
  * `String`
	  * logical view name ("car") 
	  * physical view name (`/WEB-INF/jsp/car.jsp`)
	  * special view names (`redirect:/cars/7`)
	  * ModelAndView
  * `Model`
  * `Map`
  * `ModelMap`
  * `View`
  * `@ResponseBody`
  * `@ModelAttribute`


**2 ways to configure a `Controller`**

* Add `@Component` to a class
* Add `@Controller` to a class. This is just a stereotype annotation and serves only for component-scanning.

## Request Mapping

* `@RequestMapping` can be applied at class-level and method-level.
* `@RequestMapping` takes an array paths as input as well.

```java At class-level and method-level
@Controller
@RequestMapping({"/"})
public class HomeController {
	@RequestMapping(method=GET)
	public String home() {
		return "home";
	}
}
```

```java multiple paths
@Controller
@RequestMapping({"/", "/homepage"})
public class HomeController {
	...
}
```

## User input

There are 3 ways to get user input into a controller's handler method: 

1) ***Query parameters***

```java Access query/request parameters
@RequestMapping(method=RequestMethod.GET)
public List<Spittle> spittles(
		@RequestParam("max") long max, 
		@RequestParam("count", defaultValue="0") int count
	) {
	return spittleRepository.findSpittles(max, count);
}
```

2) ***Path variables***

```java Accessing path variables
@RequestMapping(value="/{spittleId}", method=RequestMethod.GET)
public String spittle(@PathVariable("spittleId") long spittleId, Model model) {
	model.addAttribute(spittleRepository.findOne(spittleId));
	return "spittle";
}
```

3) ***Form parameters***

Spring MVC binds the form parameters to the fields in the POJO by field name.

```java Access form parameters
@RequestMapping(value="/register", method=POST)
public String processRegistration(Spitter spitter) {
	spitterRepository.save(spitter);
	return "redirect:/spitter/" + spitter.getUsername();
}
```

> When handling a `POST` request, it’s usually a good idea to send a redirect after the
`POST` has completed processing so that a browser refresh won’t accidentally submit the
form a second time

## Model

* `org.springframework.ui.Model` is nothing but a Map implementation

```java
@RequestMapping(method=RequestMethod.GET)
public String spittles(Model model) {
	List<Spittle> list = dao.findSpittles();
	model.addAttribute("spittleList", list);
	return "spittles";
}
```

## View Resolver

* Presenting here some of the commonly used view resolvers
* Default view resolver is `BeanNameViewResolver`

```java
public interface ViewResolver {
	View resolveViewName(String viewName, Locale locale) throws Exception;
}
```

### `BeanNameViewResolver` 

Resolves views as beans in the Spring application context whose ID is the same as the view name. The bean has to implement `View` interface.

### `InternalResourceViewResolver`

In the below example, when controller a string say "blah", the below resolver will resolve it to `/WEB-INF/views/blah.jsp`

```java InternalResourceViewResolver example
@Bean
public ViewResolver viewResolver() {
	InternalResourceViewResolver resolver = new InternalResourceViewResolver();
	resolver.setPrefix("/WEB-INF/views/");
	resolver.setSuffix(".jsp");
	resolver.setExposeContextBeansAsAttributes(true);
	return resolver;
}
```

`InternalResourceViewResolver` also recognizes the following special prefixes

* `redirect:` - e.g., `return "redirect:/spitter/" + spitter.getUsername();`
* `forward:` - e.g., `return "forward:/spitter/" + spitter.getUsername();`

## View

```java
public interface View {
	String getContentType();
	void render(Map<String, ?> model, HttpServletRequest request, HttpServletResponse response) throws Exception;
}
```

