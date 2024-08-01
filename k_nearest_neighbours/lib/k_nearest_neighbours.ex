defmodule KNearestNeighbours do
  require Integer
  require CSV

  def csv_to_points_matrix(file_path, classification_col) do
    file_stream =
      file_path
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> CSV.decode(headers: true)
      |> Stream.with_index()

    file_stream
    |> Stream.map(fn {{:ok, dimensions}, _ind} ->
      classification_col_removed =
        Map.delete(dimensions, classification_col)

      floats =
        classification_col_removed
        |> Map.values()
        |> Enum.map(fn bin ->
          Float.parse(bin)
          |> then(fn {val, _rem} -> val end)
        end)

      keys =
        classification_col_removed
        |> Map.keys()

      classification =
        Map.get(dimensions, classification_col)

      %{
        dimensions: Enum.zip(keys, floats) |> Enum.into(%{}),
        classification: classification
      }
    end)
    |> Enum.take_every(1)
  end

  def numbers_matrix_to_points_matrix(numbers_matrix) do
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

  def neighbours_distances(points_matrix, %{dimensions: ref_dimensions} = _reference) do
    distances =
      points_matrix
      |> Enum.map(fn %{dimensions: dest_dimensions} ->
        Enum.zip(Map.values(dest_dimensions), Map.values(ref_dimensions))
        |> Enum.map(fn {dest_val, ref_val} ->
          (ref_val - dest_val)
          |> :math.pow(2)
        end)
        |> Enum.sum()
        |> :math.sqrt()
      end)

    Enum.zip(points_matrix, distances)
    |> Enum.map(fn {point, distance} ->
      Map.put(point, :distance, distance)
    end)
    |> Enum.reject(&(&1.distance == 0))
  end

  def distance(
        %{pos: {ref_line, ref_col}} = _reference,
        %{pos: {dest_line, dest_col}} = _destination
      ) do
    (:math.pow(ref_line - dest_line, 2) + :math.pow(ref_col - dest_col, 2))
    |> then(&:math.sqrt/1)
  end

  def predict(points_matrix, reference, k_value) do
    points_matrix
    |> neighbours_distances(reference)
    |> Enum.sort(&(&1.distance < &2.distance))
    |> Enum.take(k_value)
    |> Enum.frequencies_by(& &1.classification)
    |> Enum.max_by(fn {_classification, amount} -> amount end)
    |> then(fn {prediction, _amount} -> prediction end)
  end
end

csv =
  KNearestNeighbours.csv_to_points_matrix("./IRIS.csv", "species")

csv
|> KNearestNeighbours.predict(Enum.at(csv, 139), 2)
|> IO.inspect()
