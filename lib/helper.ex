defmodule Helper do
  use ParamPipe

  import DSL

  def rl(r) do
    Enum.random(r)
  end

  def rs(l, t) do
    case t do
      :up ->
        ?A..?Z
      :down ->
        ?a..?z
      :all ->
        Enum.to_list(?a..?z) ++ Enum.to_list(?A..?Z)
    end
    |> Enum.take_random(l) 
    |> to_string()
  end

  def generate(n, f, r, t) do
    # n is the count of generated data pair
    # f is string -> string function
    # r is the range of length
    1..n |> Enum.map(fn _ ->
      l = rl(r)
      s = rs(l, t)
      {s, apply(Case, f, [s])}
    end)
  end

  def flat_search(d0, d1, s0, s1) do
    case d0 do
      [] -> Enum.reverse(d1)
      _ -> 
        [{k, v} | t] = d0
        case k do
          :del -> flat_search(t, d1, s0, s1)
          _ ->
            case k do
              :eq -> {train_bk(s0, v), fn x -> x end}
              :ins -> 
                cond do
                  String.contains?(s0, v) ->
                    {train_bk(s0, v), fn x -> x end}
                  String.contains?(s0, down(v)) 
                  && up(down(v)) == v ->
                    {train_bk(s0, down(v)), fn x -> {:up, x} end}
                  String.contains?(s0, up(v)) 
                  && down(up(v)) == v ->
                    {train_bk(s0, up(v)), fn x -> {:down, x} end}
                  true ->
                    throw(:error1)
                end 
            end
            |> (fn {m, f} -> 
              Map.to_list(m)
              |> Enum.flat_map(fn {k, v} -> 
                Enum.map(v, fn x -> f.({k, x}) end)
              end)
            end).()
            |> (fn x ->
              f = 
                case t do
                  [] -> :map
                  _ -> :flat_map
                end
              apply(Enum, f, [x, fn x -> flat_search(t, [x | d1], s0, s1) end])
            end).()
        end
    end
  end

  def merge1([{e0, e1} | t]) do
    Enum.reduce(t, {[e0], e1}, fn x, acc ->
      do_merge1(x, acc)
    end)
  end

  def do_merge1({s, ls0}, {ss, ls1}) do
    {s0, s1} = s
    ls =
      (Enum.filter(ls1, fn x -> 
        run_direct(x, s0) == s1
      end)
      ++ Enum.filter(ls0, fn x -> 
        Enum.all?(ss, fn {s0, s1} -> 
          run_direct(x, s0) == s1
        end)
      end))
      |> MapSet.new()
      |> MapSet.to_list()
    {[s | ss], ls}
  end

  def run_direct(l, s) do
    Enum.flat_map(l, fn x -> 
      do_run_direct(x, s)
    end)
    |> Enum.join("")
  end

  def do_run_direct(x, s) do
    try do
      cond do
        is_tuple(x) ->
          {e0, e1} = x
          case e0 do
            :up -> 
              do_run_direct(e1, s)
              |> Enum.at(0)
              |> up()
            :down ->
              do_run_direct(e1, s)
              |> Enum.at(0)
              |> down()
            :bk1 ->
              {a0, a1} = e1
              bk1(s, a0, a1)
            :bk2 ->
              {a0, a1} = e1
              bk2(s, a0, a1)
          end
          |> (fn x -> [x] end).()
        true ->
          throw(:error1)
      end
    rescue
      _ -> []
    end
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

  def merge(l) do
    Enum.reduce(l, fn x, acc ->
      do_merge(x, acc)
    end)
  end

  def do_merge(x, y) do
    Enum.zip(x, y)
    |> Enum.flat_map(fn {x, y} -> 
      cond do
        is_atom(x) && x == y ->
          [x]
        is_map(x) && is_map(y) ->
          d = intersection(x, y)
          if d == %{} do
            throw(:error2)
          else
            [d]
          end
        true ->
          throw(:error3)
      end
    end)
  end

  def intersection(x, y) do
    [x, y]
    |> Enum.map(fn x -> Map.keys(x) |> MapSet.new() end)
    |> (fn [x, y] -> MapSet.intersection(x, y) |> MapSet.to_list() end).()
    |> Enum.reduce(%{}, fn k, acc ->
      [x, y]
      |> Enum.map(fn x -> Map.get(x, k) |> MapSet.new() end)
      |> (fn [x, y] -> MapSet.intersection(x, y) |> MapSet.to_list() end).()
      |-1> Map.put(acc, k) 
    end)
  end

  def sub_strings(s) do
    l = String.length(s)
    Enum.flat_map(1..l-1, fn x -> 
      Enum.map(0..l-x, fn y -> 
        String.split_at(s, y)
        |> elem(1)
        |> String.split_at(x)
        |> elem(0)
      end) 
    end)
  end

end