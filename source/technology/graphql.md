---
layout: page
title: "Groovy"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Overview

* With GraphQL, clients can obtain all of the data they need in one request.
* Whenever a query is executed against a GraphQL server, it is validated against a type system. A type system is like a blueprint for your API’s data, backed by a list of objects that you define.

``` Example
type Person {
    id: ID!
    name: String
    birthYear: String
    eyeColor: String
    gender: String
}
```

* GraphQL is often referred to as a _declarative data-fetching language_. Developers list their data requirements as what data they need without focusing on how they’re going to get it.
* GraphQL is a specification (spec) for client-server communication.
* A GraphQL query is _hierarchical_. Fields are nested within other fields and the query is shaped like the data that it returns.

__REST Drawbacks__

* _Data overfetching and underfetching_ - REST either returns more data than what user needs or would require additional requests are needed to get more details. similar to N+1 problem in ORM
* _Managing endpoints_ - as the client needs change, more endpoints need to be created which eventually multiply quickly. GraphQL architecture typically involves only a single endpoint.

e.g., https://swapi.co/api/people/1/

```json Underfetching
"films": [
    "https://swapi.co/api/films/2/",
    "https://swapi.co/api/films/6/",
    "https://swapi.co/api/films/3/",
    "https://swapi.co/api/films/1/",
    "https://swapi.co/api/films/7/"
  ]
```
# Query Language

* Like SQL, GraphQL can be used for all CRUD operations
* Data Types/Operations: 
    * `Query` - read
    * `Mutation` - insert, update and delete
    * `Subscription` - used to listen for data changes
* A GraphQL document can contain the definitions of one or more operations. For example, one could place 2 query operations in a query document.
* A JSON response can contain both “data” and “errors.”

## Query

* A `Query` data type is called a _root type_ because it’s a type that maps to an operation, and operations represent the roots of our query document. 
* Selection sets
    * When we write queries, we are selecting the fields that we need by encapsulating them in curly brackets. These blocks are referred to as selection sets.
    * You can nest selection sets within one another.
* Fields
    * The _fields_ that are available to query in a GraphQL API have been defined in that API’s schema. The documentation will tell us what fields are available to select on the Query type.
    * fields can be either scalar types or object types.
    * __Scalar types__ (Built-in): 
        * `Int`, `Float` - return JSON numbers
        * `String`, `ID` (unique identifiers) - return strings. Even though ID and String will return the same type of JSON data, GraphQL still makes sure that IDs return unique strings
        * `Boolean` - return boolean
    * __Object Types__: GraphQL object types are user-defined groups of one or more fields that you define in your schema. They define the shape of the JSON object that should be returned. JSON can endlessly nest objects under fields, and so can GraphQL
* Response
    * We can change the field names in the response object within the query by specifying an _alias_. e.g., `liftName` in below example.
* Query Arguments
    * A way to filter the results of a GraphQL query is to pass in _query arguments_. 
    * Arguments are a key–value pair (or pairs) associated with a query field. 

``` Sample Query
query liftsAndTrails {
  open: liftCount(status: OPEN, sortBy: "name")
  chairlifts: allLifts {
    liftName: name
    status
  }
  skiSlopes: allTrails {
    name
    difficulty
  }
}
```

```json Sample response
{
  "data": {
    "open": 5,
    "chairlifts": [
      {
        "liftName": "Astra Express",
        "status": "open"
      }
    ],
    "skiSlopes": [
      {
        "name": "Ditch of Doom",
        "difficulty": "intermediate"
      }
    ]
  }
}
```

* Example for passing a GraphQL query in curl: 

```bash
curl  'http://snowtooth.herokuapp.com/'
  -H 'Content-Type: application/json'
  --data '{"query":"{ allLifts {name }}"}'`
```

### Object types

``` Example of user-defined types
type User {
  name: String!
  username: String!
}

type Document {
  title: String!
  content: String!
  author: User!
}
```

### One-to-Many connections

Aa one-to-many relationship between User and Document. Notice that the documents field will contain an actual array of documents.

```
type User {
  name: String!
  username: String!
  email: String!
  noOfDocuments: Int!
  documents: [Document!]!
}
```

In this example, `trailAccess` returns a filtered list of trails that are accessible from _Jazz Cat_. Because `trailAccess` is a field within the `Lift` type, the API can use details about the parent object, the Jazz Cat `Lift`, to filter the list of returned trails.

```
query trailsAccessedByJazzCat {
    Lift(id:"jazz-cat") {
        capacity
        trailAccess {
            name
            difficulty
        }
    }
}
```

### Fragments

Resuable set of fields to include in queries.

```
{
  leftComparison: hero(episode: EMPIRE) {
    ...comparisonFields # JS spread operator
  }
  rightComparison: hero(episode: JEDI) {
    ...comparisonFields
  }
}

fragment comparisonFields on Character {
  name
  appearsIn
  friends {
    name
  }
}
```

### Union types

If you want a list to return more than one type, you could create a _union type_, which creates an association between two different object types.

Suppose that we’re building a scheduling app for college students with which they can add Workout and Study Group events to an agenda. When writing a query for a student’s agenda, you can use fragments to define which fields to select when the `AgendaItem` is a `Workout`, and which fields to select when the `AgendaItem` is a `StudyGroup`.

```
query schedule {
    agenda {
    ...on Workout { # inline fragments
      name
      reps
    }
    ...on StudyGroup {
      name
      subject
      students
    }
  }
}
```

```json Sample response
{
  "data": {
    "agenda": [
      {
        "name": "Comp Sci",
        "subject": "Computer Science",
        "students": 12
      },
      {
        "name": "Cardio",
        "reps": 100
      },
      {
        "name": "Poets",
        "subject": "English 101",
        "students": 3
      }
    ]
  }
}
```

The same union type above using named fragments

```
query today {
    agenda {
    ...workout
    ...study
  }
}

fragment workout on Workout {
  name
  reps
}

fragment study on StudyGroup {
  name
  subject
  students
}
```

### Intefaces

Interfaces are another option when dealing with multiple object types that could be returned by a single field. An interface is an abstract type that establishes a list of fields that should be implemented in similar object types. When another type implements the interface, it includes all of the fields from the interface and usually some of its own fields.

```
interface Character {
  id: ID!
  name: String!
  friends: [Character]
  appearsIn: [Episode]!
}

type Human implements Character {
  id: ID!
  name: String!
  friends: [Character]
  appearsIn: [Episode]!
  starships: [Starship]
  totalCredits: Int
}

type Droid implements Character {
  id: ID!
  name: String!
  friends: [Character]
  appearsIn: [Episode]!
  primaryFunction: String
}
```


## Mutation

* `Mutation` is a root object type

```
mutation {
  setLiftStatus(id: "panorama" status: OPEN) {
    name
    status
  }
}
```

# References

* Books
    * O'Reilly Learning GraphQL
* [https://github.com/moonhighway/learning-graphql/](https://github.com/moonhighway/learning-graphql/)
* [https://www.graphqlworkshop.com/](https://www.graphqlworkshop.com/)