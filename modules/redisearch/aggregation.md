# Aggregation Queries
We will use `FT.AGGREGATE` command for aggregation queries. This command is used to perform aggregation queries on the search results. We can use this command to perform aggregation queries like `GROUP BY`, `COUNT`, `SUM`, `MIN`, `MAX`, `AVG`, etc.

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

---

Example;
```bash

```