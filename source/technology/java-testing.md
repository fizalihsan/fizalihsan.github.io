---
layout: page
title: "Java Testing"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Concepts

* [Characterization test](http://www.artima.com/weblogs/viewpost.jsp?thread=198296)
* [Characterization Testing static methods using different techniques](http://martinfowler.com/articles/modernMockingTools.html)
* [Mocks aren't Stubs](http://martinfowler.com/articles/mocksArentStubs.html)


# JUnit

## Method Level Annotations

* `@BeforeClass` - Marks the method to execute before the test case class begins
* `@AfterClass` - Marks the method to execute after the test case class completes
* `@Before` - Marks the method to execute before the test case begins
* `@After` - Marks the method to execute after the test case completes
* `@Test` - Marks the method as a test case
* `@Test(exception = NullPointerException.class)` - Marks the method to expect the given exception
* `@Test(timeout=1)` - Marks the maximum time in milliseconds the test case can take to run
* `@Ignore("Comment")` - Mark a method to ignore from testing

## Class Level Annotations

* Runner - is a class which runs tests. JUnit provides a bunch of runners out-of-the-box:
  * JUnit4 - starts the test case as a Junit4 test case
  * Parameterized - runs the same test method with different parameters
  * Suite - executes all the @Test annotated methods in a class
* `@RunWith(runner.class)` - Custom runner classes can be provided with this annotation
* `@SuiteClasses(value={foo1.class, foo2.class})`
  * Suite is a container to combine more than one test cases for grouping and invocation
  * When there are 2 test methods in a class, JUnit4 uses a Suite by default.
  * Runner invokes the Suite. Ordering or execution is up to the Suite implementation.

## Parameterized Tests 

* `Parameterized.class` is a Runner class provided by JUnit4
* Same test method is tested with different parameters returned by the method defined by `@Parameters`.
* Signature of parmeters method should be `@Parameters public static Collection`. Collection elements should be arrays of same length
* Variables used in the test method should be defined as instance variables in the test class and there should be public constructor setting all these instance variables.

``` java Example
@RunWith(value = Parameterized.class)
public class ParameterizedTest {
  private double expected, valueOne, valueTwo;


  @Parameterized.Parameters
  public static Collection<Integer[]> getTestParameters() {
    return Arrays.asList(new Integer[][]{
      {2, 1, 1}, //expected, valueOne, valueTwo
      {3, 2, 1}, //expected, valueOne, valueTwo
      {4, 3, 1}, //expected, valueOne, valueTwo
    });
  }

  public ParameterizedTest(double expected, double valueOne, double valueTwo) {
    this.expected = expected; this.valueOne = valueOne; this.valueTwo = valueTwo;
  }

  @Test
  public void sum() {
    Assert.assertEquals(expected, new Calculator().add(valueOne, valueTwo), 0);
  }

  private class Calculator{
    double add(double i, double j){ return i+j; }
  }
}
```

Parameterized.class is a Runner class provided by JUnit4
Same test method is tested with different parameters returned by the method defined by@Parameters.
Signature of parmeters method should be@Parameters public static Collection. Collection elements should be arrays of same length
Variables used in the test method should be defined as instance variables in the test class and there should be public constructor setting all these instance variables.

# Mockito

* On mock object, all methods that return value returns null by default
* Mockito follows `Arrange - Act - Assert` unlike other mock frameworks which follow `Expect-Run-Verify` pattern.
* What is not possible in Mockito compared to others?
  * Testing static methods (check PowerMockito)
  * Mocking final classes

## Examples

``` java Example of Verify
import org.junit.Test;
import java.util.List;
import static org.junit.Assert.*
import static org.mockito.Mockito.*;
 
public class MockitoTest {
    @Test public void testVerify() {
        List<String> mockedList = mock(List.class);
        mockedList.add("once");
        mockedList.add("twice");
        mockedList.add("twice");
        mockedList.add("three times");
        mockedList.add("three times");
        mockedList.add("three times");
 
        //following two verifications work exactly the same - times(1) is used by default
        verify(mockedList).add("once");
        verify(mockedList, times(1)).add("once");
 
        //exact number of invocations verification
        verify(mockedList, times(2)).add("twice");
        verify(mockedList, times(3)).add("three times");
 
        //verification using never(). never() is an alias to times(0)
        verify(mockedList, never()).add("never happened");
 
        //verification using atLeast()/atMost()
        verify(mockedList, atLeastOnce()).add("three times");
        verify(mockedList, atLeast(2)).add("three times");
        verify(mockedList, atMost(5)).add("three times");
    }
}
```

``` java Example of Stubbing
@Test public void stubbing() {
        //Arrange - Act - Assert Pattern
        Iterator i = mock(Iterator.class);
        //when next() method is called, return "Hello" first and on 2nd invocation return "World"
        when(i.next()).thenReturn("Hello").thenReturn("World"); //Arrange
        String result = i.next() + " " + i.next(); //Act
        assertThat("Hello World", is(result)); //Assert
    }
```

``` java Example of Stubbing void methods
@Test(expected = IOException.class)
    public void voidMethodCalls() throws IOException {
        OutputStream stream = mock(OutputStream.class);
        doThrow(new IOException()).when(stream).close(); //when close() method is called throw exception
        stream.close();
    }
}
```

``` java Example of Argument Matchers
@Test(expected = NullPointerException.class)
    public void throwException() {
        Comparable c = mock(Comparable.class);
        when(c.compareTo("Test")).thenReturn(1);
        when(c.compareTo(null)).thenThrow(new NullPointerException("Null...."));//when input is null, throw NPE
        assertThat(1, is(c.compareTo("Test")));
        assertThat(0, is(c.compareTo("Something")));
        assertThat(0, is(c.compareTo(null))); //throws NPE
 
        when(c.compareTo(anyString())).thenReturn(100);//regardless of the input, return 100. anyString() is called Argument Matchers
        assertThat(100, is(c.compareTo("Test")));
    }
}
```

To learn more about Argument Matchers: http://docs.mockito.googlecode.com/hg/latest/org/mockito/Matchers.html

# Hamcrest

Hamcrest is a Google library shipped with JUnit 4.x to make the assertions simpler.

| Method | Description |
| ------ | ----------- | 
| `anything` | Matches absolutely anything. Useful in some cases where you want to make the assert statement more readable. | 
| `is` | Is used only to improve the readability of your statements. | 
| `allOf` | Checks to see if all contained matchers match (just like the && operator). | 
| `anyOf` | Checks to see if any of the contained matchers match (like the || operator). | 
| `not` | Traverses the meaning of the contained matchers (just like the ! operator in Java). | 
| `instanceOf,isCompatibleType` | Match whether objects are of compatible type (are instances of one another). | 
| `sameInstance` | Tests object identity.
| `notNullValue,nullValue` | Tests for null values (or non-null values).
| `hasProperty` | Tests whether a JavaBean has a certain property.
| `hasEntry,hasKey,hasValue` | Tests whether a given Map has a given entry, key, or value.
| `hasItem,hasItems` | Tests a given collection for the presence of an item or items.
| `closeTo,greaterThan,greaterThanOrEqual,lessThan,lessThanOrEqual` | Test whether given numbers are close to, greater than, greater than or equal to, less than, or less than or equal to a given value.
| `equalToIgnoringCase` | Tests whether a given string equals another one, ignoring the case.
| `equalToIgnoringWhiteSpace` | Tests whether a given string equals another one, by ignoring the white spaces.
| `containsString,endsWith,startWith` | Test whether the given string contains, starts with, or ends with a certain string

``` java Examples of Hamcrest functions
import org.junit.Test;
import java.util.Arrays;
import java.util.List;
import static org.hamcrest.CoreMatchers.*;
import static org.junit.Assert.assertThat;

public class HamcrestTest {
    @Test public void simpleAssertions(){
        List<Integer> nums = Arrays.asList(1, 2, 3, 4, 5);
        assertThat(nums.size(), is(5)); //Assert equals
        assertThat(nums.size(), is(equalTo(5)));//Assert equals
        assertThat(nums, allOf(notNullValue(), instanceOf(List.class)));//AND operation
        assertThat(nums, anyOf(nullValue(), instanceOf(List.class)));//OR operation
        assertThat(nums, not(equalTo(Arrays.asList(1))));//NOT operation
    }
}
```

# Spock Framework

Spock is a testing and specification framework for Java and Groovy applications.

* Specification - compare to TestCase/GroovyTestCase. Instructs JUnit to run Sputnik (custom JUnitRunner)
* Every member field in test class is reinitialized for every test unless marked as @Shared.
* Feature - compare to test method or @Test
 
``` groovy Fixture Methods
 def setup(){} //run before every feature method
 def cleanup(){} //run after every feature method
 def setupSpec(){} //run before the first feature method
 def cleanupSpec(){} //run after the first feature method
```

``` groovy 2 ways of setup using DSL keywords- setup or given
setup: OR given: "setup and init of..." //must be first and only. label is optional
def stack = new Stack()
def elem = "push me"

when/then blocks
when: //stimulus
stack.push(elem)

then: //response
!stack.empty //leverages Groovy truthy feature. Implicitly asserts the collection is not null and not empty
stack.size() == 1
stack.peek() == elem
```

``` groovy Example 1: checking for an exception thrown
when:
stack.pop()

then:
thrown(EmptyStackException)
stack.empty
```

``` groovy Example 2: ensuring no exception is thrown
when: 
stack.pop()
 
 then:
 EmptyStackException e = thrown()
 e.cause == null
```

``` groovy Example 3:
 when: 
 stack.pop()
 
 then:
 notThrown(EmptyStackException)
```

# Bibliography

* Books
  * xUnit Patterns
* [BDD](http://jdave.org/)
* [Apache JMeter - Load Testing tool](http://jmeter.apache.org/)
* http://tedyoung.me/2011/01/23/junit-runtime-tests-custom-runners/
* http://stackoverflow.com/questions/13489388/how-junit-rule-works
* http://www.mkyong.com/unittest/junit-4-tutorial-6-parameterized-test/
* http://stackoverflow.com/questions/4055022/mark-unit-test-as-an-expected-failure-in-junit/8092927#8092927
* http://java.dzone.com/articles/dry-use-junit-rule-instead