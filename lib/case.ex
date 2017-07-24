defmodule Case do

  def f0(s) do
    String.split_at(s, 1) |> elem(1)
  end

  def f1(s) do
    String.split_at(s, 1) |> (fn {x, y} -> y <> x end).()
  end

  def f2(s) do
    # just upcase the first letter
    String.split_at(s, 1) |> (fn {x, y} -> String.upcase(x) <> y end).() 
  end
  
end