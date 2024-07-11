defmodule AdventOfCode20233Test do
  use ExUnit.Case
  doctest AdventOfCode20233

  @test_matrix [
    ["4", "6", "7", ".", "."],
    [".", ".", "*", ".", "."],
    [".", ".", "3", "5", "3"]
  ]

  test "reads the file" do
    assert AdventOfCode20233.read_file("./lib/input.txt")
  end

  test "detects a symbol and outputs its position" do
    assert @test_matrix |> AdventOfCode20233.get_all_symbol_positions() == [%{line: 1, col: 2}]
  end

  test "gets all imediate neighbours of a symbol" do
    assert @test_matrix |> AdventOfCode20233.get_imediate_neighbours(%{line: 0, col: 0}) ==
             {[
                [".", ".", "."],
                [".", ".", "6"],
                [".", ".", "."]
              ], %{line: 0, col: 0}}

    assert @test_matrix |> AdventOfCode20233.get_imediate_neighbours(%{line: 0, col: 1}) ==
             {[
                [".", ".", "."],
                ["4", ".", "7"],
                [".", ".", "*"]
              ], %{line: 0, col: 1}}

    assert @test_matrix |> AdventOfCode20233.get_imediate_neighbours(%{line: 1, col: 0}) ==
             {[
                [".", "4", "6"],
                [".", ".", "."],
                [".", ".", "."]
              ], %{line: 1, col: 0}}

    assert @test_matrix
           |> AdventOfCode20233.get_imediate_neighbours(%{line: length(@test_matrix) - 1, col: 0}) ==
             {[[".", ".", "."], [".", ".", "."], [".", ".", "."]],
              %{line: length(@test_matrix) - 1, col: 0}}

    assert @test_matrix
           |> AdventOfCode20233.get_imediate_neighbours(%{line: length(@test_matrix) - 1, col: 1}) ==
             {[[".", ".", "*"], [".", ".", "3"], [".", ".", "."]],
              %{line: length(@test_matrix) - 1, col: 1}}

    assert @test_matrix
           |> AdventOfCode20233.get_imediate_neighbours(%{
             line: length(@test_matrix) - 1,
             col: length(Enum.at(@test_matrix, 0)) - 1
           }) ==
             {[[".", ".", "."], ["5", ".", "."], [".", ".", "."]],
              %{
                line: length(@test_matrix) - 1,
                col: length(Enum.at(@test_matrix, 0)) - 1
              }}

    assert @test_matrix |> AdventOfCode20233.get_imediate_neighbours(%{line: 1, col: 1}) ==
             {[["4", "6", "7"], [".", ".", "*"], [".", ".", "3"]], %{line: 1, col: 1}}
  end

  test "detects all numbers adjacent to a symbol position and outputs their absolute position" do
    inner_matrix = @test_matrix |> AdventOfCode20233.get_imediate_neighbours(%{line: 1, col: 2})

    assert inner_matrix ==
             {[["6", "7", "."], [".", ".", "."], [".", "3", "5"]], %{col: 2, line: 1}}

    @test_matrix |> AdventOfCode20233.get_numbers_to_the_left(inner_matrix) |> IO.inspect()
  end
end