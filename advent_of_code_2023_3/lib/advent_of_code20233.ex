defmodule AdventOfCode20233 do
  @string_delimiter "\r\n"

  @type file_content :: list(String.t())
  @type outer_matrix :: list(list(String.t()))
  @type symbol_position :: %{line: integer(), col: integer()}
  @type inner_matrix :: {outer_matrix(), symbol_position()}

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

  @spec get_imediate_neighbours(outer_matrix(), symbol_position()) :: outer_matrix()
  def get_imediate_neighbours(matrix, %{line: 0, col: 0}) do
    above = [".", ".", "."]
    middle = [".", ".", matrix |> Enum.at(0) |> Enum.at(1)]
    below = [".", matrix |> Enum.at(1) |> Enum.at(0), matrix |> Enum.at(1) |> Enum.at(1)]

    {[above, middle, below], %{line: 0, col: 0}}
  end

  def get_imediate_neighbours(matrix, %{line: 0, col: 1}) do
    above = [".", ".", "."]
    middle = [matrix |> Enum.at(0) |> Enum.at(0), ".", matrix |> Enum.at(0) |> Enum.at(2)]

    below = [
      matrix |> Enum.at(1) |> Enum.at(0),
      matrix |> Enum.at(1) |> Enum.at(1),
      matrix |> Enum.at(1) |> Enum.at(2)
    ]

    {[above, middle, below], %{line: 0, col: 1}}
  end

  def get_imediate_neighbours(matrix, %{line: 1, col: 0}) do
    above = [".", matrix |> Enum.at(0) |> Enum.at(0), matrix |> Enum.at(0) |> Enum.at(1)]
    middle = [".", ".", matrix |> Enum.at(1) |> Enum.at(1)]
    below = [".", matrix |> Enum.at(2) |> Enum.at(0), matrix |> Enum.at(2) |> Enum.at(1)]

    {[above, middle, below], %{line: 1, col: 0}}
  end

  def get_imediate_neighbours(matrix, %{line: line, col: 0}) when line == length(matrix) - 1 do
    above = [
      ".",
      matrix |> Enum.at(line - 1) |> Enum.at(0),
      matrix |> Enum.at(line - 1) |> Enum.at(1)
    ]

    middle = [".", ".", matrix |> Enum.at(line) |> Enum.at(1)]
    below = [".", ".", "."]

    {[above, middle, below], %{line: line, col: 0}}
  end

  def get_imediate_neighbours(matrix, %{line: line, col: 1}) when line == length(matrix) - 1 do
    above = [
      matrix |> Enum.at(line - 1) |> Enum.at(0),
      matrix |> Enum.at(line - 1) |> Enum.at(1),
      matrix |> Enum.at(line - 1) |> Enum.at(2)
    ]

    middle = [matrix |> Enum.at(line) |> Enum.at(0), ".", matrix |> Enum.at(line) |> Enum.at(2)]
    below = [".", ".", "."]

    {[above, middle, below], %{line: line, col: 1}}
  end

  def get_imediate_neighbours(matrix, %{line: line, col: col}) when line == length(matrix) - 1 do
    # check if it's the last column
    max_col_ind = length(Enum.at(matrix, 0)) - 1

    if col == max_col_ind do
      above = [
        matrix |> Enum.at(line - 1) |> Enum.at(col - 1),
        matrix |> Enum.at(line - 1) |> Enum.at(col),
        "."
      ]

      middle = [matrix |> Enum.at(line) |> Enum.at(col - 1), ".", "."]
      below = [".", ".", "."]

      {[above, middle, below], %{line: line, col: col}}
    else
      # Handle cells on the last row but not in the last column
      above = [
        matrix |> Enum.at(line - 1) |> Enum.at(col - 1),
        matrix |> Enum.at(line - 1) |> Enum.at(col),
        matrix |> Enum.at(line - 1) |> Enum.at(col + 1)
      ]

      middle = [
        matrix |> Enum.at(line) |> Enum.at(col - 1),
        ".",
        matrix |> Enum.at(line) |> Enum.at(col + 1)
      ]

      below = [".", ".", "."]

      {[above, middle, below], %{line: line, col: col}}
    end
  end

  def get_imediate_neighbours(matrix, %{line: line, col: col}) do
    above = [
      matrix |> Enum.at(line - 1) |> Enum.at(col - 1),
      matrix |> Enum.at(line - 1) |> Enum.at(col),
      matrix |> Enum.at(line - 1) |> Enum.at(col + 1)
    ]

    middle = [
      matrix |> Enum.at(line) |> Enum.at(col - 1),
      ".",
      matrix |> Enum.at(line) |> Enum.at(col + 1)
    ]

    below = [
      matrix |> Enum.at(line + 1) |> Enum.at(col - 1),
      matrix |> Enum.at(line + 1) |> Enum.at(col),
      matrix |> Enum.at(line + 1) |> Enum.at(col + 1)
    ]

    {[above, middle, below], %{line: line, col: col}}
  end

  def is_left_a_number(line, index) do
    is_left_a_number(line, index, [])
  end

  defp is_left_a_number(_line, 0, acc), do: acc

  defp is_left_a_number(line, index, acc) do
    char = Enum.at(line, index - 1)

    if String.match?(char, ~r/\d/) do
      # If the character is a number, add it to the accumulator and continue left
      is_left_a_number(line, index - 1, [char | acc])
    else
      # If the character is not a number, return the accumulated numbers
      acc
    end
  end

  @spec get_numbers_to_the_left(outer_matrix(), inner_matrix()) :: integer()
  def get_numbers_to_the_left(
        outer_matrix,
        {inner_matrix, %{line: _inner_line, col: inner_col}}
      ) do
    outer_matrix
    |> Enum.with_index()
    |> Enum.map(fn {outer_line_value, outer_line_index} ->
      last_number =
        inner_matrix
        |> Enum.at(outer_line_index)
        |> Enum.with_index()
        |> Enum.reverse()
        |> Enum.find(&String.match?(Tuple.to_list(&1) |> Enum.at(0), ~r/\d/))

      if (last_number != nil) do
        # take a line of the inner matrix and get the index of the last number
        {last_number, last_number_index} =
          inner_matrix
          |> Enum.at(outer_line_index)
          |> IO.inspect()
          |> Enum.with_index()
          |> Enum.reverse()
          |> Enum.find(&String.match?(Tuple.to_list(&1) |> Enum.at(0), ~r/\d/))

        # extrapolate the last_number_index to the scope of the outer matrix
        outer_matrix_last_number_index = inner_col - 1 + last_number_index

        # check if the digit to the left of the outer_matrix_last_number_index is a number

        numbers_left =
          is_left_a_number(
            outer_line_value,
            outer_matrix_last_number_index
          )

        # returns the full number
        [numbers_left | [last_number]]
        |> List.flatten()
        |> Enum.join()
        |> String.to_integer()
      else
        # no numbers in the line
        0
      end
    end)
  end
end
