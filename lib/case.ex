defmodule Case do
  def f1(s) do
    # just upcase the first letter
    String.split_at(s, 1) |> (fn {x, y} -> String.upcase(x) <> y end).() 
  end
end