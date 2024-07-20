defmodule AdventOfCode20236 do
  require Integer
  @string_delimiter "\r\n"

  def read_file(), do: read_file("./lib/example_input.txt")
  def read_file(:real), do: read_file("./lib/input.txt")

  def read_file(path) do
    case File.read(path) do
      {:ok, result} -> result |> String.split(@string_delimiter)
      {:error, error} -> IO.inspect(error)
    end
  end

  def get_races(input) do
    [raw_times, raw_distances] = input

    times =
      Regex.scan(~r/\d+/, raw_times)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    distances =
      Regex.scan(~r/\d+/, raw_distances)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    times
    |> Enum.with_index()
    |> Enum.map(fn {time, index} -> {time, Enum.at(distances, index)} end)
  end

  def get_races_2(input) do
    [raw_times, raw_distances] = input

    [
      {
        String.replace(raw_times, ~r/[^\d]/, "") |> String.to_integer(),
        String.replace(raw_distances, ~r/[^\d]/, "") |> String.to_integer()
      }
    ]
  end

  def count_possibilities_for_race({duration, record_distance}) do
    optimized_possibilities =
      1..Integer.floor_div(duration, 2)
      |> Enum.map(fn hold_duration -> hold_duration * (duration - hold_duration) end)
      |> Enum.filter(fn distance -> distance > record_distance end)

    if Integer.is_even(duration),
      do: length(optimized_possibilities) * 2 - 1,
      else: length(optimized_possibilities) * 2
  end
end

AdventOfCode20236.read_file(:real)
|> AdventOfCode20236.get_races_2()
|> Enum.map(&AdventOfCode20236.count_possibilities_for_race/1)
|> Enum.reduce(1, &(&1 * &2))
|> IO.inspect(charlists: :as_lists)
