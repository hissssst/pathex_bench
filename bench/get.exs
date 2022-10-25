import Pathex
require Pathex

require Focus

bigstructure = %{
  x: %{x: %{x: %{x: %{x: [1, 2, 3, 4]}}}}
}

defmodule Paths do

  defmacro debug(code) do
    code
    |> Macro.expand(__CALLER__)
    |> Macro.to_string()
    |> Code.format_string!()
    |> IO.puts

    code
  end

  def pattern_matching(structure) do
    %{x: %{x: %{x: %{x: %{x: [_, _, _, value | _]}}}}} = structure
    value
  end

  def path1(), do: path(:x / :x / :x / :x / :x / 3)

  def pathvar(var) do
    index = 3
    path(var / var / var) ~> path(var / var / index)
  end

  def inlined(x) do
    view(x, path(:x / :x / :x / :x / :x / 3, :json))
  end

  def do_get_in(x, list) do
    get_in(x, list)
  end

  def path2() do
    pathx = path(:x, :map)
    pathlist = path(3)

    pathx ~> pathx ~> pathx ~> pathx ~> pathx ~> pathlist
  end

  def path3() do
    path(:x / :x / :x / :x / :x, :map) ~> path(3)
  end

  def focus(var) do
    lensx = Lens.make_lens(var)
    lens3 = Lens.idx(3)
    Focus.compose(
      lensx,
      Focus.compose(
        lensx,
        Focus.compose(
          lensx,
          Focus.compose(
            lensx,
            Focus.compose(lensx, lens3)
          )
        )
      )
    )
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

path1 = Paths.path1()
path2 = Paths.path2()
path3 = Paths.path3()
pathvar = Paths.pathvar(:x)
focus = Paths.focus(:x)
lens = Paths.lens(:x)

access_list = [:x, :x, :x, :x, :x, Access.at!(3)]

%{
  "pattern_matching" => fn ->
    4 = Paths.pattern_matching(bigstructure)
  end,
  "get_in" => fn ->
    4 = Paths.do_get_in(bigstructure, access_list)
  end,
  "optimized" => fn ->
    {:ok, 4} = view(bigstructure, path3)
  end,
  "varpath" => fn ->
    {:ok, 4} = view(bigstructure, pathvar)
  end,
  "simple" => fn ->
    {:ok, 4} = view(bigstructure, path1)
  end,
  "composed" => fn ->
    {:ok, 4} = view(bigstructure, path2)
  end,
  "inlined" => fn ->
    {:ok, 4} = Paths.inlined(bigstructure)
  end,
  "focus" => fn ->
    4 = Focus.view(focus, bigstructure)
  end,
  "lens" => fn ->
    4 = Lenss.one!(lens, bigstructure)
  end
}
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
Estimated total run time: 1.20 min

Name                       ips        average  deviation         median         99th %
pattern_matching       12.16 M       82.20 ns   ±338.71%          81 ns         101 ns
inlined                 8.11 M      123.36 ns ±10801.45%          94 ns         156 ns
simple                  7.25 M      137.99 ns ±10943.52%         102 ns         169 ns
optimized               5.95 M      168.18 ns ±15513.69%         122 ns         215 ns
get_in                  5.08 M      196.96 ns ±12149.67%         145 ns         327 ns
varpath                 4.25 M      235.05 ns ±17714.94%         140 ns         296 ns
composed                3.06 M      327.11 ns  ±8591.52%         192 ns         426 ns
focus                   2.54 M      393.05 ns  ±4786.24%         319 ns         597 ns
lens                    0.91 M     1101.06 ns  ±2514.16%         792 ns        1413 ns

Comparison:
pattern_matching       12.16 M
inlined                 8.11 M - 1.50x slower +41.16 ns
simple                  7.25 M - 1.68x slower +55.78 ns
optimized               5.95 M - 2.05x slower +85.98 ns
get_in                  5.08 M - 2.40x slower +114.75 ns
varpath                 4.25 M - 2.86x slower +152.85 ns
composed                3.06 M - 3.98x slower +244.91 ns
focus                   2.54 M - 4.78x slower +310.84 ns
lens                    0.91 M - 13.39x slower +1018.85 ns

Memory usage statistics:

Name                Memory usage
pattern_matching             0 B
inlined                     72 B - ∞ x memory usage +72 B
simple                      96 B - ∞ x memory usage +96 B
optimized                  208 B - ∞ x memory usage +208 B
get_in                      88 B - ∞ x memory usage +88 B
varpath                    224 B - ∞ x memory usage +224 B
composed                   592 B - ∞ x memory usage +592 B
focus                      136 B - ∞ x memory usage +136 B
lens                      1592 B - ∞ x memory usage +1592 B

**All measurements for memory usage were the same**
"""
