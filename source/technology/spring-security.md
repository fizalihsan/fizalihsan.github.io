---
layout: page
title: "Spring Security"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Introduction 

{% img /technology/spring-security-1.png %}

__First Intro Project__

* Spring Boot scans for components only in the package (and its subpackages) that contains the class annotated with `@SpringBootApplication`. If you annotate classes with any of the stereotype components in Spring outside of the main package, you must explicitly declare the location using the `@ComponentScan` annotation.

```xml Maven configuration
<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

```java Web service endpoint
@RestController
public class HelloController {

  @GetMapping("/hello")
  public String hello() {
    return "Hello!";
  }
}
```
* When you run the app, and access the endpoint `curl http://localhost:8080/hello`, you get the below error

```json
{
  "status":401,
  "error":"Unauthorized",
  "message":"Unauthorized",
  "path":"/hello"
}
```

* By default, Spring Security expects the default username (`user`). Each time you run the application, it generates a new password and prints this password in the console.
* It works once the generated password is passed in as input

> With cURL, you can set the HTTP basic username and password with the `-u` flag. Behind the scenes, cURL encodes the string `<username>:<password>` in Base64 and sends it as the value of the Authorization header prefixed with the string Basic. And with cURL, it’s probably easier for you to use the `-u` flag. But it’s also essential to know what the real request looks like. So, let’s give it a try and manually create the Authorization header.

```bash
# plain-text password
curl -u user:93a01cf0-794b-4b98-86ef-54860f36f7f3 http://localhost:8080/hello

OR 

# base-64 encoded
echo -n user:93a01cf0-794b-4b98-86ef-54860f36f7f3 | base64
curl -H "Authorization: Basic dXNlcjo5M2EwMWNmMC03OTRiLTRiOTgtODZlZi01NDg2MGYzNmY3ZjM=" localhost:8080/hello
```

__High-level overview__

* The main components acting in the authentication process for Spring Security and the relationships among these. This architecture represents the backbone of implementing authentication with Spring Security. 
## Authentication process

* Steps
    * The authentication filter delegates the authentication request to the authentication manager and, based on the response, configures the security context.
    * The authentication manager uses the authentication provider to process authentication.
    * The authentication provider implements the authentication logic.
    * The user details service implements user management responsibility, which the authentication provider uses in the authentication logic.
    * The password encoder implements password management, which the authentication provider uses in the authentication logic.
    * The security context keeps the authentication data after the authentication process.
    * An object that implements a `UserDetailsService` contract with Spring Security manages the details about users.
* __PasswordEncoder__
    * The `PasswordEncoder` does two things:
        * Encodes a password
        * Verifies if the password matches an existing encoding
    * the `PasswordEncoder` is mandatory for the Basic authentication flow
    * a `PasswordEncoder` exists together with the default `UserDetailsService`. When we replace the default implementation of the UserDetailsService, we must also specify a `PasswordEncoder`
* __AuthenticationProvider__
    * The `AuthenticationProvider` defines the authentication logic, delegating the user and password management. A default implementation of the `AuthenticationProvider` uses the default implementations provided for the `UserDetailsService` and the `PasswordEncoder`. Implicitly, your application secures all the endpoints. 
* __Override default configurations__
    * In some cases, developers choose to use beans in the Spring context for the configuration. In other cases, they override various methods for the same purpose.
    * Configuring a project with a mix of styles is not desirable as it makes the code difficult to understand and affects the maintainability of the application.

## Overriding the UserDetailsService component

* The application now uses the instance of type UserDetailsService you added to the context instead of the default autoconfigured one. But, at the same time, you won’t be able to access the endpoint anymore for two reasons:
    * You don’t have any users.
    * You don’t have a `PasswordEncoder`.
* When building the instance, we have to provide the username, the password, and at least one authority. The __authority__ is an action allowed for that user, and we can use any string for this.
* Because we overrode `UserDetailsService`, we also have to declare a `PasswordEncoder`. Trying the example now, you’ll see an exception when you call the endpoint. When trying to do the authentication, Spring Security realizes it doesn’t know how to manage the password and fails. 
* The `NoOpPasswordEncoder` instance treats passwords as plain text. It doesn’t encrypt or hash them. For matching, `NoOpPasswordEncoder` only compares the strings using the underlying `equals(Object o)` method of the String class.

```java
@Configuration
public class ProjectConfig {

  @Bean
  public UserDetailsService userDetailsService() {
    var userDetailsService = new InMemoryUserDetailsManager();

    var user = User.withUsername("john")
            .password("12345")
            .authorities("read")
            .build();
        
    userDetailsService.createUser(user);
    return userDetailsService;
  }

  @Bean
  public PasswordEncoder passwordEncoder() {
    return NoOpPasswordEncoder.getInstance();
  }
}
```

## Overriding the endpoint authorization configuration

* With default configuration, all the endpoints assume you have a valid user managed by the application. Also, by default, your app uses HTTP Basic authentication as the authorization method.
* Not all endpoints of an application need to be secured, and for those that do, we might need to choose different authorization rules. To make such changes, we start by extending the `WebSecurityConfigurerAdapter` class. Extending this class allows us to override the `configure(HttpSecurity http)`.
* The `permitAll()` call in the configuration, together with the `anyRequest()` method, makes all the endpoints accessible without the need for credentials:

```java
@Configuration
public class ProjectConfig extends WebSecurityConfigurerAdapter {

  // Omitted code

  @Override
  protected void configure(HttpSecurity http) throws Exception {
    http.httpBasic();
    http.authorizeRequests()
           .anyRequest().permitAll();
  }
}
```

## Overriding the AuthenticationProvider implementation

* Below example shows the `AuthenticationProvider`, which implements the authentication logic and delegates to the `UserDetailsService` and `PasswordEncoder` for user and password management. So we could say that with this section, we go one step deeper in the authentication and authorization architecture to learn how to implement custom authentication logic with `AuthenticationProvider`
* I recommend that you respect the responsibilities as designed in the Spring Security architecture. This architecture is loosely coupled with fine-grained responsibilities. That design is one of the things that makes Spring Security flexible and easy to integrate in your applications. But depending on how you make use of its flexibility, you could change the design as well. You have to be careful with these approaches as they can complicate your solution. For example, you could choose to override the default `AuthenticationProvider` in a way in which you no longer need a `UserDetailsService` or `PasswordEncoder`.

{% img /technology/spring-security-2.png %}

```java
@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {

  @Override
  public Authentication authenticate (Authentication authentication) throws AuthenticationException {
    // authentication logic here
    String username = authentication.getName();
    String password = String.valueOf(authentication.getCredentials());

    if ("john".equals(username) && "12345".equals(password)) {
        return new UsernamePasswordAuthenticationToken(username, password, Arrays.asList());
    } else {
        throw new AuthenticationCredentialsNotFoundException ("Error in authentication!");
    }
  }

  @Override
  public boolean supports(Class<?> authenticationType) {
    // type of the Authentication implementation here
    return UsernamePasswordAuthenticationToken.class.isAssignableFrom(authenticationType);
  }
}
```

```java
@Configuration
public class ProjectConfig extends WebSecurityConfigurerAdapter {

  @Autowired
  private CustomAuthenticationProvider authenticationProvider;

  @Override
  protected void configure(AuthenticationManagerBuilder auth) {
    auth.authenticationProvider(authenticationProvider);
  }

  ...
}
```

* __Using multiple configuration classes in your project__
    * good practice to separate the responsibilities even for the configuration classes. We need this separation because the configuration starts to become more complex.
    * You can’t have both classes extending `WebSecurityConfigurerAdapter` in this case. If you do so, the dependency injection fails. You might solve the dependency injection by setting the priority for injection using the `@Order` annotation. But, functionally, this won’t work, as the configurations exclude each other instead of merging.

# Managing Users

* Classes
    * `UserDetails` - which describes the user for Spring Security.
    * `GrantedAuthority` - which allows us to define actions that the user can execute.
    * `UserDetailsManager` - which extends the `UserDetailsService` contract. Beyond the inherited behavior, it also describes actions like creating a user and modifying or deleting a user’s password.

## Implementing authentication in Spring Security

{% img /technology/spring-security-3.png %}

* The `UserDetailsService` is only responsible for retrieving the user by username. This action is the only one needed by the framework to complete authentication. 
* The `UserDetailsManager` adds behavior that refers to adding, modifying, or deleting the user, which is a required functionality in most applications. The separation between the two contracts is an excellent example of the interface segregation principle. Separating the interfaces allows for better flexibility because the framework doesn’t force you to implement behavior if your app doesn’t need it. If the app only needs to authenticate the users, then implementing the UserDetailsService contract is enough to cover the desired functionality.

{% img /technology/spring-security-4.png %}

* Dependencies between the components involved in user management. The `UserDetailsService` returns the details of a user, finding the user by its name. The `UserDetails` contract describes the user. A user has one or more authorities, represented by the `GrantedAuthority` interface. To add operations such as create, delete, or change password to the user, the `UserDetailsManager` contract extends `UserDetailsService` to add operations.

## Describing the user

* For Spring Security, a user definition should respect the `UserDetails` contract. The `UserDetails` contract represents the user as understood by Spring Security. The class of your application that describes the user has to implement this interface, and in this way, the framework understands it.

```java
public interface UserDetails extends Serializable {
  String getUsername();
  String getPassword();
  Collection<? extends GrantedAuthority> getAuthorities();
  boolean isAccountNonExpired();
  boolean isAccountNonLocked();
  boolean isCredentialsNonExpired();
  boolean isEnabled();
}
```

* Spring Security uses authorities to refer either to fine-grained privileges or to roles, which are groups of privileges.

## Detailing on the GrantedAuthority contract

* the actions granted for a user are called _authorities_.
* The authorities represent what the user can do in your application. Without authorities, all users would be equal.
* To create an authority, you only need to find a name for that privilege so you can refer to it later when writing the authorization rules. 

```java
public interface GrantedAuthority extends Serializable {
    String getAuthority();
}
```

* The `SimpleGrantedAuthority` class offers a way to create immutable instances of the type GrantedAuthority.
    * `GrantedAuthority g1 = () -> "READ";`
    * `GrantedAuthority g2 = new SimpleGrantedAuthority("READ");`


## Using a builder to create instances of the UserDetails type

The `User` class from the `org.springframework.security.core.userdetails` package is a simple way to build instances of the `UserDetails` type. Using this class, you can create immutable instances of `UserDetails`.

```java
UserDetails u = User.withUsername("bill")
                .password("12345")
                .authorities("read", "write")
                .accountExpired(false)
                .disabled(true)
                .build();
```

## Understanding the UserDetailsService contract

```java
public interface UserDetailsService {
  UserDetails loadUserByUsername(String username) throws UsernameNotFoundException;
}
```

The authentication implementation calls the `loadUserByUsername(String username)` method to obtain the details of a user with a given username . The `username` is, of course, considered unique. The user returned by this method is an implementation of the `UserDetails` contract. If the username doesn’t exist, the method throws a `UsernameNotFoundException`.

The `AuthenticationProvider` is the component that implements the authentication logic and uses the `UserDetailsService` to load details about the user. To find the user by username, it calls the `loadUserByUsername(String username)` method.

{% img /technology/spring-security-5.png %}

## Implementing the UserDetailsManager contract

The Spring Security authentication flow. Here we use a `JDBCUserDetailsManager` as our `UserDetailsService` component. The `JdbcUserDetailsManager` uses a database to manage users.

```java
public interface UserDetailsManager extends UserDetailsService {
  void createUser(UserDetails user);
  void updateUser(UserDetails user);
  void deleteUser(String username);
  void changePassword(String oldPassword, String newPassword);
  boolean userExists(String username);
}
```

{% img /technology/spring-security-6.png %}

# Dealing with Passwords

## Understanding the PasswordEncoder contract

{% img /technology/spring-security-7.png %}

```java
public interface PasswordEncoder {

  String encode(CharSequence rawPassword);
  boolean matches(CharSequence rawPassword, String encodedPassword);

  default boolean upgradeEncoding(String encodedPassword) { 
    return false; 
  }
}
```

```java
public class Sha512PasswordEncoder implements PasswordEncoder {

  @Override
  public String encode(CharSequence rawPassword) {
    return hashWithSHA512(rawPassword.toString());
  }

  @Override
  public boolean matches(
    CharSequence rawPassword, String encodedPassword) {
    String hashedPassword = encode(rawPassword);
    return encodedPassword.equals(hashedPassword);
  }

  // Omitted code

}
```

Spring Security provides the following encoders out-of-the-box:

* `NoOpPasswordEncoder`--Doesn’t encode the password but keeps it in cleartext. We use this implementation only for examples. Because it doesn’t hash the password, you should never use it in a real-world scenario.
* `StandardPasswordEncoder`--Uses SHA-256 to hash the password. This implementation is now deprecated, and you shouldn’t use it for your new implementations. The reason why it’s deprecated is that it uses a hashing algorithm that we don’t consider strong enough anymore, but you might still find this implementation used in existing applications.
* `Pbkdf2PasswordEncoder`--Uses the password-based key derivation function 2 (PBKDF2).
* `BCryptPasswordEncoder`--Uses a bcrypt strong hashing function to encode the password.
* `SCryptPasswordEncoder`--Uses an scrypt hashing function to encode the password.

# Implementing authentication

The authentication process, which has only two possible results:

1. The entity making the request is not authenticated. The user is not recognized, and the application rejects the request without delegating to the authorization process. Usually, in this case, the response status sent back to the client is _HTTP 401 Unauthorized_.
2. The entity making the request is authenticated. The details about the requester are stored such that the application can use these for authorization. The `SecurityContext` interface is the instance that stores the details about the current authenticated request.

{% img /technology/spring-security-8.png %}

The `Authentication` interface represents the authentication request event and holds the details of the entity that requests access to the application. You can use the information related to the authentication request event during and after the authentication process. The user requesting access to the application is called a _principal_. If you’ve ever used the Java Security API in any app, you learned that in the Java Security API, an interface named `Principal` represents the same concept.

```java
public interface Authentication extends Principal, Serializable {

  Collection<? extends GrantedAuthority> getAuthorities();
  Object getCredentials();
  Object getDetails();
  Object getPrincipal();
  boolean isAuthenticated();
  void setAuthenticated(boolean isAuthenticated) 
     throws IllegalArgumentException;
}
```

```java
public interface AuthenticationProvider {

  Authentication authenticate(Authentication authentication) throws AuthenticationException;

  boolean supports(Class<?> authentication);
}
```

The `AuthenticationProvider` responsibility is strongly coupled with the `Authentication` contract. The `authenticate()` method receives an `Authentication` object as a parameter and returns an `Authentication` object. We implement the `authenticate()` method to define the authentication logic.

* The method should throw an `AuthenticationException` if the authentication fails.
* If the method receives an authentication object that is not supported by your implementation of `AuthenticationProvider`, then the method should return `null`. This way, we have the possibility of using multiple `Authentication` types separated at the HTTP-filter level.
* The method should return an `Authentication` instance representing a fully authenticated object. For this instance, the `isAuthenticated()` method returns true, and it contains all the necessary details about the authenticated entity. Usually, the application also removes sensitive data like a password from this instance. After implementation, the password is no longer required and keeping these details can potentially expose them to unwanted eyes.

The second method in the `AuthenticationProvider` interface is `supports-(Class<?> authentication)`. You can implement this method to return true if the current `AuthenticationProvider` supports the type provided as an `Authentication` object. Observe that even if this method returns true for an object, there is still a chance that the `authenticate()` method rejects the request by returning null. Spring Security is designed like this to be more flexible and to allow you to implement an `AuthenticationProvider` that can reject an authentication request based on the request’s details, not only by its type.

{% img /technology/spring-security-9.png %}

`AuthenticationManager` delegates to one of the available authentication providers. The `AuthenticationProvider` might not support the provided type of authentication. On the other hand, if it does support the object type, it might not know how to authenticate that specific object. The authentication is evaluated, and an `AuthenticationProvider` that can say if the request is correct or not responds to the `AuthenticationManager`.

{% img /technology/spring-security-10.png %}

If the user doesn’t exist, the `loadUserByUsername()` method should throw an `AuthenticationException`. In this case, the authentication process stops, and the HTTP filter sets the response status to HTTP 401 Unauthorized. If the username exists, we can check further the user’s password with the matches() method of the PasswordEncoder from the context. If the password does not match, then again, an `AuthenticationException` should be thrown. If the password is correct, the `AuthenticationProvider` returns an instance of `Authentication` marked as “authenticated,” which contains the details about the request.

To plug in the new implementation of the `AuthenticationProvider`, override the `configure(AuthenticationManagerBuilder auth)` method of the `WebSecurityConfigurerAdapter` class in the configuration class of the project.

Using the `@Autowired` annotation over a field declared as an `AuthenticationProvider`. Spring recognizes the `AuthenticationProvider` as an interface (which is an abstraction). But Spring knows that it needs to find in its context an instance of an implementation for that specific interface. In our case, the implementation is the instance of `CustomAuthenticationProvider`, which is the only one of this type that we declared and added to the Spring context using the `@Component` annotation.

```java
@Configuration
public class ProjectConfig extends WebSecurityConfigurerAdapter {

  @Autowired
  private AuthenticationProvider authenticationProvider;

  @Override
  protected void configure(AuthenticationManagerBuilder auth) {
      auth.authenticationProvider(authenticationProvider);
  }

  // Omitted code
}
```

## Using the SecurityContext

It is likely that you will need details about the authenticated entity after the authentication process ends. You might, for example, need to refer to the username or the authorities of the currently authenticated user. Is this information still accessible after the authentication process finishes? 

Once the `AuthenticationManager` completes the authentication process successfully, it stores the `Authentication` instance for the rest of the request. The instance storing the `Authentication` object is called the _security context_.

```java
public interface SecurityContext extends Serializable {
  Authentication getAuthentication();
  void setAuthentication(Authentication authentication);
}
```

After successful authentication, the authentication filter stores the details of the authenticated entity in the security context. From there, the controller implementing the action mapped to the request can access these details when needed.

Spring Security offers three strategies to manage the `SecurityContext` with an object in the role of a manager. It’s named the `SecurityContextHolder`:

1. `MODE_THREADLOCAL`--Allows each thread to store its own details in the security context. In a thread-per-request web application, this is a common approach as each request has an individual thread.
2. `MODE_INHERITABLETHREADLOCAL`--Similar to `MODE_THREADLOCAL` but also instructs Spring Security to copy the security context to the next thread in case of an asynchronous method. This way, we can say that the new thread running the @Async method inherits the security context.
3. `MODE_GLOBAL`--Makes all the threads of the application see the same security context instance.

{% img /technology/spring-security-11.png %}

### Using a holding strategy for the security context

The first strategy for managing the security context is the `MODE_THREADLOCAL` strategy. This strategy is also the default for managing the security context used by Spring Security. With this strategy, Spring Security uses `ThreadLocal` to manage the context. This implementation works as a collection of data but makes sure that each thread of the application can see only the data stored in the collection. This way, each request has access to its security context. No thread will have access to another’s ThreadLocal. And that means that in a web application, each request can see only its own security context. We could say that this is also what you generally want to have for a backend web application.

Below figure offers an overview of this functionality. Each request (A, B, and C) has its own allocated thread (T1, T2, and T3). This way, each request only sees the details stored in their security context. But this also means that if a new thread is created (for example, when an asynchronous method is called), the new thread will have its own security context as well. The details from the parent thread (the original thread of the request) are not copied to the security context of the new thread.

> This architecture only applies to the traditional servlet application where each request has its own thread assigned. It does not apply to _reactive_ applications.

{% img /technology/spring-security-12.png %}

Each request has its own thread, represented by an arrow. Each thread has access only to its own security context details. When a new thread is created (for example, by an `@Async` method), the details from the parent thread aren’t copied.

Being the default strategy for managing the security context, this process does not need to be explicitly configured. Just ask for the security context from the holder using the static `getContext()` method wherever you need it after the end of the authentication process.

```java Obtaining the SecurityContext from the SecurityContextHolder

@GetMapping("/hello")
public String hello() {
  SecurityContext context = SecurityContextHolder.getContext();
  Authentication a = context.getAuthentication();

  return "Hello, " + a.getName() + "!";
}
```

Obtaining the authentication from the context is even more comfortable at the endpoint level, as Spring knows to inject it directly into the method parameters. You don’t need to refer every time to the `SecurityContextHolder` class explicitly.

### Using a holding strategy for asynchronous calls

{% img /technology/spring-security-13.png %}

The situation gets more complicated if we have to deal with multiple threads per request. Look at what happens if you make the endpoint asynchronous. The thread that executes the method is no longer the same thread that serves the request.

```java An @Async method served by a different thread

@GetMapping("/bye")
@Async
public void goodbye() {
  SecurityContext context = SecurityContextHolder.getContext();
  String username = context.getAuthentication().getName();

  // do something with the username
}
```

```java To enable the functionality of the @Async annotation

@Configuration
@EnableAsync
public class ProjectConfig {

}
```

If you try the code as it is now, it throws a `NullPointerException` on the line that gets the name from the authentication, which is `String username = context.getAuthentication().getName()`.

This is because the method executes now on another thread that does not inherit the security context. For this reason, the `Authorization` object is null and, in the context of the presented code, causes a `NullPointerException`. In this case, you could solve the problem by using the `MODE_INHERITABLETHREADLOCAL` strategy. This can be set either by calling the `SecurityContextHolder.setStrategyName()` method or by using the system property `spring.security.strategy`. By setting this strategy, the framework knows to copy the details of the original thread of the request to the newly created thread of the asynchronous method.

```java Using InitializingBean to set SecurityContextHolder mode

@Configuration
@EnableAsync
public class ProjectConfig {

  @Bean
  public InitializingBean initializingBean() {
    return () -> SecurityContextHolder.setStrategyName(
      SecurityContextHolder.MODE_INHERITABLETHREADLOCAL);
  }
}
```

> This works, however, only when the framework itself creates the thread (for example, in case of an `@Async` method). If your code creates the thread, you will run into the same problem even with the `MODE_INHERITABLETHREADLOCAL` strategy. This happens because, in this case, the framework does not know about the thread that your code creates. 

### Using a holding strategy for standalone applications

If what you need is a security context shared by all the threads of the application, you change the strategy to `MODE_GLOBAL`.

With `MODE_GLOBAL` used as the security context management strategy, all the threads access the same security context. This implies that these all have access to the same data and can change that information. Because of this, race conditions can occur, and you have to take care of synchronization.

Be aware that the `SecurityContext` is not thread safe. So, with this strategy where all the threads of the application can access the `SecurityContext` object, you need to take care of concurrent access.

{% img /technology/spring-security-14.png %}


### Forwarding the security context with DelegatingSecurityContextRunnable

What happens when your code starts new threads without the framework knowing about them? Sometimes we name these self-managed threads because it is we who manage them, not the framework.

No specific strategy of the `SecurityContextHolder` offers you a solution to self-managed threads. In this case, you need to take care of the security context propagation. One solution for this is to use the `DelegatingSecurityContextRunnable` to decorate the tasks you want to execute on a separate thread. The `DelegatingSecurityContextRunnable` extends `Runnable`. You can use it following the execution of the task when there is no value expected. If you have a return value, then you can use the `Callable<T>` alternative, which is `DelegatingSecurityContextCallable<T>`. Both classes represent tasks executed asynchronously, as any other `Runnable` or `Callable`. Moreover, these make sure to copy the current security context for the thread that executes the task.


{% img /technology/spring-security-15.png %}

```java Defining an ExecutorService and submitting the task
@GetMapping("/ciao")
public String ciao() throws Exception {
  Callable<String> task = () -> {
      SecurityContext context = SecurityContextHolder.getContext();
      return context.getAuthentication().getName();
  };

  ExecutorService e = Executors.newCachedThreadPool();
  try {
     return "Ciao, " + e.submit(task).get() + "!";
  } finally {
     e.shutdown();
  }
}
```

If you run the application as is, you get nothing more than a `NullPointerException`. Inside the newly created thread to run the callable task, the authentication does not exist anymore, and the security context is empty. To solve this problem, we decorate the task with `DelegatingSecurityContextCallable`, which provides the current context to the new thread, as provided by this listing.

```java Running the task decorated by DelegatingSecurityContextCallable
@GetMapping("/ciao")
public String ciao() throws Exception {
  Callable<String> task = () -> {
    SecurityContext context = SecurityContextHolder.getContext();
    return context.getAuthentication().getName();
  };

  ExecutorService e = Executors.newCachedThreadPool();
  try {
    var contextTask = new DelegatingSecurityContextCallable<>(task);
    return "Ciao, " + e.submit(contextTask).get() + "!";
  } finally {
    e.shutdown();
  }
}
```

### Forwarding the security context with DelegatingSecurityContextExecutorService

* But we have a second option to deal with the security context propagation to a new thread, and this is to manage propagation from the thread pool instead of from the task itself. An alternative to decorating tasks is to use a particular type of `Executor`.
* The propagation of the security context happens because an implementation called `DelegatingSecurityContextExecutorService` decorates the `ExecutorService`. It also takes care of the security context propagation.

{% img /technology/spring-security-16.png %}

```java Propagating the SecurityContext
@GetMapping("/hola")
public String hola() throws Exception {
  Callable<String> task = () -> {
    SecurityContext context = SecurityContextHolder.getContext();
    return context.getAuthentication().getName();
  };

  ExecutorService e = Executors.newCachedThreadPool();
  e = new DelegatingSecurityContextExecutorService(e);
  try {
    return "Hola, " + e.submit(task).get() + "!";
  } finally {
    e.shutdown();
  }
}
```

### Using and configuring HTTP Basic

* For example, you might want to implement a specific logic for the case in which the authentication process fails. You might even need to set some values on the response sent back to the client in this case.
* You can also call the `httpBasic()` method of the `HttpSecurity` instance with a parameter of type `Customizer`. This parameter allows you to set up some configurations related to the authentication method.
* Also, by using a `Customizer`, we can customize the response for a failed authentication. You need to do this if the client of your system expects something specific in the response in the case of a failed authentication. You might need to add or remove one or more headers. Or you can have some logic that filters the body to make sure that the application doesn’t expose any sensitive data to the client.

```java
@Configuration
public class ProjectConfig extends WebSecurityConfigurerAdapter {

  @Override
  protected void configure(HttpSecurity http) throws Exception {
    http.httpBasic(c -> {
      c.realmName("OTHER");
      c.authenticationEntryPoint(new CustomEntryPoint());
    });

    http.authorizeRequests().anyRequest().authenticated();
  }
}
```

* To customize the response for a failed authentication, we can implement an `AuthenticationEntryPoint`. Its `commence()` method receives the `HttpServletRequest`, the `HttpServletResponse`, and the `AuthenticationException` that cause the authentication to fail. Below listing demonstrates a way to implement the `AuthenticationEntryPoint`, which adds a header to the response and sets the HTTP status to 401 Unauthorized.

```java Implementing an AuthenticationEntryPoint
public class CustomEntryPoint implements AuthenticationEntryPoint {

  @Override
  public void commence(HttpServletRequest httpServletRequest, 
    HttpServletResponse httpServletResponse, AuthenticationException e) 
      throws IOException, ServletException {

      httpServletResponse.addHeader("message", "Luke, I am your father!");
      httpServletResponse.sendError(HttpStatus.UNAUTHORIZED.value());
    }
}
```

# Configuring authorization: Restricting access

* _Authorization_ is the process during which the system decides if an identified client has permission to access the requested resource
* In Spring Security, once the application ends the authentication flow, it delegates the request to an authorization filter. The filter allows or rejects the request based on the configured authorization rules.
* When the client makes the request, the authentication filter authenticates the user. After successful authentication, the authentication filter stores the user details in the security context and forwards the request to the authorization filter. The authorization filter decides whether the call is permitted. To decide whether to authorize the request, the authorization filter uses the details from the security context.

{% img /technology/spring-security-17.png %}

## Restricting access based on authorities and roles

* A user has one or more authorities (actions that a user can do). During the authentication process, the `UserDetailsService` obtains all the details about the user, including the authorities. The application uses the authorities as represented by the `GrantedAuthority` interface for authorization after it successfully authenticates the user
* An _authority_ is an action that a user can perform with a system resource. An authority has a name that the `getAuthority()` behavior of the object returns as a `String`. We use the name of the authority when defining the custom authorization rule. Often an authorization rule can look like this: _“Jane is allowed to delete the product records,”_ or _“John is allowed to read the document records.”_ In these cases, delete and read are the granted authorities. The application allows the users Jane and John to perform these actions, which often have names like read, write, or delete.

```java The GrantedAuthority contract
public interface GrantedAuthority extends Serializable {
  String getAuthority();
}
```

```java The getAuthorities() method from the UserDetails contract

public interface UserDetails extends Serializable {
  Collection<? extends GrantedAuthority> getAuthorities();

  // Omitted code
}
```

{% img /technology/spring-security-18.png %}


```java Restricting access for all endpoints based on user authorities
    var user1 = User.withUsername("john")
                    .password("12345")
                    .authorities("READ")
                    .build();

    var user2 = User.withUsername("jane")
                    .password("12345")
                    .authorities("WRITE")
                    .build();
```

You provide the name of the authority allowed to the user as a parameter of the `hasAuthority()` method. The application needs, first, to authenticate the request and then, based on the user’s authorities, the app decides whether to allow the call.

__1. `hasAuthority()` method

`hasAuthority('WRITE')` -- Stipulates that the user needs the WRITE authority to call the endpoint.



```java Restricting access to only users having WRITE authority

@Override
protected void configure(HttpSecurity http) throws Exception {
  http.httpBasic();

  http.authorizeRequests()
        .anyRequest()
        .hasAuthority("WRITE");
}
```

__2. `hasAnyAuthority()` method

`hasAnyAuthority('READ', 'WRITE')`--Specifies that the user needs one of either the READ or WRITE authorities. With this expression, you can enumerate all the authorities for which you want to allow access.

```java Applying the hasAnyAuthority() method
http.authorizeRequests()
          .anyRequest()
            .hasAnyAuthority("WRITE", "READ");
```

__3. `access()` method

To specify access based on user authorities, the third way you find in practice is the `access()` method. The `access()` method is more general, however. It receives as a parameter a __Spring expression (SpEL)__ that specifies the authorization condition. This method is powerful, and it doesn’t refer only to authorities. However, this method also makes the code more difficult to read and understand. For this reason, I recommend it as the last option, and only if you can’t apply one of the `hasAuthority()` or `hasAnyAuthority()` methods presented earlier.

```java Using the access() method to configure access to the endpoints
http.authorizeRequests()
          .anyRequest()
            .access("hasAuthority('WRITE')");
```

```java Applying the access() method with a more complex expression
String expression = "hasAuthority('read') and !hasAuthority('delete')";

http.authorizeRequests()
    .anyRequest()
    .access(expression);
```

## Restricting access for all endpoints based on user roles

* Roles are coarse grained. Each user with a specific role can only do the actions granted by that role. When applying this philosophy in authorization, a request is allowed based on the purpose of the user in the system. Only users who have a specific role can call a certain endpoint.
* Imagine, in your application, a user can either only have read authority or have all: read, write, and delete authorities. In this case, it might be more comfortable to think that those users who can only read have a role named READER, while the others have the role ADMIN. Having the ADMIN role means that the application grants you read, write, update, and delete privileges.
* Roles are represented using the same contract in Spring Security `GrantedAuthority`. When defining a role, its name should start with the `ROLE_` prefix. At the implementation level, this prefix specifies the difference between a role and an authority.

```java Setting roles for users
var user1 = User.withUsername("john")
                    .password("12345")
                    .authorities("ROLE_ADMIN")
                    .build();

    var user2 = User.withUsername("jane")
                    .password("12345")
                    .authorities("ROLE_MANAGER")
                    .build();
```

To set constraints for user roles, you can use one of the following methods:

1. `hasRole()`--Receives as a parameter the role name for which the application authorizes the request.
2. `hasAnyRole()`--Receives as parameters the role names for which the application approves the request.
3. `access()`--Uses a Spring expression to specify the role or roles for which the application authorizes requests. In terms of roles, you could use `hasRole()` or `hasAnyRole()` as SpEL expressions.

```java Configuring the app to accept only requests from admins
http.authorizeRequests()
         .anyRequest().hasRole("ADMIN");
```

When building users with the User builder class as we did in the example for this section, you specify the role by using the `roles()` method. This method creates the `GrantedAuthority` object and automatically adds the `ROLE_` prefix to the names you provide.

> Make sure the parameter you provide for the `roles()` method DOES NOT include the `ROLE_` prefix. If that prefix is inadvertently included in the `role()` parameter, the method throws an exception. In short, when using the `authorities()` method, include the `ROLE_` prefix. When using the `roles()` method, do not include the `ROLE_` prefix.

Important to remember that the `access()` method is generic. For example, to configure access to the endpoint to be allowed only after 12:00 pm, you can use the following SpEL expression:

```java
T(java.time.LocalTime).now().isAfter(T(java.time.LocalTime).of(12, 0))
```

## Restricting access to all endpoints

```java Using the denyAll() method to restrict access to endpoints
http.authorizeRequests()
         .anyRequest().denyAll();
```

# Configuring authorization: Applying restrictions

## Using matcher methods to select endpoints

* We use matcher methods to choose the requests to which we apply authorization configuration. 
* Requests can be selected by path, by HTTP method or both. 
* Spring Security offers you three types of matcher methods:

1. __MVC matchers__--You use MVC expressions for paths to select endpoints.
2. __Ant matchers__--You use Ant expressions for paths to select endpoints.
3. __regex matchers__--You use regular expressions (regex) for paths to select endpoints.

__MVC matchers__

* We create an application that exposes two endpoints: `/hello` and `/ciao`. We want to make sure that only users having the ADMIN role can call the `/hello` endpoint. Similarly, we want to make sure that only users having the MANAGER role can call the `/ciao` endpoint.
* To specify that only users having the ADMIN role can call the endpoint `/hello` when authorizing requests, we use the `mvcMatchers()` method.

```java
@Override
  protected void configure(HttpSecurity http) throws Exception {
    http.httpBasic();

    http.authorizeRequests()
         .mvcMatchers("/hello").hasRole("ADMIN")
         .mvcMatchers("/ciao").hasRole("MANAGER");
  }

```

If you now add any other endpoint to your application, it is accessible by default to anyone, even unauthenticated users. 

The `permitAll()` method states that all other requests are allowed without authentication.

> When you use matchers to refer to requests, the order of the rules should be from particular to general. This is why the `anyRequest()` method cannot be called before a more specific matcher method like `mvcMatchers()`.

```java Marking additional requests explicitly as accessible without authentication
@Override
  protected void configure(HttpSecurity http) throws Exception {
    http.httpBasic();

    http.authorizeRequests()
           .mvcMatchers("/hello").hasRole("ADMIN")
           .mvcMatchers("/ciao").hasRole("MANAGER")
           .anyRequest().permitAll();
  }
```


If you have designed an endpoint to be accessible to anyone, you can call it without providing a username and a password for authentication. In this case, Spring Security won’t do the authentication. If you, however, provide a username and a password, Spring Security evaluates them in the authentication process. If they are wrong (not known by the system), authentication fails, and the response status will be 401 Unauthorized. To be more precise, if you call the /hola endpoint for the configuration presented in listing 8.4, the app returns the body “Hola!” as expected, and the response status is 200 OK.

{% img /technology/spring-security-19.png %}

The authorization filter allows any request to the `/hola` path. But because the application first executes the authentication logic, the request is never forwarded to the authorization filter. Instead, the authentication filter replies with an HTTP 401 Unauthorized.


The `permitAll()` method refers to authorization configuration only, and if authentication fails, the call will not be allowed further.

To make all the other endpoints accessible only for authenticated users. To do this, you would change the `permitAll()` method with `authenticated()` as presented in the following listing. Similarly, you could even deny all other requests by using the `denyAll()` method.

```java Making other requests accessible for all authenticated users
@Override
  protected void configure(HttpSecurity http) 
    throws Exception {
    http.httpBasic();

     http.authorizeRequests()
           .mvcMatchers("/hello").hasRole("ADMIN")
           .mvcMatchers("/ciao").hasRole("MANAGER")
           .anyRequest().authenticated();
  }
```

Multiple endpoints can have the same authorization rules, so you don’t have to set them up endpoint by endpoint

## Selecting requests for authorization using MVC matchers

This matcher uses the standard MVC syntax for referring to paths. This syntax is the same one you use when writing endpoint mappings with annotations like @RequestMapping, `@GetMapping`, `@PostMapping`, and so forth. The two methods you can use to declare MVC matchers are as follows:

* `mvcMatchers(HttpMethod method, String... patterns)`--Lets you specify both the HTTP method to which the restrictions apply and the paths. This method is useful if you want to apply different restrictions for different HTTP methods for the same path.
* `mvcMatchers(String... patterns)`--Simpler and easier to use if you only need to apply authorization restrictions based on paths. The restrictions can automatically apply to any HTTP method used with the path.

Spring Security applies, by default, protection against cross-site request forgery (CSRF).

```java Authorization configuration for the first scenario, /a
http.authorizeRequests()
            .mvcMatchers(HttpMethod.GET, "/a")
               .authenticated()
            .mvcMatchers(HttpMethod.POST, "/a")
               .permitAll()
            .anyRequest()
               .denyAll();

    http.csrf().disable(); 
```

For the current project, we want to ensure that the same rules apply for all requests for paths starting with `/a/b`. These paths in our case are `/a/b` and `/a/b/c`. To achieve this, we use the `**` operator. (Spring MVC borrows the path-matching syntaxes from Ant.)

```java Changes in the configuration class for multiple paths
 http.authorizeRequests()
          .mvcMatchers( "/a/b/**")
             .authenticated()    
          .anyRequest()
             .permitAll();
```

The `**` operator refers to any number of pathnames. You can use it as we have done in the last example so that you can match requests with paths having a known prefix. You can also use it in the middle of a path to refer to any number of pathnames or to refer to paths ending in a specific pattern like `/a/**/c`. Therefore, `/a/**/c` would not only match `/a/b/c` but also `/a/b/d/c` and `a/b/c/d/e/c` and so on. If you only want to match one pathname, then you can use a single `*`. For example, `a/*/c` would match `a/b/c` and `a/d/c` but not `a/b/d/c`.

```java Configuring the authorization to permit only specific digits
http.authorizeRequests()
         .mvcMatchers("/product/{code:^[0-9]*$}") //The regex refers to strings of any length, containing any digit.
              .permitAll()
         .anyRequest()
              .denyAll();
```

Common expressions used for path matching with MVC matchers

| Expression | Description |
| `/a`| Only path /a. | 
| `/a/*`| The * operator replaces one pathname. In this case, it matches /a/b or /a/c, but not /a/b/c. | 
| `/a/**`| The ** operator replaces multiple pathnames. In this case, /a as well as /a/b and /a/b/c are a match for this expression. | 
| `/a/{param}`| This expression applies to the path /a with a given path parameter. | 
| `/a/{param:regex}`| This expression applies to the path /a with a given path parameter only when the value of the parameter matches the given regular expression. | 

__Ant matchers__

The Ant matchers apply exactly the given Ant expressions for patterns but know nothing about subtle Spring MVC functionality. In this case, `/hello` doesn’t apply as an Ant expression to the `/hello/` path. If you also want to secure the `/hello/` path, you have to individually add it or write an Ant expression that matches it as well. 

```java
http.authorizeRequests()
          .antMatchers( "/hello").authenticated();
```

# Implementing filters

* In Spring Security, in general, HTTP filters manage each responsibility that must be applied to the request. The filters form a chain of responsibilities. 
* The filter chain receives the request. Each filter uses a manager to apply specific logic to the request and, eventually, delegates the request further along the chain to the next filter.
* Spring Security provides filter implementations that you add to the filter chain through customization, but you can also define custom filters.

{% img /technology/spring-security-20.png %}

You can customize the filter chain by adding new filters before, after, or at the position of existing ones. This way, you can customize authentication as well as the entire process applied to request and response.

{% img /technology/spring-security-21.png %}

* Custom filters can created by implementing the `javax.servlet.Filter` package. 
* Default implementations from Spring Security:
    * `BasicAuthenticationFilter` takes care of HTTP Basic authentication, if present.
    * `CsrfFilter` takes care of cross-site request forgery (CSRF) protection.
    * `CorsFilter` takes care of cross-origin resource sharing (CORS) authorization rules,

* Call to the `httpBasic()` method, an instance of the `BasicAuthenticationFilter` is added to the chain.
* Each filter has an order number. This determines the order in which filters are applied to a request. You can add custom filters along with the filters provided by Spring Security.

{% img /technology/spring-security-22.png %}

* If multiple filters have the same position, the order in which they are called is not defined.

{% img /technology/spring-security-23.png %}

## Adding a filter before an existing one in chain

* For our example, we add a `RequestValidationFilter`, which acts before the authentication filter. The `RequestValidationFilter` ensures that authentication doesn’t happen if the validation of the request fails. 
* In our case, the request must have a mandatory header named `RequestId`. If the header doesn’t exist, we set an HTTP status 400 Bad Request on the response without forwarding it to the next filter in the chain.


{% img /technology/spring-security-24.png %}

```java Filter implementation
@Override
public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) 
    throws IOException, ServletException {

  var httpRequest = (HttpServletRequest) request;
  var httpResponse = (HttpServletResponse) response;

  String requestId = httpRequest.getHeader("Request-Id");

  if (requestId == null || requestId.isBlank()) {
      httpResponse.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      return;
  }

  filterChain.doFilter(request, response);
}
```

```java Configuring the filter
@Configuration
public class ProjectConfig extends WebSecurityConfigurerAdapter {

  @Override
  protected void configure(HttpSecurity http) throws Exception {
    http.addFilterBefore(
            new RequestValidationFilter(),
            BasicAuthenticationFilter.class)
        .authorizeRequests()
            .anyRequest().permitAll();
  }
}
```

## Adding a filter after an existing one in chain

{% img /technology/spring-security-25.png %}

```java
@Configuration
public class ProjectConfig extends WebSecurityConfigurerAdapter {

  @Override
  protected void configure(HttpSecurity http) throws Exception {
    http.addFilterBefore(
            new RequestValidationFilter(),
            BasicAuthenticationFilter.class)
        .addFilterAfter(
            new AuthenticationLoggingFilter(),
            BasicAuthenticationFilter.class)
        .authorizeRequests()
            .anyRequest().permitAll();
    }
}
```

## Adding a filter at the location of another in the chain

* In this section, we discuss adding a filter at the location of another one in the filter chain. You use this approach especially when providing a different implementation for a responsibility that is already assumed by one of the filters known by Spring Security. 
* A typical scenario is replacing HTTP Basic authentication flow in following scenarios:
    1. Identification based on a static header value for authentication
    2. Using a symmetric key to sign the request for authentication
    3. Using a one-time password (OTP) in the authentication process


__1. Identification based on a static header value for authentication__

* This approach  offers weak security related to authentication, but architects and developers often choose it in calls between backend applications for its simplicity.
* The request contains a header with the value of the static key. If this value matches the one known by the application, it accepts the request.

{% img /technology/spring-security-26.png %}

__2. Using a symmetric key to sign the request for authentication__

* In this scenario, using symmetric keys to sign and validate requests, both client and server know the value of a key (client and server share the key). The client uses this key to sign a part of the request (for example, to sign the value of specific headers), and the server checks if the signature is valid using the same key . The server can store individual keys for each client in a database or a secrets vault. Similarly, you can use a pair of asymmetric keys.
* The Authorization header contains a value signed with a key known by both client and server (or a private key for which the server has the public pair). The application checks the signature and, if correct, allows the request.

{% img /technology/spring-security-27.png %}

__3. Using a one-time password (OTP) in the authentication process__

* And finally, using an OTP in the authentication process, the user receives the OTP via a message or by using an authentication provider app like Google Authenticator.
* To access the resource, the client has to use a one-time password (OTP). The client obtains the OTP from a third-party authentication server. Generally, applications use this approach during login when multifactor authentication is required.

{% img /technology/spring-security-28.png %}

```java Custom auth filter
@Component
public class StaticKeyAuthenticationFilter implements Filter {

  @Value("${authorization.key}")
  private String authorizationKey;

  @Override
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) 
    throws IOException, ServletException {

    var httpRequest = (HttpServletRequest) request;
    var httpResponse = (HttpServletResponse) response;

    String authentication = httpRequest.getHeader("Authorization");

    if (authorizationKey.equals(authentication)) {
        filterChain.doFilter(request, response);
    } else {
        httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
    }
  }
}
```

```java Adding the filter in the configuration
@Configuration
public class ProjectConfig extends WebSecurityConfigurerAdapter {

  @Autowired
  private StaticKeyAuthenticationFilter filter;

  @Override
  protected void configure(HttpSecurity http) throws Exception {
    http.addFilterAt(filter, BasicAuthenticationFilter.class)
        .authorizeRequests()
           .anyRequest().permitAll();
  }
}
```

* When `UserDetailsService` is not defined, Spring Boot automatically configures one. But in our scenario, we don’t need a `UserDetailsService` at all because the concept of the user doesn’t exist. We only validate that the user requesting to call an endpoint on the server knows a given value. Application scenarios are not usually this simple and often require a `UserDetailsService`. But, if you anticipate or have such a case where this component is not needed, you can disable autoconfiguration. 

```java To disable the default UserDetailsService
@SpringBootApplication(exclude = {UserDetailsServiceAutoConfiguration.class })
```

## Filter implementations from Spring Security

* Spring Security offers a few abstract classes that implement the `Filter` interface and for which you can extend your filter definitions. 
* For example, you could extend the `GenericFilterBean` class, which allows you to use initialization parameters that you would define in a `web.xml` descriptor file where applicable. 
* A more useful class that extends the `GenericFilterBean` is `OncePerRequestFilter`. When adding a filter to the chain, the framework doesn’t guarantee it will be called only once per request. `OncePerRequestFilter`, as the name suggests, implements logic to make sure that the filter’s `doFilter()` method is executed only one time per request.

# References

* Book - Spring Security in Action (Manning publications)