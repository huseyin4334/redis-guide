# Redis Cluster

> https://redis.io/docs/latest/operate/oss_and_stack/management/scaling/

Redis Cluster is a distributed implementation of Redis instances that allows for data sharding and replication across multiple nodes. So basically, redis cluster is a multiple master-slave group manager. 
We should understand some key concepts before we dive into Redis Cluster:
- **Cluster Node**: A Redis instance that is part of a Redis Cluster. (Master or Slave)
- **Cluster Slot**: Redis Cluster uses hash slots to map keys to different nodes. 
  - There are 16384 hash slots in Redis Cluster. Each node in the cluster is responsible for a subset of the hash slots.
  - When a key added to a redis cluster, it is calculated to which hash slot it belongs to.
  - For example, "user:2" key belongs to hash slot 3300. Master3 is responsible for hash slots 3000-4000. Then this key will be stored in Master3. And the master3 will be responsible for replication of this key.
- **Sharding**: The process of distributing data across multiple nodes in a Redis Cluster.
  - Our explained example is a sharding example.
- **This way is like consistent hashing or relational databases' sharding.**

The important points about Redis Cluster are:
- When the majority of the nodes are down, the cluster will not be able to serve requests.
- Cluster can scale up to 1000 nodes.
- Redis only supports a single database per node in a cluster.
- Cluster starts with at least 3 master nodes.
- Cluster only takes nodes. It doesn't take nodes with roles. It's responsibility of cluster. It decides the role of the node.
- Cluster uses gossip protocol to communicate between nodes.

> cluster-announce-port is used for client-to-server communications.
> cluster-announce-bus-port is used for server-to-server communications.


# How is Starts a Redis Cluster
Start 6 redis instances at least with cluster mode. Because Cluster mode needs at least 3 master nodes. If we don't give nodes more than 3 + enough replica size, it will not start. 

We will have a cluster starter instance too. We will use this instance to start the cluster.

`appendonly yes` uses to save the data to the disk for the persistence.


```bash
# Cluster Nodes
redis-server --port 7000 --cluster-enabled yes --cluster-config-file nodes.conf --cluster-node-timeout 5000 --appendonly yes
redis-server --port 7001 --cluster-enabled yes --cluster-config-file nodes.conf --cluster-node-timeout 5000 --appendonly yes
redis-server --port 7002 --cluster-enabled yes --cluster-config-file nodes.conf --cluster-node-timeout 5000 --appendonly yes
redis-server --port 7003 --cluster-enabled yes --cluster-config-file nodes.conf --cluster-node-timeout 5000 --appendonly yes
redis-server --port 7004 --cluster-enabled yes --cluster-config-file nodes.conf --cluster-node-timeout 5000 --appendonly yes
redis-server --port 7005 --cluster-enabled yes --cluster-config-file nodes.conf --cluster-node-timeout 5000 --appendonly yes

# Cluster Starter Command
redis-cli --cluster create localhost:7000 localhost:7001 localhost:7002 localhost:7003 localhost:7004 localhost:7005 --cluster-replicas 1 --cluster-yes

# Redis Insight
docker run -v redisinsight:/db -p 5540:5540 redislabs/redisinsight:latest
```

Or we can use the docker-compose file to start the cluster. 

```bash
docker-compose -f ./config/dockerfiles/docker-compose-cluster.yml up
```


```bash
redis-cli -p 7001
set key1 value1
# -> Redirected to slot [12182] located at 127.0.0.1:7002
# OK
# We will automatically redirected to the correct node.

get key1
# 127.0.0.1:7002 
# value1
```

# Check The Cluster
```bash
redis-cli --cluster check 127.0.0.1:7000
# It will use a node for check all cluster

# It will say node iformations.
# For only master nodes will something;
# <ip:port> (node_id) -> <size_of_keys> keys | <size_of_slots> slots | <size_of_slaves> slaves

# for all nodes;
# M: <id> <ip:port> slots:[<slot1>-<slot2>] (<total_slot_size> slots) master
# S: <id> <ip:port> slots: (0 slots) slave



redis-cli -p 7000 cluster nodes
# get node informations
# <node-id> <ip:port>@<bus-port> <type(master or slave)> ...
```

# Add New Node
```bash
# Start a new node
redis-server --port 7006 --cluster-enabled yes --cluster-config-file nodes.conf --cluster-node-timeout 5000 --appendonly yes

# Add the new node to the cluster
# A cluster node will add the new node to the cluster.
redis-cli --cluster add-node 127.0.0.1:7006 127.0.0.1:7000
```

# CLUSTE Commands
These commands are used to get information about the cluster.
- `CLUSTER NODES`: Get information about all nodes in the cluster.
- `CLUSTER SLOTS`: Get information about all slots in the cluster.
- `CLUSTER REPLICAS`: Get information about all replicas in the cluster.
- `CLUSTER MYID`: Get the id of the current node.
- `CLUSTER INFO`: Get information about the cluster.
- `CLUSTER KEY

```bash
CLUSTER --help
```


# Find Hash Slot of a Key
```bash
redis-cli -p 7000 cluster keyslot key1
# 12182 -> this is hash number of the slot

# Return the key names in current node for the given slot.
redis-cli -p 7000 cluster getkeysinslot 12182 10
# key1
```

# Shuting Down All Cluster

```bash
redis-cli -p 7000 shutdown
redis-cli -p 7001 shutdown
# ...
```