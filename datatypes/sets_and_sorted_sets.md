# Sets
Sets are unordered collections of unique elements in redis. They are similar to lists, but they do not allow duplicate elements. Sets are useful for storing unique elements and performing set operations like union, intersection, and difference.

Sets can store up to 4 billion elements.

> Every element in a set is a string.
> Sets are unordered, meaning that the order of elements in a set is not guaranteed.

## Commands

> https://redis.io/docs/latest/commands/?group=set

### SADD, SMEMBERS (Add and Check)
SADD is used to add elements to a set. It takes a set key and one or more elements, and adds the elements to the set.

```bash
sadd myset value1 value2 value3
# 3

sadd myset value4

smembers myset
# 1) "value1"
# 2) "value2"
# 3) "value3"
# 4) "value4"

sadd myset value3
# 0
```

### SCARD
SCARD is used to get the number of elements in a set. It takes a set key and returns the number of elements in the set.

```bash
scard myset
# 4
```

### SREM, SPOP
SREM is used to remove elements from a set. It takes a set key and one or more elements, and removes the elements from the set.

SPOP is used to remove and return a random element from a set.

```bash
srem myset value1 value2
# 2

smembers myset
# 1) "value3"
# 2) "value4"

sadd myset value1 value2

spop myset 2 # 2 is the number of elements to pop
# "value3"
# "value1"

smembers myset
# 1) "value4"
# 2) "value2"
```

### SISMEMBER
SISMEMBER is used to check if an element is in a set. It takes a set key and an element, and returns 1 if the element is in the set, and 0 otherwise.

```bash
SISMEMBER myset value4
# 1

SISMEMBER myset value5
# 0
```

### SRANDMEMBER
SRANDMEMBER is used to get one or more random elements from a set. It takes a set key and an optional count, and returns one or more random elements from the set.

```bash
srandmember myset
# "value2"

srandmember myset 2
# 1) "value4"
# 2) "value2"
```

### SMOVE
SMOVE is used to move an element from one set to another. It takes the source set key, the destination set key, and the element to move, and moves the element from the source set to the destination set.

> If the element is not in the source set, SMOVE return 0.
> If the element is in the source set, SMOVE return 1.

```bash
smove myset myotherset value4

smembers myset
# 1) "value2"

smembers myotherset
# 1) "value4"
```

### SUNION, SINTER, SDIFF
SUNION is used to get the union of multiple sets. It takes the keys of the sets to union, and returns the union of those sets.

SINTER is used to get the intersection of multiple sets. It takes the keys of the sets to intersect, and returns the intersection of those sets.

SDIFF is used to get the difference between two sets. It takes the keys of the two sets, and returns the difference between those sets.

```bash
# set1 = {value1, value2, value3}
# set2 = {value2, value3, value4}
# set3 = {value4, value5}

sunion set1 set2 set3
# 1) "value1"
# 2) "value2"
# 3) "value3"
# 4) "value4"
# 5) "value5"

sinter set1 set2
# 1) "value2"
# 2) "value3"

sineter set1 set2 set3
# (empty array)

sdiff set1 set2
# 1) "value1"

sdiff set2 set1
# 1) "value4"

sdiff set1 set2 set3
# 1) "value1"
```

### SUNIONSTORE, SINTERSTORE, SDIFFSTORE
These functions will store the result of the operation in a new set.

> if the list is empty, it will return 0 and not create a new set.

```bash
sunionstore myunionset set1 set2 set3
# 5

sineterstore myinterset set1 set2
# 2

sdiffstore mydiffset set1 set2
# 1
```


# Sorted Sets
Sorted sets are similar to sets, but each element in a sorted set is associated with a score. The score is used to order the elements in the set, and elements are sorted by their scores.


## Commands

> https://redis.io/docs/latest/commands/?group=sorted_set

### ZADD, ZRANGE, ZRANK
ZADD is used to add elements to a sorted set. It takes a sorted set key, a score, and an element, and adds the element to the sorted set with the given score.

ZRANGE is used to get a range of elements from a sorted set. It takes a sorted set key, a start index, and an end index, and returns the elements in that range.

ZRANK is used to get the rank of an element in a sorted set. It takes a sorted set key and an element, and returns the rank of the element in the sorted set.


#### ZADD
ZADD have multiple options to add elements to the sorted set.

> https://redis.io/docs/latest/commands/zadd

Score is a floating point number. The score is used to order the elements in the sorted set. For example, if you have a sorted set of students and their scores, you can use the scores to order the students by their scores.

```bash
zadd myzset 1 "one" 2 "two" 3 "three"

zrange myzset 0 -1
# 1) "one"
# 2) "two"
# 3) "three"

zadd myzset gt 2 "one"
# 0 (gt is only update the existing elements score when the new score is greater than the old score. Redis will return 0 because the element not inserted)

zadd myzset xx 45 "three"
# 0 (xx is only update the existing elements score when the element is already in the set. If the value not exists, Redis will not insert it)

zadd myzset nx 45 "four"
# 1 (nx is only insert the element if it does not exist in the set)
```


#### ZRANGE, ZRANGESTORE, ZREVRANGE
ZRANGE have multiple options to get elements from the sorted set.

> https://redis.io/docs/latest/commands/zrange

- BYSCORE: Get elements by score.
- BYLEX: Get elements by lexicographical range. (alphabetical order)
- LIMIT: Limit the number of elements returned. Limit can be use with BYSCORE or BYLEX. We have to choose one of them.
  - It takes two arguments, the offset and the count.
  - The offset is the index of the first element to return, and the count is the number of elements to return.
- REV: Reverse the order of the elements returned.
- WITHSCORES: Return the scores of the elements along with the elements.

```bash
zrange myzset 0 -1

zrange myzset 0 -1 withscores
# value
# score
# ....

# Same reverse order
zrange myzset 0 -1 rev
zrevrange myzset 0 -1

# 
zrange myzset 0 -1 byscore limit 2 3

zrangestore myzsetnew myzset 0 2
zrangestore myzsetnew myzset 0 2 rev
```

#### ZRANK
ZRANK is used to get the index of an element in the sorted set.

```bash
zset myzset 1 "one" 2 "two" 3 "three"

zrank myzset "one" withscores
# 0
# 1

zrank myzset "two"
# 1

zrank myzset "three"
# 2
```


### ZINCRBY
ZINCRBY is used to increment the score of an element in a sorted set. It takes a sorted set key, an increment value, and an element, and increments the score of the element by the increment value.

```bash
zadd myzset 1 "one" 2 "two" 3 "three"

zincrby myzset 5 "one"

zrange myzset 0 -1 withscores
# 1) "two"
# 2) "2"
# 3) "three"
# 4) "3"
# 5) "one"
# 6) "6"
```


### Lexicographical Ordering
We can set the same score for multiple elements in the sorted set. In this case, Redis will use the lexicographical order to sort the elements.
Also, we can use the BYLEX option to get elements by lexicographical range.

In the min, max definition;
- ( is exclusive
  - This means that the value is not included in the range.
- [ is inclusive
  - This means that the value is included in the range.
- - is the minimum value
- + is the maximum value

- Examples:
  - [aaa
    - 

```bash
ZADD myzset 0 a 0 b 0 c 0 d 0 e 0 f 0 g

ZRANGE myzset (b [f bylex
# 1) "c"
# 2) "d"
# 3) "e"

ZRANGEBYLEX myzset [b [f

ZREVRANGEBYLEX myzset - [e
# 1) "a"
# 2) "b"
# 3) "c"
# 4) "d"
# 5) "e"
```