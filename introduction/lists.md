# List
Redis is a collection of data structures. Redis has a few different kinds of lists, but the most commonly used one is the linked list. The linked list is a sequence of elements in which every element has a reference to the next element in the sequence. This allows for fast insertion and deletion of elements in the middle of the list. Redis also has a few other list types, such as the ziplist and the quicklist, which are optimized for specific use cases.

Lists can user more than 4 billion elements. The maximum length of a list is 2^32 - 1 elements (4294967295, more than 4 billion of elements per list).


List can be use for;
- Storing logs
- Storing user activity
- Storing messages
- Event queue

# Commands
## LPUSH, RPUSH, LRANGE
LPUSH and RPUSH are used to insert elements into a list. LPUSH inserts elements at the beginning of the list, while RPUSH inserts elements at the end of the list.

LRANGE is used to get a range of elements from a list. It takes a list key, a start index, and an end index, and returns the elements in that range.

```bash
lpush mylist value1 value2 value3
lrange mylist 0 -1
# 1) "value3"
# 2) "value2"
# 3) "value1"

lpush mylist value4
lrange mylist 0 -1
# 1) "value4"
# 2) "value3"
# 3) "value2"
# 4) "value1"

rpush mylist value5 value6
lrange mylist 0 -1
# 1) "value4"
# 2) "value3"
# 3) "value2"
# 4) "value1"
# 5) "value5"
# 6) "value6"
```

## LINDEX
LINDEX is used to get an element from a list by its index. It takes a list key and an index, and returns the element at that index.

```bash
lindex mylist 0
# "value4"

lindex mylist 2
# "value2"
```

## LINSERT
LINSERT is used to insert an element into a list before or after another element. It takes a list key, a position (BEFORE or AFTER), a pivot element, and a value to insert, and inserts the value into the list.

This is a special case of the LPUSH and RPUSH commands, where the pivot element is specified. pivot element is required to be in the list for the operation to succeed.
Return value
- -1: If the pivot element is not found in the list.
- If insertion completed successfuly, Size of the list after the insert operation.

```bash
linsert mylist BEFORE value2 newvalue

lrange mylist 0 -1
# 1) "value4"
# 2) "value3"
# 3) "newvalue"
# 4) "value2"
# 5) ....
```

## LPOP, RPOP, LTRIM, LREM
LPOP and RPOP are used to remove elements from a list. LPOP removes elements from the beginning of the list, while RPOP removes elements from the end of the list.

```bash
lpop mylist
# "value4" -> deleted element

rpop mylist
# "value2" -> deleted element

lpop mylist 2
# "value3"
# "newvalue"
```

---

LTRIM is used to trim a list to a specified range of elements. It takes a list key, a start index, and an end index, and removes all elements from the list that are not in that range.

```bash
# mylist = [value3, newvalue, value2, value1]
ltrim mylist 0 1
# OK

lrange mylist 0 -1
# 1) "value3"
# 2) "newvalue"

# mylist = [value3, newvalue, value2, value1]
ltrim mylist 1 -1
# OK

lrange mylist 0 -1
# 1) "newvalue"
# 2) "value2"
# 3) "value1"
```

---

LREM is used to remove elements from a list by value. It takes a list key, a count, and a value, and removes the specified number of elements with that value from the list.
Count is used to define how many occurrences to remove. If count is 0, it will remove all occurrences. If count is 1, it will remove the first occurrence. If count is -1, it will remove the last occurrence.

```bash
# mylist = [value3, newvalue, value2, value1, newvalue, newvalue, newvalue]
lrem mylist 2 newvalue
# 2

lrange mylist 0 -1
# 1) "value3"
# 2) "value2"
# 3) "value1"
# 4) "newvalue"
# 5) "newvalue"
```



## LSET
LSET is used to set the value of an element in a list by its index. It takes a list key, an index, and a value, and sets the value of the element at that index.
Basicly, it's change the value of the element in the list.

```bash
# mylist = [value3, newvalue, value2, value1]
lset mylist 1 value4

lrange mylist 0 -1
# 1) "value3"
# 2) "value4"
# 3) "value2"
# 4) "value1"
```

## LLEN
LLEN is used to get the length of a list. It takes a list key and returns the number of elements in the list.

```bash
llen mylist
# 4
```

## LPOS
LPOS is used to get the position of an element in a list. It takes a list key, a value, and an optional rank, and returns the index of the first occurrence of the value in the list.
Rank is used to define where to start the return matching indexes. For example, if rank is 2, it matched the 3 value. It will start to return the indexes from second element.
Count is used to define how many occurrences to return. If count is 2, if there are 3 occurrences, it will return the first 2 occurrences (when rank is 0).
MAXLEN is used to define the maximum number of elements to scan.

```bash
# mylist = [value3, newvalue, value2, value1, value2, value2, value2]
lpos mylist value2
# 2

lpos mylist value2 rank 2
# 4 -> 2nd occurrence of value2

lpos mylist value2 rank 2 count 2
# 4 -> 2nd occurrence of value2
# 5 -> 3rd occurrence of value2

lpos mylist value2 rank 2 count 3
# 4 -> 2nd occurrence of value2
# 5 -> 3rd occurrence of value2
# 6 -> 4th occurrence of value2

lpos mylist value2 rank 2 count 10 maxlen 3
# (empty array) -> because doesn't matched in first 3 elements
```

## LMOVE
LMOVE is used to move an element from one list to another. It takes a source list key, a destination list key, and take 2 times left or right. 

LEFT is mean add/remove from the first element of the list.
RIGHT is mean add/remove from the last element of the list.

```bash
# mylist = [value3, newvalue, value2, value1]
# mylist2 = [value5, value6]
lmove mylist mylist2 LEFT RIGHT
# it will return the value of the element moved

# mylist = [newvalue, value2, value1]
# mylist2 = [value5, value6, value3]
```