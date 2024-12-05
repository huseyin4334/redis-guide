--[[

IF statement
===============

IF condition1 THEN 
    -- processing
ELSEIF condition2 THEN 
    -- processing
ELSE 
    -- processing
END


Loops statement
=================
- Loops allows execution of statements on a block of codes based 
  on a condition
  
  FOR condition
  DO
     statements...   
  END
]]


-- 1. Lets see an example

x = 10
if x > 12 then 
    print("X > 12")
elseif x == 20 then 
    print("X = 10") 
else 
    print("X is not there")       
end    

-- 2. Can we short the IF statement
-- we have to set these conditions to a variable.
y = x > 5 and print ("X > 5")



list = nil
for line in io.lines() do
    list = {next=list, value=line}
end




-- FOR loop
-- ================


-- print 4 to 10 
-- 4 and 10 are included in the loop

for num = 4,10
do 
    print(num)
end    

-- WHILE loop
-- ================

i = 10
while i > 0
do 
    print(i)
    i = i - 1
end    




-- Create 50 new elements

t = {}
for i=1,50
do
    t[i] = i*10
end    
print(t[1],t[2])

-- read 5 lines and stored them in a table

a = {}
for i = 1,5
do
    a[i] = io.read()
end
print(a[1],a[2])



-- i is the index and v is the value
-- ipairs iterate over all elements in a table

t1 = {9,8,7,6,5,4,3,2,1}
for i,v in ipairs(t1)
do 
    print("Index: ", i, "Value: ", v)
end

-- print reverse days of the week 

days = {
    "Monday", 
    "Tuesday", 
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
}

-- print(days[1])

for i=#days, 1, -1 -- start, end, increment (#days returns the length of the table)(increment value is optional)
do 
    value = days[i]
    print (i .. ":" .. value)
end

-- Another way to print reverse days of the week
for i=1, #days
do 
    print(days[#days + 1 -i])
end

-- while Loop

-- Lets sum numbers in a table
-- #table returns the length of the table 

-- We have 2 ways to while loop.

--[[
    while condition
    do
        statements
    end

    repeat
        statements
    until condition

    first way is similar to while loop in other languages
    second way is similar to do while loop in other languages
--]]

numbers = { 20, 30, 40, 50}

-- print (numbers[1])

sum, counter = 0, 1
while counter <= #numbers
do 
    sum = sum + numbers[counter]
    counter = counter + 1
end     

print ("The total sum is :", sum)

sum, counter = 0, 1
repeat 
    sum = sum + numbers[counter]
    counter = counter + 1    
until counter > #numbers

print ("The total sum is :", sum)


-- >, <, >=, <=, ==, ~=
-- and, or, not
-- ~ is used to represent not equal to
-- ~= is also used to represent not equal to
print(10 ~= 20)
-- true

-- not is used to represent negation
-- and returns the bigger value. But nil is except for this rule
-- in boolean context, it will work normal condition
print(not 10)
-- false

print(not nil)
-- true

print(not not nil)
-- false

print(10 and 20)
-- 20

print(true and 20)
-- 20

print(10 and nil)
-- nil

print(true and false)
-- false