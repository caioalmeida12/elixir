defmodule Neuron do
  def activate(input, weight) when is_list(input) and is_list(weight) do
    input + weight
  end
end
