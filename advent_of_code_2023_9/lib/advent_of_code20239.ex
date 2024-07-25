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
    |> Enum.with_index()
    |> Enum.map(fn {line, layer} ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def get_difference_for_layer(single_layer) do
    single_layer
    |> Enum.with_index()
    |> Enum.flat_map(fn {curr, ind} ->
      next = Enum.at(single_layer, ind + 1)

      if is_integer(next), do: [next - curr], else: []
    end)
  end

  def get_layered_differences(single_layer) do
    layered_differences =
      get_difference_for_layer(single_layer)

    if(Enum.any?(layered_differences, &(&1 > 0))) do
      [single_layer, layered_differences, get_difference_for_layer(layered_differences)]
    else
      IO.inspect([single_layer, layered_differences], label: "stop")
      [single_layer, layered_differences]
    end
  end

  def extrapolate(all_layers) do
    number_of_layers = Enum.count(all_layers)

    all_layers
    |> Enum.reverse()
    |> Enum.reduce(Enum.at(all_layers, -2) |> Enum.at(-1), fn layer, acc ->
      IO.inspect(layer, label: "current layer")
      IO.inspect(Enum.at(layer, -1), label: "last digit of layer")
      IO.inspect(acc, label: "acc")
      Enum.at(layer, -1) + acc
    end)
  end
end

AdventOfCode20239.read_file()
|> AdventOfCode20239.format_input()
|> Enum.map(fn history ->
  AdventOfCode20239.get_layered_differences(history)

  # |> AdventOfCode20239.extrapolate()
end)
|> IO.inspect(charlists: :as_lists, label: "task  1")
