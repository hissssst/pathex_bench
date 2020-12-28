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

defmodule Paths do

  def path1(), do: path(:x/:x/:x/:x/:x/:x)

  def pathvar(var) do
    path var/var/var/var/var/var
  end

  def path2() do
    pathx = path(:x)
    Pathex.~>(pathx,
      Pathex.~>(pathx,
        Pathex.~>(pathx,
          Pathex.~>(pathx,
            Pathex.~>(pathx, pathx)
          )
        )
      )
    )
  end

  def path3(), do: path(:x/:x/:x/:x/:x/:x, :map)

  def focus(var) do
    lensx = Lens.make_lens(var)
    lensx ~> lensx ~> lensx ~> lensx ~> lensx ~> lensx
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
              Lenss.key(var)
            )
          )
        )
      )
    )
  end

end

path1   = Paths.path1()
path2   = Paths.path2()
path3   = Paths.path3()
pathvar = Paths.pathvar(:x)
focus   = Paths.focus(:x)
lens    = Paths.lens(:x)

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

  "map mod" => fn ->
    {:ok, ^resstructure} = set bigstructure, path3, 2
  end,

  "simply" => fn ->
    {:ok, ^resstructure} = set bigstructure, path1, 2
  end,

  "composed" => fn ->
    {:ok, ^resstructure} = set bigstructure, path2, 2
  end,

  "focus" => fn ->
    ^resstructure = focus |> Focus.set(bigstructure, 2)
  end,

  "lens" => fn ->
    ^resstructure = Lenss.put(lens, bigstructure, 2)
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
Estimated total run time: 56 s

Benchmarking composed...
Benchmarking focus...
Benchmarking inlined...
Benchmarking lens...
Benchmarking map mod...
Benchmarking put_in...
Benchmarking simply...
Benchmarking varpath...

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
"""
