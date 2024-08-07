defmodule AdventOfCode20235 do
  require Integer
  @string_delimiter "\r\n\r\n"

  @type line :: String.t()
  @type file_content :: list(line())

  @spec read_file(String.t()) :: file_content()
  def read_file(path) do
    case File.read(path) do
      {:ok, result} -> result |> String.split(@string_delimiter)
      {:error, error} -> IO.inspect(error)
    end
  end

  def get_global_map(file_content) do
    [seeds_raw | maps_raw] = file_content

    seeds =
      seeds_raw
      |> String.split(": ")
      |> then(fn [key, values] ->
        split_values = String.split(values, " ") |> Enum.map(&String.to_integer/1)
        [{key, split_values}]
      end)

    maps =
      maps_raw
      |> Enum.map(&String.split(&1, ":\r\n"))
      |> Enum.map(fn [map_key, values] ->
        values
        |> String.split("\r\n")
        |> Enum.map(&(String.split(&1) |> Enum.map(fn num -> String.to_integer(num) end)))
        |> then(&{map_key |> String.replace(" map", ""), &1})
      end)

    (seeds ++ maps)
    |> Enum.into(%{})
  end

  def convert(global_map, map_key, search_num) do
    global_map
    |> Map.get(map_key)
    |> Enum.find_value(fn [dest_start, source_start, range_length] ->
      if search_num >= source_start and search_num <= source_start + range_length - 1,
        do: dest_start + search_num - source_start
    end)
    |> then(fn res -> unless res == nil, do: res, else: search_num end)
  end

  def get_lowest_location(global_map) do
    seeds = global_map |> Map.get("seeds")

    seeds
    |> Enum.map(fn seed ->
      soil = convert(global_map, "seed-to-soil", seed)
      fertilizer = convert(global_map, "soil-to-fertilizer", soil)
      water = convert(global_map, "fertilizer-to-water", fertilizer)
      light = convert(global_map, "water-to-light", water)
      temperature = convert(global_map, "light-to-temperature", light)
      humidity = convert(global_map, "temperature-to-humidity", temperature)

      convert(global_map, "humidity-to-location", humidity)
    end)
    |> Enum.min()
  end

  def get_seed_ranges(global_map) do
    seeds = global_map |> Map.get("seeds")

    range_starts =
      seeds
      |> Enum.with_index()
      |> Enum.filter(fn {_val, ind} -> Integer.is_even(ind) end)
      |> Enum.map(fn {val, _ind} -> val end)

    range_lengths =
      seeds
      |> Enum.with_index()
      |> Enum.filter(fn {_val, ind} -> Integer.is_odd(ind) end)
      |> Enum.map(fn {val, _ind} -> val end)

    range_starts
    |> Enum.with_index()
    |> Enum.map(fn {start, ind} ->
      {start, start + Enum.at(range_lengths, ind) - 1}
    end)
  end

  def get_lowest_location_for_ranges(global_map) do
    get_seed_ranges(global_map)
    |> Enum.at(0)
    |> then(&[&1])
    |> Enum.map(fn {start, finish} ->
      start..finish
      |> Enum.reduce([], fn seed, acc ->
        soil = convert(global_map, "seed-to-soil", seed)
        fertilizer = convert(global_map, "soil-to-fertilizer", soil)
        water = convert(global_map, "fertilizer-to-water", fertilizer)
        light = convert(global_map, "water-to-light", water)
        temperature = convert(global_map, "light-to-temperature", light)
        humidity = convert(global_map, "temperature-to-humidity", temperature)
        location = convert(global_map, "humidity-to-location", humidity)

        Enum.min([acc, location])
      end)
    end)
    |> Enum.min()
  end
end

# Task 1
# AdventOfCode20235.read_file("./lib/input.txt")
# |> AdventOfCode20235.get_global_map()
# |> AdventOfCode20235.get_lowest_location()
# |> IO.inspect()

# Task 2
# AdventOfCode20235.read_file("./lib/example_input.txt")
AdventOfCode20235.read_file("./lib/input.txt")
|> AdventOfCode20235.get_global_map()
|> AdventOfCode20235.get_lowest_location_for_ranges()
|> IO.inspect(label: "Result")
