# RDBMS to Redis
We have columns, rows, primary keys and so on. How do we convert this to Redis?

We can defin tables with names. After that we will seperate the rows with ":". We can use the primary key as the key and the rest of the row as the value.

`<tableName>:<primaryKey>` -> `<row>`

Every row can be hash object. field key is column name and field value is the value of the column.

`<tableName>:<primaryKey>` -> `<column>:<value>`

```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    salary FLOAT
);

INSERT INTO users VALUES (1, 'John Doe', 30, 1000.0);
INSERT INTO users VALUES (2, 'Jane Doe', 25, 2000.0);
```

```bash
hmset users:1 id 1 name 'John Doe' age 30 salary 1000.0
hmset users:2 id 2 name 'Jane Doe' age 25 salary 2000.0
```

```bash
hmget users:1 id name age salary
# 1) "1"
# 2) "John Doe"
# 3) "30"
# 4) "1000.0"
```

```bash	
scan 0 match users:*
# 1) "0"
# 2) 1) "users:1"
#    2) "users:2"
```

---

When we unique with 2 column a table, we can use the following format.

`<tableName>:<column1>:<column2>` -> `<row>`

```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    salary FLOAT,
    UNIQUE(name, age)
);

INSERT INTO users VALUES (1, 'John Doe', 30, 1000.0);
INSERT INTO users VALUES (2, 'Jane Doe', 25, 2000.0);
```

```bash
hmset users:name:age:John_Doe:30 id 1 name 'John Doe' age 30 salary 1000.0

hmget users:name:age:John_Doe:30 id name age salary
# 1) "1"
# 2) "John Doe"
# 3) "30"
# 4) "1000.0"
```