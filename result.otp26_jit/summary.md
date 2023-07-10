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

### Test1

```
$ grep average result.otp26_jit/test1-log.txt
cowboy1.1.2-1M-10: average(ms)=6.171
cowboy1.1.2-10M-10: average(ms)=12.219
cowboy1.1.2-100M-10: average(ms)=68.612
cowboy1.1.2-1G-10: average(ms)=743.383
cowboy2.10.0-1M-10: average(ms)=14.379
cowboy2.10.0-10M-10: average(ms)=64.766
cowboy2.10.0-100M-10: average(ms)=545.160
cowboy2.10.0-1G-10: average(ms)=5615.298
```

- 1MB: cowboy2/cowboy1 = 2.3
- 10MB: cowboy2/cowboy1 = 5.3
- 100MB: cowboy2/cowboy1 = 7.9
- 1GB: cowboy2/cowboy1 = 7.6


### Test2

```
$ grep average result.otp26_jit/test2-log.txt
cowboy2.10.0-1G-10-active-n10-length8000000: average(ms)=6200.232
cowboy2.10.0-1G-10-active-n10-length80000000: average(ms)=6345.807
cowboy2.10.0-1G-10-active-n10-length800000000: average(ms)=6243.578
cowboy2.10.0-1G-10-active-n100-length8000000: average(ms)=5605.120
cowboy2.10.0-1G-10-active-n100-length80000000: average(ms)=5608.048
cowboy2.10.0-1G-10-active-n100-length800000000: average(ms)=5592.340
cowboy2.10.0-1G-10-active-n1000-length8000000: average(ms)=5518.947
cowboy2.10.0-1G-10-active-n1000-length80000000: average(ms)=5529.960
cowboy2.10.0-1G-10-active-n1000-length800000000: average(ms)=5497.716
cowboy2.10.0-1G-10-active-n10000-length8000000: average(ms)=5655.809
cowboy2.10.0-1G-10-active-n10000-length80000000: average(ms)=5506.548
cowboy2.10.0-1G-10-active-n10000-length800000000: average(ms)=5643.722
```

Changing `active_n` or `length` has little effect.
