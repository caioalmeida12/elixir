defmodule KNearestNeighbours do
  def numbers_matrix_to_point_matrix(numbers_matrix) do
    numbers_matrix
    |> Enum.with_index(fn line, line_ind ->
      line
      |> Enum.with_index(fn val, col_ind ->
        %{value: val, pos: {line_ind, col_ind}}
      end)
    end)
  end

  def neighbours(points_matrix, %{pos: {ref_line, _ref_col}} = _reference, k_value) do
    points_matrix
    |> Enum.with_index()
    |> Enum.reduce([], fn {line, line_ind}, acc ->
      if line_ind in (ref_line - k_value)..(ref_line + k_value),
        do: [line | acc],
        else: acc
    end)
  end

  def hello do
    :world
  end
end

matrix = [
  [1, 2, 3, 4, 5],
  [6, 7, 8, 9, 10],
  [11, 12, 13, 14, 15],
  [16, 17, 18, 19, 20],
  [21, 22, 23, 24, 25]
]

KNearestNeighbours.numbers_matrix_to_point_matrix(matrix)
|> KNearestNeighbours.neighbours(%{pos: {2, 2}}, 1)
|> IO.inspect()
