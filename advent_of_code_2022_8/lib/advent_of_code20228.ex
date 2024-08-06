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
              pos: {line_ind, col_ind}
            }

          col_ind == 0 and line_ind == last_line ->
            %{
              value: String.to_integer(val),
              type: :outer,
              pos: {line_ind, col_ind}
            }

          col_ind == last_col and line_ind == 0 ->
            %{
              value: String.to_integer(val),
              type: :outer,
              pos: {line_ind, col_ind}
            }

          col_ind == last_col and line_ind == last_line ->
            %{
              value: String.to_integer(val),
              type: :outer,
              pos: {line_ind, col_ind}
            }

          line_ind == 0 ->
            %{
              value: String.to_integer(val),
              type: :outer,
              pos: {line_ind, col_ind}
            }

          line_ind == last_line ->
            %{
              value: String.to_integer(val),
              type: :outer,
              pos: {line_ind, col_ind}
            }

          col_ind == 0 ->
            %{
              value: String.to_integer(val),
              type: :outer,
              pos: {line_ind, col_ind}
            }

          col_ind == last_col ->
            %{
              value: String.to_integer(val),
              type: :outer,
              pos: {line_ind, col_ind}
            }

          true ->
            %{
              value: String.to_integer(val),
              type: :inner,
              pos: {line_ind, col_ind}
            }
        end
      end)
    end)
  end

  defp visible_from_direction?(
         direction,
         %{value: ref_value} = reference
       )
       when is_list(direction) and is_map(reference) do
    direction
    |> Enum.all?(fn %{value: value} -> value < ref_value end)
  end

  def is_visible?(file_content, %{pos: {ref_line, ref_col}} = reference) do
    siblings =
      file_content
      |> label_inner_and_outer()
      |> List.flatten()

    same_line =
      siblings
      |> Enum.filter(fn %{pos: {line, col}} -> line == ref_line and col != ref_col end)

    same_col =
      siblings
      |> Enum.filter(fn %{pos: {line, col}} -> col == ref_col and line != ref_line end)

    %{true: above, false: below} =
      same_col
      |> Enum.group_by(fn %{pos: {line, _col}} -> line < ref_line end)

    %{true: left, false: right} =
      same_line
      |> Enum.group_by(fn %{pos: {_line, col}} -> col < ref_col end)

    visible_from_direction?(above, reference) or visible_from_direction?(below, reference) or
      visible_from_direction?(left, reference) or visible_from_direction?(right, reference)
  end

  def count_visible_trees(file_content) do
    labeled =
      file_content
      |> label_inner_and_outer()

    %{outer: outer, inner: inner} =
      labeled
      |> List.flatten()
      |> Enum.group_by(& &1.type)

    inner_visible =
      inner
      |> Enum.count(&is_visible?(file_content, &1))

    outer_visible = Enum.count(outer)

    outer_visible + inner_visible
  end

  def scenic_score(file_content, %{value: ref_val, pos: {ref_line, ref_col}} = _reference) do
    siblings =
      file_content
      |> label_inner_and_outer()
      |> List.flatten()

    same_line =
      siblings
      |> Enum.filter(fn %{pos: {line, col}} -> line == ref_line and col != ref_col end)

    same_col =
      siblings
      |> Enum.filter(fn %{pos: {line, col}} -> col == ref_col and line != ref_line end)

    [above, below] =
      same_col
      |> Enum.group_by(fn %{pos: {line, _col}} -> line < ref_line end)
      |> then(fn
        %{true: above, false: below} -> [above, below]
        %{true: above} -> [above, []]
        %{false: below} -> [[], below]
      end)

    [left, right] =
      same_line
      |> Enum.group_by(fn %{pos: {_line, col}} -> col < ref_col end)
      |> then(fn
        %{true: left, false: right} -> [left, right]
        %{true: left} -> [left, []]
        %{false: right} -> [[], right]
      end)

    [above, right, below, left]
    |> Enum.map(fn dir ->
      dir
      |> Enum.reduce_while(0, fn %{value: value}, acc ->
        if ref_val > value do
          {:cont, acc + 1}
        else
          {:halt, acc}
        end
      end)
    end)
    |> Enum.product()
  end

  def biggest_scenic_score(file_content) do
    file_content
    |> label_inner_and_outer()
    |> List.flatten()
    |> Enum.map(&scenic_score(file_content, &1))
    |> Enum.with_index()

    # |> Enum.max()
  end
end

# AdventOfCode20228.read_file()
# |> AdventOfCode20228.count_visible_trees()

AdventOfCode20228.read_file()
|> AdventOfCode20228.biggest_scenic_score()
|> IO.inspect()
