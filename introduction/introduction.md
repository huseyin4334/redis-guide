# Redis

Redis is a high-performance, in-memory key-value store that can be used as a database, cache, and message broker. It supports various data structures such as strings, hashes, lists, sets, and sorted sets. Redis is written in C and is known for its simplicity, speed, and flexibility.

We will use redis with docker in this notes.

## Installation
```bash
docker run -d --name redis -p 6379:6379 redis
```

## Usage
```bash
docker exec -it redis redis-cli
```

redis-cli is the Redis command line interface that allows you to interact with the Redis server.
When we run the above command, we will be connected to the Redis server and we can start running Redis commands. Then we are a connection to redis when we run the above command.

# Data Management

## Key-Value
Keys have to be unique and are used to store values. Redis supports various data structures such as strings, hashes, lists, sets, and sorted sets.

We will see nil when we try to get a key that does not exist. nil is a special value in Redis that means the key does not exist.

> All Commands: [https://redis.io/commands](https://redis.io/commands)

## Get and Set
```bash
SET key value
GET key
```

```bash
SET name "John Doe"
GET name
```

## Deleting Keys
```bash
DEL key or [keys]
```

```bash
DEL name
# It will return size of deleted key size (in this case 1)
```

### Asynchronous Delete
We can use `UNLINK` command to delete keys asynchronously. It will return OK immediately and it will continue to delete keys in the background.

```bash
UNLINK name
# It will return size of deleted key size (in this case 1)
```

## Check Key Existence
```bash
EXISTS key or [keys]
```

```bash
EXISTS name surname home
# It will size of existing keys (in this case 0. because we deleted name key)
```

## Expiration
Expiration will control with TTL (Time To Live) or PTTL (Time To Live in milliseconds). (`pttl`, `ttl`)
We can set expiration with `EXPIRE` or `PEXPIRE` commands or in the set command with `EX` or `PX` options.

When the key expired, we will see `-2` when execute `ttl` or `pttl` command.
When the key does not have an expiration, we will see `-1` when execute `ttl` or `pttl` command.
Other cases we will see the remaining time in seconds or milliseconds.

We can use `EXPIREAT` or `PEXPIREAT` commands to set expiration with a specific time.

```bash
SET name "John" EX 10
# It will expire in 10 seconds

SET surname "Doe" PX 10000

TTl name
# It will return remaining time in seconds

PTTL name
# It will return remaining time in milliseconds

EXPIREAT name 1631540400 # 2021-09-13 00:00:00 -> this is unix timestamp, 1631540400 is byte representation of this date

EXPIRE surname 10
# It will expire in 10 seconds

PEXPIRE surname 10000
# It will expire in 10 seconds, 10000 milliseconds
```

---

We can also remove the expiration with `PERSIST` command.

```bash
PERSIST name

TTl name
# It will return -1
```

### How is Handle Expiration
Redis can check the expiration of keys in two ways. One is active and the other is passive.
**Passive expiration** is the default behavior of Redis. It will check the expiration of keys when we try to access them. If the key is expired, it will be deleted.
**Active expiration** is the other way. It will check the expiration of keys in the background. Redis will control 10 times per second default. We can change this with `hz` configuration. It will test 20 random keys in each check. If more than 25% of the keys are expired, it will go on to the next check. If less than 25% of the keys are expired, it will wait for the next check.


## Keys And Scans
We can use `KEYS` or `SCAN` commands to find keys with a pattern. `KEYS` command is not recommended for production because it will block the server until it finds all keys. `SCAN` command is recommended for production because it will not block the server and it will return a cursor to continue the search.

`SCAN` command will return a cursor and keys. We can use this cursor to continue the search. We can use `MATCH` option to filter keys with a pattern. We can use `COUNT` option to limit the number of keys to return.

`SCAN <index> [MATCH <pattern>] [COUNT <count>]`
- index: cursor. 
  - When we start a scan execution, redis save a cursor. 
  - And It turns this cursor to us. We can use this cursor to continue the search.
  - When we set 0, it will start a new search.
  - We can continue the search until the cursor is 0.
  - When the cursor is 0, it means the search is completed.
- MATCH: pattern to filter keys
  - MATCH is apply after get the collection of keys. Because of that we can get empty result or unexpected size of keys.

```bash
# let's assume, we have keys like name1, name2, name3, surname1, surname2, surname3
SCAN 0 MATCH name* count 2
# It will return cursor and keys that start with name
```

```bash
keys name*
# It will return all keys that start with name
```

### Patterns
- `*` : any character or no character
- `?` : any character
- `[abc]` : a, b, or c
- `[a-z]` : a to z
- `[a-z0-9]` : a to z and 0 to 9
- `[^abc]` : not a, b, or c
- `[^a-z]` : not a to z

```bash
keys name? # name1, name2, name3 or any character

keys name[123] # name1, name2, name3

keys name[1-3] # name1, name2, name3

keys name[^123] # name4, name5, name6 or any character except 1, 2, 3

keys name* # name234, name2, name, ...
```

## Key Space
Key space is a namespace. Or schema like in a database. We can use `SELECT` command to switch between key spaces. When we switch to a key space, we will only see keys in that key space. Also if the key space is not available, Redis will create it.

> Every key unique in the namespaces. Not in the whole Redis server.

```bash
set name "John"
get name
# It will return John

SELECT 1

set name "Doe"
get name
# It will return Doe

SELECT 0
get name
# It will return John
```

## Flushdb and Flushall
We can use `FLUSHDB` command to delete all keys in the current key space.

```bash
FLUSHDB
# It will return OK
```

## Naming Conventions
We should keep it simple but robust to be unique.
`Object-id:field` is a good example. `user:1:name`, `user:1:surname`, `user:1:email`

The maximum key size is 512 MB.
Redis keys are binary safe. We can use any binary data as a key.
Empty string is a valid key.


## Saving Keys
Let's assume, we `set` some keys. We should know that redis opened a temporary save. So if we shutdown the server without saving, we will lose all setted keys in this connection.

Let's assume we have 2 redis connections (redis-cli).
- In the first connection, we set some keys.
- When we try to get these keys in the second connection, we will see values.
- If we shutdown the server from any connection without saving (`shutdown nosave`), we will lose all keys from the all connections.
- But if we did `save` or `bgsave` before shutdown, we will not lose any keys. Or we can use `shutdown save` to save and shutdown the server.


## Rename Keys

We can use `RENAME` command to rename a key. If the new key is already exists, it will overwrite the value.

```bash
SET name "John"
RENAME name firstname

set name "Doe"
set surname "Doee"

RENAME name surname

GET name
# It will return nil
GET surname
# It will return Doe
```

---

Also, we can use `RENAMENX` command to rename a key if the new key is not exists. If the key exists, it will not rename the key.

```bash
SET name "John"
RENAMENX name firstname

set name "Doe"
set surname "Doee"

RENAMENX name surname
# It will return 0

GET name
# It will return Doe
GET surname
# It will return Doee
```


## Find Key Data Type
We can use `TYPE` command to find the data type of a key.

```bash
SET name "John"
TYPE name
# It will return string

HSET user:1 name "John"
TYPE user:1
# It will return hash

LPUSH names "John" "Doe" "Jane"
TYPE names
# It will return list
```