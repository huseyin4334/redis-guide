# Hashes
Hashes are list of field-value pairs. 
This is similar to Json objects.
Elements in a hash are accessed by their field name.
Hashes are schema-less, meaning that you can add any field to a hash at any time.
Hashes can store more than 4 billion field-value pairs.

> Every field in a hash is a string, and every value in a hash is a string.


# Commands

> https://redis.io/docs/latest/commands/?name=H&group=hash

## HSET, HGET, HGETALL
HSET is used to set a field-value pair in a hash. If the field already exists, it is overwritten.

HGET is used to get the value of a field in a hash.

HGETALL is used to get all the field-value pairs in a hash.

```bash
hset myhash field1 "value1"
# OK
hset myhash field2 "value2" field3 "value3"

hget myhash field1
# value1

hget myhash field
# (nil)

hgetall myhash
# 1) "field1"
# 2) "value1"
# 3) "field2"
# 4) "value2"
# 5) "field3"
# 6) "value3"

hset myhash field1 "newvalue"

hgetall myhash
# 1) "field1"
# 2) "newvalue"
# 3) "field2"
# 4) "value2"
# 5) "field3"
# 6) "value3"
```


## HMGET
HMGET is used to get the values of multiple fields in a hash. It takes a hash key and a list of fields, and returns the values of those fields.

```bash
hset myhash field1 "value1" field2 "value2" field3 "value3"

hmget myhash field1 field2
# 1) "value1"
# 2) "value2"
```

## HLEN
HLEN is used to get the number of field-value pairs in a hash. It takes a hash key and returns the number of fields in the hash.

```bash
hlen myhash
# 3
```

## HDEL
HDEL is used to delete fields from a hash. It takes a hash key and a list of fields, and deletes those fields from the hash.

```bash
hdel myhash field1 field2

hgetall myhash
# 1) "field3"
# 2) "value3"
```

## HEXISTS
HEXISTS is used to check if a field exists in a hash. It takes a hash key and a field, and returns 1 if the field exists, and 0 if it does not.

```bash
# myhash = {field3: value3}
hexists myhash field1
# 0

hexists myhash field3
# 1
```

## HKEYS, HVALS
HKEYS is used to get all the field names in a hash. It takes a hash key and returns a list of all the fields in the hash.
HVALS is used to get all the values in a hash. It takes a hash key and returns a list of all the values in the hash.

```bash
# myhash = {field1: value1, field2: value2, field3: value3}
hkeys myhash
# 1) "field1"
# 2) "field2"
# 3) "field3"

hvals myhash
# 1) "value1"
# 2) "value2"
# 3) "value3"
```


## HINCRBY, HINCRBYFLOAT
HINCRBY is used to increment the value of a field in a hash by a specified amount. It takes a hash key, a field, and an integer value, and increments the value of the field by that amount.

HINCRBYFLOAT is used to increment the value of a field in a hash by a specified amount. It takes a hash key, a field, and a float value, and increments the value of the field by that amount.

```bash
hset myhash field1 10
hset myhash field2 10.5

hincrby myhash field1 5
# 15

hincrbyfloat myhash field2 5.5
# 16

hincrbyfloat myhash field1 5.5
# 20.5
```


## HSETNX
HSETNX is used to set a field-value pair in a hash only if the field does not already exist. It takes a hash key, a field, and a value, and sets the value of the field only if the field does not already exist.

```bash
hsetnx myhash field1 "value1"
# 1

hsetnx myhash field1 "newvalue"
# 0
```

## HRANDFIELD
HRANDFIELD is used to get a random field from a hash with produced count.

```bash
hset myhash field1 "value1" field2 "value2" field3 "value3"

hrandfield myhash 2
# field2
# field1

hrandfield myhash -2
# field3
# field1

hrandfield myhash 1 withvalues
# field2
# value2
```