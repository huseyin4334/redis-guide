# Pipeline
Redis is a single-threaded server, which means that it can only execute a single command at a time. This is a limitation that can be overcome by using the pipeline feature. A pipeline is a sequence of commands that are sent to the server in a single request, which allows the server to execute them in a single step. This can greatly improve the performance of your application, especially when you need to execute multiple commands in a row.

> https://redis.io/docs/latest/develop/use/pipelining/

---

To use the pipeline feature, you need to create a pipeline object using the `pipeline()` method of the Redis client. You can then use the pipeline object to queue up commands

```java
Jedis jedis = new Jedis("localhost");

Pipeline pipeline = jedis.pipelined();

pipeline.set("key1", "value1");
pipeline.set("key2", "value2");
pipeline.set("key3", "value3");

Response<String> response1 = pipeline.get("key1");

system.out.println(response1.get()); // null. Because the command has not been executed yet.

pipeline.sync();

system.out.println(response1.get()); // value1. The command has been executed now.
```

In the command above, we create a pipeline object using the `pipeline()` method of the `Jedis` client. We then queue up three `set` commands using the `set()` method of the pipeline object. We also queue up a `get` command using the `get()` method of the pipeline object, and store the response in a `Response` object. We then call the `sync()` method of the pipeline object to execute all the queued commands. Finally, we call the `get()` method of the `Response` object to get the result of the `get` command.

---

In the command line;

```python
# 1 milyon satırlık bir dosya oluşturma

dosya_adi = "redis_set_commands.txt"

# Open the file in write mode
with open(dosya_adi, "w", encoding="utf-8") as dosya:
    # Write 10 million lines to the file
    dosya.writelines([f'SET key{i} "key{i}" ex {1+(i%10)}\n' for i in range(1, 10_000_001)])

print(f"{dosya_adi} file has been created.")
```

```bash
python3 p.py

# or

awk 'BEGIN { for(i=1; i<=1000000; i++) print "SET key" i " \"key" i "\" ex " 1+(i%10) }' > redis_set_commands.txt

cat redis_set_commands.txt | redis-cli --pipe
```