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

  def f3(s) do
    # upcase the first letter
    # downcase the others
    String.split_at(s, 1) |> (fn {x, y} -> String.upcase(x) <> String.downcase(y) end).() 
  end

  def a0(s) do
    s <> s
  end

  def a1(s) do
    String.split_at(s, 1) |> (fn {x, y} -> 
      {s0, s1} = String.split_at(y, 2)
      x <> String.upcase(s0) <> s1  
    end).() 
  end

  def m1(s) do
    d = String.split(s, " ")
    Enum.at(d, -1) <> ", " <> f3(Enum.at(d, 0))
  end
  
end