-- Values and Data Types
-- =======================

--[[ 
    
1. Lua is a dynamic typed language 
  - This means that variables do not have types; only values do. It's like python

2. Data types 
    Nil 
    Boolean
    Numbers
    Strings
    Tables - Similar to Redis Hashes
    Functions
--]]

-- 3. Lets print a number and a Nil object

-- print ("hello Lua")

a = "Redis"
b = Nil
c = 1

print (a,b,c)

-- To run this script, you can use the following command:
-- lua types.lua

-- The output of this script will be:
-- Redis	nil	1


bool1 = true
bool2 = false

print (bool1, bool2)

-- The output of this script will be:
-- true	false

num1, num2 = 1, 2
str1, str2 = "Hello", "World"



-- All types
-- String
a = "Hello"

-- Number
b = 10

-- Boolean
c = true

-- Nil
d = nil

-- Array
e = {1,2,3,4,5}

-- Function
f = function() print("Hello") end

-- Table
g = {name = "Redis", age = 10}
g.job = "Developer"
g["city"] = "Bangalore"
g[1] = "One"

-- Array and tables are same things. Keys are numbers in array and strings in tables
-- Indexing starts from 1 in Lua (VERY IMPORTANT)
-- Array indexes works for witout keys in tables

print(g)
-- table: 0x7f8f4b402f10 -> This is the memory address of the table


mixed = {name = "Redis", 10, 20, "Hello", function() print("Hello") end}

print(mixed.name, mixed[1], mixed[2], mixed[3], mixed[4])
-- Redis	10	20	Hello	function: 0x7f8f4b402f10
