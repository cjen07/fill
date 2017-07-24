defmodule Fill do
  # use jaro_distance as loss function
  # use myers_difference as a heuristics

  import Helper
  import DSL

  # Fill.fit0 10, :f, 4..10
  # ok for :f0, :f1, :f2
  def fit0(n, f, r) do
    generate(n, f, r)
    |> Enum.map(fn {s0, s1} -> 
      d = String.myers_difference(s0, s1)
      Enum.flat_map(d, fn {k, v} -> 
        case k do
          :del -> [:ok]
          :eq -> [train_bk(s0, v)]
          :ins -> 
            cond do
              String.contains?(s0, v) ->
                [train_bk(s0, v)]
              String.contains?(s0, down(v)) 
              && up(down(v)) == v ->
                [:up, train_bk(s0, down(v))]
              true ->
                throw(:error1)
            end    
        end
      end) 
    end)
    |> merge()
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
