defmodule AdventOfCode20233 do
  @string_delimiter "\r\n"

  @type file_content :: list(String.t())
  @type matrix :: list(list(String.t()))
  @type symbol_position :: %{line: integer(), col: integer()}

  @spec read_file(String.t()) :: file_content()
  def read_file(path) do
    case File.read(path) do
      {:ok, result} -> result |> String.split(@string_delimiter)
      {:error, error} -> IO.inspect(error)
    end
  end

  @spec get_all_symbol_positions(file_content()) :: list(symbol_position())
  def get_all_symbol_positions(file_content) do
    file_content
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, line_ind} ->
      line
      |> Enum.with_index()
      |> Enum.map(fn {col, col_ind} ->
        if String.match?(col, ~r/[^0-9.]/), do: %{line: line_ind, col: col_ind}, else: nil
      end)
    end)
    |> Enum.filter(&(&1 != nil))
  end

  @spec get_imediate_neighbours(matrix(), symbol_position()) :: matrix()
  def get_imediate_neighbours(matrix, %{line: 0, col: 0}) do
    above = [".", ".", "."]
    middle = [".", ".", matrix |> Enum.at(0) |> Enum.at(1)]
    below = [".", matrix |> Enum.at(1) |> Enum.at(0), matrix |> Enum.at(1) |> Enum.at(1)]

    [
      above,
      middle,
      below
    ]
  end

  def get_imediate_neighbours(matrix, %{line: 0, col: 1}) do
    above = [".", ".", "."]
    middle = [matrix |> Enum.at(0) |> Enum.at(0), ".", matrix |> Enum.at(0) |> Enum.at(2)]
    below = [matrix |> Enum.at(1) |> Enum.at(0), matrix |> Enum.at(1) |> Enum.at(1), matrix |> Enum.at(1) |> Enum.at(2)]

    [
      above,
      middle,
      below
    ]
  end

  def get_imediate_neighbours(matrix, %{line: 1, col: 0}) do
    above = [".", matrix |> Enum.at(0) |> Enum.at(0), matrix |> Enum.at(0) |> Enum.at(1)]
    middle = [".", ".", matrix |> Enum.at(1) |> Enum.at(1)]
    below = [".", matrix |> Enum.at(2) |> Enum.at(0), matrix |> Enum.at(2) |> Enum.at(1)]

    [
      above,
      middle,
      below
    ]
  end

  def get_imediate_neighbours(matrix, %{line: line, col: 0}) when line == length(matrix) - 1 do
    above = [".", matrix |> Enum.at(line - 1) |> Enum.at(0), matrix |> Enum.at(line - 1) |> Enum.at(1)]
    middle = [".", ".", matrix |> Enum.at(line) |> Enum.at(1)]
    below = [".", ".", "."]

    [
      above,
      middle,
      below
    ]
  end
end
