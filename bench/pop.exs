defmodule Pop do
  import Pathex

  def inlined(structure) do
    pop!(structure, path(:x / :y / :z / 3, :json))
  end

  def regular(structure) do
    p = path(:x / :y / :z / 3, :json)
    pop!(structure, p)
  end

  def naive(structure) do
    p = path(:x / :y / :z / 3, :naive)
    pop!(structure, p)
  end

  def access(structure) do
    pop_in(structure, [Access.key(:x), Access.key(:y), Access.key(:z), Access.at!(3)])
  end

  def naive_access(structure) do
    pop_in(structure, [:x, :y, :z, Access.at!(3)])
  end

end

structure = %{x: %{y: %{z: [1, 2, 3, 4]}}}

runs = %{
  "inlined" => fn -> Pop.inlined(structure) end,
  "regular" => fn -> Pop.regular(structure) end,
  "naive" => fn -> Pop.naive(structure) end,
  "access" => fn -> Pop.access(structure) end,
  "naive_access" => fn -> Pop.access(structure) end
}

Enum.reduce(runs, {4, %{x: %{y: %{z: [1, 2, 3]}}}}, fn {_, f}, res -> ^res = IO.inspect f.() end)

Benchee.run(runs, warmup: 2, time: 5, memory_time: 2)
