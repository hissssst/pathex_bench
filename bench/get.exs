import Pathex, except: ["~>": 2]
require Pathex

import Focus, only: ["~>": 2]
require Focus

bigstructure = %{
  x: %{x: %{x: %{x: %{x: [1, 2, 3, 4]}}}}
}

defmodule Paths do

  def path1(), do: path(:x/:x/:x/:x/:x/3)

  def pathvar(var) do
    index = 3
    path var/var/var/var/var/index
  end

  def path2() do
    pathx = path(:x, :map)
    pathlist = path(3)
    Pathex.~>(pathx,
      Pathex.~>(pathx,
        Pathex.~>(pathx,
          Pathex.~>(pathx,
            Pathex.~>(pathx, pathlist)
          )
        )
      )
    )
  end

  def focus(var) do
    lensx = Lens.make_lens(var)
    lens3 = Lens.idx(3)
    lensx ~> lensx ~> lensx ~> lensx ~> lensx ~> lens3
  end

  def lens(var) do
    Lenss.seq(
      Lenss.key(var),
      Lenss.seq(
        Lenss.key(var),
        Lenss.seq(
          Lenss.key(var),
          Lenss.seq(
            Lenss.key(var),
            Lenss.seq(
              Lenss.key(var),
              Lenss.at(3)
            )
          )
        )
      )
    )
  end

end

path1   = Paths.path1()
path2   = Paths.path2()
pathvar = Paths.pathvar(:x)
focus   = Paths.focus(:x)
lens    = Paths.lens(:x)

%{
  "get_in" => fn ->
    [_, _, _, 4] = get_in(bigstructure, [:x,:x,:x,:x,:x])
  end,

  "varpath" => fn ->
    {:ok, 4} = view bigstructure, pathvar
  end,

  "simple" => fn ->
    {:ok, 4} = view bigstructure, path1
  end,

  "composed" => fn ->
    {:ok, 4} = view bigstructure, path2
  end,

  "inlined" => fn ->
    {:ok, 4} = view bigstructure, path(:x/:x/:x/:x/:x/3)
  end,

  "focus" => fn ->
    4 = focus |> Focus.view(bigstructure)
  end,

  "lens" => fn ->
    4 = Lenss.one!(lens, bigstructure)
  end
}
|> Benchee.run(
  warmup: 2,
  time: 5
)

"""
Operating System: Linux
CPU Information: Intel(R) Core(TM) m3-7Y30 CPU @ 1.00GHz
Number of Available Cores: 4
Available memory: 3.72 GB
Elixir 1.10.2
Erlang 23.0.2

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
memory time: 0 ns
parallel: 1
inputs: none specified
Estimated total run time: 49 s

Benchmarking composed...
Benchmarking focus...
Benchmarking get_in...
Benchmarking inlined...
Benchmarking lens...
Benchmarking simple...
Benchmarking varpath...

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
"""
