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

defmodule WeatherStation do
  @doc """
  Generates a random `WeatherDataPoint`
  """
  def gen_weather_data_point do
    rand_temp = :rand.uniform() * 60 |> Float.round(2)
    rand_hum = :rand.uniform() * 100 |> Float.round(2)
    rand_wind = :rand.uniform() * 500 |> Float.round(2)

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
    0..(size-1)
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

end

WeatherStation.gen_weather_dataset(24) |> WeatherStation.log_wheather_data()
