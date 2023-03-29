defmodule MechsTest do
  use ExUnit.Case
  doctest Mechs

  test "greets the world" do
    assert Mechs.hello() == :world
  end
end
