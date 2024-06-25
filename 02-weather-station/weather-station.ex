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
  Generates an Enum of length `size` filled with random `WeatherDataPoint`s
  """
  def gen_weather_dataset(size) do
    0..size
    |> Enum.map(fn _ -> gen_weather_data_point() end)
  end
end

WeatherStation.gen_weather_dataset(5)
