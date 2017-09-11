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

  def substr(s, a, b) do
    String.split_at(s, a)
    |> elem(1)
    |> String.split_at(b)
    |> elem(0)
  end

  def const(s) do
    s
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

  def move(s, a, x) do
    cond do
      x > 0 ->
        {s1, s2} = String.split_at(s, a + x)
        {s3, s4} = String.split_at(s1, a - 1)
        {s5, s6} = String.split_at(s4, 1)
        s3 <> s6 <> s5 <> s2
      x < 0 ->
        {s1, s2} = String.split_at(s, a)
        {s3, s4} = String.split_at(s1, a + x - 1)
        {s5, s6} = String.split_at(s4, -1)
        s3 <> s6 <> s5 <> s2
      true ->
        s
    end
  end
end