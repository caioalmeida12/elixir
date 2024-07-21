defmodule AdventOfCode20237 do
  @line_break "\r\n"

  @card_values %{
    "A" => 13,
    "K" => 12,
    "Q" => 11,
    "J" => 10,
    "T" => 9,
    "9" => 8,
    "8" => 7,
    "7" => 6,
    "6" => 5,
    "5" => 4,
    "4" => 3,
    "3" => 2,
    "2" => 1
  }

  @type_rankings %{
    :five_of_a_kind => 1,
    :four_of_a_kind => 2,
    :full_house => 3,
    :three_of_a_kind => 4,
    :two_pair => 5,
    :one_pair => 6,
    :high_hand => 7
  }

  def read_file(), do: read_file("./lib/example_input.txt")
  def read_file(:real), do: read_file("./lib/input.txt")

  def read_file(path) do
    case File.read(path) do
      {:ok, result} -> result |> String.split(@line_break)
      {:error, error} -> IO.inspect(error)
    end
  end

  def get_hand_type(hand) do
    [cards, bid] = String.split(hand)
    graphemes = String.graphemes(cards)

    frequencies = Enum.frequencies(graphemes)

    sorted_frequencies =
      frequencies
      |> Enum.sort(fn curr, next ->
        {_label, curr_amount} = curr
        {_label, next_amount} = next

        next_amount < curr_amount
      end)

    {_labels, amounts} = Enum.unzip(sorted_frequencies)

    type =
      case amounts do
        [5] -> :five_of_a_kind
        [4, 1] -> :four_of_a_kind
        [3, 2] -> :full_house
        [3, 1, 1] -> :three_of_a_kind
        [2, 2, 1] -> :two_pair
        [2, 1, 1, 1] -> :one_pair
        _ -> :high_card
      end

    %{
      cards: cards,
      bid: String.to_integer(bid),
      type: type
    }
  end

  def full_sort(hands) do
    hands
    |> Enum.sort(fn curr, next ->
      if curr.type == next.type do
        curr_card_graphemes = String.graphemes(curr.cards)
        next_card_graphemes = String.graphemes(next.cards)

        Enum.reduce_while(0..4, :equal, fn card_index, acc ->
          if acc != :equal, do: {:halt, acc}

          curr_val = Map.get(@card_values, Enum.at(curr_card_graphemes, card_index))
          next_val = Map.get(@card_values, Enum.at(next_card_graphemes, card_index))

          cond do
            curr_val > next_val -> {:halt, :curr_is_bigger}
            curr_val < next_val -> {:halt, :next_is_bigger}
            true -> {:cont, :equal}
          end
        end)
        |> then(fn val -> val == :curr_is_bigger end)
      else
        Map.get(@type_rankings, curr.type) < Map.get(@type_rankings, next.type)
      end
    end)
  end

  def get_total_winnings(fully_sorted_hands) do
    fully_sorted_hands
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {%{type: _type, cards: _cards, bid: bid}, rank} ->
      bid * rank
    end)
    |> Enum.sum()
  end
end

AdventOfCode20237.read_file(:real)
|> Enum.map(&AdventOfCode20237.get_hand_type/1)
|> AdventOfCode20237.full_sort()
|> AdventOfCode20237.get_total_winnings()
|> IO.inspect(label: "task 1")
