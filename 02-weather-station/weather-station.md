# Weather Station Exercise Requirements

## Objective
Create an Elixir module that simulates a weather station. This module should generate random weather data, log the data, and calculate statistics based on the generated data.

## Requirements

### 1. Weather Data Generation {cm:2024-06-25}
- Generate random weather data for temperature (in Celsius), humidity (percentage), and wind speed (in km/h). {cm:2024-06-25}
- Each weather data point should be a map with keys `:temperature`, `:humidity`, and `:wind_speed`. {cm:2024-06-25}
- Implement a function `generate_weather_data/0` that returns a list of 24 data points, simulating 24 hours of weather data. {cm:2024-06-25}

### 2. Logging Weather Data {cm:2024-06-25}
- Implement a function `log_weather_data/1` that takes the list of weather data points and logs each data point to the console. {cm:2024-06-25}
- Format the log as `"Hour X: Temperature: Y°C, Humidity: Z%, Wind Speed: W km/h"` where X is the hour (0 to 23). {cm:2024-06-25}

### 3. Calculating Statistics {cm:2024-06-25}
- Implement a function `calculate_statistics/1` that takes the list of weather data points and calculates the following statistics: {cm:2024-06-25}
  - Average temperature {cm:2024-06-25}
  - Maximum humidity {cm:2024-06-25}
  - Average wind speed {cm:2024-06-25}
- The function should return a map with keys `:avg_temperature`, `:max_humidity`, and `:avg_wind_speed`. {cm:2024-06-25}

### 4. Simulate Weather Station {cm:2024-06-25}
- Implement a function `simulate_weather_station/0` that generates the weather data, logs it, and then calculates and logs the statistics. {cm:2024-06-25}

## Bonus Challenges

### Data Persistence
- Instead of logging the weather data to the console, persist the data to a file in CSV format.

### Realistic Data Generation
- Improve the data generation logic to simulate more realistic weather patterns, possibly based on time of year or geographic location.

### Concurrency
- Use Elixir's concurrency features to simulate data generation and logging in real-time, as if the weather station is running continuously.
