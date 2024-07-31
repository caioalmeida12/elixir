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

  defp run_command(%{value: "$ cd .."}, state) do
    Map.put(state, :current_directory, tl(state.current_directory))
  end

  defp run_command(%{value: <<"$ cd ", dir_name::binary>>}, state) do
    if Regex.match?(~r/[a-z\/]/, dir_name),
      do:
        Map.put(state, :directories, [
          %{name: dir_name, path: state.current_directory} | state.directories
        ])
        |> Map.put(:current_directory, [dir_name | state.current_directory]),
      else: state
  end

  defp run_command(%{value: "$ ls"}, state) do
    typed_lines =
      AdventOfCode20227.read_file()
      |> AdventOfCode20227.typify_lines()

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
  end

  defp run_command(_, state), do: state

  def get_tree() do
    AdventOfCode20227.read_file()
    |> AdventOfCode20227.typify_lines()
    |> Enum.filter(&(&1.type == :command))
    |> Enum.reduce(
      %{
        directories: [],
        current_directory: []
      },
      &run_command/2
    )
  end

  def get_files_of_directory(tree, dir_name) do
    tree
    |> Map.get(:directories)
    |> Enum.filter(&(dir_name in &1.path or &1.name == dir_name))
    |> Enum.reduce([], fn files, acc -> [files | acc] end)
  end
end

AdventOfCode20227.get_tree()
|> Map.get(:directories)
|> Enum.map(fn %{name: dir_name} ->
  AdventOfCode20227.get_tree()
  |> AdventOfCode20227.get_files_of_directory(dir_name)
  |> Enum.map(fn %{files: files} ->
    files
    |> Enum.map(fn %{value: value} ->
      [size, _name] = String.split(value)

      String.to_integer(size)
    end)
    |> Enum.sum()
  end)
  |> Enum.sum()
  |> IO.inspect(label: dir_name)
end)
|> Enum.reject(&(&1 > 100_000))
|> Enum.sum()
|> IO.inspect()
