defmodule AdventOfCode20231 do
  @string_delimiter "\r\n"

  @spec read_file(String.t()) :: list(String.t())
  def read_file(path) do
    case File.read(path) do
      {:ok, result} -> result |> String.split(@string_delimiter)
      {:error, error} -> IO.inspect(error)
    end
  end

  @spec get_numbers_from_string(String.t()) :: list(integer())
  def get_numbers_from_string(string) do
    string
    |> String.graphemes()
    |> Enum.filter(fn char -> String.match?(char, ~r/^\d$/) end)
    |> Enum.map(&String.to_integer/1)
  end

  @spec get_numbers_from_string_2(String.t()) :: list(integer())
  def get_numbers_from_string_2(string) do
    numbers_as_string = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

    digits =
      string
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn {char, _ind} -> String.match?(char, ~r/^\d$/) end)
      |> Enum.map(fn {val, ind} -> {String.to_integer(val), ind} end)

    spelled =
      numbers_as_string
      |> Enum.with_index(1)
      |> Enum.flat_map(fn {num_str, num_int} ->
        if String.contains?(string, num_str) do
          :binary.matches(string, num_str)
          |> Enum.map(fn {start, _length} -> {num_int, start} end)
        else
          []
        end
        |> IO.inspect(label: num_int - 1)
      end)

    (digits ++ spelled)
    |> Enum.sort(fn {_v1, i1}, {_v2, i2} -> i1 < i2 end)
    |> Enum.map(fn {val, _ind} -> val end)
  end

  @spec get_first_and_last_integer_from_enum(list(integer())) :: {integer(), integer()}
  def get_first_and_last_integer_from_enum(enum) do
    {Enum.at(enum, 0), Enum.at(enum, Enum.count(enum) - 1)}
  end

  @spec get_two_digit_number_from_tuple({integer(), integer()}) :: integer()
  def get_two_digit_number_from_tuple(tuple) do
    list = Tuple.to_list(tuple)

    "#{Enum.at(list, 0)}#{Enum.at(list, 1)}"
    |> String.to_integer()
  end

  @spec get_calibration_values(String.t()) :: integer()
  def get_calibration_values(path) do
    read_file(path)
    |> Enum.map(&get_numbers_from_string/1)
    |> Enum.map(&get_first_and_last_integer_from_enum/1)
    |> Enum.map(&get_two_digit_number_from_tuple/1)
    |> Enum.reduce(0, &(&1 + &2))
  end

  @spec get_calibration_values_2(String.t()) :: integer()
  def get_calibration_values_2(path) do
    read_file(path)
    |> Enum.map(&get_numbers_from_string_2/1)
    |> Enum.map(&get_first_and_last_integer_from_enum/1)
    |> Enum.map(&get_two_digit_number_from_tuple/1)
    |> Enum.reduce(0, &(&1 + &2))
  end
end

AdventOfCode20231.get_calibration_values_2("./lib/example_input.txt")
|> IO.inspect()
