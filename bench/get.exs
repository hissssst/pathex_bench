import Pathex, except: ["~>": 2]
require Pathex

import Focus, only: ["~>": 2]
require Focus

bigstructure = %{
  x: %{x: %{x: %{x: %{x: %{x: [1, 2, 3, 4]}}}}}
}

path_simple = path :x/:x/:x/:x/:x/:x/3
pathx = path :x
path_list3 = path 3

var = :x
pathvar = path var/var/var/var/var/var/3

path_composed =
  Pathex.~>(pathx,
    Pathex.~>(pathx,
      Pathex.~>(pathx,
        Pathex.~>(pathx,
          Pathex.~>(pathx, Pathex.~>(pathx, path_list3)
          )
        )
      )
    )
  )

lensx = Lens.make_lens(:x)
lens = lensx ~> lensx ~> lensx ~> lensx ~> lensx ~> lensx

%{
  "get_in" => fn ->
    [_, _, _, 4] = get_in(bigstructure, [:x,:x,:x,:x,:x,:x])
  end,

  "varpath" => fn ->
    {:ok, 4} = view pathvar, bigstructure
  end,

  "simple" => fn ->
    {:ok, 4} = view path_simple, bigstructure
  end,

  "composed" => fn ->
    {:ok, 4} = view path_composed, bigstructure
  end,

  "focus" => fn ->
    [_, _, _, 4] = lens |> Focus.view(bigstructure)
  end
}
|> Benchee.run(
  warmup: 1,
  time: 2
)

"""
Operating System: Linux
CPU Information: Intel(R) Core(TM) m3-7Y30 CPU @ 1.00GHz
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

Benchmarking composed...
Benchmarking focus...
Benchmarking get_in...
Benchmarking simple...
Benchmarking varpath...

Name               ips        average  deviation         median         99th %
simple          4.25 M      235.09 ns  ±6362.65%         173 ns         718 ns
varpath         4.22 M      237.01 ns  ±6173.02%         168 ns         703 ns
get_in          2.37 M      422.69 ns  ±2341.89%         356 ns        1210 ns
composed        1.58 M      634.44 ns  ±2773.69%         491 ns        1901 ns
focus           0.79 M     1268.32 ns  ±1607.95%         942 ns        3674 ns

Comparison:
simple          4.25 M
varpath         4.22 M - 1.01x slower +1.92 ns
get_in          2.37 M - 1.80x slower +187.60 ns
composed        1.58 M - 2.70x slower +399.35 ns
focus           0.79 M - 5.40x slower +1033.24 ns
"""
