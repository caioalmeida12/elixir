defmodule WeatherDataPoint do
  defstruct temperature: 0, humidity: 0, wind_speed: 0

  defimpl String.Chars, for: WeatherDataPoint do
    def to_string(data_point) do
      "Temperature: #{data_point.temperature}°C, " <>
        "Humidity: #{data_point.humidity}%, " <>
        "Wind Speed: #{data_point.wind_speed} km/h"
    end
  end
end

defmodule WeatherDataPointStatistics do
  defstruct avg_temperature: 0, average_humidity: 0, average_wind_speed: 0

  defimpl String.Chars, for: WeatherDataPointStatistics do
    def to_string(data_point) do
      "Average Temperature: #{data_point.avg_temperature}°C, " <>
        "Maximum Humidity: #{data_point.average_humidity}%, " <>
        "Average Wind Speed: #{data_point.average_wind_speed} km/h"
    end
  end
end

defmodule WeatherStation do
  @doc """
  Generates a random `WeatherDataPoint`
  """
  def gen_weather_data_point do
    rand_temp = (:rand.uniform() * 60) |> Float.round(2)
    rand_hum = (:rand.uniform() * 100) |> Float.round(2)
    rand_wind = (:rand.uniform() * 500) |> Float.round(2)

    %WeatherDataPoint{
      temperature: rand_temp,
      humidity: rand_hum,
      wind_speed: rand_wind
    }
  end

  @doc """
  Generates an Enum of `size` elements filled with random `WeatherDataPoint`s
  """
  def gen_weather_dataset(size) do
    0..(size - 1)
    |> Enum.map(fn _ -> gen_weather_data_point() end)
  end

  @doc """
  Takes in an Enum of `WeatherDataPoint`s and logs each to the console
  """
  def log_wheather_data(enum) do
    enum
    |> Enum.with_index()
    |> Enum.map(fn {val, ind} -> "Hour: #{ind} #{val} \n" end)
    |> IO.puts()
  end

  @doc """
  Takes in an enum of `WeatherDataPoint`s and an `:atom` and returns the average of the specified atom, such as `:temperature`,`:humidity` or `:wind_speed`
  """
  def get_average(enum, field) do
    acc = enum
    |> Enum.map(fn val -> Map.get(val, field) end)
    |> Enum.reduce(0, fn val, acc -> acc + val end)

    acc / length(enum)
    |> Float.round(2)
  end

  @doc """
  Takes in an enum of `WeatherDataPoint`s and an `:atom` and returns the maximum value of the specified atom, such as `:temperature`,`:humidity` or `:wind_speed`
  """
  def get_maximum(enum, field) do
    enum
    |> Enum.map(fn val -> Map.get(val, field) end)
    |> Enum.max()
  end

  @doc """
  Takes in an Enum of `WeatherDataPoint`s and calculates statistics based on it. \n
  Returns a `WeatherDataPointStatistics`.
  """
  def calculate_statistics(enum) do
    %WeatherDataPointStatistics{
      avg_temperature: get_average(enum, :temperature),
      average_humidity: get_maximum(enum, :humidity),
      average_wind_speed: get_average(enum, :temperature)
    }
  end

  @doc """
  Simulates a wheather station. Generates random data, logs it, then calculates its statistics and logs those.
  """
  def simulate_weather_station do
    dataset = gen_weather_dataset(24)
    dataset |> log_wheather_data

    statistics = dataset |> calculate_statistics()
    statistics |> IO.puts


  end


end

WeatherStation.simulate_weather_station()
