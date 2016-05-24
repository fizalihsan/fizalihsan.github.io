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

**3 ways to configure `DispatcherServlet`**

1. via web.xml
Example?????
2. Implement `WebApplicationInitializer`. (From Spring 3.0, container automatically detects an implementation of this interface)
3. Extend abstract class `AbstractAnnotationConfigDispatcherServletInitializer` (which implements `WebApplicationInitializer` and invoked by `SpringServletContainerInitializer`). It creates both a `DispatcherServlet` and a `ContextLoaderListener`. (*works only in containers supporting Servlet 3.0*)

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

* Request handler method in controller different types of input parameters
	* No input parameter
	* `Model`
	* `java.util.Map`
	* Parameters annotated with `@RequestParam`
	* Parameters annotated with `@PathVariable`
	* POJO populated with form parameters
	* `Errors` - used for form validation

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

**3 ways to get user input**

A client can pass data into a controller's handler method in following ways

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

# Open questions

* what are the return types of a controller
* what are the types of method input parameters passed to the controller