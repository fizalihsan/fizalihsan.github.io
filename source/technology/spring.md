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

* 3 wiring mechanisms
	* Explicit configuration in XML
	* Explicit configuration in Java
	* Implicit bean discovery and automatic wiring

Spring attacks automatic wiring from two angles:

* *Component scanning*
	* Spring automatically discovers beans to be created in the application context.
	* * Enables Spring to scan classpath for classes that are annotated with `@Component` (or one of the specialized annotations like `@Service`, `@Repository`, `@Controller`, or `@Configuration`). 
	* Application Context needs to be enabled for component scanning via `@ComponentScan` annotation.
* *Autowiring* — Spring automatically satisfies bean dependencies.

```java Enabling Component Scanning via Java
@Configuration
@ComponentScan
public class ApplicationContextConfiguration {}
```

```java Enabling scanning on multiple base packages (Not type safe)
@Configuration
@ComponentScan(basePackages = {"com.apress.prospringmvc.moneytransfer.scanning","com.apress.prospringmvc.moneytransfer.repository" })
public class ApplicationContextConfiguration {}
```

```java Enabling scanning based on class names (type safe)
@Configuration
@ComponentScan(basePackageClasses = {CDPlayer.class, DVDPlayer.class})
public class ApplicationContextConfiguration {}
```

```xml Enabling Component Scanning via XML
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
	http://www.springframework.org/schema/beans/spring-beans.xsd
	http://www.springframework.org/schema/context
	http://www.springframework.org/schema/context/spring-context.xsd">

	<context:component-scan base-package="soundsystem" />

</beans>
```

* Naming a bean is named using `@Component` or Java Dependency Injection Specification (JSR-330) annotation `@Named`

```java
@Component("lonelyHeartsClub")
public class SgtPeppers {
...
}

import javax.inject.Named;

@Named("lonelyHeartsClub")
public class SgtPeppers {
...
}
```

* `@Autowired` - on a field denotes the bean implementation will injected
	* Can be used on constructors, setter methods and fields
	* If there are no matching beans, Spring will throw an exception as the application context is being created. To avoid that exception, you can set the `required` attribute on `@Autowired` to false

* Dependency injection types: Setter-based, Constructor-based and Annotation-based. 
* `@Inject` and `@Resource`. Last 2 are Java JSR-330 based.
* `ApplicationContext` - different ways to configure. via XML or Java. Multiple application contexts can be defined in a hierarchy.
* `@Configuration` - marks the class as config class. 
  * Classes can be abstract but not final. 
  * Class with no `@Bean` annotation is now allowed.
* `@Bean` - 
* Resource Loading
  * Prefixes are classpath:, file: and http:
  * Ant-style wild cards - e.g., classpath:/META-INF/spring/*.xml, file:/var/conf/**/*.properties

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

# JDBC

## Why Spring JDBC over plain Java JDBC?

* Java `SQLException` is a checked exception and doesn't give much clarity on the error occurred. Spring has defined a wide variety of database-specific exceptions which are unchecked exceptions.
* Spring JDBCTemplate removes most of boilerplate data access code - no exception handling, no need to close result set and connection

## JdbcTemplate

* `JdbcTemplate` — The most basic of Spring’s JDBC templates, this class provides simple access to a database through JDBC and indexed-parameter queries.
* `NamedParameterJdbcTemplate` — This JDBC template class enables you to perform queries where values are bound to named parameters in SQL, rather than indexed parameters.
* Instances of the JdbcTemplate class are *thread-safe* once configured. This is important because it means that you can configure a single instance of a JdbcTemplate and then safely inject this shared reference into multiple DAOs (or repositories). 
* The JdbcTemplate is stateful, in that it maintains a reference to a DataSource, but this state is not conversational state.

```java Wiring JdbcTemplate
@Bean
public SpitterRepository spitterRepository(JdbcTemplate jdbcTemplate) {
	return new MyRepository(jdbcTemplate);
}
```

```java Autowiring JdbcTemplate into JdbcOperations indirectly
@Repository
public class MyRepository implements MyRepo {
	private JdbcOperations jdbcOperations;
	
	@Inject
	public JdbcSpitterRepository(JdbcOperations jdbcOperations) {
		this.jdbcOperations = jdbcOperations;
	}
```

```java Example of Batch Updating
public int[] batchUpdate(final List<Actor> actors) {
    int[] updateCounts = jdbcTemplate.batchUpdate("update t_actor set first_name = ?, " +
            "last_name = ? where id = ?",
        new BatchPreparedStatementSetter() {
            public void setValues(PreparedStatement ps, int i) throws SQLException {
                    ps.setString(1, actors.get(i).getFirstName());
                    ps.setString(2, actors.get(i).getLastName());
                    ps.setLong(3, actors.get(i).getId().longValue());
                }

                public int getBatchSize() {
                    return actors.size();
                }
            });
    return updateCounts;
}
```

## Querying results

```java
interface RowMapper<T> {
public T mapRow(ResultSet rs, int rowNum) throws SQLException;
```
