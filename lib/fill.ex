defmodule Fill do
  # use ParamPipe
  # use jaro_distance as loss function
  # use myers_difference as a heuristics

  import Helper
  import DSL

  # Fill.fit0 10, :f, 4..10
  # ok for :f0, :f1, :f2
  def fit0(n, f, r) do
    generate(n, f, r, :down)
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

  # Fill.fit1 10, :f, 4..10
  # ok for :f0, :f1, :f2, :a0, :a1
  
  # Fill.fit1 20, :p1, 8..10
  # Fill.fit1 20, :p2, 20..22
  def fit1(n, f, r) do
    generate(n, f, r, :all)
    |> Enum.map(fn {s0, s1} -> 
      d = String.myers_difference(s0, s1)
      flat_search(d, [], s0, s1)
      |> (fn x -> {{s0, s1}, x} end).()
    end)
    |> merge1()
  end

end
