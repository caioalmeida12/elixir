csv =
  FileIO.read_csv("basic.csv", ["Feature1", "Feature2", "Feature3"], :normalize)

sigmoid_fn = fn val -> 1 / (1 + :math.exp(-val)) end

csv
|> Enum.map(fn line ->
  Perceptron.evaluate(%Perceptron{}, line, sigmoid_fn)
end)
