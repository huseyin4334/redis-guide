-- NUMBERS

num1, num2 = 1, 2.3
num3 = 4.573e-3
-- e-3 means 10^-3

num4 = 0x1A
num5 = 0x0D
num6 = 3e3
-- 0x is used to represent hexadecimal numbers
-- 0x1A = 1*16 + 10 = 26
-- 0x0D = 0*16 + 13 = 13
-- ...

total = num1 + num2

print (total, num3, num4, num5, num6)

-- 3.3 0.004573 26 13 3000



-- STRINGS
a = "Hello"
b = 'World'

-- .. is used to concatenate strings. It is similar to + in python
-- 

print (a,b,c,d)

-- Hello	World	nil	nil

print(a..b)
-- HelloWorld

print (a.. " " ..b)
-- Hello World

print("car is a \"vehicle\"")
print('car is a "vehicle"')

print("car is a 'vehicle'\nBus is a \"vehicle\"")

-- [[]] is used to represent multi-line strings
-- It is similar to triple quotes in python

html = [[
<html>
    <head>
        <title>Sample HTML</title>
    </head>
    <body>
        <h1> Hello World </h1>
    </body>
</html>
]]

print(html)

-- Lua can also understand numbers in strings
f = "10"
print (f + 1)

-- 11

print("test" + 1)
-- Error: attempt to perform arithmetic on a string value

-- If we concatenate a string with a number, Lua will convert the number to a string with .. operator
print(20 .. 30)
-- 2030

print("test" .. 1)
-- test1

-- toString() in Lua
print(tostring(10) + 1)
-- 11

print(tostring(10) == "10")
-- true

-- io.read() is used to read input from the user
line = io.read()

print("You entered: " .. line)


-- string.gsub() is used to replace a string
newval = string.gsub("Hello World", "World", "Lua")
print(newval)