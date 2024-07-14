defmodule AdventOfCode20234 do
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

  def get_formatted_input(file_content) do
    file_content
    |> Enum.map(fn row ->
       card_id =
        row
        |> String.split(":", trim: true)
        |> Enum.at(0)
        |> String.split(" ")
        |> Enum.at(1)

        [winning_numbers, card_numbers] =
          row
          |> String.split(":", trim: true)
          |> Enum.at(1)
          |> String.split("|", trim: true)
          |> Enum.map(fn side ->
            side
            |> String.split(" ")
            |> Enum.reject(& &1=="")
          end)

      %{id: card_id, winning_numbers: winning_numbers, card_numbers: card_numbers}
    end)
  end

  def count_common_numbers(%{id: _card_id, winning_numbers: winning_numbers, card_numbers: card_numbers}) do
    winning_numbers
    |> Enum.reduce(0, fn number, acc ->
      if Enum.find(card_numbers, &(number==&1)), do: acc + 1, else: acc
    end)
  end

  def get_total_result(list_of_points) do
    list_of_points
    |> Enum.reduce(0, fn val, acc ->
      if val > 0, do: acc + :math.pow(2, val-1), else: acc
    end)
  end
end

AdventOfCode20234.read_file("./lib/input.txt")
|> AdventOfCode20234.get_formatted_input()
|> Enum.map(&AdventOfCode20234.count_common_numbers/1)
|> AdventOfCode20234.get_total_result()
|> IO.inspect
