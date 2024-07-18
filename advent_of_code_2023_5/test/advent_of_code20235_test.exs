defmodule AdventOfCode20235Test do
  use ExUnit.Case
  doctest AdventOfCode20235

  test "reads the file" do
    assert AdventOfCode20235.read_file("./lib/example_input.txt") |> is_list()
  end

  test "converts each raw input line to a {key, values} and builds a global Map with them" do
    AdventOfCode20235.read_file("./lib/example_input.txt")
    |> AdventOfCode20235.get_global_map()
  end

  test "converts seed 98 -> soil 50 and seed 99 -> soil 51" do
    global_map =
      AdventOfCode20235.read_file("./lib/example_input.txt")
      |> AdventOfCode20235.get_global_map()

    assert AdventOfCode20235.convert(global_map, "seed-to-soil", 98) == 50
    assert AdventOfCode20235.convert(global_map, "seed-to-soil", 99) == 51
  end

  test "converts seed 79 -> soil 81 and seed 13 -> soil 13" do
    global_map =
      AdventOfCode20235.read_file("./lib/example_input.txt")
      |> AdventOfCode20235.get_global_map()

    assert AdventOfCode20235.convert(global_map, "seed-to-soil", 79) == 81
    assert AdventOfCode20235.convert(global_map, "seed-to-soil", 13) == 13
  end

  test "converts seed 14 -> location 43" do
    global_map =
      AdventOfCode20235.read_file("./lib/example_input.txt")
      |> AdventOfCode20235.get_global_map()

    assert AdventOfCode20235.convert(global_map, "seed-to-soil", 14) == 14
    assert AdventOfCode20235.convert(global_map, "soil-to-fertilizer", 14) == 53
    assert AdventOfCode20235.convert(global_map, "fertilizer-to-water", 53) == 49
    assert AdventOfCode20235.convert(global_map, "water-to-light", 49) == 42
    assert AdventOfCode20235.convert(global_map, "light-to-temperature", 42) == 42
    assert AdventOfCode20235.convert(global_map, "temperature-to-humidity", 42) == 43
    assert AdventOfCode20235.convert(global_map, "humidity-to-location", 43) == 43
  end

  test "converts seed 55 -> location 86" do
    global_map =
      AdventOfCode20235.read_file("./lib/example_input.txt")
      |> AdventOfCode20235.get_global_map()

    assert AdventOfCode20235.convert(global_map, "seed-to-soil", 55) == 57
    assert AdventOfCode20235.convert(global_map, "soil-to-fertilizer", 57) == 57
    assert AdventOfCode20235.convert(global_map, "fertilizer-to-water", 57) == 53
    assert AdventOfCode20235.convert(global_map, "water-to-light", 53) == 46
    assert AdventOfCode20235.convert(global_map, "light-to-temperature", 46) == 82
    assert AdventOfCode20235.convert(global_map, "temperature-to-humidity", 82) == 82
    assert AdventOfCode20235.convert(global_map, "humidity-to-location", 82) == 86
  end

  test "converts seed 13 -> location 35" do
    global_map =
      AdventOfCode20235.read_file("./lib/example_input.txt")
      |> AdventOfCode20235.get_global_map()

    assert AdventOfCode20235.convert(global_map, "seed-to-soil", 13) == 13
    assert AdventOfCode20235.convert(global_map, "soil-to-fertilizer", 13) == 52
    assert AdventOfCode20235.convert(global_map, "fertilizer-to-water", 52) == 41
    assert AdventOfCode20235.convert(global_map, "water-to-light", 41) == 34
    assert AdventOfCode20235.convert(global_map, "light-to-temperature", 34) == 34
    assert AdventOfCode20235.convert(global_map, "temperature-to-humidity", 34) == 35
    assert AdventOfCode20235.convert(global_map, "humidity-to-location", 35) == 35
  end

  test "finds the lowest location value between all seeds" do
    global_map =
      AdventOfCode20235.read_file("./lib/example_input.txt")
      |> AdventOfCode20235.get_global_map()

    assert AdventOfCode20235.get_lowest_location(global_map) == 35
  end
end
