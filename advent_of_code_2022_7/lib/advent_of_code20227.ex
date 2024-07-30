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

  # def get_deep_directory_files(tipified_lines, dir_name) do
  #   dir_index =
  #     tipified_lines
  #     |> Enum.find_index(&(&1.value == "$ cd #{dir_name}"))

  #   Enum.drop(tipified_lines, dir_index + 1)
  #   |> Enum.reject(&(&1.value == "$ ls"))
  #   |> Enum.reduce_while([], fn %{type: type, value: value} = line, acc ->
  #     cond do
  #       # Subfolder detection and scanning
  #       String.starts_with?(value, "dir") ->
  #         <<"dir ", dir_name::binary>> = value
  #         {:cont, acc ++ get_deep_directory_files(tipified_lines, dir_name)}

  #       type != :command ->
  #         {:cont, [line | acc]}

  #       type == :command ->
  #         {:halt, acc}
  #     end
  #   end)
  # end

  def get_total_size(files) do
    files
    |> Enum.reduce(0, fn %{value: value}, acc ->
      [size, _name] = String.split(value)

      acc + String.to_integer(size)
    end)
  end
end

typed_lines =
  AdventOfCode20227.read_file()
  |> AdventOfCode20227.typify_lines()

# IO.inspect(typed_lines, label: "typed_lines")
commands =
  typed_lines
  |> Enum.filter(&(&1.type == :command))

# |> IO.inspect()

state =
  commands
  |> Enum.reduce(
    %{
      directories: [],
      current_directory: []
    },
    fn
      %{value: "$ cd .."}, state ->
        Map.put(state, :current_directory, tl(state.current_directory))

      %{value: <<"$ cd ", dir_name::binary>>}, state ->
        if Regex.match?(~r/[a-z\/]/, dir_name),
          do:
            Map.put(state, :directories, [
              %{name: dir_name, path: state.current_directory} | state.directories
            ])
            |> Map.put(:current_directory, [dir_name | state.current_directory]),
          else: state

      %{value: "$ ls"}, state ->
        files =
          typed_lines
          |> Enum.drop_while(&(&1.value != "$ cd #{hd(state.current_directory)}"))
          |> Enum.drop(2)
          |> Enum.take_while(&(&1.type == :file))

        state

      %{value: _value}, state ->
        state
    end
  )
  |> IO.inspect()
