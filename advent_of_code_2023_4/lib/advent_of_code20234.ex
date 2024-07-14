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
        |> String.split(" ", trim: true)
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

  def get_copy_cards(formatted_input, {id, amount}) do
    index_and_cards =
      formatted_input
      |> Enum.with_index()
      |> Enum.map(fn {_, ind} -> {ind+1, Enum.at(formatted_input, ind)} end)

    min_range = max((id+1), 0)
    max_range = min((id+amount), length(formatted_input)-1)

    min_range..max_range
    |> Enum.map(fn range_id ->
      index_and_cards
      |> Enum.find(fn {index, _card} -> range_id == index end)
    end)
    |> Enum.filter(& &1)
    |> Enum.map( fn {_, card} -> card end)
  end
end

# AdventOfCode20234.read_file("./lib/example_input.txt")
# |> AdventOfCode20234.get_formatted_input()
# |> Enum.map(&AdventOfCode20234.count_common_numbers/1)
# |> AdventOfCode20234.get_total_result()
# |> IO.inspect

formatted_input =
AdventOfCode20234.read_file("./lib/example_input.txt")
|> AdventOfCode20234.get_formatted_input()

formatted_input
|> Enum.map(&AdventOfCode20234.count_common_numbers/1)
|> Enum.with_index(&({&2+1, &1}))
|> Enum.map(&AdventOfCode20234.get_copy_cards(formatted_input, &1))
|> Enum.with_index()
|> Enum.map(& IO.inspect(&1))
