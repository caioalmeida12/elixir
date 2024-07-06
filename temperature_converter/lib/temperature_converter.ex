defmodule TemperatureConverter do
  def celsius_to_fahrenheit(celsius) do
    celsius * (9 / 5) + 32
  end

  def celsius_to_kelvin(celsius) do
    celsius + 273.15
  end

  def fahrenheit_to_celsius(fahrenheit) do
    ((fahrenheit - 32) / 180) * 100
  end

  def fahrenheit_to_kelvin(fahrenheit) do
    fahrenheit_to_celsius(fahrenheit) |> celsius_to_kelvin()
  end

  def kelvin_to_celsius(kelvin) do
    kelvin - 273.15
  end

  def kelvin_to_fahrenheit(kelvin) do
    kelvin_to_celsius(kelvin) |> celsius_to_fahrenheit()
  end
end
