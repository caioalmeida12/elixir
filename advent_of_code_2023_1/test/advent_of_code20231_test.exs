defmodule AdventOfCode20231Test do
  use ExUnit.Case
  doctest AdventOfCode20231

  test "reads the file" do
    assert AdventOfCode20231.read_file("./lib/input.txt")
  end

  test "returns only numbers from a given string" do
    assert AdventOfCode20231.get_numbers_from_string("1asdiohas2hoda3sh4ohno")
  end

  test "gets only first and last integers from an enum" do
    assert AdventOfCode20231.get_first_and_last_integer_from_enum([1, 2, 3, 4]) == {1, 4}
  end

  test "gets an integer from a tuple" do
    assert AdventOfCode20231.get_two_digit_number_from_tuple({1, 2}) == 12
  end

  test "gets calibration values" do
    assert AdventOfCode20231.get_calibration_values("./lib/input.txt") == 54667
  end
end
