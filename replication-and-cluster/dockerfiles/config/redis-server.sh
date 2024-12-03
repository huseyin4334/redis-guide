CONF_FILE="/tmp/redis.conf"

# generate redis.conf file
# port is the port that the redis server will listen on
# cluster-enabled yes: enable cluster mode
echo "port 7000
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
cluster-announce-bus-port 17000
appendonly yes
" >> $CONF_FILE

# start server
redis-server $CONF_FILE
