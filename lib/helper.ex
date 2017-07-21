defmodule Helper do
  def rl(r) do
    Enum.random(r)
  end

  def rs(l) do
    Enum.take_random(?a..?z, l) |> to_string()
  end

  def generate(n, f, r) do
    1..n |> Enum.map(fn _ ->
      l = rl(r)
      s = rs(l)
      {s, apply(Case, f, [s])}
    end)
  end
end