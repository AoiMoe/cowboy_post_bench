## cowboy_post_bench

POST benchmark to compare between cowboy-1.1.2 and cowboy-2.10.0.

### how to run
```
make
```


## how it works

### test unit
- Prepare a binary file of a specific size filled with zeros.
  - Note: It does not consume storage because it is actually a hole file.
- Upload this file to the local cowboy HTTP/1.1 server via loopback device using local curl client.
  - The cowboy HTTP/1.1 server measures the time to read the request body and simply discards the body.
- Repeat 10 times.

### test1
- Repeat the test unit in various binary sizes and cowboy1/2.

### test2
- Repeat the test unit in various active_n and length options setting with cowboy2 and 1Gbytes binary.


## Tested platforms
- Xubuntu 16.04
- OTP-21.3.8.18
- OPT-26.0


## Result summary
- [OTP-21](result.otp21/summary.md)
- [OTP-26 without JIT](result.otp26/summary.md)
- [OTP-26 with JIT](result.otp26_jit/summary.md)

### Findings
- Cowboy2 is about 10 times (without JIT) or 7.6 times (with JIT) slower than cowboy1 for uploading 1 1Gbyte file.
- Changing `active_n` or `length` has too little effect to solve the problem.
