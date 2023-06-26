### Parameters
- Machine:
  - VirtualBox 7.0.4
    - 1 CPU
    - 16GB memory
  - Intel Core i9-9900K
- OS: Xubuntu 16.04 LTS
  - Linux 4.15.0-47-generic #50~16.04.1-Ubuntu SMP x86_64
- Erlang/OTP
  - OTP-21.3.8.18
  - Erlang (SMP,ASYNC_THREADS,HIPE) (BEAM) emulator version 10.3.5.14

### Averages

```
$ grep average result.otp21/test-log.txt
cowboy-1.1.2, size=1M, 10times average(ms): 9.882
cowboy-1.1.2, size=10M, 10times average(ms): 14.870
cowboy-1.1.2, size=100M, 10times average(ms): 67.726
cowboy-1.1.2, size=1G, 10times average(ms): 669.218
cowboy-2.10.0, size=1M, 10times average(ms): 9.929
cowboy-2.10.0, size=10M, 10times average(ms): 82.134
cowboy-2.10.0, size=100M, 10times average(ms): 722.683
cowboy-2.10.0, size=1G, 10times average(ms): 7354.874
```

- 1MB: almost the same.
- 10MB: cowboy2/cowboy1 = 5.5
- 100MB: cowboy2/cowboy1 = 10.7
- 1GB: cowboy2/cowboy1 = 11.0
