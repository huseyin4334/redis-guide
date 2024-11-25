# HyperLogLog
HyperLogLog is a probabilistic data structure used to estimate the cardinality of a multiset. 
It is used to count the number of distinct elements in a set. It is a space-efficient way to count the number of distinct elements in a set. 
It is an approximate algorithm that can estimate the number of distinct elements in a set with a standard error of 1.04/sqrt(m), where m is the number of bits used to represent the elements.

> https://en.wikipedia.org/wiki/HyperLogLog

---

Conceptually, HyperLogLog does same tasks like Set but with less memory.
It's not estimate %100 accurate but it's very close to the real value. (0.81% error rate)

Blooms Filter is another probabilistic data structure that is used to test whether an element is a member of a set. (We will also use this in redis too)

---

We have only 5 commands for HyperLogLog in Redis:

- PFADD: Adds the specified elements to the specified HyperLogLog.
- PFCOUNT: Returns the approximated cardinality of the set(s) observed by the HyperLogLog at key(s).
- PFMERGE: Merges multiple HyperLogLogs into an unique HyperLogLog.
- PFDEBUG: Debugging information about a HyperLogLog.
- PFSELFTEST: Perform a self-test of the HyperLogLog implementation.


> Cardinality is not hash value directly. It's a number that represents the number of unique elements in the set. It's calculated by the hash values of the elements.

> **Important**: We can't see the elements in the HyperLogLog. Because this data structure not store the elements, it just stores the cardinality of the set.
> **Important**: HyperLogLog is a probabilistic data structure, so it's not possible to get the exact number of elements in the set. It's an approximate algorithm.


```bash
PFADD key element [element ...]

PFCOUNT key [key ...]

PFMERGE destkey sourcekey [sourcekey ...]

PFDEBUG subcommand key [key ...]

PFSELFTEST [numtests]
```

```bash
# Example
PFADD hll1 foo bar zap
PFADD hll2 a b c foo

PFCOUNT hll1 hll2
# 4 -> It's returns the biggest cardinality of the sets.

PFMERGE hll3 hll1 hll2
PFCOUNT hll3
# 6 
```


# Use Cases
- Counting the number of unique visitors to a website.

Imagine, you need the unique visitors by IP addresses. You can use HyperLogLog to count the unique IP addresses. It's very useful for this kind of tasks.
Because it's not save the IP addresses, it just saves the cardinality of the set. So, it's very memory efficient.
Also, we can get count of the unique visitors in a very short time.

Also, we can merge the HyperLogLogs to get the total unique visitors in a specific time range. 