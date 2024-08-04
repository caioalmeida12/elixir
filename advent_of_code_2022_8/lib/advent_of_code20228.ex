defmodule AdventOfCode20228 do
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

  def label_inner_and_outer(file_content) do
    last_col = String.length(hd(file_content)) - 1
    last_line = length(file_content) - 1

    file_content
    |> Enum.with_index()
    |> Enum.map(fn {line, line_ind} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {val, col_ind} ->
        cond do
          col_ind == 0 and line_ind == 0 ->
            %{
              value: String.to_integer(val),
              type: :outer,
              pos: {line_ind, col_ind},
              has_siblings: [:down, :right]
            }

          col_ind == 0 and line_ind == last_line ->
            %{
              value: String.to_integer(val),
              type: :outer,
              pos: {line_ind, col_ind},
              has_siblings: [:up, :right]
            }

          col_ind == last_col and line_ind == 0 ->
            %{
              value: String.to_integer(val),
              type: :outer,
              pos: {line_ind, col_ind},
              has_siblings: [:down, :left]
            }

          col_ind == last_col and line_ind == last_line ->
            %{
              value: String.to_integer(val),
              type: :outer,
              pos: {line_ind, col_ind},
              has_siblings: [:up, :left]
            }

          line_ind == 0 ->
            %{
              value: String.to_integer(val),
              type: :outer,
              pos: {line_ind, col_ind},
              has_siblings: [:down]
            }

          line_ind == last_line ->
            %{
              value: String.to_integer(val),
              type: :outer,
              pos: {line_ind, col_ind},
              has_siblings: [:up]
            }

          col_ind == 0 ->
            %{
              value: String.to_integer(val),
              type: :outer,
              pos: {line_ind, col_ind},
              has_siblings: [:right]
            }

          col_ind == last_col ->
            %{
              value: String.to_integer(val),
              type: :outer,
              pos: {line_ind, col_ind},
              has_siblings: [:left]
            }

          true ->
            %{
              value: String.to_integer(val),
              type: :inner,
              pos: {line_ind, col_ind},
              has_siblings: [:up, :right, :down, :left]
            }
        end
      end)
    end)
  end

  defp sibling_value(:down, file_content, line_ind, col_ind) do
    file_content
    |> Enum.at(line_ind + 1)
    |> String.graphemes()
    |> Enum.at(col_ind)
    |> String.to_integer()
  end

  defp sibling_value(:right, file_content, line_ind, col_ind) do
    file_content
    |> Enum.at(line_ind)
    |> String.graphemes()
    |> Enum.at(col_ind + 1)
    |> String.to_integer()
  end

  defp sibling_value(:up, file_content, line_ind, col_ind) do
    file_content
    |> Enum.at(line_ind - 1)
    |> String.graphemes()
    |> Enum.at(col_ind)
    |> String.to_integer()
  end

  defp sibling_value(:left, file_content, line_ind, col_ind) do
    file_content
    |> Enum.at(line_ind)
    |> String.graphemes()
    |> Enum.at(col_ind - 1)
    |> String.to_integer()
  end

  def populate_siblings(file_content) do
    file_content
    |> label_inner_and_outer()
    |> Enum.with_index()
    |> Enum.map(fn {line, line_ind} ->
      line
      |> Enum.with_index()
      |> Enum.map(fn
        {%{has_siblings: has_siblings} = labeled, col_ind} ->
          case has_siblings do
            [:down, :right] ->
              labeled
              |> Map.update(
                :siblings,
                [
                  %{pos: :down, value: sibling_value(:down, file_content, line_ind, col_ind)},
                  %{pos: :right, value: sibling_value(:right, file_content, line_ind, col_ind)}
                ],
                fn val -> val end
              )

            [:up, :right] ->
              labeled
              |> Map.update(
                :siblings,
                [
                  %{pos: :up, value: sibling_value(:up, file_content, line_ind, col_ind)},
                  %{pos: :right, value: sibling_value(:right, file_content, line_ind, col_ind)}
                ],
                fn val -> val end
              )

            [:down, :left] ->
              labeled
              |> Map.update(
                :siblings,
                [
                  %{pos: :down, value: sibling_value(:down, file_content, line_ind, col_ind)},
                  %{pos: :left, value: sibling_value(:left, file_content, line_ind, col_ind)}
                ],
                fn val -> val end
              )

            [:up, :left] ->
              labeled
              |> Map.update(
                :siblings,
                [
                  %{pos: :up, value: sibling_value(:up, file_content, line_ind, col_ind)},
                  %{pos: :left, value: sibling_value(:left, file_content, line_ind, col_ind)}
                ],
                fn val -> val end
              )

            [:down] ->
              labeled
              |> Map.update(
                :siblings,
                [
                  %{pos: :down, value: sibling_value(:down, file_content, line_ind, col_ind)}
                ],
                fn val -> val end
              )

            [:up] ->
              labeled
              |> Map.update(
                :siblings,
                [
                  %{pos: :up, value: sibling_value(:up, file_content, line_ind, col_ind)}
                ],
                fn val -> val end
              )

            [:right] ->
              labeled
              |> Map.update(
                :siblings,
                [
                  %{pos: :right, value: sibling_value(:right, file_content, line_ind, col_ind)}
                ],
                fn val -> val end
              )

            [:left] ->
              labeled
              |> Map.update(
                :siblings,
                [
                  %{pos: :left, value: sibling_value(:left, file_content, line_ind, col_ind)}
                ],
                fn val -> val end
              )

            [:up, :right, :down, :left] ->
              labeled
              |> Map.update(
                :siblings,
                [
                  %{pos: :up, value: sibling_value(:up, file_content, line_ind, col_ind)},
                  %{pos: :right, value: sibling_value(:right, file_content, line_ind, col_ind)},
                  %{pos: :down, value: sibling_value(:down, file_content, line_ind, col_ind)},
                  %{pos: :left, value: sibling_value(:left, file_content, line_ind, col_ind)}
                ],
                fn val -> val end
              )
          end
      end)
    end)
  end

  def prepare_for_counting(file_content, mapping_fn) do
    file_content
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.with_index(fn element, col_ind -> {String.to_integer(element), col_ind} end)
      |> Enum.reduce(%{}, fn {val, col_ind}, acc -> mapping_fn.({val, col_ind}, acc) end)
    end)
    |> Enum.flat_map(&Enum.into(&1, []))
  end

  def count_visible_trees(:up, file_content) do
    file_content
    |> prepare_for_counting(fn {val, col_ind}, acc -> Map.put(acc, col_ind, val) end)
    |> Enum.group_by(fn {k, _v} -> k end, fn {_k, v} -> v end)
    |> Enum.map(fn {_col_ind, col_values} ->
      col_values
      |> Enum.reduce_while(
        %{
          curr_size: 0,
          count: 0
        },
        fn next_size, %{curr_size: curr_size, count: count} = col_acc ->
          cond do
            next_size > curr_size ->
              {
                :cont,
                col_acc
                |> Map.put(:curr_size, next_size)
                |> Map.put(:count, count + 1)
              }

            next_size == 0 ->
              {:cont, col_acc}

            true ->
              {:halt, col_acc.count}
          end
        end
      )
    end)
    |> Enum.sum()
  end
end

file_content =
  AdventOfCode20228.read_file()

AdventOfCode20228.count_visible_trees(:up, file_content)
|> IO.inspect()
