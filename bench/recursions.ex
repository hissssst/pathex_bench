defmodule Helpers do

  use Pathex
  import Pathex.Combinator
  import Pathex.Lenses

  def x(v), do: %{x: v}

  def x2(v), do: x(x(v))

  def x8(v), do: x2(x2(x2(x2(v))))

  def x32(v), do: x8(x8(x8(x8(v))))

  def x128(v), do: x32(x32(x32(x32(v))))

  def x512(v), do: x128(x128(x128(x128(v))))

  def rectest(x) do
    lens = rec(fn lens -> path(:x, :map) ~> (lens ||| matching(_)) end)
    Pathex.view!(x, lens)
  end

  def ytest(x) do
    lens = y(fn lens -> path(:x, :map) ~> (lens ||| matching(_)) end)
    Pathex.view!(x, lens)
  end

end

%{
  "y"   => fn x -> 1 = Helpers.ytest(x) end,
  "rec" => fn x -> 1 = Helpers.rectest(x) end
}
|> Benchee.run(warmup: 1, time: 4, memory_time: 1, inputs: %{
  1   => Helpers.x(1),
  2   => Helpers.x2(1),
  8   => Helpers.x8(1),
  32  => Helpers.x32(1),
  128 => Helpers.x128(1),
  512 => Helpers.x512(1),
})

"""
Operating System: Linux
CPU Information: 11th Gen Intel(R) Core(TM) i7-1185G7 @ 3.00GHz
Number of Available Cores: 8
Available memory: 15.35 GB
Elixir 1.13.3
Erlang 24.2

Benchmark suite executing with the following configuration:
warmup: 1 s
time: 3 s
memory time: 0 ns
parallel: 1
inputs: 1, 2, 8, 32, 128, 512
Estimated total run time: 48 s

Benchmarking rec with input 1...
Benchmarking rec with input 2...
Benchmarking rec with input 8...
Benchmarking rec with input 32...
Benchmarking rec with input 128...
Benchmarking rec with input 512...
Benchmarking y with input 1...
Benchmarking y with input 2...
Benchmarking y with input 8...
Benchmarking y with input 32...
Benchmarking y with input 128...
Benchmarking y with input 512...

##### With input 1 #####
Name           ips        average  deviation         median         99th %
y           2.52 M      396.53 ns  ±5838.46%         179 ns         558 ns
rec         2.46 M      406.30 ns  ±6030.25%         173 ns         535 ns

Comparison:
y           2.52 M
rec         2.46 M - 1.02x slower +9.77 ns

##### With input 2 #####
Name           ips        average  deviation         median         99th %
rec         1.98 M      505.58 ns  ±4961.43%         244 ns         673 ns
y           1.84 M      542.24 ns  ±4849.87%         266 ns         757 ns

Comparison:
rec         1.98 M
y           1.84 M - 1.07x slower +36.66 ns

##### With input 8 #####
Name           ips        average  deviation         median         99th %
rec       790.32 K        1.27 μs  ±1677.70%        0.68 μs        1.62 μs
y         734.77 K        1.36 μs  ±1733.67%        0.73 μs        1.90 μs

Comparison:
rec       790.32 K
y         734.77 K - 1.08x slower +0.0957 μs

##### With input 32 #####
Name           ips        average  deviation         median         99th %
rec       278.77 K        3.59 μs   ±483.26%        2.38 μs       40.55 μs
y         259.76 K        3.85 μs   ±368.64%        2.59 μs       42.66 μs

Comparison:
rec       278.77 K
y         259.76 K - 1.07x slower +0.26 μs

##### With input 128 #####
Name           ips        average  deviation         median         99th %
rec        83.43 K       11.99 μs    ±92.43%        8.39 μs       74.53 μs
y          73.79 K       13.55 μs    ±81.28%        9.58 μs       76.68 μs

Comparison:
rec        83.43 K
y          73.79 K - 1.13x slower +1.57 μs

##### With input 512 #####
Name           ips        average  deviation         median         99th %
rec        16.23 K       61.62 μs    ±37.94%       50.50 μs      137.45 μs
y          14.68 K       68.14 μs    ±36.59%       56.40 μs      152.07 μs

Comparison:
rec        16.23 K
y          14.68 K - 1.11x slower +6.52 μs
"""
