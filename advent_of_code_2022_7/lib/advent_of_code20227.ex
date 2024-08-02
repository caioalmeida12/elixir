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

  def prepare_lines(lines) do
    lines
    |> Enum.with_index()
    |> Enum.map(fn {line, line_id} ->
      cond do
        String.starts_with?(line, "$") -> %{value: line, type: :command, line_id: line_id}
        String.starts_with?(line, "dir") -> %{value: line, type: :directory, line_id: line_id}
        true -> %{value: line, type: :file, line_id: line_id}
      end
    end)
  end

  def interpret_line(%{type: :command, value: "$ cd .."} = _line, %{curr_dir: curr_dir} = state) do
    state
    |> Map.put(:curr_dir, tl(curr_dir))
  end

  def interpret_line(
        %{type: :command, value: <<"$ cd ", cd_into::binary>>},
        %{curr_dir: curr_dir} = state
      ) do
    state
    |> Map.put(:curr_dir, [cd_into | curr_dir])
  end

  def interpret_line(%{type: :command, value: "$ ls"}, state) do
    state
  end

  def interpret_line(
        %{type: :directory, value: <<"dir ", _dir_name::binary>>},
        state
      ) do
    state
  end

  def interpret_line(
        %{type: :file, value: file},
        %{curr_dir: curr_dir, dir_sizes: dir_sizes} = state
      ) do
    [file_size, _file_name] = String.split(file)

    curr_dir_size = Map.get(dir_sizes, curr_dir)

    new_dir_size =
      case curr_dir_size do
        nil -> String.to_integer(file_size)
        _ -> Map.get(dir_sizes, curr_dir) + String.to_integer(file_size)
      end

    updated_dir_sizes =
      dir_sizes
      |> Map.put(curr_dir, new_dir_size)

    state
    |> Map.put(:dir_sizes, updated_dir_sizes)
  end

  def total_size_of_dir(%{dir_sizes: dir_sizes} = _state, dir_name) do
    dir_sizes
    |> Enum.reduce(0, fn {path, size}, total ->
      cond do
        Enum.all?(dir_name, &(&1 in path)) -> total + size
        true -> total
      end
    end)
  end
end

AdventOfCode20227.read_file(:example_2)
|> AdventOfCode20227.prepare_lines()
|> Enum.reduce(
  %{
    curr_dir: [],
    dir_sizes: %{}
  },
  fn line, state ->
    AdventOfCode20227.interpret_line(line, state)
  end
)
|> then(fn %{dir_sizes: dir_sizes} = state ->
  dir_sizes
  |> Enum.reduce(0, fn {dir_name, _dir_size} = _dir_info, total ->
    size = AdventOfCode20227.total_size_of_dir(state, dir_name)
    if size <= 100_000, do: total + size, else: total
  end)
end)
|> IO.inspect(label: "task 1")
