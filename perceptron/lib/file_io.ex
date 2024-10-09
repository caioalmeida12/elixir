defmodule FileIO do
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
      |> Enum.map(&{&1, Float.parse(Map.get(map, &1)) |> Tuple.to_list() |> hd})
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

        if max == min,
          do: 0,
          else: (value - min) / (max - min)
      end)
    end)
  end
end
