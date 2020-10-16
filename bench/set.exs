import Pathex, except: ["~>": 2]
require Pathex

import Focus, only: ["~>": 2]
require Focus

bigstructure = %{
  x: %{x: %{x: %{x: %{x: %{x: 1}}}}}
}

resstructure = %{
  x: %{x: %{x: %{x: %{x: %{x: 2}}}}}
}

path1 = path :x/:x/:x/:x/:x/:x
pathx = path :x

var = :x
pathvar = path var/var/var/var/var/var

path2 =
  Pathex.~>(pathx,
    Pathex.~>(pathx,
      Pathex.~>(pathx,
        Pathex.~>(pathx,
          Pathex.~>(pathx, pathx)
        )
      )
    )
  )

lensx = Lens.make_lens(:x)
lens = lensx ~> lensx ~> lensx ~> lensx ~> lensx ~> lensx

%{
  "put_in" => fn ->
    ^resstructure = put_in(bigstructure, [:x, :x, :x, :x, :x, :x], 2)
  end,

  "inlined" => fn ->
    {:ok, ^resstructure} = set bigstructure, path(:x/:x/:x/:x/:x/:x), 2
  end,

  "varpath" => fn ->
    {:ok, ^resstructure} = set bigstructure, pathvar, 2
  end,

  "simply" => fn ->
    {:ok, ^resstructure} = set bigstructure, path1, 2
  end,

  "composed" => fn ->
    {:ok, ^resstructure} = set bigstructure, path2, 2
  end,

  "focus" => fn ->
    ^resstructure = lens |> Focus.set(bigstructure, 2)
  end
}
|> Benchee.run(
  warmup: 1,
  time: 2
)

"""
Operating System: Linux
Number of Available Cores: 4
Available memory: 3.79 GB
Elixir 1.10.2
Erlang 22.3.1

Benchmark suite executing with the following configuration:
warmup: 1 s
time: 2 s
memory time: 0 ns
reduction time: 0 ns
parallel: 1
inputs: none specified
Estimated total run time: 15 s

Name               ips        average  deviation         median         99th %
simply       1644.61 K        0.61 μs  ±2884.44%        0.47 μs        1.55 μs
varpath      1469.09 K        0.68 μs  ±3070.33%        0.50 μs        1.77 μs
composed      870.99 K        1.15 μs  ±1980.35%        0.88 μs        3.39 μs
put_in        661.51 K        1.51 μs  ±1428.16%        1.05 μs        3.73 μs
focus         205.70 K        4.86 μs   ±156.35%        3.91 μs       16.92 μs

Comparison:
simply       1644.61 K
varpath      1469.09 K - 1.12x slower +0.0726 μs
composed      870.99 K - 1.89x slower +0.54 μs
put_in        661.51 K - 2.49x slower +0.90 μs
focus         205.70 K - 8.00x slower +4.25 μs
"""
