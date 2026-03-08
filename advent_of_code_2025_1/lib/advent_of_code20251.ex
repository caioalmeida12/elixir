defmodule AdventOfCode20251 do
  def read_file(:example) do
    File.read!("./lib/example_input.txt")
  end

  def read_file() do
    File.read!("./lib/input.txt")
  end

  def input_to_string_enum(input) do
    String.split(input, "\r\n")
  end

  def string_enum_to_tuple_enum(string_enum) do
    Enum.map(string_enum, fn <<dir::binary-size(1), amount::binary>> ->
      {dir, String.to_integer(amount)}
    end)
  end

  def process_instruction([50], {"L", amount}) do
    next_pos = Integer.mod(50 - amount, 100)
    [next_pos, 50]
  end

  def process_instruction([50], {"R", amount}) do
    next_pos = Integer.mod(50 + amount, 100)
    [next_pos, 50]
  end

  def process_instruction(results, {"L", amount}) do
    [curr_pos | _] = results
    next_pos = Integer.mod(curr_pos - amount, 100)
    [next_pos | results]
  end

  def process_instruction(results, {"R", amount}) do
    [curr_pos | _] = results
    next_pos = Integer.mod(curr_pos + amount, 100)
    [next_pos | results]
  end
end
