--[[
EVAL 
============================
1.  Core features of Lua
2.  Knowledge to extend standard sets of Redis Database
3.  Input / Output
4.  Input Sources:  
        - Redis Database
        - Script Arguments
    Output 
        - based on Redis Server replies we generate the output
        

Lua and Redis Data Types are still different
==============================================
How they reply?

Type            Redis                   Lua
-----------     --------------------    ---------------
integer         -                       number
bulk            -                       string
multi-bulk      -                       table
nil bulk        -                       boolean false
status          -                       'ok'
error           -                       'err'
  
- We need to follow RULES OF CONVERSIONS as per above

]]

-- 1. Lets evaluate the script from the command line

-- 1.1 Simple script to return static string

EVAL "return \"Hello Lua!\"" 0 

-- the first argument in EVAL is Lua script
-- the 2nd argument is number of arguments/keys that we will pass to redis

-- 2. Lets pass a key to the script

-- The arguments can be accessed in the form of KEYS global variables
--  KEYS[1] means 1st argument

SET name "Kim"

EVAL "return string.format(\"Hi %s\",KEYS[1])" 1 name

-- Redis commands from a Lua script via redis.call()
-- We need to call redis.call to get value of a KEYS argument

EVAL "return string.format(\"Hi %s\",redis.call('GET',KEYS[1]))" 1 name

-- You can pass arguments too i.e. ARGV[1], ARGV[2]....

EVAL "return string.format(\"%s, %s\",ARGV[1],redis.call('GET',KEYS[1]))" 1 name "Hello"

-- 3. Can we retrieve key values directly

SET key1 1
SET key2 2 

EVAL "return {KEYS[1],KEYS[2]}" 2 key1 key2 

-- 4. What about passing KEYS and ARGV together

EVAL "return {KEYS[1],KEYS[2],ARGV[1],ARGV[2]}" 2 key1 key2 "one" "two"

-- 5. Lets SET some key value from a lua script
-- Not a good one 
EVAL "return redis.call('set','k1','v1')" 0 

-- We should always use KEYS

EVAL "return redis.call('SET',KEYS[1],'v2')" 1 k2

EVAL "return redis.call('SET',KEYS[1],'KlickAnalytics.com')" 1 app:config.title
