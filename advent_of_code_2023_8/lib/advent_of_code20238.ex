defmodule AdventOfCode20238 do
  @line_break "\r\n"

  def read_file(), do: read_file("./lib/example_input.txt")
  def read_file(:real), do: read_file("./lib/input.txt")

  def read_file(path) do
    case File.read(path) do
      {:ok, result} -> result |> String.split(@line_break)
      {:error, error} -> IO.inspect(error)
    end
  end

  def follow_instructions(node, instructions, %{} = nodes, len, ended?) when is_binary(node) do
    if ended?.(node) do
      len
    else
      instruction = elem(instructions, rem(len, tuple_size(instructions)))
      follow_instructions(nodes[node][instruction], instructions, nodes, len + 1, ended?)
    end
  end
end

[raw_instructions, _ | raw_nodes] = AdventOfCode20238.read_file(:real)

instructions =
  raw_instructions
  |> String.to_charlist()
  |> List.to_tuple()

nodes =
  Enum.map(raw_nodes, fn node ->
    <<root::binary-size(3), " = (", left::binary-size(3), ", ", right::binary-size(3), ")">> =
      node

    {root, %{?L => left, ?R => right}}
  end)
  |> Enum.into(%{})

data =
  %{instructions: instructions, nodes: nodes}

AdventOfCode20238.follow_instructions("AAA", data.instructions, data.nodes, 0, &(&1 == "ZZZ"))
|> IO.inspect()
