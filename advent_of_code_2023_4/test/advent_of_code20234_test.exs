defmodule AdventOfCode20234Test do
  use ExUnit.Case
  doctest AdventOfCode20234

  test "reads the file" do
    assert AdventOfCode20234.read_file("./lib/example_input.txt")
    |> IO.inspect()
  end
end
