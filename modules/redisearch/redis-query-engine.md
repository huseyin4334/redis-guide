# Redis Query Engine
Redis Query Engine is an infrastructure that provides traditional data query features to Redis. Redisearch is a module that uses Redis Query Engine to provide full-text search capabilities. 

Now we will look at the Redis Query Engine for use it in Redisearch module.

## Redis Query Engine Commands (FT.<command>)
Redis Query Engine provides a set of commands that can be used to query data in Redis. 
These commands are prefixed with `FT.`. Here are some of the commands provided by Redis Query Engine.

- `FT.CREATE` - Create a new index
- `FT.ADD` - Add a new document to an index
- `FT.SEARCH` - Search the index
- `FT.AGGREGATE` - Aggregate the search results
- `FT.EXPLAIN` - Explain the query execution plan
- `FT.DROP` - Drop an index
- `FT.ALTER` - Alter an index

> https://redis.io/docs/latest/commands/?group=search


## Create Index
To create an index, we need to use the `FT.CREATE` command.

When we create an index in redis, redis creates a new data structure for the index. This data structure is a hash table that contains the indexed values and their corresponding document ids. When we search from a field, redis look at the index and find matching document ids. Then it gets the documents from the main data structure.


Required arguments;
- `index_name`: Name of the index
- `SCHEMA`: Schema of the index. This is a list of fields with their types. Supported types: `TEXT`, `NUMERIC`, `TAG`, `GEO`, ...
  - Schema fileds have some options;
    - NUMERIC, TAG, TEXT, or GEO attributes can have an optional `SORTABLE` flag. This flag allows sorting by the attribute (clustered index).
    - `NOINDEX` uses for not indexing the field. We are telling the redis with this flag that we will get this field in results but we won't search with this field. Because of that, don't index this field.
    - CASESENSITIVE uses for case-sensitive search.
    - `WEIGHT` uses for the declares the importance of this field when calculating accuracy. The default weight is 1. Only used for the `TEXT` fields.
    - ...

Optional arguments;
`FILTER`: Filter keyword uses for filtering the data with a query. This query is used to index that which documents will be indexed. Document will find with prefix first. After that, filter works for the detailed search. 
- `ON`: Suppoorted structures: HASH, JSON (`ON HASH` or `ON JSON`)
- `PREFIX`: Prefix have 2 values; `count` and `prefix`. count is number of the key prefixes. prefix get key prefixes. This is used for the prefix search.
  - `PREFIX 2 "movie:" "category:"` - This will index the keys that start with `movie:` and `category:`.


```bash
FT.CREATE idx:movies SCHEMA movie_id NUMERIC SORTABLE movie_name TEXT SORTABLE plot TEXT category TAG SORTABLE release_date NUMERIC rating NUMERIC SORTABLE poster TEXT NOINDEX imdb_id TEXT
```

> `TAG` type is used for the fields that have multiple values. For example, a movie can have multiple categories. In this case, we can use the `TAG` type for the `category` field.

> `SORTABLE` flag is used for the fields that we want to sort by. When we create index with `SORTABLE` flag, redis will get matched documents but it won't search all index. For example, we used `SORTABLE` flag for rating field. And we search rating between 5 and 10. It will start to search from 5 to 10. It won't search all index.



## Query Data
We can query data with the `FT.SEARCH` command. It have so many options for the search. We can search with the fields, we can sort the results, we can filter the results, we can get the results with pagination, we can get the results with the aggregation, ...

it have 2 required arguments;
- `index_name`: Name of the index
- `query`: Query string. We can use the query string for the full-text search. We can use the query string for the filtering. We can use the query string for the sorting, ...

> For quering: https://redis.io/docs/latest/develop/interact/search-and-query/query/


### Query Syntax

> [Syntax](https://redis.io/docs/latest/develop/interact/search-and-query/advanced-concepts/query_syntax/)

WE have 3 option for the query;
- **Selection:** A selection allows you to return all documents that fulfill specific criteria.
- **Projection:** Projections are used to return specific fields of the result set. You can also map/project to calculated field values.
- **Aggregation:** Aggregations collect and summarize data across several fields.

> We will use the `FT.SEARCH` command for selection and projection. We can use the `FT.AGGREGATE` command for the aggregation.

Some important flags for the query;
- `LIMIT`: Limit the number of results.
  - It works with offset and count. `LIMIT offset count` (Depriacted: `LIMIT count offset` with dialect 2)
- `SORTBY`: Sort the results by a field.
  - `ASC` or `DESC` can be used for the sorting order.
- `DIALECT`: Dialect is used for the query syntax. We can use the `REDIS` or `REDBOX` dialects.
- `NOCONTENT`: If we don't want to get the content of the documents, we can use this flag. It will return only the document ids.
- `RETURN`: Return the fields of the documents. We can use this flag for the projection.

In filtering;
- `@` is used for the field name.
- `{}` is used for the exact match for the tag fields.
  - If we have short text, tag fields can be more memory efficient than the text fields.
  - Because in tag field, we just search the exact match. But in the text field, we search the full-text search.
- `[]` is used for the range. In default if we don't set `(` the setted value is included in the range.
  - `@rating:[8 10]` - Rating can be 8, 9, or 10.
  - `@rating:[(8 10]` - Rating can be 9 or 10.
  - `@rating:[(8 (10]` - Rating can be just 9.
- `+inf` is used for the infinity.
- `-inf` is used for the negative infinity.
- `""` is used for the full-text search. (It means that the given value is in the text)
  - `@movie_name:"The*"` - Movie name starts with `The`.
- `|` is used for the OR operator.
- `-` is used to NOT operator.
  - `-@rating:[8 10]` - Rating can't be between 8 and 10.
- `==` is used for the equal operator. (Only for the numeric fields)
  - It's same with the `@rating:[8]`

Fuzzy search filter characters;
- `%<value>%` is used for the wildcard character. (It means that the given character can be any character)
  - This means Levanstein distance size. We can set this character for the how many character can be changed, deleted, or inserted.
  - Levanstein distance is the number of single-character edits (insertions, deletions, or substitutions) required to change one word into the other.
  - This character can be max 3 times in a search term.
  - `@movie_name:%Avtar%` 
    - When i set just 1 `%` character, it will tolarate 1 character. So it will find the `Avatar` movie.
  - `@movie_name:%%Avtir%%` 
    - When i set 2 `%` character, it will tolarate 2 character. So it will find the `Avatar` movie.

---

Selection;

`select * from movies where category = 'Action' and rating > 8`

```bash
FT.SEARCH idx:movies "@category:{Action} @rating:[8 +inf]"
```

`select movie_name, rating from movies where category = 'Action' or category = 'Drama'`

```bash
FT.SEARCH idx:movies "@category:{Action|Drama}"
```

`select * from movies where url = 'Action' or movie_name = 'Action'`

```bash
FT.SEARCH idx:movies "@url|movie_name:Action"
```

---

Projection;

`select movie_name, rating from movies where category = 'Action' and rating > 8`

```bash
FT.SEARCH idx:movies "@category:{Action} @rating:[8 +inf]" RETURN 2 __key movie_name rating
```

> `__key` field is a special field. It contains the key of the document. We can use this field for the projection.



#### Example

Paginate data;

```bash
FT.SEARCH idx:movies "@category:{Action}" LIMIT 0 10
```

---

Sort data;

```bash
FT.SEARCH idx:movies "@category:{Action}" SORTBY rating DESC
```

---

Full-text search; (`TEXT` type fields)

```bash
FT.SEARCH idx:movies "@movie_name:The*" LIMIT 0 10

FT.SEARCH idx:movies "@plot:love" LIMIT 0 10
```

**A fuzzy search allows you to find documents with words that approximately match your search term.**

```bash
FT.SEARCH idx:movies "@movie_name:%Avtar%" LIMIT 0 10
```

---

Get Total Number of Results;

```bash
FT.SEARCH idx:movies * limit 0 0
```

## Add, Update, Delete Document And Index
When we add a document to indexable data, Redis creates a new document in the index. 
When we update a document, Redis updates the document in the index. 
When we delete a document, Redis deletes the document from the index.

Expiration time can be set for the documents. When the expiration time is reached, the document will be deleted from redis and the index.


## How Manage Indexes (List, Drop, Alter, Info)
We can list all indexes with the `FT._LIST` command.

```bash
FT._LIST
```

---

We can get the information of an index with the `FT.INFO` command.

```bash
FT.INFO idx:movies
```

---

We can drop an index with the `FT.DROPINDEX` command.

```bash
FT.DROPINDEX idx:movies
```

---

We can add new schema fields an existing index with the `FT.ALTER` command.

```bash
FT.ALTER idx:movies SCHEMA ADD new_field TEXT
```

