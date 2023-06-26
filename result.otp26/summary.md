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
    - no JIT

### Averages

```
grep average result.otp26/test-log.txt
cowboy-1.1.2, size=1M, 10times average(ms): 14.432
cowboy-1.1.2, size=10M, 10times average(ms): 11.727
cowboy-1.1.2, size=100M, 10times average(ms): 66.124
cowboy-1.1.2, size=1G, 10times average(ms): 655.953
cowboy-2.10.0, size=1M, 10times average(ms): 8.775
cowboy-2.10.0, size=10M, 10times average(ms): 78.580
cowboy-2.10.0, size=100M, 10times average(ms): 726.954
cowboy-2.10.0, size=1G, 10times average(ms): 7287.101
```

- 1MB: cowboy2/cowboy1 = 0.6
- 10MB: cowboy2/cowboy1 = 6.7
- 100MB: cowboy2/cowboy1 = 11.0
- 1GB: cowboy2/cowboy1 = 11.1
