defmodule Helper do
  use ParamPipe

  def rl(r) do
    Enum.random(r)
  end

  def rs(l) do
    Enum.take_random(?a..?z, l) |> to_string()
  end

  def generate(n, f, r) do
    # n is the count of generated data pair
    # f is string -> string function
    # r is the range of length
    1..n |> Enum.map(fn _ ->
      l = rl(r)
      s = rs(l)
      {s, apply(Case, f, [s])}
    end)
  end

  def sub_strings(s) do
    l = String.length(s)
    Enum.flat_map(1..l-1, fn x -> 
      Enum.map(0..l-x, fn y -> 
        String.split_at(s, y)
        |> elem(1)
        |> String.split_at(x)
        |> elem(0)
      end) 
    end)
  end

  def intersection(x, y) do
    [x, y]
    |> Enum.map(fn x -> Map.keys(x) |> MapSet.new() end)
    |> (fn [x, y] -> MapSet.intersection(x, y) |> MapSet.to_list() end).()
    |> Enum.reduce(%{}, fn k, acc ->
      [x, y]
      |> Enum.map(fn x -> Map.get(x, k) |> MapSet.new() end)
      |> (fn [x, y] -> MapSet.intersection(x, y) |> MapSet.to_list() end).()
      |-1> Map.put(acc, k) 
    end)
  end

end