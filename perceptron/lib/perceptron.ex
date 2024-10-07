defmodule Perceptron do
  defstruct bias: 0, weights: []

  def evaluate(all_inputs, all_weights, bias) when is_list(all_inputs) and is_list(all_weights) and is_number(bias) do
    Enum.zip(all_inputs, all_weights)
    |> Enum.reduce(bias, fn {inputs, weights}, sum ->
      Enum.zip(inputs, weights)
      sum + Neuron.activate(inputs, weights)
    end)
    |> then(fn result -> if result >= 0, do: 1, else: 0 end)
  end
end

Perceptron.evaluate([[1], [2]], [[1], [2]], -6)
|> IO.inspect()
