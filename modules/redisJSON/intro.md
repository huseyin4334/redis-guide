# RediJSON
RediJSON is a Redis module that provides native JSON capabilities to Redis. It allows you to store, update, and retrieve JSON values in a Redis database, enabling you to work with JSON data structures directly within Redis. With ReJSON, you can perform complex operations on JSON documents, such as nested updates and queries, while benefiting from Redis's high performance and scalability.

## Why Choose RediJSON Over Redis Hashes
1. **Nested Data Structures**: RediJSON supports nested data structures, allowing you to store and query complex JSON documents. Redis Hashes, on the other hand, are flat and do not support nested data.
2. **Schema Flexibility**: With RediJSON, you can store data without a predefined schema, making it easier to handle dynamic and evolving data models. Redis Hashes require a more rigid structure.
3. **Rich Querying**: RediJSON provides advanced querying capabilities, including support for JSONPath queries, which are not available with Redis Hashes.
4. **Atomic Operations**: RediJSON supports atomic operations on JSON documents, ensuring data consistency and integrity during updates.
5. **Integration with RediSearch**: RediJSON can be seamlessly integrated with RediSearch, enabling powerful search and indexing capabilities on JSON documents.

By choosing RediJSON, you can leverage the flexibility and power of JSON data structures while still benefiting from the performance and scalability of Redis.


## Commands

Json module like other modules that provide commands to interact with the data. These commands start with `JSON.` prefix. 

> https://redis.io/docs/latest/commands/?group=json

---
Accessing the JSON values;
- `.`: Access the key in the JSON object.
- `$.`: Access the key in the JSON object.
- `$..`: Access all the keys in the JSON object.
- `$[*]`: Access all the elements in the JSON array.
- `$.[0]`: Access the first element in the JSON array.
  - `<key_name> [<index>].<key>`: Access the element in the JSON array.

We can access to keys with `.` or `$.`. For example, `JSON.GET user .name` and `JSON.GET user $.name` are the same.
Also when we call `$..name` it means all the name fields in the JSON object.

### JSON.SET, JSON.GET, JSON.MSET, JSON.MGET
JSON.SET command is used to set a JSON value in the Redis key. The key is created if it does not exist. If the key already exists, the value is overwritten. The JSON value can be a JSON object, array, string, number, or boolean.

JSON.GET command is used to get the JSON value stored in the Redis key.

We can do multiple set and get operations using JSON.MSET and JSON.MGET commands.

```bash
# Set a JSON value in the Redis key
JSON.SET user .name "John"
# or
JSON.SET user . '{"name": "John"}'

JSON.SET user address '{"city": "New York", "zip": 10001}'

# Get the JSON value stored in the Redis key
JSON.GET user

# Set multiple JSON values in the Redis keys
JSON.MSET user1 name "Alice" user2 name "Bob"

redis --raw JSON.MGET user1 user2
# 1) {"name":"Alice"}
# 2) {"name":"Bob"}

JSON.TYPE user1
# object

JSON.TYPE user .name
# string

JSON.SET user .score 100
```

### JSON.STRLEN, JSON.STRAPPEND
JSON.STRLEN command is used to get the length of the JSON string value stored in the Redis key. (Value should be a string)

JSON.STRAPPEND command is used to append a string to the JSON string value stored in the Redis key.

```bash
JSON.STRLEN user .name
# 8

JSON.STRAPPEND user .name " Doe"

JSON.GET user .name
# "John Doe"
```

### JSON.OBJLEN, JSON.OBJKEYS
JSON.OBJLEN command is used to get the number of keys in the JSON object stored in the Redis key.

JSON.OBJKEYS command is used to get the keys of the JSON object stored in the Redis key.

```bash
JSON.OBJLEN user
# 3 (name, address, score)

JSON.OBJKEYS user
# 1) "name"
# 2) "address"
# 3) "score"
```

### Atomic Operations
We can perform some atomic operations on JSON values without fetching the all JSON.

#### Number Operations (JSON.NUMINCRBY, JSON.NUMMULTBY)

```bash
JSON.NUMINCRBY user .score 10
# 110

JSON.NUMMULTBY user .score 2
# 220

JSON.NUMINCRBY user .score -20
# 200

JSON.SET doc . '{"a":"b","b":[{"a":2}, {"a":5}, {"a":"c"}]}'

JSON.NUMINCRBY doc $..a 10
# "[null,12,15,null]"
```

#### Array Operations (JSON.ARRAPPEND, JSON.ARRLEN, JSON.ARRINDEX, JSON.ARRINSERT, JSON.ARRPOP, JSON.ARRTRIM)

```bash
JSON.ARRAPPEND user .hobbies "reading"
JSON.ARRAPPEND user .hobbies "swimming"

JSON.ARRLEN user .hobbies
# 2

JSON.ARRINDEX user .hobbies "swimming"
# 1

JSON.ARRINSERT user .hobbies 1 "coding"
# OK

JSON.ARRPOP user .hobbies 1
# "coding"

JSON.ARRPOP user .hobbies 10
# -1

JSON.ARRTRIM user .hobbies 0 1
```

### JSON.DEL
JSON.DEL command is used to delete the JSON value stored in the Redis key.

```bash
JSON.DEL user .name
```

### JSON.DEBUG MEMORY
JSON.DEBUG MEMORY command is used to get the memory usage of the JSON value stored in the Redis key.

```bash
JSON.DEBUG MEMORY user
```