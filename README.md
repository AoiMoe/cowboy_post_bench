## cowboy_post_bench

POST benchmark to compare between cowboy-1.1.2 and cowboy-2.10.0.

### how to run
```
make
```


## how it works
- Prepare a binary file of a specific size filled with zeros.
  - Note: It does not consume storage because it is actually a hole file.
- Upload this file to the local cowboy HTTP/1.1 server via loopback device using local curl client.
  - The cowboy HTTP/1.1 server measures the time to read the request body and simply discards the body.
- Repeat 10 times per specific property.
- Repeat the above in various binary sizes and cowboy1/2.


## Tested platforms
- Xubuntu 16.04
- OTP-21.3.8.18
- OPT-26.0
