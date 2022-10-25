import Pathex, except: [~>: 2]
require Pathex

import Focus, only: [~>: 2]
require Focus

bigstructure = %{
  x: %{x: %{x: %{x: %{x: [1, 2, 3, 4]}}}}
}

defmodule Paths do
  def path1(), do: path(:x / :x / :x / :x / :x / 3)

  def pathvar(var) do
    index = 3
    Pathex.~>(path(var / var / var), path(var / var / index))
  end

  def path2() do
    pathx = path(:x)

    Pathex.~>(
      pathx,
      Pathex.~>(
        pathx,
        Pathex.~>(
          pathx,
          Pathex.~>(
            pathx,
            Pathex.~>(pathx, path(3))
          )
        )
      )
    )
  end

  def path3(), do: path(:x / :x / :x / :x / :x / 3, :json)

  def focus(var) do
    lensx = Lens.make_lens(var)
    lensx ~> lensx ~> lensx ~> lensx ~> lensx ~> Lens.idx(3)
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
              Lenss.index(3)
            )
          )
        )
      )
    )
  end

  def inlined(x) do
    set!(x, path(:x / :x / :x / :x / :x / 3, :json), 2)
  end

end

path1 = Paths.path1()
path2 = Paths.path2()
path3 = Paths.path3()
pathvar = Paths.pathvar(:x)
focus = Paths.focus(:x)
lens = Paths.lens(:x)

access_path = [:x, :x, :x, :x, :x, Access.at!(3)]

%{
  "put_in" => fn ->
    put_in(bigstructure, access_path, 2)
  end,
  "inlined" => fn ->
    Paths.inlined(bigstructure)
  end,
  "varpath" => fn ->
    set!(bigstructure, pathvar, 2)
  end,
  "map mod" => fn ->
    set!(bigstructure, path3, 2)
  end,
  "simply" => fn ->
    set!(bigstructure, path1, 2)
  end,
  "composed" => fn ->
    set!(bigstructure, path2, 2)
  end,
  "focus" => fn ->
    focus |> Focus.set(bigstructure, 2)
  end,
  "lens" => fn ->
    Lenss.put(lens, bigstructure, 2)
  end
}
|> tap(fn m ->
  [head | tail] = Enum.map(m, fn {_, v} -> v.() end)
  true = Enum.all?(tail, & &1 == head)
end)
|> Benchee.run(
  warmup: 2,
  memory_time: 1,
  time: 5
)

"""
Operating System: Linux
CPU Information: 11th Gen Intel(R) Core(TM) i7-1185G7 @ 3.00GHz
Number of Available Cores: 8
Available memory: 15.35 GB
Elixir 1.13.4
Erlang 24.3.4.5

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
memory time: 1 s
reduction time: 0 ns
parallel: 1
inputs: none specified
Estimated total run time: 1.07 min

Name               ips        average  deviation         median         99th %
inlined         3.77 M      265.57 ns ±15839.66%         127 ns         329 ns
simply          3.50 M      285.65 ns ±14753.77%         165 ns         327 ns
map mod         3.47 M      288.32 ns ±17318.40%         153 ns         367 ns
varpath         2.72 M      367.57 ns  ±9741.91%         207 ns         457 ns
composed        2.01 M      496.68 ns  ±7102.10%         290 ns         607 ns
put_in          1.67 M      597.11 ns  ±5368.07%         345 ns         862 ns
lens            0.94 M     1063.91 ns  ±2598.91%         722 ns        1485 ns
focus           0.62 M     1621.40 ns  ±1110.46%        1386 ns        2478 ns

Comparison:
inlined         3.77 M
simply          3.50 M - 1.08x slower +20.08 ns
map mod         3.47 M - 1.09x slower +22.75 ns
varpath         2.72 M - 1.38x slower +102.01 ns
composed        2.01 M - 1.87x slower +231.11 ns
put_in          1.67 M - 2.25x slower +331.55 ns
lens            0.94 M - 4.01x slower +798.34 ns
focus           0.62 M - 6.11x slower +1355.83 ns

Memory usage statistics:

Name        Memory usage
inlined            296 B
simply             320 B - 1.08x memory usage +24 B
map mod            320 B - 1.08x memory usage +24 B
varpath            512 B - 1.73x memory usage +216 B
composed          1000 B - 3.38x memory usage +704 B
put_in            1000 B - 3.38x memory usage +704 B
lens              1552 B - 5.24x memory usage +1256 B
focus             1344 B - 4.54x memory usage +1048 B

**All measurements for memory usage were the same**
"""
