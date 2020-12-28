This project shows efficency of `Pathex` path-closures,
`Focus`, `Lens` and builtin `put_in`, `get_in`

Current `pathex` version is `1.2.0`

```
Operating System: Linux
Number of Available Cores: 4
Available memory: 3.79 GB
Elixir 1.10.2
Erlang 23.0.2
```

Get value
```
Name               ips        average  deviation         median         99th %
inlined        38.93 M       25.69 ns ±51655.82%           0 ns           0 ns
get_in         23.34 M       42.84 ns ±49981.22%           0 ns         329 ns
simple         19.87 M       50.33 ns ±63091.37%           0 ns          91 ns
varpath        10.22 M       97.87 ns ±36768.89%           0 ns         492 ns
composed        8.02 M      124.71 ns ±18738.85%           0 ns        1287 ns
focus           1.57 M      636.80 ns  ±4634.70%         474 ns        1995 ns
lens            0.45 M     2230.26 ns  ±1254.69%        1614 ns     5995.58 ns

Comparison:
inlined        38.93 M
get_in         23.34 M - 1.67x slower +17.15 ns
simple         19.87 M - 1.96x slower +24.64 ns
varpath        10.22 M - 3.81x slower +72.18 ns
composed        8.02 M - 4.86x slower +99.02 ns
focus           1.57 M - 24.79x slower +611.11 ns
lens            0.45 M - 86.83x slower +2204.57 ns
```

Set value

```
Name               ips        average  deviation         median         99th %
inlined        11.17 M       89.50 ns ±36855.28%           0 ns         489 ns
map mod         5.33 M      187.71 ns ±18324.76%           0 ns         923 ns
simply          5.01 M      199.54 ns ±17766.20%           0 ns         949 ns
varpath         4.25 M      235.09 ns ±16993.84%           0 ns        1139 ns
put_in          1.01 M      991.73 ns  ±3325.34%         533 ns        3048 ns
composed        0.98 M     1023.97 ns  ±3273.74%         479 ns        3275 ns
lens            0.40 M     2479.04 ns  ±1407.15%        1631 ns     8127.50 ns
focus           0.21 M     4834.19 ns   ±549.19%        3697 ns       14867 ns

Comparison:
inlined        11.17 M
map mod         5.33 M - 2.10x slower +98.20 ns
simply          5.01 M - 2.23x slower +110.03 ns
varpath         4.25 M - 2.63x slower +145.59 ns
put_in          1.01 M - 11.08x slower +902.23 ns
composed        0.98 M - 11.44x slower +934.46 ns
lens            0.40 M - 27.70x slower +2389.54 ns
focus           0.21 M - 54.01x slower +4744.69 ns
```

---

> Complete results and tests you can find in `bench` directory
