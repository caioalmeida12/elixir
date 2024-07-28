defmodule AdventOfCode20225 do
  @line_break "\r\n\r\n"

  def read_file(), do: read_file("./lib/example_input.txt")
  def read_file(:example_2), do: read_file("./lib/example_input_2.txt")
  def read_file(:real), do: read_file("./lib/input.txt")

  def read_file(path) do
    case File.read(path) do
      {:ok, result} -> result |> String.split(@line_break)
      {:error, error} -> IO.inspect(error)
    end
  end

  def get_initial_crates_map(raw_crates_string) do
    as_matrix =
      raw_crates_string
      |> String.split("\r\n")
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&Enum.chunk_every(&1, 3, 4))
      |> Enum.map(fn row ->
        row
        |> Enum.map(&List.to_string/1)
      end)

    as_matrix
    |> Enum.reduce(%{}, fn row, map ->
      row
      |> Enum.with_index()
      |> Enum.reduce(map, fn {val, col}, map ->
        if Map.get(map, col) != nil do
          Map.put(map, col, [val | Map.get(map, col)])
        else
          Map.put(map, col, [val])
        end
      end)
    end)
    |> Enum.map(fn {row_ind, list_of_values} ->
      relevant_values =
        list_of_values
        |> Enum.reject(&String.match?(&1, ~r/^\s\d\s$|^\s{3}$/))
        |> Enum.reverse()

      {row_ind + 1, relevant_values}
    end)
    |> Enum.into(%{})
  end

  def get_list_of_moves(raw_moves_string) do
    raw_moves_string
    |> String.split("\r\n")
    |> Enum.map(fn string ->
      String.split(string, ["move ", " from ", " to "], trim: true)
      |> then(fn [amount, from, to] ->
        %{
          amount: String.to_integer(amount),
          from: String.to_integer(from),
          to: String.to_integer(to)
        }
      end)
    end)
  end

  def apply_moves(crates, moves) do
    moves
    |> Enum.reduce(crates, fn move, map ->
      from_column = Map.get(map, move.from)
      to_column = Map.get(map, move.to)

      crates_that_will_move = Enum.take(from_column, move.amount) |> Enum.reverse()

      Map.put(map, move.from, Enum.drop(from_column, move.amount))
      |> Map.put(move.to, crates_that_will_move ++ to_column)
    end)
  end

  def get_top_layer_crates_string(map) do
    map
    |> Enum.reduce("", fn {_ind, values}, acc ->
      <<"[", letter::binary-size(1), "]">> = Enum.at(values, 0)

      "#{acc}#{letter}"
    end)
  end
end

[raw_crates_string, raw_movements_string] =
  AdventOfCode20225.read_file(:real)

initial_crates =
  raw_crates_string
  |> AdventOfCode20225.get_initial_crates_map()

moves =
  raw_movements_string
  |> AdventOfCode20225.get_list_of_moves()

AdventOfCode20225.apply_moves(initial_crates, moves)
|> AdventOfCode20225.get_top_layer_crates_string()
|> IO.inspect(label: "task 1")
