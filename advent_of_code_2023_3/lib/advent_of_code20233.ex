defmodule AdventOfCode20233 do
  @string_delimiter "\r\n"

  @type line :: String.t()
  @type file_content :: list(line())

  @spec read_file(String.t()) :: file_content()
  def read_file(path) do
    case File.read(path) do
      {:ok, result} -> result |> String.split(@string_delimiter)
      {:error, error} -> IO.inspect(error)
    end
  end

  defp convert_list_of_integers_to_list_of_ranges(line) when length(line) == 0, do: []

  defp convert_list_of_integers_to_list_of_ranges(line) when is_list(line) and length(line) > 0 do
    current_val = Enum.at(line, 0)
    next_val = Enum.at(line, 1)

    first_continuous_ind = 0
    current_ind = 0

    if current_val == next_val - 1 do
      # is continuous
      convert_list_of_integers_to_list_of_ranges(
        line,
        first_continuous_ind,
        current_ind + 1,
        current_ind,
        []
      )
    else
      # its not continuous
      convert_list_of_integers_to_list_of_ranges(
        line,
        first_continuous_ind,
        current_ind + 1,
        current_ind,
        [0..0]
      )
    end
  end

  defp convert_list_of_integers_to_list_of_ranges(
         line,
         first_continuous_ind,
         _current_ind,
         last_continuous_ind,
         acc
       )
       when last_continuous_ind == length(line) - 1,
       do:
         acc ++
           [Range.new(Enum.at(line, first_continuous_ind), Enum.at(line, last_continuous_ind))]

  defp convert_list_of_integers_to_list_of_ranges(
         line,
         first_continuous_ind,
         current_ind,
         _last_continuous_ind,
         acc
       ) do
    current_val = Enum.at(line, current_ind)
    next_val = Enum.at(line, current_ind + 1)

    if next_val != nil and current_val == next_val - 1 do
      # is continuous
      convert_list_of_integers_to_list_of_ranges(
        line,
        first_continuous_ind,
        current_ind + 1,
        current_ind + 1,
        acc
      )
    else
      # its not continuous
      new_acc =
        if Enum.at(line, first_continuous_ind) == nil and Enum.at(line, current_ind) == nil,
          do: acc,
          else:
            acc ++ [Range.new(Enum.at(line, first_continuous_ind), Enum.at(line, current_ind))]

      if current_ind <= length(line) do
        convert_list_of_integers_to_list_of_ranges(
          line,
          current_ind + 1,
          current_ind + 1,
          current_ind + 1,
          new_acc
        )
      else
        acc
      end
    end
  end

  @spec get_number_coordinates_for_line(file_content(), integer()) :: list(tuple())
  def get_number_coordinates_for_line(file_content, line_index) do
    line =
      file_content
      |> Enum.at(line_index)

    list_of_integer_coordinates =
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn {char, _} -> String.match?(char, ~r/\d/) end)
      |> Enum.map(fn {_char, coord} -> coord end)

    ranges = convert_list_of_integers_to_list_of_ranges(list_of_integer_coordinates)

    list_of_coordinates =
      ranges
      |> Enum.map(fn range ->
        Enum.map(range, fn col -> {line_index, col} end)
      end)

    list_of_coordinates
    |> Enum.map(fn adjacent_coordinates ->
      # adjacent_coordinates = [{0, 0}, {0, 1}, {0, 2}]

      # [0, 1, 2]
      cols_with_number =
        adjacent_coordinates
        |> Enum.map(fn {_, col} -> col end)

      list_of_chars =
        line
        |> String.graphemes()

      number =
        cols_with_number
        |> Enum.map(&Enum.at(list_of_chars, &1))
        |> Enum.join()
        |> String.to_integer()

      # {467, [{0, 0}, {0, 1}, {0, 2}]}
      {number, adjacent_coordinates}
    end)
  end

  @spec get_symbol_coordinates(file_content()) :: list(tuple())
  def get_symbol_coordinates(file_content) do
    file_content
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, line_ind} ->
      graphemes = String.graphemes(line)

      graphemes
      |> Enum.with_index()
      |> Enum.map(fn {_col, col_ind} ->
        value =
          graphemes
          |> Enum.at(col_ind)

        unless String.match?(value, ~r/^\d$|^\.$/) do
          {line_ind, col_ind}
        end
      end)
    end)
    |> Enum.filter(& &1)
  end

  @spec get_adjacent_coordinates_of_symbol(file_content(), tuple()) :: list(tuple())
  def get_adjacent_coordinates_of_symbol(file_content, {line, col}) do
    max_line = file_content |> Enum.count()
    max_col = file_content |> Enum.at(0) |> String.graphemes() |> Enum.count()

    min_line = 0
    min_col = 0

    possible_lines = [max(min_line, line - 1), line, min(max_line, line + 1)] |> Enum.uniq()
    possible_cols = [max(min_col, col - 1), col, min(max_col, col + 1)] |> Enum.uniq()

    possible_coords =
      possible_lines
      |> Enum.flat_map(fn line_ind ->
        possible_cols
        |> Enum.map(&{line_ind, &1})
      end)

    # reject the symbol position, as it is never gonna be a number
    possible_coords
    |> Enum.reject(&(&1 == {line, col}))
  end
end

file_content = AdventOfCode20233.read_file("./lib/input.txt")

numbers_with_coordinates =
  file_content
  |> Enum.with_index()
  |> Enum.flat_map(fn {_line, line_ind} ->
    AdventOfCode20233.get_number_coordinates_for_line(file_content, line_ind)
  end)

symbol_adjacent_coordinates =
  file_content
  |> AdventOfCode20233.get_symbol_coordinates()
  |> Enum.map(&AdventOfCode20233.get_adjacent_coordinates_of_symbol(file_content, &1))

symbol_adjacent_coordinates
|> Enum.flat_map(fn coords_of_line ->
  coords_of_line
  |> Enum.map(fn neighbour_of_symbol ->
    numbers_with_coordinates
    |> Enum.map(fn {number, coordinates} ->
      if Enum.find_index(coordinates, &(neighbour_of_symbol == &1)), do: number, else: 0
    end)

    # for every coordinate adjacent of a symbol (neighbour_of_symbol)
    # take the numbers_with_coordinates
    # for every number
    # take the coordinates of it
    # check if this neighbour_of_symbol is in that enum
    # if it is, return the number
    # else, return 0
  end)
end)
|> Enum.sort()
|> Enum.dedup()
|> List.flatten()
|> Enum.sum()
|> IO.inspect()
