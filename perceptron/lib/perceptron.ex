defmodule Perceptron do
  defstruct bias: 0, weights: []

  def apply_weight({input, weight}) when is_number(input) and is_number(weight) do
    input * weight
  end

  def evaluate(perceptron, inputs) when is_map(perceptron) and perceptron.weights == [] do
    Enum.zip(inputs, inputs)
    |> Enum.reduce(perceptron.bias, &apply_weight(&1) + &2)
  end
end
