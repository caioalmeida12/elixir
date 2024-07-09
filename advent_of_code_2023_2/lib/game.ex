defmodule Game do
  @type roll :: %{red: integer(), green: integer(), blue: integer()}
  @type rolls_string :: String.t()
  @type roll_list :: [roll]

  @type t :: %__MODULE__{
          id: integer() | nil,
          rolls: rolls_string() | nil
        }
  @enforce_keys [:id, :rolls]
  defstruct id: nil, rolls: nil

  @doc """
  Takes in the `Game.rolls` string, which is expected to be a semicolon-separated list of rolls,
  each roll detailing the counts of red, blue, and green items in a specific format,
  and outputs a list of strings where each string represents the counts of red, blue, and green items for a single roll.

  ## Examples

      iex> Game.get_list_of_rolls("1 red, 5 blue, 10 green; 5 green, 6 blue, 12 red; 4 red, 10 blue, 4 green")
      ["1 red, 5 blue, 10 green", "5 green, 6 blue, 12 red", "4 red, 10 blue, 4 green"]
  """
  @spec get_list_of_rolls(rolls_string()) :: list(String.t())
  def get_list_of_rolls(rolls) when is_binary(rolls) do
    String.split(rolls, "; ")
  end

  @spec get_integers_from_string(String.t() | nil) :: integer()
  def get_integers_from_string(string) when is_binary(string) do
    string
    |> String.graphemes()
    |> Enum.filter(&String.match?(&1, ~r/\d/))
    |> Enum.join()
    |> String.to_integer()
  end

  def get_integers_from_string(nil), do: 0

  @doc """
  Takes in a roll `ex: "1 red, 5 blue, 10 green"` and returns a tuple of :red, :green and :blue

  ## Examples
      iex > Game.get_numeric_values_from_roll("1 red, 5 blue, 10 green")
      {
        red: 1,
        blue: 5,
        green: 10
      }
  """
  @spec get_numeric_values_from_roll(String.t()) :: roll()
  def get_numeric_values_from_roll(roll) do
    rgb_list = String.split(roll, ", ")
    red = rgb_list |> Enum.find(&String.contains?(&1, "red")) |> get_integers_from_string()
    blue = rgb_list |> Enum.find(&String.contains?(&1, "blue")) |> get_integers_from_string()
    green = rgb_list |> Enum.find(&String.contains?(&1, "green")) |> get_integers_from_string()

    %{
      red: red,
      green: green,
      blue: blue
    }
  end

  @doc """
  Takes a list of maps, each representing a roll with numeric values for red, green, and blue, and returns a map with the maximum values found for each color across all rolls.

  ## Examples

    iex> Game.get_max_values_from_list_of_rolls([%{red: 1, green: 5, blue: 10}, %{red: 2, green: 1, blue: 0}, %{red: 3, green: 0, blue: 12}])
    %{red: 3, green: 5, blue: 12}
  """
  @spec get_max_values_from_list_of_rolls(list(roll())) :: roll()
  def get_max_values_from_list_of_rolls(list_of_rolls) do
    Enum.reduce(list_of_rolls, %{red: 0, green: 0, blue: 0}, fn %{red: r, green: g, blue: b},
                                                                acc ->
      %{
        red: max(r, acc.red),
        green: max(g, acc.green),
        blue: max(b, acc.blue)
      }
    end)
  end

  @doc """
  Takes in a roll and outputs whether it was possible or not based on a fixed maximum amount of each color per roll. The maximum amounts are: `%{red: 12, green: 13, blue: 14}`.

  ## Examples

      iex> Game.was_this_game_possible?(%{red: 12, green: 13, blue: 14})
      true

      iex> Game.was_this_game_possible?(%{red: 13, green: 13, blue: 14})
      false

      iex> Game.was_this_game_possible?(%{red: 11, green: 12, blue: 14})
      true

  """
  @spec was_this_game_possible?(roll()) :: boolean()
  def was_this_game_possible?(roll) do
    %{red: r, green: g, blue: b} = roll
    r <= 12 and g <= 13 and b <= 14
  end

  @spec get_id_if_was_possible(integer(), roll()) :: integer()
  def get_id_if_was_possible(id, roll) do
    if was_this_game_possible?(roll), do: id, else: 0
  end
end
