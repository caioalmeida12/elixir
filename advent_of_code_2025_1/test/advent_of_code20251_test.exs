defmodule AdventOfCode20251Test do
  use ExUnit.Case

  test "reads the example input file" do
    content = AdventOfCode20251.read_file(:example)
    assert is_binary(content)
  end

  test "reads the real input file" do
    content = AdventOfCode20251.read_file()
    assert is_binary(content)
  end

  test "converts the input into an enum of directions" do
    content =
      AdventOfCode20251.read_file()
      |> AdventOfCode20251.input_to_string_enum()

    assert Enum.all?(content, &is_binary/1)
  end

  test "converts the string enum into a tuples enum of format {dir, amount}" do
    content =
      AdventOfCode20251.read_file()
      |> AdventOfCode20251.input_to_string_enum()
      |> AdventOfCode20251.string_enum_to_tuple_enum()

    assert Enum.all?(content, fn {dir, amount} -> is_binary(dir) and is_integer(amount) end)
  end

  test "asserts the dirs are only L and R and amounts are larger than 0" do
    content =
      AdventOfCode20251.read_file()
      |> AdventOfCode20251.input_to_string_enum()
      |> AdventOfCode20251.string_enum_to_tuple_enum()

    assert Enum.all?(content, fn {dir, amount} ->
             dir in ["L", "R"]
           end)

    assert Enum.all?(content, fn {dir, amount} ->
             amount > 0
           end)
  end

  test "processes instructions correctly (Part 1 Logic)" do
    assert AdventOfCode20251.process_instruction_p1([50], {"L", 0}) |> hd() == 50

    assert AdventOfCode20251.process_instruction_p1([50], {"L", 0})
           |> AdventOfCode20251.process_instruction_p1({"L", 1})
           |> hd() == 49

    assert AdventOfCode20251.process_instruction_p1([50], {"L", 0})
           |> AdventOfCode20251.process_instruction_p1({"L", 1})
           |> AdventOfCode20251.process_instruction_p1({"R", 1})
           |> hd() == 50

    assert AdventOfCode20251.process_instruction_p1([50], {"L", 0})
           |> AdventOfCode20251.process_instruction_p1({"L", 1})
           |> AdventOfCode20251.process_instruction_p1({"R", 1})
           |> AdventOfCode20251.process_instruction_p1({"L", 50})
           |> hd() == 0

    assert AdventOfCode20251.process_instruction_p1([50], {"L", 0})
           |> AdventOfCode20251.process_instruction_p1({"L", 1})
           |> AdventOfCode20251.process_instruction_p1({"R", 1})
           |> AdventOfCode20251.process_instruction_p1({"L", 50})
           |> AdventOfCode20251.process_instruction_p1({"R", 50})
           |> hd() == 50

    assert AdventOfCode20251.process_instruction_p1([50], {"L", 0})
           |> AdventOfCode20251.process_instruction_p1({"L", 1})
           |> AdventOfCode20251.process_instruction_p1({"R", 1})
           |> AdventOfCode20251.process_instruction_p1({"L", 50})
           |> AdventOfCode20251.process_instruction_p1({"R", 50})
           |> AdventOfCode20251.process_instruction_p1({"R", 50})
           |> hd() == 0

    assert AdventOfCode20251.process_instruction_p1([50], {"L", 0})
           |> AdventOfCode20251.process_instruction_p1({"L", 1})
           |> AdventOfCode20251.process_instruction_p1({"R", 1})
           |> AdventOfCode20251.process_instruction_p1({"L", 50})
           |> AdventOfCode20251.process_instruction_p1({"R", 50})
           |> AdventOfCode20251.process_instruction_p1({"R", 50})
           |> AdventOfCode20251.process_instruction_p1({"L", 50})
           |> hd() == 50

    assert AdventOfCode20251.process_instruction_p1([50], {"L", 0})
           |> AdventOfCode20251.process_instruction_p1({"L", 1})
           |> AdventOfCode20251.process_instruction_p1({"R", 1})
           |> AdventOfCode20251.process_instruction_p1({"L", 50})
           |> AdventOfCode20251.process_instruction_p1({"R", 50})
           |> AdventOfCode20251.process_instruction_p1({"R", 50})
           |> AdventOfCode20251.process_instruction_p1({"L", 50})
           |> AdventOfCode20251.process_instruction_p1({"L", 100})
           |> hd() == 50
  end

  test "correctly counts the amount of zeroes after processing (Part 2 Logic)" do
    positions =
      [{"L", 0}, {"L", 1}, {"R", 1}, {"L", 50}, {"R", 50}, {"R", 50}, {"L", 50}, {"L", 100}]
      |> Enum.reduce([50], fn curr, acc -> AdventOfCode20251.process_instruction_p2(acc, curr) end)

    assert Enum.filter(positions, fn item -> item == 0 end) |> Enum.count() == 3
  end

  test "correctly processes the example input for part one" do
    positions =
      AdventOfCode20251.read_file(:example)
      |> AdventOfCode20251.input_to_string_enum()
      |> AdventOfCode20251.string_enum_to_tuple_enum()
      |> Enum.reduce([50], fn curr, acc ->
        AdventOfCode20251.process_instruction_p1(acc, curr)
      end)

    assert hd(positions) == 32
  end

  test "correctly processes the real input for part one" do
    positions =
      AdventOfCode20251.read_file()
      |> AdventOfCode20251.input_to_string_enum()
      |> AdventOfCode20251.string_enum_to_tuple_enum()
      |> Enum.reduce([50], fn curr, acc ->
        AdventOfCode20251.process_instruction_p1(acc, curr)
      end)

    assert hd(positions) > 0
  end

  test "correctly processes the example input for part two" do
    positions =
      AdventOfCode20251.read_file(:example)
      |> AdventOfCode20251.input_to_string_enum()
      |> AdventOfCode20251.string_enum_to_tuple_enum()
      |> Enum.reduce([50], fn curr, acc ->
        AdventOfCode20251.process_instruction_p2(acc, curr)
      end)

    assert Enum.filter(positions, fn item -> item == 0 end) |> Enum.count() > 0
  end

  test "correctly processes the real input for part two" do
    positions =
      AdventOfCode20251.read_file()
      |> AdventOfCode20251.input_to_string_enum()
      |> AdventOfCode20251.string_enum_to_tuple_enum()
      |> Enum.reduce([50], fn curr, acc ->
        AdventOfCode20251.process_instruction_p2(acc, curr)
      end)

    assert Enum.filter(positions, fn item -> item == 0 end) |> Enum.count() > 0
  end

  test "correctly counts how many zeros" do
    assert AdventOfCode20251.count_zeros_passed(50, {"L", 68}) == 1
    assert AdventOfCode20251.count_zeros_passed(82, {"L", 30}) == 0
    assert AdventOfCode20251.count_zeros_passed(52, {"R", 48}) == 1
    assert AdventOfCode20251.count_zeros_passed(52, {"R", 152}) == 2
    assert AdventOfCode20251.count_zeros_passed(95, {"R", 60}) == 1
  end
end
