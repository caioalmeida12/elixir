defmodule KMeans do
  require Integer
  require CSV

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
end

csv =
  KMeans.read_csv("./housing.csv", ["latitude", "longitude", "median_house_value", "housing_median_age"])
|> IO.inspect()
