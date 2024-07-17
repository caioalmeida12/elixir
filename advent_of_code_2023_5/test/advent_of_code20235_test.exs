defmodule AdventOfCode20235Test do
  use ExUnit.Case
  doctest AdventOfCode20235

  test "reads the file" do
    assert AdventOfCode20235.read_file("./lib/example_input.txt") |> is_list()
  end

  test "formats the file content to a global map with name as index and an array of strings as values" do
    file_content =
      AdventOfCode20235.read_file("./lib/example_input.txt")

    # |> IO.inspect()

    seeds =
      Enum.at(file_content, 0)
      |> String.split(": ")
      |> then(fn [key, values] -> [{key, values}] end)
      |> Enum.into(%{})

    map_indexes =
      file_content
      |> Enum.with_index()
      |> Enum.filter(fn {val, _} -> String.contains?(val, "map") end)

    value_ranges =
      map_indexes
      |> Enum.into(%{})
      |> Map.values()
      |> Enum.sort()
      |> Enum.with_index()
      |> Enum.map(fn {start, ind} ->
        if Enum.at(map_indexes, ind + 1) do
          {_, stop} = Enum.at(map_indexes, ind + 1)

          (start + 1)..(stop - 1)
        end
      end)
      |> Enum.filter(& &1)

    map_indexes
    |> Enum.map(fn {key, start_index} -> {key, start_index, []} end)
    # |> IO.inspect()
    |> Enum.map(fn {key, start_index, _values} ->

      file_content
      |> Enum.with_index()
      |> Enum.filter(fn {line, ind} ->
        range = Enum.at(value_ranges, start_index - 1)

        if range, do: ind in Range.to_list(range), else: false
      end)
      |> IO.inspect()
    end)
  end
end
