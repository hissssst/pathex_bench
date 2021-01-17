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
inlined        80.20 M       12.47 ns ±56492.76%           0 ns           0 ns
get_in         26.19 M       38.19 ns ±55690.02%           0 ns           0 ns
simple         23.61 M       42.36 ns ±72760.78%           0 ns           0 ns
varpath        12.79 M       78.16 ns ±42297.54%           0 ns           0 ns
composed        5.61 M      178.13 ns ±19602.03%           0 ns         790 ns
focus           2.36 M      423.06 ns  ±6940.72%         255 ns        1067 ns
lens            0.50 M     2007.94 ns  ±1426.55%        1357 ns        7610 ns

Comparison:
inlined        80.20 M
get_in         26.19 M - 3.06x slower +25.72 ns
simple         23.61 M - 3.40x slower +29.89 ns
varpath        12.79 M - 6.27x slower +65.69 ns
composed        5.61 M - 14.29x slower +165.66 ns
focus           2.36 M - 33.93x slower +410.59 ns
lens            0.50 M - 161.04x slower +1995.47 ns
```

Set value

```
Name               ips        average  deviation         median         99th %
inlined        16.96 M       58.97 ns ±38021.19%           0 ns         280 ns
varpath         7.29 M      137.09 ns ±30336.96%           0 ns         426 ns
simply          6.80 M      147.15 ns ±28481.65%           0 ns         317 ns
map mod         6.54 M      152.95 ns ±28904.50%           0 ns         375 ns
composed        1.33 M      750.61 ns  ±4751.99%         422 ns     1445.09 ns
put_in          1.27 M      790.25 ns  ±4130.77%         496 ns        1802 ns
lens            0.45 M     2233.56 ns  ±1294.40%        1638 ns        4500 ns
focus           0.25 M     4005.91 ns   ±716.66%        3322 ns       13143 ns

Comparison:
inlined        16.96 M
varpath         7.29 M - 2.32x slower +78.12 ns
simply          6.80 M - 2.50x slower +88.18 ns
map mod         6.54 M - 2.59x slower +93.98 ns
composed        1.33 M - 12.73x slower +691.64 ns
put_in          1.27 M - 13.40x slower +731.28 ns
lens            0.45 M - 37.87x slower +2174.59 ns
focus           0.25 M - 67.93x slower +3946.93 ns
```

---

> Complete results and tests you can find in `bench` directory
