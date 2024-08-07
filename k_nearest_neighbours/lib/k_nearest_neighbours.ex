defmodule KNearestNeighbours do
  require Integer

  def numbers_matrix_to_point_matrix(numbers_matrix) do
    numbers_matrix
    |> Enum.with_index(fn line, line_ind ->
      line
      |> Enum.with_index(fn val, col_ind ->
        %{
          value: val,
          pos: {line_ind, col_ind},
          class: if(Integer.is_even(val), do: :even, else: :odd)
        }
      end)
    end)
  end

  def neighbours(points_matrix, %{pos: {ref_line, ref_col}} = reference, k_value) do
    min_line = max(ref_line - k_value, 0)
    max_line = min(ref_line + k_value, length(hd(points_matrix)))
    min_col = max(ref_col - k_value, 0)
    max_col = min(ref_line + k_value, length(hd(points_matrix)))

    points_matrix
    |> List.flatten()
    |> Enum.reject(&(&1.pos == reference.pos))
    |> Enum.reduce([], fn %{pos: {dest_line, dest_col}} = destination, acc ->
      if(dest_line in min_line..max_line and dest_col in min_col..max_col) do
        [destination | acc]
      else
        acc
      end
    end)
  end

  def distance(
        %{pos: {ref_line, ref_col}} = _reference,
        %{pos: {dest_line, dest_col}} = _destination
      ) do
    (Integer.pow(ref_line - dest_line, 2) + Integer.pow(ref_col - dest_col, 2))
    |> then(&:math.sqrt/1)
  end

  def neighbours_distances(points_matrix, reference, k_value) do
    points_matrix
    |> neighbours(reference, k_value)
    |> List.flatten()
    |> Enum.reject(&(&1.pos == reference.pos))
    |> Enum.map(fn dest ->
      distance(reference, dest)
      Map.put(dest, :distance, distance(reference, dest))
    end)
  end

  def predict(points_matrix, reference, k_value) do
    points_matrix
    |> neighbours_distances(reference, k_value)
    |> Enum.frequencies_by(& &1.class)
    |> Enum.max()
    |> then(fn {prediction, _} ->
      Map.put(reference, :class, prediction)
    end)
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
|> KNearestNeighbours.predict(%{pos: {5, 1}}, 2)
|> IO.inspect()
