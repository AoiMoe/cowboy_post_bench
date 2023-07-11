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

### Test1

```
$ grep average result.otp21/test1-log.txt
cowboy1.1.2-1M-10: average(ms)=18.766
cowboy1.1.2-10M-10: average(ms)=17.877
cowboy1.1.2-100M-10: average(ms)=69.127
cowboy1.1.2-1G-10: average(ms)=701.400
cowboy2.10.0-1M-10: average(ms)=13.695
cowboy2.10.0-10M-10: average(ms)=83.453
cowboy2.10.0-100M-10: average(ms)=729.878
cowboy2.10.0-1G-10: average(ms)=7489.999
```

- 1MB: cowboy2/cowboy1 = 0.7
- 10MB: cowboy2/cowboy1 = 4.7
- 100MB: cowboy2/cowboy1 = 10.6
- 1GB: cowboy2/cowboy1 = 10.7


### Test2

```
$ grep average result.otp21/test2-log.txt    
cowboy2.10.0-1G-10-active-n10-length8000000: average(ms)=7887.772
cowboy2.10.0-1G-10-active-n10-length80000000: average(ms)=7936.551
cowboy2.10.0-1G-10-active-n10-length800000000: average(ms)=7877.492
cowboy2.10.0-1G-10-active-n100-length8000000: average(ms)=7503.057
cowboy2.10.0-1G-10-active-n100-length80000000: average(ms)=7478.289
cowboy2.10.0-1G-10-active-n100-length800000000: average(ms)=7464.551
cowboy2.10.0-1G-10-active-n1000-length8000000: average(ms)=7724.781
cowboy2.10.0-1G-10-active-n1000-length80000000: average(ms)=7459.111
cowboy2.10.0-1G-10-active-n1000-length800000000: average(ms)=7428.073
cowboy2.10.0-1G-10-active-n10000-length8000000: average(ms)=7388.793
cowboy2.10.0-1G-10-active-n10000-length80000000: average(ms)=7362.439
cowboy2.10.0-1G-10-active-n10000-length800000000: average(ms)=7442.078
```

Changing `active_n` or `length` has little effect.


### Test3

```
$ grep ave result.otp21/test3*.txt
cowboy2_so_buffer-1G-10-so-buffer1460: average(ms)=7588.170
cowboy2_so_buffer-1G-10-so-buffer8192: average(ms)=2088.018
cowboy2_so_buffer-1G-10-so-buffer16384: average(ms)=1478.754
cowboy2_so_buffer-1G-10-so-buffer32768: average(ms)=1152.600
cowboy2_so_buffer-1G-10-so-buffer65536: average(ms)=978.629
cowboy2_so_buffer-1G-10-so-buffer131072: average(ms)=870.632
cowboy2_so_buffer-1G-10-so-buffer262144: average(ms)=838.661
cowboy2_so_buffer-1G-10-so-buffer524288: average(ms)=1078.477
```

- 1460-262144 : The bigger the better performance.
- 524288 : Too big and it is conterproductive.
