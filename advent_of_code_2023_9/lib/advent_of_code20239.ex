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
    |> Enum.map(fn {line_number, line_content} ->
      {
        line_content,
        line_number
        |> String.split()
        |> Enum.map(&String.to_integer/1)
      }
    end)
  end

  def differentiate_line({_line_number, line_content}),
    do: differentiate_line(line_content, %{}, 0)

  def differentiate_line(line_content, acc, key) when is_map(acc) do
    acc
    |> Map.put_new(
      key,
      line_content
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)
    )
    |> then(fn new_acc ->
      if Enum.sum(Map.get(new_acc, key)) == 0 do
        differentiate_line(line_content, new_acc, key + 1)
      else
        new_acc
      end
    end)
  end
end

AdventOfCode20239.read_file()
|> AdventOfCode20239.format_input()
|> Enum.at(0)
|> AdventOfCode20239.differentiate_line()
|> IO.inspect(charlists: :as_lists, label: "task  1")
