# IMDB Example
Our data under `./sample-data` directory. We can use this data for the examples.

We have movies, actors, theaters, and users data. We can create an index for each data type.


# Create Container And Import Data

```bash

docker run -d --name redisearch -p 6379:6379 -v fullpath/sample-data/:/sample-data:ro redislabs/redisearch:latest

docker exec -it redisearch bash

cd ../sample-data

cat import_actors.redis | redis-cli --pipe
cat import_movies.redis | redis-cli --pipe
cat import_theaters.redis | redis-cli --pipe
cat import_users.redis | redis-cli --pipe
```

# Create Indexes

```bash
FT.CREATE idx:movies ON HASH PREFIX 1 "movies:" SCHEMA movie_name TEXT category TAG votes NUMERIC SORTABLE rating NUMERIC SORTABLE release_year numeric SORTABLE plot TEXT poster TEXT NOINDEX imdb_id TEXT SORTABLE

ft.create idx:actor ON hash PREFIX 1 "actor:" SCHEMA first_name TEXT SORTABLE last_name TEXT SORTABLE date_of_birth NUMERIC SORTABLE

ft.create idx:theater ON hash PREFIX 1 "theater:" SCHEMA name TEXT SORTABLE location GEO

ft.create idx:user ON hash PREFIX 1 "user:" SCHEMA gender TAG country TAG SORTABLE last_login NUMERIC SORTABLE location GEO
```


# Query Data

Get the movies starting with the `heat` word but not want to get the `heater` word.

```bash
FT.SEARCH idx:movies "@movie_name:(heat* -heater)"
```

> If we set only `FT.SEARCH idx:movies "heat"` in the query, it will search the `heat` word in all fields like `*heat*`. If we want to search the `heat` word only in the `movie_name` field, we need to use the `@` sign before the field name.


---

Let's get `Drama` and `Action` categories movies.

```bash
FT.SEARCH idx:movies "@category:{Drama|Action}"
```

Let's combine the `category` and `heat` search.

```bash
FT.SEARCH idx:movies "@category:{Drama|Action} | @movie_name:(heat* -heater)"
```

> When we didn't specify `|` between the `category` and `heat` search, it will search the criterias with `&` operator.


---

Let's get the movies that have a rating between 5 and 10 (10 not included) and (category will be `Drama` or name contains `heat` but not contains `heater`) and release year 2000 or 2005

```bash
FT.SEARCH idx:movies "@rating:[5 (10] (@category:{Drama} | @movie_name:(heat* -heater)) (@release_year:2000 | @release_year:2005)"
```

---

Let's sort the results by the rating field.

```bash
FT.SEARCH idx:movies "@rating:[5 (10] (@category:{Drama} | @movie_name:(heat* -heater)) (@release_year:2000 | @release_year:2005) SORTBY rating ASC
```

---

Ok, I need only movie names and ratings.

```bash
FT.SEARCH idx:movies "@rating:[5 (10] (@category:{Drama} | @movie_name:(heat* -heater)) (@release_year:2000 | @release_year:2005) SORTBY rating ASC RETURN 2 movie_name rating
```