# RESP (REdis Serialization Protocol)
Redis uses a protocol called RESP (REdis Serialization Protocol). It is the protocol used in communication between clients and servers. It is a text-based protocol that is simple to implement and easy to debug. It is also human-readable, which makes it easy to understand.

RESP is a request-response protocol. The client sends a command to the server, and the server responds with the result of the command. The commands are sent as strings, and the responses are sent as strings, integers, or arrays.

Resp is binary safe. This means that it can handle binary data without any problems. For example, when the data have null characters, it can handle them without any issues.

We can use it for other client-server software projects.


# Request Response Models
When we execute an operation, request sends as RESP Array of Bulk Strings.
Replies are sent as RESP Simple Strings, Integers, Errors, Bulk Strings, Arrays according to the operation.

We can understand which type of response we will get from the first byte of the response.
- Simple Strings: First byte is `+`
- Errors: First byte is `-`
- Integers: First byte is `:`
- Bulk Strings: First byte is `$`
- Arrays: First byte is `*`
- Null Bulk Strings: First byte is `$` and the length is -1

After the responsed byte, client deserializes the response according to the type of the response.


# Generating RESP
We can generate RESP strings by using the following rules:
`<cr>` is basically `\r` and `<lf>` is `\n`.
`<args>` is the number of arguments in the array.


- `*<args><cr><lf>`: Start the array with the number of arguments.
- `$<length><cr><lf>`: Start the bulk string with the length of the string.
- `<string><cr><lf>`: The string itself.
- `:<integer><cr><lf>`: Start the integer with the integer itself.
- `+<string><cr><lf>`: Start the simple string with the string itself.
- `-$<cr><lf>`: Start the null bulk string with -1.
  

Let's see an example:
  
```bash
# Command: SET key value

# 3 arguments in the array (SET, key, value) (*3<cr><lf>)
# 3 characters in the first argument (SET) ($3<cr><lf>)
# SET<cr><lf> (String definition)
# 3 characters in the second argument (key) ($3<cr><lf>)
# key<cr><lf> (String definition)
# 5 characters in the third argument (value) ($5<cr><lf>)
# value<cr><lf> (String definition)
*3<cr><lf>$3<cr><lf>SET<cr><lf>$3<cr><lf>key<cr><lf>$5<cr><lf>value<cr><lf>


# Command: hset key field 10

# 4 arguments in the array (HSET, key, field, 10) (*4<cr><lf>)
# 4 characters in the first argument (HSET) ($4<cr><lf>)
# HSET<cr><lf> (String definition)
# 3 characters in the second argument (key) ($3<cr><lf>)
# key<cr><lf> (String definition)
# 5 characters in the third argument (field) ($5<cr><lf>)
# field<cr><lf> (String definition)
# 2 characters in the fourth argument (10) ($2<cr><lf>)
# 10<cr><lf> (String definition)
*4<cr><lf>$4<cr><lf>HSET<cr><lf>$3<cr><lf>key<cr><lf>$5<cr><lf>field<cr><lf>$2<cr><lf>10<cr><lf>
```
