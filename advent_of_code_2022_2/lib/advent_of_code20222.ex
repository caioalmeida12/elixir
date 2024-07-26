defmodule AdventOfCode20222 do
  @line_break "\r\n"

  @shape_points %{
    "X" => 1,
    "Y" => 2,
    "Z" => 3
  }

  def read_file(), do: read_file("./lib/example_input.txt")
  def read_file(:example_2), do: read_file("./lib/example_input_2.txt")
  def read_file(:real), do: read_file("./lib/input.txt")

  def read_file(path) do
    case File.read(path) do
      {:ok, result} -> result |> String.split(@line_break)
      {:error, error} -> IO.inspect(error)
    end
  end

  def get_each_player_shape(line) do
    String.split(line)
  end

  # A, X -> Rock
  # B, Y -> Paper
  # C, Z -> Scizors

  def matchup("A", ours) do
    case ours do
      "X" -> :draw
      "Y" -> :win
      "Z" -> :lose
    end
  end

  def matchup("B", ours) do
    case ours do
      "X" -> :lose
      "Y" -> :draw
      "Z" -> :win
    end
  end

  def matchup("C", ours) do
    case ours do
      "X" -> :win
      "Y" -> :lose
      "Z" -> :draw
    end
  end

  def what_is_the_perfect_matchup(["A", result]) do
    case result do
      "X" -> ["A", "Z"]
      "Y" -> ["A", "X"]
      "Z" -> ["A", "Y"]
    end
  end

  def what_is_the_perfect_matchup(["B", result]) do
    case result do
      "X" -> ["B", "X"]
      "Y" -> ["B", "Y"]
      "Z" -> ["B", "Z"]
    end
  end

  def what_is_the_perfect_matchup(["C", result]) do
    case result do
      "X" -> ["C", "Y"]
      "Y" -> ["C", "Z"]
      "Z" -> ["C", "X"]
    end
  end

  def score_for_matchup([opponent, ours]) do
    case matchup(opponent, ours) do
      :win -> 6 + @shape_points[ours]
      :draw -> 3 + @shape_points[ours]
      :lose -> 0 + @shape_points[ours]
    end
  end
end

# Task 1
AdventOfCode20222.read_file(:real)
|> Enum.map(&AdventOfCode20222.get_each_player_shape/1)
|> Enum.map(&AdventOfCode20222.score_for_matchup/1)
|> Enum.sum()
|> IO.inspect(label: "task 1")

# Task 2
AdventOfCode20222.read_file(:real)
|> Enum.map(&AdventOfCode20222.get_each_player_shape/1)
|> Enum.map(&AdventOfCode20222.what_is_the_perfect_matchup/1)
|> Enum.map(&AdventOfCode20222.score_for_matchup/1)
|> Enum.sum()
|> IO.inspect(label: "task 2")
