defmodule Bench do
  import Pathex
  require Pathex

  def get_in_all(s) do
    get_in(s, [Access.all(), "a", "b"])
  end

  def get_in_all_key(s) do
    get_in(s, [Access.all(), Access.key("a"), Access.key("b")])
  end

  def pathex_all_get(s) do
    Pathex.get(s, Pathex.Lenses.all() ~> path("a" / "b"))
  end

  def pathex_all_view!(s) do
    Pathex.view!(s, Pathex.Lenses.all() ~> path("a" / "b"))
  end

  def pathex_star_view!(s) do
    Pathex.view!(s, Pathex.Lenses.star() ~> path("a" / "b", :map))
  end

  def pathex_all_path_from_list!(s) do
    Pathex.get(s, Pathex.Lenses.all() ~> Pathex.Accessibility.from_list(["a", "b"]))
  end
end

bigstructure = for i <- 1..100, do: %{"a" => %{"b" => i}}
resstructure = Enum.to_list 1..100

%{
  "get_in_all" => fn ->
    Bench.get_in_all bigstructure
  end,

  "get_in_all_key" => fn ->
    Bench.get_in_all_key bigstructure
  end,

  "pathex_all_get" => fn ->
    Bench.pathex_all_get bigstructure
  end,

  "pathex_star_view!" => fn ->
    Bench.pathex_star_view! bigstructure
  end,

  "pathex_all_view!" => fn ->
    Bench.pathex_all_view! bigstructure
  end,

  "pathex_all_path_from_list!" => fn ->
    Bench.pathex_all_path_from_list! bigstructure
  end
}
|> tap(fn benches ->
  Enum.each(benches, fn {_, f} -> ^resstructure = f.() end)
end)
|> Benchee.run(
  warmup: 2,
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
memory time: 0 ns
reduction time: 0 ns
parallel: 1
inputs: none specified
Estimated total run time: 42 s

Benchmarking get_in_all ...
Benchmarking get_in_all_key ...
Benchmarking pathex_all_get ...
Benchmarking pathex_all_path_from_list! ...
Benchmarking pathex_all_view! ...
Benchmarking pathex_star_view! ...

Name                                 ips        average  deviation         median         99th %
pathex_all_view!                271.21 K        3.69 μs   ±299.59%        3.45 μs        6.30 μs
pathex_star_view!               264.74 K        3.78 μs   ±307.38%        3.47 μs        5.48 μs
pathex_all_get                  262.27 K        3.81 μs   ±300.91%        3.50 μs        5.96 μs
get_in_all                      232.91 K        4.29 μs   ±340.34%        4.06 μs        6.18 μs
pathex_all_path_from_list!      135.59 K        7.37 μs   ±186.69%        6.25 μs       23.09 μs
get_in_all_key                  127.75 K        7.83 μs   ±237.44%        6.20 μs       49.58 μs

Comparison:
pathex_all_view!                271.21 K
pathex_star_view!               264.74 K - 1.02x slower +0.0901 μs
pathex_all_get                  262.27 K - 1.03x slower +0.126 μs
get_in_all                      232.91 K - 1.16x slower +0.61 μs
pathex_all_path_from_list!      135.59 K - 2.00x slower +3.69 μs
get_in_all_key                  127.75 K - 2.12x slower +4.14 μs
"""
