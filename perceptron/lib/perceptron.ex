defmodule Perceptron do
  defstruct bias: 0, weights: []

  def evaluate(perceptron, inputs, bias) when is_map(perceptron) and is_list(inputs) do

  end
end

Perceptron.evaluate([[1], [2]], [[1], [2]], -6)
|> IO.inspect()
