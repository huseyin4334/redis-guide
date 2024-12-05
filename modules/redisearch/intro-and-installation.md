# Redisearch Module
The Redisearch module is a powerful tool that allows you to perform complex search queries on your Redis data. 
It is built on top of the RediSearch engine, which is a full-text search engine that is designed to work with Redis. 
The Redisearch module provides a simple and efficient way to perform full-text search queries on your Redis data, and it is designed to be easy to use and integrate with your existing Redis applications.

Redisearch provides;
- Secondary indexing
  - Indexing of fields in documents
- Full-text search (prefix, fuzzy, phonetic, stemming, etc.)
  - Searching for documents based on the content of the fields
- Incremental indexing
  - This allows you to index new documents without reindexing the entire dataset
- Multi-field queries
  - Searching for documents based on multiple fields
- AND/OR/NOT queries
  - Combining multiple conditions in a single query
- Numeric filtering and range queries
  - Filtering documents based on numeric values
- Data Aggregation
  - Aggregating data based on certain fields
- Auto-complete
  - Providing auto-complete suggestions based on the content of the fields
- Geo indexing and filtering
  - Indexing and searching for documents based on geographic coordinates

# Installation
We have 3 way to install Redisearch module;
- Building from source
- Using Docker with redisearch image
- Using Docker with redis-stack-server image

Redis stack server is a docker image that includes Redis, Redisearch, and RedisInsight and other additional modules.

> **redis/redis-stack** contains both Redis Stack server and RedisInsight. This container is best for local development because you can use RedisInsight to visualize your data.
> **redis/redis-stack-server** provides Redis Stack but excludes RedisInsight. This container is best for production deployment.

> https://hub.docker.com/r/redis/redis-stack
> https://redis.io/blog/introducing-redis-stack/


```bash

docker run -d --name redisearch -p 6379:6379 redislabs/redisearch:latest

# In logs we will see some additional information about the Redisearch module
# <search> Low level api version 1 initialized successfully  (using 1 threads)
# <search> concurrent writes: off, gc: on, prefix min length: 2, prefix max expansions: 200, query timeout (ms): 500, timeout policy: return, 
# cursor read size: 1000, cursor max idle (ms): 300000, max doctable size: 1000000, search pool size: 1, index pool size: 1,
# <search> Initialized thread pool!
# Module 'search' loaded from /usr/lib/redis/modules/redisearch.so
```

> In default; redis put modules in /usr/lib/redis/modules/ directory. If you want to change this directory, you can use `loadmodule` command in redis.conf file.
> Thread pool size can be changed with `FT.CONFIG SET NUMERIC_THREAD` command. Thread pool uses for parallel indexing and searching.
> We will speak other configurations in the next sections.
> Low level api version is the version of the RediSearch engine. It is used for the communication between Redis and RediSearch engine. It created 1 thread for this communication for now.


# Data
We will use imd movie dataset.

Movie Dataset Properties;
- movie_id
- movie_name
- plot
- category
- release_date
- rating
- poster
- imdb_id

Data Structure; (Business Model)
- movies
- actors
- theaters
- users

Key Names;
- <business_name>:<key>
- movie:1
- actor:1


> We can use hash or json data structure for storing data. We will use hash data structure for this example.
> We will apply json data structure in the next examples.

In the has topology;
- movie:1
  - movie_id: 1
  - movie_name: The Shawshank Redemption
  - plot: Two imprisoned
  - category: Drama
  - release_date: 1994
  - rating: 9.3
  - poster: https://www.imdb.com/title/tt0111161/
  - imdb_id: tt0111161