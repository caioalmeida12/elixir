defmodule LinearRegression.Math do
  @spec average(list(float())) :: float()
  def average(numbers) do
    Enum.sum(numbers) / Enum.count(numbers)
  end

  @spec product_of_differences({float(), float()}, {float(), float()}) :: float()
  def product_of_differences({x, x_average}, {y, y_average}) do
    (x - x_average) * (y - y_average)
  end

  @spec squared_difference(float(), float()) :: float()
  def squared_difference(n, m) do
    :math.pow(n - m, 2)
  end

  def total_sum_of_squares(single_axis_points, compare_against)
      when is_list(compare_against) do
    single_axis_points
    |> Enum.zip(compare_against)
    |> Enum.reduce(0, fn {left, right}, acc -> squared_difference(left, right) + acc end)
  end

  def total_sum_of_squares(single_axis_points, compare_against) do
    single_axis_points
    |> Enum.reduce(0, &(squared_difference(&1, compare_against) + &2))
  end
end

defmodule LinearRegression do
  @type dataset :: %{dependant: list(float()), independant: list(float())}

  @spec interceptor(dataset()) :: float()
  def interceptor(%{dependant: dependant, independant: independant} = dataset) do
    x_average = LinearRegression.Math.average(independant)
    y_average = LinearRegression.Math.average(dependant)

    y_average - angular_coeficient(dataset) * x_average
  end

  @spec angular_coeficient(dataset()) :: float()
  def angular_coeficient(%{dependant: dependant, independant: independant}) do
    x_average = LinearRegression.Math.average(independant)
    y_average = LinearRegression.Math.average(dependant)

    dividend =
      independant
      |> Enum.zip(dependant)
      |> Enum.reduce(0, fn {x, y}, acc ->
        acc + LinearRegression.Math.product_of_differences({x, x_average}, {y, y_average})
      end)

    divisor =
      independant
      |> Enum.reduce(0, &(LinearRegression.Math.squared_difference(&1, x_average) + &2))

    dividend / divisor
  end

  @spec prediction(dataset(), float()) :: float()
  def prediction(x, dataset) do
    (angular_coeficient(dataset) * x + interceptor(dataset))
    |> Float.round(5)
  end

  @spec coefficient_of_determination(dataset()) :: float()
  def coefficient_of_determination(%{dependant: dependant, independant: independant} = dataset) do
    dependant_predictions = Enum.map(independant, &prediction(&1, dataset))
    dependant_average = LinearRegression.Math.average(dependant)

    residue_squared_sum =
      LinearRegression.Math.total_sum_of_squares(dependant, dependant_predictions)

    total_squared_sum =
      LinearRegression.Math.total_sum_of_squares(dependant, dependant_average)

    (1 - residue_squared_sum / total_squared_sum)
    |> Float.round(5)
  end
end

dataset = %{
  dependant: [2, 3, 4, 6, 8],
  independant: [1, 2, 4, 3, 5]
}

LinearRegression.interceptor(dataset)
|> IO.inspect(label: "Interceptor")

LinearRegression.angular_coeficient(dataset)
|> IO.inspect(label: "Angular Coeficient")

LinearRegression.prediction(1, dataset)
|> IO.inspect(label: "Prediction")

LinearRegression.coefficient_of_determination(dataset)
|> IO.inspect(label: "Coefficient of Determination")
