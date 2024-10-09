csv =
  FileIO.read_csv("basic.csv", ["Feature1", "Feature2", "Feature3"], :normalize)

perceptron = %Perceptron{}


csv
|> Enum.map(&Perceptron.evaluate(perceptron, &1))
|> Numexy.new()
|> Numexy.sigmoid()
|> IO.inspect()
