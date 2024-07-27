defmodule AdventOfCode20224 do
  @line_break "\r\n"

  def read_file(), do: read_file("./lib/example_input.txt")
  def read_file(:example_2), do: read_file("./lib/example_input_2.txt")
  def read_file(:real), do: read_file("./lib/input.txt")

  def read_file(path) do
    case File.read(path) do
      {:ok, result} -> result |> String.split(@line_break)
      {:error, error} -> IO.inspect(error)
    end
  end

  def get_range_pairs(pairs_string) do
    [[one, two], [three, four]] =
      pairs_string
      |> String.split(["-", ","])
      |> Enum.chunk_every(2)

    mapset_one = MapSet.new(String.to_integer(one)..String.to_integer(two))
    mapset_two = MapSet.new(String.to_integer(three)..String.to_integer(four))

    [mapset_one, mapset_two]
  end

  def one_fully_contains_another?(one, two) do
    MapSet.subset?(one, two) or MapSet.subset?(two, one)
  end

  def one_partially_contains_another?(one, two) do
    not MapSet.disjoint?(one, two)
  end
end

# Task 1
AdventOfCode20224.read_file(:real)
|> Enum.map(&AdventOfCode20224.get_range_pairs/1)
|> Enum.count(fn [one, two] -> AdventOfCode20224.one_fully_contains_two?(one, two) end)
|> IO.inspect(label: "task 1")

# Task 2
AdventOfCode20224.read_file(:real)
|> Enum.map(&AdventOfCode20224.get_range_pairs/1)
|> Enum.count(fn [one, two] -> AdventOfCode20224.one_partially_contains_two?(one, two) end)
|> IO.inspect(label: "task 2")
