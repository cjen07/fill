defmodule DSL do
  def bk1(s, a, b) do
    String.split(s, a) |> Enum.at(b)
  end

  def bk2(s, a, b) do
    String.split_at(s, a) |> elem(b)
  end

  def join(s1, s2) do
    s1 <> s2
  end

  def up(s) do
    String.upcase(s)
  end

  def down(s) do
    String.downcase(s)
  end
end