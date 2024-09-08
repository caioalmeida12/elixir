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

    if Enum.sum(new_line_content) == 0,
      do: new_acc,
      else: differentiate_line(new_acc, current_layer_index + 1)
  end
end

AdventOfCode20239.read_file()
|> AdventOfCode20239.format_input()
|> Enum.map(&AdventOfCode20239.differentiate_line/1)
|> IO.inspect(charlists: :as_lists, label: "task  1")
