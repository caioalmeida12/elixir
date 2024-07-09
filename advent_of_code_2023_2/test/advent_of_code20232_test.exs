defmodule AdventOfCode20232Test do
  use ExUnit.Case
  doctest AdventOfCode20232

  test "reads the file" do
    assert AdventOfCode20232.read_file("./lib/input.txt")
  end
end
