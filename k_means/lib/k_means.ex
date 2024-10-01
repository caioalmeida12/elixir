defmodule KMeans do
  require Integer
  require CSV

  def read_csv(file_path, columns_to_read, :normalize) when is_list(columns_to_read),
    do: read_csv(file_path, columns_to_read) |> normalize()

  def read_csv(file_path, columns_to_read) when is_list(columns_to_read) do
    file_stream =
      file_path
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> CSV.decode(headers: true)
      |> Stream.with_index()

    file_stream
    |> Enum.map(fn {{:ok, map}, _ind} ->
      columns_to_read
      |> Enum.map(&{&1, String.to_float(Map.get(map, &1))})
      |> Enum.into(%{})
    end)
  end

  def normalize(list_of_maps) when is_list(list_of_maps) do
    keys =
      list_of_maps
      |> Enum.at(0)
      |> Map.keys()

    all_values =
      keys
      |> Enum.reduce(%{}, fn key, acc ->
        value = Enum.map(list_of_maps, &Map.get(&1, key))

        Map.put(acc, key, value)
      end)

    mins_and_maxes =
      all_values
      |> Enum.map(fn {key, values} ->
        {
          key,
          {Enum.min(values), Enum.max(values)}
        }
      end)
      |> Enum.into(%{})

    list_of_maps
    |> Enum.map(fn dimensions ->
      dimensions
      |> Enum.map(fn {key, value} ->
        {min, max} = Map.get(mins_and_maxes, key)

        (value - min) / (max - min)
      end)
    end)
  end

  def distance(reference, destination) when is_list(reference) and is_list(destination) do
    Enum.zip(reference, destination)
    |> Enum.reduce(0, fn {dim_ref, dim_dest}, sum_of_squares ->
      sum_of_squares + :math.pow(dim_ref - dim_dest, 2)
    end)
    |> then(&:math.sqrt/1)
  end

  def converge(list_of_points, k)
      when is_list(list_of_points) and
             is_integer(k) do
    initial_centroids =
      list_of_points
      |> Enum.take_random(k)

    converge(list_of_points, initial_centroids)
  end

  def converge(list_of_points, list_of_centroids)
      when is_list(list_of_centroids) and
             is_list(list_of_points) do
    labeled_points =
      list_of_points
      |> Enum.reduce([], fn point, acc ->
        distances =
          list_of_centroids
          |> Enum.map(&distance(&1, point))

        min_distance = Enum.min(distances)

        nearest_centroid =
          distances
          |> Enum.find_index(&(&1 == min_distance))

        [%{dimensions: point, centroid: nearest_centroid} | acc]
      end)
  end
end

csv =
  KMeans.read_csv(
    "./housing.csv",
    [
      "latitude",
      "longitude",
      "median_house_value",
      "housing_median_age"
    ],
    :normalize
  )
  |> Enum.take(3)
  |> KMeans.converge(2)
  |> IO.inspect()
