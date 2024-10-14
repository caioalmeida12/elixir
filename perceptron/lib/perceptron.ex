defmodule Perceptron do
  defstruct bias: 0, weights: []

  def apply_weight({input, weight}) when is_number(input) and is_number(weight) do
    input * weight
  end

  def evaluate(%Perceptron{weights: weights, bias: bias}, last_layer_outputs, activation_fn) when is_list(last_layer_outputs) and is_function(activation_fn) do
    Enum.zip(weights, last_layer_outputs)
    |> Enum.reduce(bias, &apply_weight(&1) + &2)
    |> then(&activation_fn.(&1))
  end

  def evaluate(%Perceptron{}, last_layer_outputs, activation_fn) when is_list(last_layer_outputs) and is_function(activation_fn) do
    evaluate(%Perceptron{weights: last_layer_outputs}, last_layer_outputs, activation_fn)
  end

end
