defmodule AdventOfCode20233Test do
  use ExUnit.Case
  doctest AdventOfCode20233

  test "reads the file" do
    assert AdventOfCode20233.read_file("./lib/example_input.txt")
  end

  test "gets the tuple of {number, adjacent_coordinates} for every number in a line" do
    assert AdventOfCode20233.read_file("./lib/example_input.txt")
           |> AdventOfCode20233.get_number_coordinates_for_line(0) == [
             {467, [{0, 0}, {0, 1}, {0, 2}]},
             {114, [{0, 5}, {0, 6}, {0, 7}]}
           ]
  end

  test "gets the tuple of coordinates of evey symbol in the file" do
    assert AdventOfCode20233.read_file("./lib/example_input.txt")
           |> AdventOfCode20233.get_symbol_coordinates() == [
             {1, 3},
             {3, 6},
             {4, 3},
             {5, 5},
             {8, 3},
             {8, 5}
           ]
  end
end
