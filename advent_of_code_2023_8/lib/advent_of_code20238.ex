defmodule AdventOfCode20238 do
  @line_break "\r\n"

  def read_file(), do: read_file("./lib/example_input.txt")
  def read_file(:example_2), do: read_file("./lib/example_input_2.txt")
  def read_file(:real), do: read_file("./lib/input.txt")

  def read_file(path) do
    case File.read(path) do
      {:ok, result} -> result |> String.split(@line_break)
      {:error, error} -> IO.inspect(error)
    end
  end

  def next_node("L", %{root: node_root}, nodes) do
    next_root =
      nodes
      |> Enum.find(&(&1.root == node_root))
      |> then(& &1.left)

    Enum.find(nodes, &(&1.root == next_root))
  end

  def next_node("R", %{root: node_root}, nodes) do
    next_root =
      nodes
      |> Enum.find(&(&1.root == node_root))
      |> then(& &1.right)

    Enum.find(nodes, &(&1.root == next_root))
  end

  def next_instruction(instructions, ind) when (ind + 1) in 0..(length(instructions) - 1)//1,
    do: Enum.at(instructions, ind + 1)

  def next_instruction(instructions, invalid_ind),
    do: next_instruction(instructions, invalid_ind - length(instructions))

  def count_steps(%{root: "ZZZ"}, _nodes, {_instruction, instruction_ind}, _instructions),
    do: instruction_ind

  def count_steps(node, nodes, {instruction, instruction_ind}, instructions) do
    IO.inspect(nodes)
    next_node = next_node(instruction, node, nodes)
    next_instruction = next_instruction(instructions, instruction_ind)

    count_steps(next_node, nodes, {next_instruction, instruction_ind + 1}, instructions)
  end

  def from_AAA_to_ZZZ(instructions, nodes) do
    initial_node =
      nodes
      |> Enum.find(&(&1.root == "AAA"))

    count_steps(
      initial_node,
      nodes,
      instructions |> Enum.with_index() |> Enum.at(0),
      instructions
    )
  end

  def from_XXA_to_XXZ(instructions, nodes) do
    starting_positions =
      nodes
      |> Enum.filter(&Regex.match?(~r/^([A-Z]|[1-9]){2}A$/, &1.root))

    count_steps(
      %{root: "11A", left: "11B", right: "XXX"},
      nodes,
      instructions |> Enum.with_index() |> Enum.at(0),
      instructions
    )
  end
end

[raw_instructions, _ | raw_nodes] = AdventOfCode20238.read_file(:example_2)

instructions = String.graphemes(raw_instructions)

nodes =
  raw_nodes
  |> Enum.map(fn node ->
    <<root::binary-size(3), " = (", left::binary-size(3), ", ", right::binary-size(3), ")">> =
      node

    %{root: root, left: left, right: right}
  end)

# AdventOfCode20238.from_AAA_to_ZZZ(instructions, nodes)
# |> IO.inspect(label: "task 1")

AdventOfCode20238.from_XXA_to_XXZ(instructions, nodes)
|> IO.inspect(label: "task 2")
