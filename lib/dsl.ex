defmodule DSL do
  def bk1(s, a, b) do
    # length decrease
    # s contains a
    # b = 0 1 2..nil or -1 -2..nil
    # O(l^2)
    String.split(s, a) |> Enum.at(b)
  end

  def bk2(s, a, b) do
    # length decrease
    # length(s) > a > 0 or -length(s) < a < 0
    # b is 0 or 1
    # O(l)
    String.split_at(s, a) |> elem(b)
  end

  def join(s1, s2) do
    # length increase
    s1 <> s2
  end

  def up(s) do
    String.upcase(s)
  end

  def down(s) do
    String.downcase(s)
  end
end