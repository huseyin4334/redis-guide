# Redis Modules
Redis modules make it possible to extend Redis functionality using external modules, rapidly implementing new Redis commands with features similar to what can be done inside the core itself.

- search,
- real-time inventory monitoring,
- analytics,
- gaming, and more.

> https://redis.io/modules

When we create redis instance, we can find the module files in `/usr/lib/redis/modules/` directory.

```bash
ls /usr/lib/redis/modules/ -l
# -rw-r--r-- 1 root root  1139200 Mar  4  2021 redisearch.so
# -rw-r--r-- 1 root root   292000 Mar  4  2021 redistimeseries.so
# -rw-r--r-- 1 root root  1139200 Mar  4  2021 redisjson.so
# -rw-r--r-- 1 root root  1139200 Mar  4  2021 redisbloom.so
# -rw-r--r-- 1 root root  1139200 Mar  4  2021 redisgears.so
# -rw-r--r-- 1 root root  1139200 Mar  4  2021 redisai.so

module load /usr/lib/redis/modules/redisjson.so
```