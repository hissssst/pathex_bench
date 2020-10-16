This project shows efficency of `Pathex` path-closures,
`Focus` lenses and builtin `put_in`, `get_in`

Current `pathex` version is `1.0.0`

Get value
```
Operating System: Linux
Number of Available Cores: 4
Available memory: 3.79 GB
Elixir 1.10.2
Erlang 23.0.2

Benchmark suite executing with the following configuration:
warmup: 1 s
time: 2 s
memory time: 0 ns
parallel: 1

Name               ips        average  deviation         median         99th %
inlined        13.98 M       71.52 ns ±28919.15%           0 ns         259 ns
simple         12.74 M       78.52 ns ±28689.89%           0 ns         410 ns
varpath        11.49 M       87.01 ns ±27885.22%           0 ns         361 ns
get_in          5.19 M      192.62 ns ±11332.68%          85 ns         690 ns
composed        1.55 M      644.77 ns  ±3763.49%         397 ns        2200 ns
focus           1.29 M      772.44 ns  ±3273.19%         548 ns     2034.77 ns

Comparison:
inlined        13.98 M
simple         12.74 M - 1.10x slower +7.00 ns
varpath        11.49 M - 1.22x slower +15.49 ns
get_in          5.19 M - 2.69x slower +121.10 ns
composed        1.55 M - 9.02x slower +573.25 ns
focus           1.29 M - 10.80x slower +700.92 ns
```

Set value

```
Operating System: Linux
Number of Available Cores: 4
Available memory: 3.79 GB
Elixir 1.10.2
Erlang 23.0.2

Benchmark suite executing with the following configuration:
warmup: 1 s
time: 2 s
memory time: 0 ns
parallel: 1
inputs: none specified
Estimated total run time: 18 s

Name               ips        average  deviation         median         99th %
inlined         1.75 M        0.57 μs  ±4637.20%        0.41 μs        1.22 μs
varpath         1.52 M        0.66 μs  ±4173.68%        0.46 μs        1.21 μs
simply          1.51 M        0.66 μs  ±4372.63%        0.45 μs        1.23 μs
composed        0.86 M        1.16 μs  ±1888.03%        0.79 μs        2.48 μs
put_in          0.63 M        1.60 μs  ±1508.69%        1.15 μs        3.48 μs
focus           0.22 M        4.54 μs   ±186.26%        3.62 μs       14.85 μs

Comparison:
inlined         1.75 M
varpath         1.52 M - 1.15x slower +0.0856 μs
simply          1.51 M - 1.15x slower +0.0876 μs
composed        0.86 M - 2.02x slower +0.58 μs
put_in          0.63 M - 2.79x slower +1.02 μs
focus           0.22 M - 7.92x slower +3.96 μs
```
