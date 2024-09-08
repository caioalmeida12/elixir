defmodule Tile do
  defstruct char: nil, can_connect_to: nil, pos: {nil, nil}, is_connected_to: []

  def create_from_char(char, pos)
      when char in [".", "|", "-", "7", "L", "F", "J", "S"] do
    case char do
      "." -> create_dot_pipe(pos)
      "|" -> create_vertical_pipe(pos)
      "-" -> create_horizontal_pipe(pos)
      "F" -> create_f_pipe(pos)
      "L" -> create_l_pipe(pos)
      "7" -> create_7_pipe(pos)
      "J" -> create_j_pipe(pos)
      "S" -> create_s_pipe(pos)
    end
  end

  def neighbours(%Tile{pos: {row_ind, col_ind}}, matrix_of_tiles) do
    all_tiles = List.flatten(matrix_of_tiles)

    up = all_tiles |> Enum.filter(&(&1.pos == {row_ind - 1, col_ind}))
    right = all_tiles |> Enum.filter(&(&1.pos == {row_ind, col_ind + 1}))
    down = all_tiles |> Enum.filter(&(&1.pos == {row_ind + 1, col_ind}))
    left = all_tiles |> Enum.filter(&(&1.pos == {row_ind, col_ind - 1}))

    [up, right, down, left]
    |> Enum.flat_map(&Enum.reject(&1, fn %Tile{char: char} -> char == "." end))
  end

  def populate_connections(%Tile{char: "."} = tile, _matrix_of_tiles), do: tile

  def populate_connections(%Tile{char: "S"} = tile, matrix_of_tiles) do
  end

  def populate_connections(%Tile{pos: {row_ind, col_ind}} = tile, matrix_of_tiles)
      when is_map(tile) and is_list(matrix_of_tiles) do
    neighbours(tile, matrix_of_tiles)
    # connections =
    #   Enum.reject(Tile.neighbours(tile, matrix_of_tiles), &(&1 == [] or &1.char == "."))

    # Map.put(tile, :is_connected_to, connections)
  end

  defp create_dot_pipe(pos), do: %Tile{char: ".", can_connect_to: {nil, nil}, pos: pos}
  defp create_vertical_pipe(pos), do: %Tile{char: "|", can_connect_to: {:top, :down}, pos: pos}

  defp create_horizontal_pipe(pos),
    do: %Tile{char: "-", can_connect_to: {:left, :right}, pos: pos}

  defp create_f_pipe(pos), do: %Tile{char: "F", can_connect_to: {:down, :right}, pos: pos}
  defp create_j_pipe(pos), do: %Tile{char: "J", can_connect_to: {:top, :left}, pos: pos}
  defp create_l_pipe(pos), do: %Tile{char: "L", can_connect_to: {:top, :right}, pos: pos}
  defp create_7_pipe(pos), do: %Tile{char: "7", can_connect_to: {:down, :left}, pos: pos}
  defp create_s_pipe(pos), do: %Tile{char: "S", can_connect_to: {:s_tile, :s_tile}, pos: pos}
end

defmodule AdventOfCode202310 do
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

  def input_to_matrix(list_of_lines) do
    list_of_lines
    |> Enum.map(&String.graphemes/1)
  end

  def matrix_to_tiles(input_as_matrix) do
    input_as_matrix
    |> Enum.with_index(fn line, row_ind ->
      line
      |> Enum.with_index(fn char, col_ind ->
        Tile.create_from_char(char, {row_ind, col_ind})
      end)
    end)
  end

  def populate_tile_connections(matrix_of_tiles) do
    matrix_of_tiles
    |> List.flatten()
    |> Enum.map(&Tile.populate_connections(&1, matrix_of_tiles))
  end
end

AdventOfCode202310.read_file()
|> AdventOfCode202310.input_to_matrix()
|> AdventOfCode202310.matrix_to_tiles()
|> AdventOfCode202310.populate_tile_connections()
|> IO.inspect()
