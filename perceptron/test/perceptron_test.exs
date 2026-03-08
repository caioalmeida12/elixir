defmodule PerceptronTest do
  use ExUnit.Case
  doctest Perceptron

  test "greets the world" do
    assert Perceptron.hello() == :world
  end
end
