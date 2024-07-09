defmodule AdventOfCode20231 do
  @string_delimiter "\r\n"

  @spec read_file(String.t()) :: list(String.t())
  def read_file(path) do
    case File.read(path) do
      {:ok, result} -> result |> String.split(@string_delimiter)
      {:error, error} -> IO.inspect(error)
    end
  end

  @spec get_numbers_from_string(String.t()):: list(integer())
  def get_numbers_from_string(string) do
    string
    |> String.graphemes()
    |> Enum.filter(fn char -> String.match?(char, ~r/^\d$/) end)
    |> Enum.map(&String.to_integer/1)
  end

  @spec get_first_and_last_integer_from_enum(list(integer())) :: {integer(), integer()}
  def get_first_and_last_integer_from_enum(enum) do
    {Enum.at(enum, 0), Enum.at(enum, Enum.count(enum) - 1)}
  end

  @spec get_two_digit_number_from_tuple({integer(), integer()}):: integer()
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
    |> IO.inspect()
  end
end

AdventOfCode20231.get_calibration_values("./lib/input.txt")
