---
layout: page
title: "Spring"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Overview

* Dependency injection types: Setter-based, Constructor-based and Annotation-based. 
* `@Autowired` - on a field denotes the bean implementation will injected
* `@Inject` and `@Resource`. Last 2 are Java JSR-330 based.
* `ApplicationContext` - different ways to configure. via XML or Java. Multiple application contexts can be defined in a hierarchy.
* `@Configuration` - marks the class as config class. 
  * Classes can be abstract but not final. 
  * Class with no `@Bean` annotation is now allowed.
* `@Bean` - 
* Resource Loading
  * Prefixes are classpath:, file: and http:
  * Ant-style wild cards - e.g., classpath:/META-INF/spring/*.xml, file:/var/conf/**/*.properties
* Component Scanning
  * Enables Spring to scan classpath for classes that are annotated with @Component (or one of the specialized annotations like @Service, @Repository, @Controller, or @Configuration). Application Context needs to be enabled for component scanning via @ComponentScan annotation.

```java
@Configuration
@ComponentScan(basePackages = {"com.apress.prospringmvc.moneytransfer.scanning","com.apress.prospringmvc.moneytransfer.repository" })
public class ApplicationContextConfiguration {}
```

## Scope
* By default, all beans in Spring application context is singleton.
* singleton - 
* prototype - new instance of bean is created every time
* thread - new bean created and bound to current thread. Thread dies - bean destroyed.
* request - new bean created and bound to the current javax.servlet.ServletRequest. Request dies - bean destroyed.
* session - new bean created and bound to the current javax.servlet.HttpSession. Request dies - bean destroyed.
* globalSession - new bean is created when needed and stored in the globally available session (which is available in Portlet environments). If no such session is available, the scope reverts to the session scope functionality.
* application - This scope is very similar to the singleton scope; however, beans with this scope are also registered in javax.servlet.ServletContext.

## Profiles
* Enables creating different configuration for different environments like testing, local deployment, cloud deployment, etc.
* To enable a profile, tell the application context which profiles are activeby setting a system property called 'spring.profiles.active' (in a web environment, this can be a servlet initialization parameter or web context parameter).

```java
@Configuration
@Profile(value = "test")
public static class TestContextConfiguration {
   @Bean
   public TransactionRepository transactionRepository() {
      return new StubTransactionRepository();
   }
}
```

* @EnableCaching - Enables support for bean methods with the @Cacheable annotation.
* @EnableWebMvc - Enables support for the powerful and flexible annotation-driven controllers with request handling methods. This feature detects beans with the @Controller annotation and binds methods with the @RequestMapping annotations to URLs.