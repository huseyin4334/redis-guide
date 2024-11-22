# Strings (SET, GET)
Normal default key-value pair. We can store any string value in a key.

```bash
SET name "John"

GET name

set age 25
type age
# It will return string
```

# Numbers (INCR, INCRBY, DECR, DECRBY)
When we store a number in a key, it will be stored as a string. But we can use arithmetic operations on it.

> Redis also supports negative numbers.

## Integer

```bash
SET age 25

INCR age
# It will return 26

type age
# It will return string

INCRBY age 5
# It will return 31

DECR age
# It will return 30

DECRBY age 5

GET age
# It will return 25
```

## Float

```bash
SET height 5.5

INCRBYFLOAT height 0.5
# It will return 6.0

GET height
# It will return 6.0

DECRBYFLOAT height 0.5
# It will return 5.5

GET height

type height
# It will return string

Incrbyfloat height -0.5
# It will return 5.0
```

# Functions

## Append (APPEND)
We can append a string to an existing key.

```bash
SET name "John"

APPEND name " Doe"
# It will return size of the string after appending (8)

GET name
# It will return John Doe

set n 6
append n 7

get n
# It will return 67

append f 8
# It will return 1

get f
# It will return 8
```

## Carachter Size (STRLEN)
We can get the length of a string.

```bash
SET name "John Doe"

STRLEN name
# It will return 8
```


## Set And Get Multiple Values (MSET, MGET, MSETNX)
We can set multiple key-value pairs at once.
`MSET` will set multiple key-value pairs. If the key already exists, it will overwrite the value.
`MGET` will get multiple values at once.
`MSETNX` will set multiple key-value pairs only if all the keys do not exist.

```bash
MSET name "John" age 25 city "New York"

MGET name age city
# It will return John 25 New York like a list
```

## GET Last value And Set New Value (GETSET)
We can get the last value of a key and set a new value.
If the key does not exist, it will return nil. And set the new value.
Atomic reset of the key. This means that the key is set to the new value and the old value is returned. We didn't execute two commands.

```bash
SET name "John"

GETSET name "Doe"
# It will return John

GET name
# It will return Doe

INCR age
It will return 1

GETSET age 25
# It will return 1

GET age
# It will return 25
```

## Get Range (GETRANGE)
We can get a substring of a string.

```bash
SET name "John Doe"

GETRANGE name 0 3
# It will return John. 0 is the starting index and 3 is the ending index. Ending index is included.

GETRANGE name 5 -1
# It will return Doe. -1 is the last index.

GETRANGE name 5 100
# It will return Doe. If the ending index is greater than the length of the string, it will return the string from the starting index to the end.

GETRANGE name 5 -2
# It will return Do. -2 is the second last index.

GETRANGE name -3 -1
# It will return Doe. -3 is the third last index.
```

## Set Range (SETRANGE)
We can replace a substring of a string.

```bash
SET name "John Doe"

SETRANGE name 5 "Smith"
# It will return size of the string after replacing (9)

GET name
# It will return John Smith
```


## Atomic Set With Expiry (SETEX, PSETEX)
We can set a key-value pair with an expiry time.
This is same with SET command but with an additional expiry time.

```bash
SETEX name 10 "John"
# It will set the key name with the value John and expiry time 10 seconds.

SET name "John" EX 10
# It will set the key name with the value John and expiry time 10 seconds.

SET name "John"
EXPIRE name 10

####

PSETEX name 10000 "John"

SET name "John" PX 10000

SET name "John"
PEXPIRE name 10000
```


## Set If Not Exists (SETNX)
We can set a key-value pair only if the key does not exist.

```bash
SETNX name "John"
# It will return 1

SETNX name "Doe"
# It will return 0

GET name
# It will return John
```


## String Encoding Types
Redis decide the encoding automatically as per string value. Redis uses different encoding types for strings based on the value for memory optimization.

- `raw` - A raw string is a simple string that is not encoded in any way. It is used for small strings. Greater than 44 bytes.
- `int` - An integer encoded string is a string that is encoded as a 64-bit signed integer. It is used for integers.
- `embstr` - An embedded string is a string that is encoded as a length-prefixed string. It is used for small strings. Less than or equal 44 bytes.

```bash
SET name "John"

OBJECT ENCODING name
# It will return embstr

SET age 25

OBJECT ENCODING age
# It will return int

SET city "<very long string>"

OBJECT ENCODING city
# It will return raw
```










