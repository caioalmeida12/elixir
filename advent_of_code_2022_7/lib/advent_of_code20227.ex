defmodule AdventOfCode20227 do
  @line_break "\r\n"

  def read_file(), do: read_file("./lib/example_input.txt")
  def read_file(:example_2), do: read_file("./lib/example_input_2.txt")
  def read_file(:real), do: read_file("./lib/input.txt")

  def read_file(path) do
    case File.read(path) do
      {:ok, result} -> result |> String.split(@line_break)
      {:error, error} -> IO.inspect(error)
    end
  end

  def typify_lines(lines) do
    lines
    |> Enum.map(fn line ->
      cond do
        String.starts_with?(line, "$") -> %{value: line, type: :command}
        String.starts_with?(line, "dir") -> %{value: line, type: :directory}
        true -> %{value: line, type: :file}
      end
    end)
  end

  def get_deep_directory_files(tipified_lines, dir_name) do
    dir_index =
      tipified_lines
      |> Enum.find_index(&(&1.value == "$ cd #{dir_name}"))

    Enum.drop(tipified_lines, dir_index + 1)
    |> Enum.reject(&(&1.value == "$ ls"))
    |> Enum.reduce_while([], fn %{type: type, value: value} = line, acc ->
      cond do
        # Subfolder detection and scanning
        String.starts_with?(value, "dir") ->
          <<"dir ", dir_name::binary>> = value
          {:cont, acc ++ get_deep_directory_files(tipified_lines, dir_name)}

        type != :command ->
          {:cont, [line | acc]}

        type == :command ->
          {:halt, acc}
      end
    end)
  end

  def get_total_size(files) do
    files
    |> Enum.reduce(0, fn %{value: value}, acc ->
      [size, _name] = String.split(value)

      acc + String.to_integer(size)
    end)
  end
end

typified_lines =
  AdventOfCode20227.read_file()
  |> AdventOfCode20227.typify_lines()

# IO.inspect(typified_lines, label: "typified_lines")

AdventOfCode20227.get_deep_directory_files(typified_lines, "a")
|> AdventOfCode20227.get_total_size()

# |> IO.inspect()

commands =
  typified_lines
  |> Enum.filter(&(&1.type == :command))

commands
|> Enum.reduce(
  %{
    commands: commands,
    current_directory: [],
    directories_contents: []
  },
  fn %{value: command}, state ->
    cond do
      command == "$ cd .." ->
        Map.put(state, :current_directory, tl(state.current_directory))

      String.starts_with?(command, "$ cd") ->
        <<"$ cd ", dir_name::binary>> = command

        Map.put(state, :current_directory, [
          String.split(command) |> Enum.at(-1) | state.current_directory
        ])
        |> Map.put(:directories_contents, %{
          name: dir_name,
          deep_content: [
            AdventOfCode20227.get_deep_directory_files(typified_lines, dir_name)
            | state.directories_contents
          ]
        })

      true ->
        state
    end
  end
)
|> IO.inspect()
