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

  def get_total_size(files) do
    files
    |> Enum.reduce(0, fn %{value: value}, acc ->
      [size, _name] = String.split(value)

      acc + String.to_integer(size)
    end)
  end

  def get_tree(typed_lines) do
    commands =
      typed_lines
      |> Enum.filter(&(&1.type == :command))

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
            |> Enum.take_while(fn
              %{value: <<"$ cd ", dir_name::binary>>} ->
                not Regex.match?(~r/[a-z\/]/, dir_name)

              _ ->
                true
            end)
            |> Enum.reject(&(&1.type != :file))

          directory_with_files =
            Map.get(state, :directories)
            |> Enum.find(&(&1.name == hd(state.current_directory)))
            |> Map.update(:files, files, fn _ -> files end)

          Map.get(state, :directories)
          |> Enum.reject(&(&1.name == hd(state.current_directory)))
          |> then(fn directories ->
            [directory_with_files | directories]
          end)
          |> then(fn updated_directories ->
            Map.put(state, :directories, updated_directories)
          end)

        _, state ->
          state
      end
    )
  end
end

typed_lines =
  AdventOfCode20227.read_file()
  |> AdventOfCode20227.typify_lines()

AdventOfCode20227.get_tree(typed_lines)
|> IO.inspect()
