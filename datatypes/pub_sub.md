# Publish - Subscribe
We have a data type in redis like that.
We can use it for real-time messaging. A client can subscribe to a channel and another client can publish a message to that channel. The message will be delivered to all the clients that are subscribed to that channel.

In the pattern, every key is a channel and every value is a message.

## Commands

> https://redis.io/docs/latest/commands/?group=pubsub

### SUBSCRIBE, UNSUBSCRIBE, PUBLISH
Subscribe is used to subscribe to a channel.
Unsubscribe is used to unsubscribe from a channel.

Publish is used to publish a message to a channel. Publish works like set command.

> When we publish a message a channel, will be return how many clients received the message. These messages are 1 time only. So, if any subscriber is not connected, it will not receive the message and it will not receive the message when it connects.

> When a subscriber is connected, subscriber only can see the messages that are published after it connected.

`SUBSCRIBE channel [channel ...]`
`PUBLISH channel message`
`UNSUBSCRIBE [channel [channel ...]]`

```bash
subscribe mychannel
# Reading messages...
# 1) "subscribe"
# 2) "mychannel"
# 3) (integer) 1 (Ctrl+C to quit (When we click Ctrl+C, It will execute unsubscribe command))


publish mychannel "Hello, World!"
# (integer) 1

# After main messages in subscriber terminal
# 1) "Hello, World!"

telnet localhost 6379
# Trying
# Connected to localhost.
# Escape character is '^]'.
# *3
# $7 (These commands are not human-readable)
# publish
# $8
# mychannel
# unsubscribe mychannel (We execute this command in telnet)
# ....
# Connection closed by foreign host.
```

```bash
subscribe mychannel mychannel2
# Reading messages...
# 1) "subscribe"
# 2) "mychannel"
# 3) (integer) 1
# 1) "subscribe"
# 2) "mychannel2"
# 3) (integer) 2


publish mychannel "Hello, World!"
# (integer) 1

# After main messages in subscriber terminal
# 1) "message"
# 2) "mychannel"
# 3) "Hello, World!"
```

### Patterned Subscription (PSUBSCRIBE, PUNSUBSCRIBE)
Patterned subscription is used to subscribe to a channel with a pattern.

`PSUBSCRIBE pattern [pattern ...]`
`PUNSUBSCRIBE [pattern [pattern ...]]`

```bash
psubscribe my*
# Reading messages...
# 1) "psubscribe"
# 2) "my*"
# 3) (integer) 1

publish mychannel "Hello, World!"

# After main messages in subscriber terminal
# 1) "pmessage"
# 2) "my*"
# 3) "mychannel"
# 4) "Hello, World!"

publish mychannel2 "Hello, World!"

# After main messages in subscriber terminal
# 1) "pmessage"
# 2) "my*"
# 3) "mychannel2"
# 4) "Hello, World!"
```

We can use same patterns that we use in keys.


### Channel Management (PUBSUB)
PUBSUB is used to get information about channels and clients.

We can use it for getting the number of subscribers of a channel, getting the list of channels that a client is subscribed to, getting the list of clients that are subscribed to a channel.

> https://redis.io/docs/latest/commands/?group=pubsub&name=pubsub

`PUBSUB subcommand [argument [argument ...]]`

```bash
# Returns the list of channels that a client is subscribed to
PUBSUB CHANNELS my*

# Returns the count of the number of clients subscribed to the specified channels
PUBSUB NUMSUB mychannel

# Returns the count of the number of clients subscribed to the patterns
PUBSUB NUMPAT
```
















