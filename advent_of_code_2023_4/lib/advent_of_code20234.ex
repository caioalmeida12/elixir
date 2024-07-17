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
          |> Enum.reject(&(&1 == ""))
        end)

      %{id: card_id, winning_numbers: winning_numbers, card_numbers: card_numbers}
    end)
  end

  def count_common_numbers(%{
        id: _card_id,
        winning_numbers: winning_numbers,
        card_numbers: card_numbers
      }) do
    winning_numbers
    |> Enum.reduce(0, fn number, acc ->
      if Enum.find(card_numbers, &(number == &1)), do: acc + 1, else: acc
    end)
  end

  def get_total_result(list_of_points) do
    list_of_points
    |> Enum.reduce(0, fn val, acc ->
      if val > 0, do: acc + :math.pow(2, val - 1), else: acc
    end)
  end

  def get_winner_cards(path) do
    read_file(path)
    |> Enum.with_index(1)
    |> Enum.map(fn {line, idx} ->
      [_, winners, numbers] = String.split(line, ~r/(: )|( \| )/)

      winners =
        winners
        |> String.split()
        |> Enum.map(&String.to_integer(&1))
        |> MapSet.new()

      score =
        numbers
        |> String.split()
        |> Enum.map(&String.to_integer(&1))
        |> Enum.filter(&(&1 in winners))
        |> length

      {idx, score}
    end)
  end

  def get_total_scratchcards(winners) do
    winners
    |> Enum.reduce(
      1..length(winners) |> Enum.map(&{&1, 1}) |> Enum.into(%{}),
      fn {card, wins}, acc ->
        if wins > 0 do
          (card + 1)..(card + wins)
          |> Enum.reduce(acc, fn i, acc -> Map.put(acc, i, acc[i] + acc[card]) end)
        else
          acc
        end
      end
    )
    |> then(&Map.values/1)
    |> Enum.sum()
  end
end

AdventOfCode20234.get_winner_cards("./lib/input.txt")
|> AdventOfCode20234.get_total_scratchcards()
|> IO.inspect()
