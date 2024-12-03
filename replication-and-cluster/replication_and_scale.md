# Replication and Scale Methodology In Redis
Redis provide a way to replicate data across multiple Redis instances. This is useful for read scaling, failover, and data redundancy. Redis replication is a very simple to use and configure. It is also very fast and reliable. Redis replication is based on the master-slave model. In this model, there is one master and multiple slaves.

Master is the primary Redis instance that accepts write operations. Slave is the secondary Redis instance that **replicates** data from the master. Slave can also accept read operations. Redis replication is asynchronous. This means that the master does not wait for the slave to acknowledge the write operation. 

---

Let's build a master-slave cluster with 1 master.

> [Docker Compose File](/replication-and-cluster/docker-compose.yml)

- rdb format is used to save data in a file. It is a binary file format that Redis uses to save data. (https://redis.io/topics/persistence)
- Normally every redis server starts in master mode. We can see it by running the following command: info replication
- We can change the mode of the server to slave inside of the server by running the following command: `slaveof <master-ip> <master-port>`
- We can also change the mode of the server to slave by running the following command: `redis-server --slaveof <master-ip> <master-port>`
- After slave connected to the master, we can see the connected slave count in master: `info replication` (connected_slaves)

> `replicaof <master-ip> <master-port>` is the new command to change the mode of the server to slave. It is the same as `slaveof <master-ip> <master-port>`

Also, slaves have master information in the `info replication` command. We can see the master information in the slaves.

---

Important some information about replication:
`master_repl_offset`:
- In the master, shows where the master is in the replication stream. (It shows the which byte the master is in the replication stream)
- In the slave, shows where the slave is in the replication stream. (It shows the which byte the slave is in the replication stream)

But these numbers different from each other. Because the master sends the data to the slave asynchronously. So the slave may not receive the data that the master has sent. This is why the `master_repl_offset` of the master and the slave are different.


> When the slave connects to the master, slave flushes all the data in the memory and gets the data from the master. We can see this from logs.


# Important Redis Info Keys
- **SERVER**
  - **redis_version**: Redis version
  - **redis_mode**: Redis mode (master, slave, sentinel, cluster)
  - **process_id**: Process ID of the Redis server in the system (PID in linux)
  - **run_id**: A unique identifier for the Redis server. It uses to identify the Redis server in a Redis Cluster.
  - **tcp_port**: TCP port number that Redis server listens on.
  - **executable**: Path to the Redis server executable.
  - **config_file**: Path to the Redis server configuration file. (redis.conf) We can change the configuration of the Redis server by changing this file.
  - **io_threads_active**: Number of active I/O threads in the Redis server. Redis uses I/O threads to handle I/O operations asynchronously.
- **CLIENTS**
  - **connected_clients**: Number of clients connected to the Redis server.
  - **maxclients**: Maximum number of clients that can connect to the Redis server.
  - **client_recent_max_input_buffer**: Maximum input buffer size of the Redis server. Input buffer is used to store the data received from the clients. 48 bytes per client connection.
- **Memory**
  - **used_memory**: Total memory used by the Redis server. (in bytes)
  - **used_memory_human**: Total memory used by the Redis server in human-readable format.
  - **used_memory_rss**: Total memory used by the Redis server including the memory used by the operating system. (in bytes)
  - **used_memory_peak**: Peak memory usage of the Redis server. Peak memory usage is the maximum memory used by the Redis server since it started.
  - **used_memory_overhead**: Memory used by the Redis server for internal overheads. (in bytes)
  - **used_memory_dataset**: Memory used by the Redis server to store the dataset. Dataset is the actual data stored in the Redis server.
  - **allocator_allocated**: Memory allocated by the Redis server's allocator. Redis uses jemalloc as the default allocator.
  - **used_memory_lua**: Memory used by the Lua engine in the Redis server. Lua engine is used to run Lua scripts in Redis.
  - **maxmemory**: Maximum memory that the Redis server can use. If this value is 0, the Redis server can use unlimited memory.
  - **maxmemory_policy**: Policy used by the Redis server to evict keys when it reaches the maximum memory limit.
  - **active_defrag_running**: Indicates whether the active defragmentation is running in the Redis server.
    - Fragmentation is seperating the data physically and store it different places. 
    - Defragmentation is combining the data physically and store it in the same place.
- **PERSISTENCE**
  - **loading**: Indicates whether the Redis server is loading data from the disk in the actual moment. (Dumping data from the disk to the memory, or loading data from the memory to the disk)
  - **current_cow_size**: Current copy-on-write memory usage of the Redis server. Copy-on-write is a technique used to reduce memory usage when forking a process.
    - First, we should understand what is forking a process. Forking a process is creating a child process from a parent process. The child process is an exact copy of the parent process. When the child process writes to a memory page, the operating system creates a copy of the memory page for the child process (only 1 page creates that the child process write. Not all memory). This is called copy-on-write.
    - After that, if child process try to save the changes operating system will save the changes in this cow memory.
  - **rdb_bgsave_in_progress**: Indicates whether the Redis server is saving data to the disk in the background.
  - **rdb_last_bgsave_status**: Status of the last background save operation. (ok, error)
  - **aof_enabled**: Indicates whether the append-only file (AOF) is enabled in the Redis server.
    - AOF is a persistence mechanism used by Redis to save data to the disk. We can enable AOF by setting the appendonly configuration option to yes in the Redis configuration file. We can look at persistence page of redis website.
- **STATS**
  - **total_connections_received**: Total number of connections accepted by the Redis server.
  - **total_commands_processed**: Total number of commands processed by the Redis server.
  - **total_net_input_bytes**: Total number of bytes received by the Redis server.
  - **total_net_output_bytes**: Total number of bytes sent by the Redis server.
  - **sync_full**: Number of full synchronization operations performed by the Redis server. Full synchronization is the process of copying the entire dataset from the master to the slave.
  - **expired_keys**: Number of keys expired by the Redis server.
  - **evicted_keys**: Number of keys evicted by the Redis server.
    - Eviction is the process of removing keys from the Redis server when it reaches the maximum memory limit.
  - **keyspace_hits**: Number of successful key lookups by the Redis server. Key lookup is the process of finding a key in the Redis server.
  - **pubsub_channels**: Number of pub/sub channels in the Redis server.
  - **pubsub_patterns**: Number of pub/sub patterns in the Redis server. Pub/sub patterns are used to subscribe to multiple channels at once.
  - **latest_fork_usec**: Duration of the latest fork operation in the Redis server. Fork operation is the process of creating a child process in Redis.
- **REPLICATION**
  - **role**: Role of the Redis server in the replication. (master, slave)
  - **connected_slaves**: Number of slaves connected to the Redis server.
  - **salve0**: Information about the first slave connected to the Redis server.
  - **master_failover_state**: When the master redis server is down, the new master is selected by the sentinel. 
    - In this situation, we have some states until the new master is selected. Default is no-failover. (no-failover, wait-for-sync, in-progress, failover-complete, failover-abort). 
    - no-failover means that the master is up and running.
    - wait-for-sync: The master is down and the sentinel is waiting for the slave to sync with the master.
    - in-progress: The master is down and the slave is syncing with the master.
    - failover-complete: The new master is selected and the failover is completed.
  - **repl_backlog_active**: Replication backlog is a buffer that stores the replication data in the Redis server.
    - Master node stores the replication data in the replication backlog until the slave node reads it. 
    - It's like a publish-subscribe mechanism. Slave node reads the data from the replication backlog and applies it to the dataset. 
    - Maybe the slave node is down and when it comes up, it reads the data from the replication backlog where it left off.
  - **repl_backlog_size**: Size of the replication backlog in the Redis server.
- **ErrorStats**
  - **errorstat_ERR:count**: Number of errors with the ERR error code.
- **Cluster**
  - **cluster_enabled**: Indicates whether the Redis server is part of a Redis Cluster. Redis cluster is a distributed system that allows you to shard data across multiple Redis instances. We can connect master and slaves to each other. But the cluster is different. In the cluster, we will have multiple masters and slaves.
- **Keyspace**
  - **db0**: Information about the first database in the Redis server. (db1, db2, db3, ...)
    - **keys**: Number of keys in the database.
    - **expires**: Number of keys with an expiration time set in the database.
    - **avg_ttl**: Average time-to-live of the keys in the database. Time-to-live is the time remaining before the key expires.


# ROLE Command And Redis Modes
- **ROLE Command**: The ROLE command is used to get the role of the Redis server in the replication. The ROLE command returns the role of the Redis server as a single line reply. The possible roles are master, slave, and sentinel.
  - If the Redis server is a master, the ROLE command returns master.
  - If the Redis server is a slave, the ROLE command returns slave.
  - If the Redis server is a sentinel, the ROLE command returns sentinel.

- **Redis Modes**: Redis can run in different modes. The mode of the Redis server is determined by the configuration of the Redis server. The possible modes are master, slave, sentinel, and cluster.
  - **Master**: In the master mode, the Redis server is the primary server that accepts write operations. The master server can have multiple slaves
  - **Slave**: In the slave mode, the Redis server is the secondary server that replicates data from the master server. The slave server can accept read operations.
  - **Sentinel**: In the sentinel mode, the Redis server is a monitoring server that monitors the master and slave servers. The sentinel server can perform automatic failover when the master server is down.
  - **Cluster**: In the cluster mode, the Redis server is part of a Redis Cluster. Redis Cluster is a distributed system that allows you to shard data across multiple Redis instances. In the cluster mode, we will have multiple masters and slaves.

```bash
# In the slave
ROLE
# Output
# slave
# master_host:<master-ip>
# master_port:<master-port>
# master_link_status: connected
# master replication offset:<offset>

# In the master
ROLE
# Output
# master
# master_repl_offset:<offset>
# connected_slaves:<slave-count> (::<connected_count>)
# slave port:<slave-port>
# master_rep_offset:<offset>
```