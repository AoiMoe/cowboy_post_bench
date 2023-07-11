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

### Test1

```
$ grep average result.otp26/test1-log.txt
cowboy1.1.2-1M-10: average(ms)=10.182
cowboy1.1.2-10M-10: average(ms)=12.260
cowboy1.1.2-100M-10: average(ms)=68.285
cowboy1.1.2-1G-10: average(ms)=806.812
cowboy2.10.0-1M-10: average(ms)=12.695
cowboy2.10.0-10M-10: average(ms)=78.526
cowboy2.10.0-100M-10: average(ms)=718.439
cowboy2.10.0-1G-10: average(ms)=7257.001
```

- 1MB: cowboy2/cowboy1 = 1.2
- 10MB: cowboy2/cowboy1 = 6.4
- 100MB: cowboy2/cowboy1 = 10.5
- 1GB: cowboy2/cowboy1 = 9.0


### Test2

```
$ grep average result.otp26/test2-log.txt
cowboy2.10.0-1G-10-active-n10-length8000000: average(ms)=7778.305
cowboy2.10.0-1G-10-active-n10-length80000000: average(ms)=7614.556
cowboy2.10.0-1G-10-active-n10-length800000000: average(ms)=7563.244
cowboy2.10.0-1G-10-active-n100-length8000000: average(ms)=7334.242
cowboy2.10.0-1G-10-active-n100-length80000000: average(ms)=7312.322
cowboy2.10.0-1G-10-active-n100-length800000000: average(ms)=7260.507
cowboy2.10.0-1G-10-active-n1000-length8000000: average(ms)=7363.506
cowboy2.10.0-1G-10-active-n1000-length80000000: average(ms)=7447.815
cowboy2.10.0-1G-10-active-n1000-length800000000: average(ms)=7317.825
cowboy2.10.0-1G-10-active-n10000-length8000000: average(ms)=7265.109
cowboy2.10.0-1G-10-active-n10000-length80000000: average(ms)=7327.915
cowboy2.10.0-1G-10-active-n10000-length800000000: average(ms)=7585.791
```

Changing `active_n` or `length` has little effect.


### Test3

```
$ grep ave result.otp26/test3*.txt
cowboy2_so_buffer-1G-10-so-buffer1460: average(ms)=7462.431
cowboy2_so_buffer-1G-10-so-buffer8192: average(ms)=2088.745
cowboy2_so_buffer-1G-10-so-buffer16384: average(ms)=1460.635
cowboy2_so_buffer-1G-10-so-buffer32768: average(ms)=1154.215
cowboy2_so_buffer-1G-10-so-buffer65536: average(ms)=981.736
cowboy2_so_buffer-1G-10-so-buffer131072: average(ms)=883.305
cowboy2_so_buffer-1G-10-so-buffer262144: average(ms)=836.368
cowboy2_so_buffer-1G-10-so-buffer524288: average(ms)=893.081
```

- 1460-262144 : The bigger the better performance.
- 524288 : Too big and it is conterproductive.
