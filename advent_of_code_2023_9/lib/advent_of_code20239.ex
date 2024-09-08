defmodule AdventOfCode20239 do
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

  def format_input(raw_input) do
    raw_input
    |> Enum.map(fn line_number ->
      line_number
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def differentiate_line(line_content),
    do: differentiate_line(%{0 => line_content}, 0)

  def differentiate_line(acc, current_layer_index) when is_map(acc) do
    new_acc =
      acc
      |> Map.put_new(
        current_layer_index + 1,
        Map.get(acc, current_layer_index)
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(fn [a, b] -> b - a end)
      )

    new_line_content = Map.get(new_acc, current_layer_index + 1)

    if Enum.all?(new_line_content, &(&1 == 0)),
      do: new_acc,
      else: differentiate_line(new_acc, current_layer_index + 1)
  end

  def extrapolate(map_of_layers) do
    keys = Map.keys(map_of_layers) |> Enum.reverse()

    keys
    |> Enum.reduce(map_of_layers, fn key, acc ->
      current_values_of_layer =
        Map.get(acc, key)
        |> IO.inspect()

      value_to_concat = List.last(current_values_of_layer) + List.last(Map.get(acc, key + 1, [0]))

      Map.put(acc, key, Enum.concat(current_values_of_layer, [value_to_concat]))
    end)
  end

  def top_layer_value(map_of_layers) when is_map(map_of_layers) do
    map_of_layers
    |> Map.get(0)
    |> List.last()
  end
end

AdventOfCode20239.read_file(:real)
|> AdventOfCode20239.format_input()
|> Enum.map(&AdventOfCode20239.differentiate_line/1)
|> Enum.map(&AdventOfCode20239.extrapolate/1)
|> Enum.map(&AdventOfCode20239.top_layer_value/1)
|> Enum.sum()
|> IO.inspect(charlists: :as_lists, label: "task  1")
