defmodule AdventOfCode20232 do
  @type roll :: %{red: integer(), green: integer(), blue: integer()}
  @type id_and_max_roll :: %{id: integer(), max_roll: roll()}

  @string_delimiter "\r\n"

  @doc """
  Reads a file from the given path and returns a list of strings, each representing a line from the file. If an error occurs, the error is printed.

  ## Examples

      iex> AdventOfCode20232.read_file("path/to/file")
      ["Game 1: 1 red, 5 blue, 10 green; 5 green, 6 blue, 12 red; 4 red, 10 blue, 4 green", "Game 2: 2 green, 1 blue; 1 red, 2 green"]
  """
  @spec read_file(String.t()) :: list(String.t())
  def read_file(path) do
    case File.read(path) do
      {:ok, result} -> result |> String.split(@string_delimiter)
      {:error, error} -> IO.inspect(error)
    end
  end

  @doc """
  Processes a list of game strings, extracting the game ID and calculating the maximum roll for each game. Returns a list of maps, each containing the game ID and its maximum roll.

  ## Examples

      iex> AdventOfCode20232.get_ids_and_max_rolls(["Game 1: 1 red, 5 blue, 10 green; 5 green, 6 blue, 12 red; 4 red, 10 blue, 4 green"])
      [%{id: 1, max_roll: %{red: 12, green: 10, blue: 10}}]
  """
  @spec get_ids_and_max_rolls(list(String.t())) :: list(id_and_max_roll())
  def get_ids_and_max_rolls(games) do
    game_ids =
      games
      |> Enum.map(
        &(String.split(&1, ":")
          |> Enum.at(0)
          |> String.split(" ")
          |> Enum.at(1)
          |> String.to_integer())
      )

    game_max_rolls =
      games
      |> Enum.map(&(String.split(&1, ": ") |> Enum.at(1)))
      |> Enum.map(&Game.get_list_of_rolls/1)
      |> Enum.map(fn game ->
        game
        |> Enum.map(&Game.get_numeric_values_from_roll/1)
      end)
      |> Enum.map(&Game.get_max_values_from_list_of_rolls/1)

    games
    |> Enum.with_index()
    |> Enum.map(fn {_, ind} ->
      %{
        id: Enum.at(game_ids, ind),
        max_rolls: Enum.at(game_max_rolls, ind)
      }
    end)
  end

  @doc """
  Given a list of games, identifies which games are possible based on a fixed maximum amount of each color per roll. Returns a list of game IDs for which the game is possible.

  ## Examples

      iex> AdventOfCode20232.get_all_possible_game_ids([%{id: 1, max_roll: %{red: 12, green: 13, blue: 14}}, %{id: 2, max_roll: %{red: 13, green: 13, blue: 14}}])
      [1]
  """
  @spec get_all_possible_game_ids(list(id_and_max_roll())) :: list(integer())
  def get_all_possible_game_ids(games) do
    games
    |> get_ids_and_max_rolls()
    |> Enum.map(&Game.get_id_if_was_possible(&1.id, &1.max_rolls))
    |> Enum.sum()
  end
end

AdventOfCode20232.read_file("./lib/input.txt") |> AdventOfCode20232.get_all_possible_game_ids() |> IO.inspect()
