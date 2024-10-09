csv =
  FileIO.read_csv("basic.csv", ["Feature1", "Feature2", "Feature3"], :normalize)

perceptron = %Perceptron{bias: -1}

Perceptron.evaluate(perceptron, Enum.at(csv, 0))
|> IO.inspect()
