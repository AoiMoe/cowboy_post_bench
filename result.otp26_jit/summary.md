### Parameters
- Machine:
  - VirtualBox 7.0.4
    - 1 CPU
    - 16GB memory
  - Intel Core i9-9900K
- OS: Xubuntu 16.04 LTS
  - Linux 4.15.0-47-generic #50~16.04.1-Ubuntu SMP x86_64
- Erlang/OTP
  - OTP-26.0
  - Erlang (SMP,ASYNC_THREADS) (BEAM) emulator version 14.0
    - with JIT

### Averages

```
cowboy-1.1.2, size=1M, 10times average(ms): 14.791
cowboy-1.1.2, size=10M, 10times average(ms): 12.997
cowboy-1.1.2, size=100M, 10times average(ms): 65.237
cowboy-1.1.2, size=1G, 10times average(ms): 647.311
cowboy-2.10.0, size=1M, 10times average(ms): 6.349
cowboy-2.10.0, size=10M, 10times average(ms): 60.930
cowboy-2.10.0, size=100M, 10times average(ms): 525.656
cowboy-2.10.0, size=1G, 10times average(ms): 5411.372
```

- 1MB: cowboy2/cowboy1 = 0.4
- 10MB: cowboy2/cowboy1 = 4.7
- 100MB: cowboy2/cowboy1 = 8.1
- 1GB: cowboy2/cowboy1 = 8.4
