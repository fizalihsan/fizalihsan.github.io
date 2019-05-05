---
layout: page
title: "GraphQL"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Overview

* With GraphQL, clients can obtain all of the data they need in one request.
* Whenever a query is executed against a GraphQL server, it is validated against a type system. A type system is like a blueprint for your API’s data, backed by a list of objects that you define.

```
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

```json
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
* Response
    * We can change the field names in the response object within the query by specifying an _alias_. e.g., `liftName` in below example.
* Query Arguments
    * A way to filter the results of a GraphQL query is to pass in _query arguments_. 
    * Arguments are a key–value pair (or pairs) associated with a query field. 

```
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

```json
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

```
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

```json
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
* In the below example, it returns a selection set with `name` and `status` after mutation

```
mutation {
  setLiftStatus(id: "panorama" status: OPEN) {
    name
    status
  }
}
```

* Using query variables to replace hardcoded values in the mutation arguments

```
mutation createSong($title:String! $numberOne:Int $by:String!) {
  addSong(title:$title, numberOne:$numberOne, performerName:$by) {
    id
    title
    numberOne
  }
}
```

## Introspection

* Introspection is the ability to query details about the current API's schema. You can send queries to every GraphQL API that return data about a given API’s schema. 

* This query returns all available types in the API, including root types, custom types, and even scalar types.

```
query {
  __schema {
    types {
      name
      description
    }
  }
}
```

* To see the details of a particular type, we can run the `__type` query and send the name of the type that we want to query as an argument:

```
query liftDetails {
  __type(name:"Lift") {
    name
    fields {
      name
      description
      type {
        name
      }
    }
  }
}
```

# Schema Design

* GraphQL is going to change your design process. Instead of looking at APIs as a collection of REST endpoints, begin looking at your APIs as collections of types.
* __Schema First Design__ 
  * _Schema First_ design methodology gets all teams on the same page about the data types that make up your application.
  * The backend team will have a clear understanding about the data that it needs to store and deliver. The frontend team will have the definitions that it needs to begin building user interfaces.
* GraphQL Schema Definition Language (SDL) is same irrespective of the language or framework in which your application is built.

__Schema & Types__

* A _schema_ is a collection of type definitions. You can write your schemas in a JS file as a string or in any text file. These files usually carry the `.graphql` extension.
* A _type_ has fields that represent the data associated with each object. Each field returns a specific type of data. This could mean an integer or a string, but it also could mean a custom object type or list of types.
* The exclamation point specifies that the field is non-nullable, which means that the name and url fields must return some data in each query

```
"""
Defining a custom type named Photo
"""
type Photo {
    id: ID!
    name: String!
    url: String!

    "Optional field to describe the photo
    "
    description: String
}
```

## Scalar types

* A scalar type is not an object type. It does not have fields. 
* Built-in scalar types 
  * `Int`, `Float` - return JSON numbers
  * `String`, `ID` (unique identifiers) - return strings. 
    * Even though ID and String will return the same type of JSON data, GraphQL still makes sure that IDs return unique strings
    * the ID scalar type is used when a unique identifier should be returned.
  * `Boolean` - return boolean
* Custom scalar type
  * In the example below, a custom scalar type: `DateTime` is created. 
  * Any field marked `DateTime` will return a JSON string, but we can use the custom scalar to make sure that string can be serialized, validated, and formatted as an official date and time
  * The `graphql-custom-types` npm package contains some commonly used custom scalar types
  * _enums_ are scalar types that allow a field to return a restrictive set of string values.

```
scalar DateTime

enum PhotoCategory {
    PORTRAIT
    LANDSCAPE
}

type Photo {
    id: ID!
    name: String!
    url: String!
    description: String
    created: DateTime!
    category: PhotoCategory!
}
```

## Object Types

* GraphQL object types are user-defined groups of one or more fields that you define in your schema. They define the shape of the JSON object that should be returned. JSON can endlessly nest objects under fields, and so can GraphQL

## Connections and Lists

* When you create GraphQL schemas, you can define fields that return lists of any GraphQL type
* A list can contain elements of different types
* Variations
  * `[Int]` - A list of nullable integer values
  * `[Int!]` - A list of non-nullable integer values
  * `[Int]!` - A non-nullable list of nullable integer values
  * `[Int!]!` - A non-nullable list of non-nullable integer values
* One-to-many connections
  * It is a good idea to keep GraphQL services undirected when possible. This provides our clients with the ultimate flexibility to create queries because they can start traversing the graph from any node. All we need to do to follow this practice is provide a path back from `User` types to `Photo` types. This means that when we query a `User`, we should get to see all of the photos that particular user posted:

```
type User {
    githubLogin: ID!
    name: String
    avatar: String
    postedPhotos: [Photo!]!
}

type Photo {
    id: ID!
    name: String!
    url: String!
    description: String
    created: DateTime!
    category: PhotoCategory!
    postedBy: User!
}
```

### Many-to-many connections

```
type User {
    ...
    inPhotos: [Photo!]!
}

type Photo {
    ...
    taggedUsers: [User!]!
}
```

### Unions

* a union type is a type that we can use to return one of several different types.
* `AgendaItem` combines study groups and workouts under a single type. When we add the agenda field to our Query, we are defining it as a list of either workouts or study groups.

```
union AgendaItem = StudyGroup | Workout

type StudyGroup {
    name: String!
    subject: String
    students: [User!]!
}

type Workout {
    name: String!
    reps: Int!
}

type Query {
    agenda: [AgendaItem!]!
}
```

### Interfaces

* Another way of handling fields that could contain multiple types is to use an interface. 
* Both union types and interfaces are tools that you can use to create fields that contain different object types. 
* In general, if the objects contain completely different fields, it is a good idea to use union types. They are very effective. If an object type must contain specific fields in order to interface with another type of object, you will need to use an interface rather than a union type.

```
scalar DateTime

interface AgendaItem {
    name: String!
    start: DateTime!
    end: DateTime!
}

type StudyGroup implements AgendaItem {
    name: String!
    start: DateTime!
    end: DateTime!
    participants: [User!]!
    topic: String!
}

type Workout implements AgendaItem {
    name: String!
    start: DateTime!
    end: DateTime!
    reps: Int!
}

type Query {
    agenda: [AgendaItem!]!
}
```

## Arguments

* Arguments can be added to any field in GraphQL.
* Just like a field, an argument must have a type - which can be scalar types or object types that are available in our schema. 

```
type Query {
    ...
    User(githubLogin: ID!): User! # mandatory argument
    Photo(category: PhotoCategory): [Photo!]! # optional argument
}
```

## Data Paging

* Used to control the number of records returned in query response

```
type Query {
    ...
    allUsers(first: Int=50 start: Int=0): [User!]!
    allPhotos(first: Int=25 start: Int=0): [Photo!]!
}
```

## Sorting

```
enum SortDirection {
    ASCENDING
    DESCENDING
}

enum SortablePhotoField {
    name
    description
    category
    created
}

Query {
    allPhotos(
        sort: SortDirection = DESCENDING
        sortBy: SortablePhotoField = created
    ): [Photo!]!
}
```

## Return Types

```
type AuthPayload {
    user: User!
    token: String!
}

type Mutation {
    ...
    githubAuth(code: String!): AuthPayload!
}
```

# References

* Books
    * O'Reilly Learning GraphQL
* [https://github.com/moonhighway/learning-graphql/](https://github.com/moonhighway/learning-graphql/)
* [https://www.graphqlworkshop.com/](https://www.graphqlworkshop.com/)
* [https://www.graphql.org/](https://www.graphql.org/)
* [GraphQL Python Examples](https://github.com/fizalihsan/graphql101)
* [GraphQL Java Examples](https://github.com/fizalihsan/graphql102)