defmodule AdventOfCode20221 do
  @line_break "\r\n\r\n"

  def read_file(), do: read_file("./lib/example_input.txt")
  def read_file(:example_2), do: read_file("./lib/example_input_2.txt")
  def read_file(:real), do: read_file("./lib/input.txt")

  def read_file(path) do
    case File.read(path) do
      {:ok, result} -> result |> String.split(@line_break)
      {:error, error} -> IO.inspect(error)
    end
  end

  def format_input(file_content) do
    file_content
    |> Enum.map(&String.split(&1, "\r\n"))
    |> Enum.map(fn calories_list ->
      calories_list
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.with_index()
    |> Enum.map(fn {calories, elf} ->
      {elf, %{calories: calories, total_calories: Enum.sum(calories)}}
    end)
    |> Enum.into(%{})
  end

  def sort_elves_by_calories(%{} = elves_map) do
    elves_map
    |> Enum.sort(fn {_curr_elf, %{total_calories: curr_total_calories}},
                    {_next_elf, %{total_calories: next_total_calories}} ->
      curr_total_calories > next_total_calories
    end)
  end
end

AdventOfCode20221.read_file(:real)
|> AdventOfCode20221.format_input()
|> AdventOfCode20221.sort_elves_by_calories()
|> Enum.at(0)
|> then(fn {_, %{total_calories: total_calories}} -> total_calories end)
|> IO.inspect(label: "task 1")

AdventOfCode20221.read_file(:real)
|> AdventOfCode20221.format_input()
|> AdventOfCode20221.sort_elves_by_calories()
|> Enum.take(3)
|> Enum.map(fn {_elf, %{total_calories: total_calories}} -> total_calories end)
|> Enum.sum()
|> IO.inspect(label: "task 2")
