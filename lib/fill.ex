defmodule Fill do
  # use jaro_distance as loss function
  # use myers_distance as a heuristics

  import Helper

  def fit_bk(n, f, r) do
    generate(n, f, r)
    |> Enum.map(fn {s0, s1} -> train_bk(s0, s1) end)
    |> Enum.reduce_while(:start, fn x, acc ->
      case acc do
        :start ->
          {:cont, x}
        _ ->
          y = intersection(x, acc)
          if y == %{} do
            {:halt, %{}}
          else
            {:cont, y} 
          end
       end 
    end)
  end

  def train_bk(s0, s1) do
    %{bk1: train_bk1(s0, s1), bk2: train_bk2(s0, s1)}
  end

  def train_bk1(s0, s1) do
    Enum.flat_map(sub_strings(s0), fn s ->
      d = String.split(s0, s)
      l = length(d)
      Enum.flat_map(0..l-1, fn x -> 
        if Enum.at(d, x) == s1 do
          [{s, x}, {s, x-l}]
        else
          []
        end
      end)
    end)
  end

  def train_bk2(s0, s1) do
    l = String.length(s0)
    Enum.flat_map(1..l-1, fn x ->
      d = String.split_at(s0, x)
      Enum.flat_map([0, 1], fn y -> 
        if elem(d, y) == s1 do
          [{x, y}, {x-l, y}]
        else
          []
        end
      end)
    end)
  end

end
