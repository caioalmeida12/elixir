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
        %{curr_dir: curr_dir, all_dirs: all_dirs} = state
      ) do
    state
    |> Map.put(:curr_dir, [cd_into | curr_dir])
    |> Map.put(:all_dirs, [[cd_into | curr_dir] | all_dirs])
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
        :binary.match("#{path}", "#{dir_name}") != :nomatch -> total + size
        true -> total
      end
    end)
  end

  def interpret_lines(file_content) do
    file_content
    |> prepare_lines()
    |> Enum.reduce(
      %{
        curr_dir: [],
        dir_sizes: %{},
        all_dirs: []
      },
      fn line, state ->
        interpret_line(line, state)
      end
    )
  end

  def total_size_of_dirs_smaller_than_100_000(file_content) do
    interpret_lines(file_content)
    |> then(fn %{all_dirs: all_dirs} = state ->
      all_dirs
      |> Enum.reduce(0, fn dir_name, total ->
        size = total_size_of_dir(state, dir_name)
        if size <= 100_000, do: total + size, else: total
      end)
    end)
  end

  def what_dir_should_be_deleted(file_content) do
    total_space = 70_000_000
    update_size = 30_000_000

    state = interpret_lines(file_content)

    used_space = total_size_of_dir(state, "/")

    unused_space = total_space - used_space

    needs_to_be_deleted = update_size - unused_space

    state
    |> then(fn %{all_dirs: all_dirs} = state ->
      all_dirs
      |> Enum.map(&total_size_of_dir(state, &1))
    end)
    |> Enum.zip_with(state.all_dirs, fn size, dir_name ->
      %{dir_name: dir_name, size: size}
    end)
    |> Enum.filter(&(&1.size >= needs_to_be_deleted))
    |> Enum.min_by(& &1.size)
  end
end

AdventOfCode20227.read_file(:real)
|> AdventOfCode20227.total_size_of_dirs_smaller_than_100_000()
|> IO.inspect(label: "task 1")

AdventOfCode20227.read_file(:real)
|> AdventOfCode20227.what_dir_should_be_deleted()
|> IO.inspect(label: "task 2")
