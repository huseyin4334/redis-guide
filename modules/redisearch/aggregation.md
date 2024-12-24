# Aggregation Queries
We will use `FT.AGGREGATE` command for aggregation queries. This command is used to perform aggregation queries on the search results. 
We can use this command to perform aggregation queries like `GROUP BY`, `COUNT`, `SUM`, `MIN`, `MAX`, `AVG`, etc.

The main idea is that we can use this for grouping, reducing, sorting, and transforming the search results.

> [Document](https://redis.io/docs/latest/commands/ft.aggregate/)

Required arguments same with the `FT.SEARCH` command;
- `index_name`: Name of the index
- `query`: Query string. We can use the query string for the full-text search. We can use the query string for the filtering. We can use the query string for the sorting, ...

---

The important flags for the aggregation queries;
- `LOAD`: Load the fields of the documents. We can use this flag for the projection.
  - It's same with the `RETURN` flag in the `FT.SEARCH` command.
- `GROUPBY`: Group the results by fields. (argumentsize and [fields...])
  - Redisearch groups the results by the given fields.
- `REDUCE`: Reduce the results by the given reducer. (argumentsize and [reducer...])
  - Every reduce function works with the grouped results.
  - We can create multiple groups. Also we can reduce the results by the multiple reducers.
  - We can use the `COUNT`, `SUM`, `MIN`, `MAX`, `AVG`, `STDDEV`, `STDDEVPOP`, `VAR`, `VARPOP` reducers.
- `APPLY`: Apply the given transformation to the results. (argumentsize and [transform...])
  - We can use the `APPLY` flag for the transformation of the results and set the alias for the transformed results.
- `SORTBY`: Sort the results by a field.
  - `ASC` or `DESC` can be used for the sorting order.
- `LIMIT`: Limit the number of the results.
- `FILTER`: Filter the results by the given expression.
  - Filters works after the `GROUPBY` and `REDUCE` flags. It's like a `HAVING` clause in the SQL.
  
> GROUPBY, SORTBY, REDUCE gets argumentsize. The argumentsize is the number of the fields that will be used in the operation.

These definitions works with order:
1. `LOAD`
2. `GROUPBY`
3. `REDUCE`
4. `APPLY`
5. `SORTBY`
6. `LIMIT`
7. `FILTER`

---

movie_name / category / rating / votes / release_year / plot / poster / imdb_id

`FT.AGGREGATE movies LOAD 3 @category @rating @votes`

category / rating / votes

`GROUPBY 1 @category REDUCE COUNT 0 AS total_movies REDUCE SUM 1 @votes AS total_votes`

category / total_movies / total_votes (if we don't give name for the reduced field, it will return as `__generated_alias<function_name>`)

`SORTBY 2 @total_movies DESC`

category / total_movies / total_votes

`LIMIT 0 5` (100 categories grouped)

First 5 categories with the most movies will be listed. And We will get offset value for continue the listing.

---

We will use imdb dataset for the examples. We will use the `movies` index for the examples.


```bash

FT.AGGREGATE movies LOAD 3 @category @rating @votes GROUPBY 1 @category REDUCE COUNT 0 AS total_movies REDUCE SUM 1 @votes AS total_votes SORTBY 2 @total_movies DESC LIMIT 0 5

```


---

Let's use the `APPLY` flag for the transformation of the results. Apply uses for create new fields from the existing fields. 
For example we want to get total votes per movie. It can execute before group by or after group by. 


We have lots of functions for the transformation. [Expressions](https://redis.io/docs/latest/develop/interact/search-and-query/advanced-concepts/aggregations/#apply-expressions)

Execute after group by;

```bash
FT.AGGREGATE movies LOAD 3 @category @rating @votes GROUPBY 1 @category REDUCE COUNT 0 AS total_movies_by_category REDUCE SUM 1 @votes AS total_votes_by_category APPLY @total_votes_by_category / @total_movies_by_category AS avg_votes_per_movie SORTBY 2 @total_movies_by_category DESC LIMIT 0 5
```

category / total_movies_by_category / total_votes_by_category / avg_votes_per_movie

Execute before group by;

```bash
FT.AGGREGATE movies LOAD 3 @category @rating @votes APPLY @votes / @rating AS votes_per_rating GROUPBY 1 @category REDUCE COUNT 0 AS total_movies_by_category REDUCE SUM 1 @votes AS total_votes_by_category
```

category / total_movies_by_category / total_votes_by_category


---

Let's use the `FILTER` flag for the filtering of the results. Filter uses for filtering the results after the `GROUPBY` and `REDUCE` flags.	

Find female users from the `users` index. Group by the country except for China. After that, filter the results by the count of the female users.

```bash
ft.aggregate idx:user "@gender:{female}" groupby 1 @country reduce count 0 as count_females filter "@country !='china' && @count_females > 100" sortby 2 @count_females DESC
```

country / count_females

