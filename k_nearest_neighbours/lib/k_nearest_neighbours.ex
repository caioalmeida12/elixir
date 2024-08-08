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
