defmodule FillTest do
  use ExUnit.Case
  doctest Fill

  test "greets the world" do
    assert Fill.hello() == :world
  end
end
