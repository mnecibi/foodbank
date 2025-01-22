defmodule FoodbankTest do
  use ExUnit.Case
  doctest Foodbank

  test "greets the world" do
    assert Foodbank.hello() == :world
  end
end
