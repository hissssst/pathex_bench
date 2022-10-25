defmodule Helper do

  def ifsample(keyword, func) do
    if Keyword.has_key?(keyword, :x) do
      Keyword.update!(keyword, :x, fn x ->
        x |> func.()
      end)
    end
  end

  def fetchsample(keyword, func) do
    with {:ok, new_value} <- Keyword.fetch(keyword, :x) do
      Keyword.put(keyword, :x, new_value |> func.())
    end
  end

end

input = [a: 1, b: 2, c: 3, d: 4, x: 5, y: 6]
output = [a: 1, b: 2, c: 3, d: 4, x: 15, y: 6]
func = fn x -> x + 10 end

^output = Helper.ifsample(input, func)
^output = Helper.fetchsample(input, func)

%{
  "if" => fn ->
    Helper.ifsample(input, func)
  end,
  "fetch" => fn ->
    Helper.fetchsample(input, func)
  end,
}
|> Benchee.run(
  warmup: 2,
  time: 5
)
