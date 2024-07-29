defmodule AdventOfCode20226 do
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

  def find_start_of_packet_indexes(input_string, packet_length) do
    input_string
    |> String.graphemes()
    |> Enum.chunk_every(packet_length, 1)
    |> Enum.with_index()
    |> Enum.reduce([], fn {chunk, chunk_ind}, acc ->
      number_of_different_letters =
        Enum.frequencies(chunk)
        |> Map.keys()
        |> Enum.count()

      if number_of_different_letters == packet_length do
        [chunk_ind + length(chunk) | acc]
      else
        acc
      end
    end)
  end
end

AdventOfCode20226.read_file(:real)
|> Enum.map(&(AdventOfCode20226.find_start_of_packet_indexes(&1, 4) |> Enum.at(-1)))
|> IO.inspect(label: "task 1")

AdventOfCode20226.read_file(:real)
|> Enum.map(&(AdventOfCode20226.find_start_of_packet_indexes(&1, 14) |> Enum.at(-1)))
|> IO.inspect(label: "task 2")
