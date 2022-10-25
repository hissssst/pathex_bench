use Pathex
import Pathex.Lenses
import Pathex.Combinator

require Meeseeks.CSS

html = File.read!("elixir-org.html")
{:ok, document} = Floki.parse_document(html)

defmodule Viewer do

  import Pathex.HTML.Language, only: [html: 0]

  def attrs_filter(with_attrs) do
    filtering(fn
      {_, tag_attrs, _} = node ->
        with_attrs -- tag_attrs == []

      _ ->
        false
    end)
  end

  def id_filter(id) do
    filtering(fn
      {_, attrs, _} = node ->
        match?(^id, :proplists.get_value("id", attrs, nil))

      _ ->
        false
    end)
  end

  def class_filter(class) do
    filtering(fn
      {_, attrs, _} = node ->
        case :proplists.get_value("class", attrs, nil) do
          nil -> false
          "widget" -> true
          "widget " <> _ -> true
          _ -> false
        end

      _ ->
        false
    end)
  end

  def find_searchq_pathex_precompiled(document, lens) do
    document
    |> Pathex.view!(lens)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.sort()
  end

  def find_searchq_pathex(document) do
    lens = walking(star() ~> id_filter("searchq"))

    document
    |> Pathex.view!(lens)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.sort()
  end

  def find_searchq_pathex_html(document) do
    lens = html() ~> Pathex.HTML.selector("#searchq", :floki)
    Pathex.inspect lens

    document
    |> Pathex.view!(lens)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.sort()
  end

  def find_searchq_floki(document) do
    Floki.find(document, "#searchq") |> Enum.sort()
  end

  def find_searchq_meeseeks_runtime(document, searchq) do
    document
    |> Meeseeks.all(Meeseeks.CSS.css(searchq))
    |> Enum.map(&Meeseeks.tree/1)
    |> Enum.sort()
  end

  def find_searchq_meeseeks_prepared(document) do
    document
    |> Meeseeks.all(Meeseeks.CSS.css("#searchq"))
    |> Enum.map(&Meeseeks.tree/1)
    |> Enum.sort()
  end

  def find_searchq_meeseeks(document) do
    document
    |> Meeseeks.parse(:tuple_tree)
    |> Meeseeks.all(Meeseeks.CSS.css("#searchq"))
    |> Enum.map(&Meeseeks.tree/1)
    |> Enum.sort()
  end

  def lazy(inner) do
    fn op, argtuple -> (inner.()).(op, argtuple) end
  end

  def walking(predicate) do
    combine(fn recursive ->
      predicate
      ~> (
        alongside([
          star() ~> path(2 :: :tuple) ~> recursive,
          matching(_)
        ])
        ||| matching(_)
      )
      ||| (star() ~> path(2 :: :tuple) ~> recursive)
    end)
  end

  def find_widget_pathex(document) do
    lens = walking(star() ~> class_filter("widget"))

    document
    |> Pathex.view!(lens)
    |> List.flatten()
    |> Enum.sort()
  end

  def find_widget_floki(document) do
    Floki.find(document, ".widget") |> Enum.sort()
  end

  def update_widget_pathex(document) do
    lens = walking(star() ~> class_filter("widget"))

    Pathex.over!(document, lens, fn {name, attrs, body} ->
      {name, [{"hey", "there"} | attrs], body}
    end)
  end

  def update_widget_pathex_html(document) do
    lens = html() ~> Pathex.HTML.selector(".widget", :floki)

    Pathex.over!(document, lens, fn {name, attrs, body} ->
      {name, [{"hey", "there"} | attrs], body}
    end)
  end

  def update_widget_floki(document) do
    Floki.find_and_update(document, ".widget", fn {name, attrs} ->
      {name, [{"hey", "there"} | attrs]}
    end)
  end

  def run_benchee(funcs) do
    [res | other] = Enum.map(funcs, fn {_name, f} -> f.() end)
    true = Enum.all?(other, & &1 === res)

    Benchee.run(
      funcs,
      [warmup: 2, time: 5]
    )
  end

end

# Viewer.run_benchee(
#   floki:       fn -> Viewer.update_widget_floki(document) end,
#   pathex:      fn -> Viewer.update_widget_pathex(document) end,
#   pathex_html: fn -> Viewer.update_widget_pathex_html(document) end
# )

# Viewer.run_benchee(
#   fn -> Viewer.find_widget_floki(document) end,
#   fn -> Viewer.find_widget_pathex(document) end
# )

meeseeks_doc = Meeseeks.parse(document, :tuple_tree)
searchq_select = Viewer.walking(star() ~> Viewer.id_filter("searchq"))

Viewer.run_benchee(%{
  meeseeks_prepared:  fn -> Viewer.find_searchq_meeseeks_prepared(meeseeks_doc) end,
  meeseeks_fromtuple: fn -> Viewer.find_searchq_meeseeks(document) end,
  meeseeks_runtime:   fn -> Viewer.find_searchq_meeseeks_runtime(meeseeks_doc, "#searchq") end,

  floki:       fn -> Viewer.find_searchq_floki(document) end,
  pathex:      fn -> Viewer.find_searchq_pathex(document) end,
  pathex_pre:  fn -> Viewer.find_searchq_pathex_precompiled(document, searchq_select) end,
  pathex_html: fn -> Viewer.find_searchq_pathex_html(document) end
})
