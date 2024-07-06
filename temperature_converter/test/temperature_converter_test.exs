defmodule TemperatureConverterTests do
  use ExUnit.Case
  doctest TemperatureConverter

  test "converts Celsius to Fahrenheit" do
    assert TemperatureConverter.celsius_to_fahrenheit(100) == 212
  end

  test "converts Celsius to Kelvin" do
    assert TemperatureConverter.celsius_to_kelvin(0) == 273.15
  end

  test "converts Fahrenheit to Celsius" do
    assert TemperatureConverter.fahrenheit_to_celsius(212) == 100
  end

  test "converts Fahrenheit to Kelvin" do
    assert TemperatureConverter.fahrenheit_to_kelvin(32) == 273.15
  end

  test "converts Kelvin to Celsius" do
    assert TemperatureConverter.kelvin_to_celsius(273.15) == 0
  end

  test "converts Kelvin to Fahrenheit" do
    assert TemperatureConverter.kelvin_to_fahrenheit(273.15) == 32
  end

end
