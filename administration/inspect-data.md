# Object Keyword
- `OBJECT` is a keyword that is used with some ways;
	- `OBJECT ENCODING` is used to specify the encoding of the redis object.
	- `OBJECT FREQ` is used to specify the logarithmic access frequency counter of the object.
	- `OBJECT IDLETIME` is used to specify the number of seconds since the object stored in the database.
	- `OBJECT REFCOUNT` is used to specify the number of reference counts of the object.

## Object Encoding
- `OBJECT ENCODING key` is used to get the encoding of the object stored at the specified key.

> https://redis.io/docs/latest/commands/object-encoding/

```bash
SET key "Hello"

OBJECT ENCODING key
# Output: raw

SET key 100

object encoding key
# Output: int
```

## Reference Count
- `OBJECT REFCOUNT key` is used to get the reference count of the object stored at the specified key.
- This method useful for debugging purposes.
- The reference means some other keys are pointing to the same object. (WE can think like in java memory management)
- Because of that, the reference count is increased by 1 when a new key is created that points to the same object.

> https://redis.io/docs/latest/commands/object-refcount/

```bash
SET key "Hello"

OBJECT REFCOUNT key
# 1

set hello "Hello"
OBJECT REFCOUNT hello
# (Integer) 2147483647
# This turns different because this key is a system key. System keys have a reference count of 2147483647. Internally, Redis uses this value to represent the system key.
```

## Object IDLETIME
- `OBJECT IDLETIME key` is used to get the number of seconds since the object stored in the database. When we set a key again, the idle time is reset.

> https://redis.io/docs/latest/commands/object-idletime/

```bash
SET key "Hello"

OBJECT IDLETIME key
# 2
```


# Dump And Restore
- `DUMP key` is used to serialize the value stored at the specified key.
- `RESTORE key ttl serialized-value [REPLACE]` is used to restore the serialized value of the key.

> https://redis.io/docs/latest/commands/dump/

```bash
SET key "Hello"

DUMP key
# "\x00\x06Hello\x06
# This is a serialized value of the key. This value is original value of the key that is stored in the database.

restore key 0 "\x00\x06Hello\x06"
# If we have the key already exists, It will give an error. BUSYKEY Target key name already exists.
# If the key not exists, it will return OK.

restore key 0 "\x00\x06Hello\x06" REPLACE
# if the key exists, it will replace the value of the key with the serialized value.
# OK

GET key
# Hello
```

> This serialized value can be different in different versions of Redis. So, we can't use this value in different versions of Redis.


# Command History
- `MONITOR` is used to get the command history of the Redis server. This command works like a tail command in Linux. It will show the command history of the Redis server continuously. We can stop this command by pressing `Ctrl+C`. Also we can use telnet for stopping this command by sending a `Ctrl+C` signal with `QUIT` command.

Redis stores the command history in the `.rediscli_history` file. This file is located in the home directory of the user. It's a hidden file. Bcause of that, we can see it with `ls -lrta` command. `r` is used to list the files in reverse order. `t` is used to list the files by the time. `a` is used to list all files including hidden files. 

> https://redis.io/docs/latest/commands/monitor/

```bash
MONITOR


telnet localhost 6379
QUIT
```

# Populate Data
- `DEBUG POPULATE count` is used to populate the database with the specified number of keys. This command is useful for testing purposes.


# Redis-cli Command With Arguments
Redis-cli command can be used with arguments. We can use the `--help` option to get the help of the command. We can use the `--version` option to get the version of the command.

```bash
redis-cli --help

redis-cli --version
```

---

```bash
redis-cli --scan --pattern "key*"

redis-cli --scan --pattern "key*" --count 10

redis-cli --scan --pattern "key*" --count 10 --cursor 0 --type string

redis-cli --scan --pattern "key*" > keys.txt
```

---

Get all key and values from the Redis server and save them to the file.

```bash
redis-cli --scan --type > keys.txt

cat keys.txt | xargs -I {} redis-cli get {} > values.txt

paste keys.txt values.txt > keys-values.txt
```

---

Redis-cli with url.

`redis://[password@]host[:port][/db]`
- This managemment is default in the Redis 6.0.0 and later versions.
- `redis://` is the protocol. Redis will use this protocol to connect to the server.
- `password` is the password of the Redis server. If the server doesn't have a password, this part can be empty.
- `host` is the IP address or the hostname of the Redis server.
- `port` is the port number of the Redis server. The default port number is 6379.
- `db` is the database number of the Redis server. The default database number is 0.

```bash
redis-cli -u redis://localhost:6379
```