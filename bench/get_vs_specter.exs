defmodule Paths do
  use Pathex

  def path1(), do: path(:a / :b / :c, :map)

  def inlined(x) do
    Pathex.view(x, path(:a / :b / :c, :map))
  end

  def path2() do
    path(:a) ~> path(:b) ~> path(:c)
  end
end

path1 = Paths.path1()
path2 = Paths.path2()
bigstructure = %{a: %{b: %{c: 1}}}

require Pathex

%{
  "simple" => fn ->
    Pathex.view(bigstructure, path1)
  end,
  "composed" => fn ->
    Pathex.view(bigstructure, path2)
  end,
  "inlined" => fn ->
    Paths.inlined(bigstructure)
  end
}
|> Benchee.run(
  warmup: 2,
  time: 5
)
