defmodule AdventOfCode20223 do
  @line_break "\r\n"

  @alphabet %{
    "a" => 1,
    "b" => 2,
    "c" => 3,
    "d" => 4,
    "e" => 5,
    "f" => 6,
    "g" => 7,
    "h" => 8,
    "i" => 9,
    "j" => 10,
    "k" => 11,
    "l" => 12,
    "m" => 13,
    "n" => 14,
    "o" => 15,
    "p" => 16,
    "q" => 17,
    "r" => 18,
    "s" => 19,
    "t" => 20,
    "u" => 21,
    "v" => 22,
    "w" => 23,
    "x" => 24,
    "y" => 25,
    "z" => 26
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

  def split_string_in_half(string) do
    half_point = Integer.floor_div(String.length(string), 2)

    <<left::binary-size(half_point), right::binary-size(half_point)>> = string

    {left, right}
  end

  def get_intersection({string_one, string_two}) do
    graphemes_one = String.graphemes(string_one)
    graphemes_two = String.graphemes(string_two)

    graphemes_one
    |> Enum.filter(fn grapheme -> grapheme in graphemes_two end)
    |> Enum.uniq()
    |> then(&Enum.at(&1, 0))
  end

  def get_intersection({string_one, string_two, string_three}) do
    graphemes_one = String.graphemes(string_one)
    graphemes_two = String.graphemes(string_two)
    graphemes_three = String.graphemes(string_three)

    graphemes_one
    |> Enum.filter(fn grapheme -> grapheme in graphemes_two and grapheme in graphemes_three end)
    |> Enum.uniq()
    |> then(&Enum.at(&1, 0))
  end

  def get_priority_for_letter(letter) when is_binary(letter) do
    capitalized_letter = String.downcase(letter)

    priority =
      Map.get(@alphabet, capitalized_letter)

    if Regex.match?(~r/[a-z]/, letter), do: priority, else: priority + 26
  end
end

# Task 1
AdventOfCode20223.read_file(:real)
|> Enum.map(&AdventOfCode20223.split_string_in_half/1)
|> Enum.map(&AdventOfCode20223.get_intersection/1)
|> Enum.map(&AdventOfCode20223.get_priority_for_letter/1)
|> Enum.sum()
|> IO.inspect(label: "task 1")

# Task 2
AdventOfCode20223.read_file(:real)
|> Enum.chunk_every(3)
|> Enum.map(&List.to_tuple/1)
|> Enum.map(&AdventOfCode20223.get_intersection/1)
|> Enum.map(&AdventOfCode20223.get_priority_for_letter/1)
|> Enum.sum()
|> IO.inspect(label: "task 2")
