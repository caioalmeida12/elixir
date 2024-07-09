defmodule GameTest do
  use ExUnit.Case
  doctest Game

  test "can instantiate with only id and rolls" do
    assert %Game{
      id: 1,
      rolls: "1 red, 5 blue, 10 green; 5 green, 6 blue, 12 red; 4 red, 10 blue, 4 green"
    }
  end

  test "breaks the rolls down into a list" do
    assert Game.get_list_of_rolls("1 red, 5 blue, 10 green; 5 green, 6 blue, 12 red; 4 red, 10 blue, 4 green") == ["1 red, 5 blue, 10 green", "5 green, 6 blue, 12 red", "4 red, 10 blue, 4 green"]
  end

  test "gets the get_numeric_values_from_roll tuple from a roll" do
    assert Game.get_numeric_values_from_roll("1 red, 5 blue, 10 green") == %{red: 1, green: 10, blue: 5}
  end

  test "gets the maximum values from a list of rolls" do
    assert Game.get_max_values_from_list_of_rolls([%{red: 1, green: 5, blue: 10}, %{red: 2, green: 1, blue: 0}, %{red: 3, green: 0, blue: 12}]) == %{red: 3, green: 5, blue: 12}
  end

  test "checks if a game roll was possible" do
    assert Game.was_this_game_possible?(%{red: 12, green: 13, blue: 14}) == true
    assert Game.was_this_game_possible?(%{red: 13, green: 13, blue: 14}) == false
    assert Game.was_this_game_possible?(%{red: 11, green: 12, blue: 14}) == true
  end

  test "gets the game id if the game was possible" do
    game = %Game{id: 1, rolls: "1 red, 5 blue, 10 green; 5 green, 6 blue, 12 red; 4 red, 10 blue, 4 green"}
    assert Game.get_id_if_was_possible(game.id, %{red: 12, green: 13, blue: 14}) == 1

    impossible_game = %Game{id: 2, rolls: "13 red, 5 blue, 10 green; 5 green, 6 blue, 12 red; 4 red, 10 blue, 4 green"}
    assert Game.get_id_if_was_possible(impossible_game.id, %{red: 13, green: 13, blue: 13}) == 0
  end

  test "handles rolls with missing color values correctly" do
    assert Game.get_numeric_values_from_roll("2 green, 1 blue") == %{red: 0, green: 2, blue: 1}
    assert Game.get_numeric_values_from_roll("1 red, 2 green") == %{red: 1, green: 2, blue: 0}
    assert Game.get_numeric_values_from_roll("3 red, 1 blue") == %{red: 3, green: 0, blue: 1}
    assert Game.get_numeric_values_from_roll("2 blue, 1 green, 8 red") == %{red: 8, green: 1, blue: 2}
    assert Game.get_numeric_values_from_roll("10 red") == %{red: 10, green: 0, blue: 0}
    assert Game.get_numeric_values_from_roll("1 green, 10 red") == %{red: 10, green: 1, blue: 0}
    assert Game.get_numeric_values_from_roll("11 blue, 3 red") == %{red: 3, green: 0, blue: 11}
    assert Game.get_numeric_values_from_roll("3 blue, 2 green, 13 red") == %{red: 13, green: 2, blue: 3}
    assert Game.get_numeric_values_from_roll("11 red, 7 blue, 1 green") == %{red: 11, green: 1, blue: 7}
  end
end
