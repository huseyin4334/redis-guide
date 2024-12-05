# What is Lua?
Lua is a powerful, efficient, lightweight, embeddable scripting language. It supports procedural programming, object-oriented programming, functional programming, data-driven programming, and data description.

Lua combines simple procedural syntax with powerful data description constructs based on associative arrays and extensible semantics. Lua is dynamically typed, runs by interpreting bytecode for a register-based virtual machine, and has automatic memory management with incremental garbage collection, making it ideal for configuration, scripting, and rapid prototyping.

**LUA IS PROGRAMING LANGUAGE**

# Why Lua in Redis?
Redis uses Lua for its server-side scripting. Server-side scripting means that we can execute Lua scripts on the Redis server. This is a powerful feature that allows us to execute complex operations on the server without having to make multiple round trips to the server.

# Installing Lua
```bash
curl -R -O http://www.lua.org/ftp/lua-5.4.3.tar.gz

tar zxf lua-5.4.3.tar.gz

cd lua-5.4.3

sudo make all
```

# Eval Command And Lua Script
The `EVAL` command is used to evaluate scripts using the Lua interpreter built into Redis. The `EVAL` command takes the following arguments:
- The Lua script to evaluate.
- The number of keys in the keys array. Other sets of passed values will be arguments.
- The arguments to pass to the script.
- `KEYS` and `ARGV` are two special variables that are used to pass arguments to the script.

How the script distiguishes between `KEYS` and `ARGV` when we set them in the `EVAL` command?

`EVAL <script> <numkeys> [key [key ...]] [arg [arg ...]]`


```bash
redis-cli

EVAL "return 'Hello, World!'" 0

EVAL "return {KEYS[1],KEYS[2],ARGV[1],ARGV[2], ARGV[3],ARGV[4]}" 2 keya keyb first second third fourth
```

---

Inside of the script, we can access to the redis with the `redis.call` and `redis.pcall` functions. The `redis.call` function is used to call Redis commands from Lua scripts. The `redis.pcall` function is used to call Redis commands from Lua scripts and catch any errors that occur.

```bash
redis-cli

EVAL "return redis.call('get', 'keya')" 1

EVAL "return redis.call('set', 'keyc', 'valuec')" 0

EVAL "return redis.pcall('set', 'keyd', 'valued')" 0
```