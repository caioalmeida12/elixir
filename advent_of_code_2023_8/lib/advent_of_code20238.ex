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

  def count_steps(
        %{root: <<_::binary-size(2), "Z">>},
        _nodes,
        {_instruction, instruction_ind},
        _instructions
      ),
      do: instruction_ind

  def count_steps(node, nodes, {instruction, instruction_ind}, instructions) do
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

  def next_step(starting_nodes, instructions, instruction_ind, nodes) do
    instruction = next_instruction(instructions, instruction_ind)

    next_nodes =
      starting_nodes
      |> Enum.map(&AdventOfCode20238.next_node(instruction, &1, nodes))

    finished? =
      next_nodes
      |> Enum.all?(fn %{root: root} -> Regex.match?(~r/^([A-Z]|[1-9]){2}Z$/, root) end)

    if finished? do
      instruction_ind + 2
    else
      next_step(next_nodes, instructions, instruction_ind + 1, nodes)
    end
  end

  def factor(n), do: factor(n, 2) |> Enum.frequencies()

  def factor(n, i) when i <= n do
    if rem(n, i) == 0 do
      [i | factor(div(n, i), i)]
    else
      factor(n, i + 1)
    end
  end

  def factor(_, _), do: []

  def from_XXA_to_XXZ(instructions, nodes) do
    starting_positions =
      nodes
      |> Enum.filter(&Regex.match?(~r/^([A-Z]|[1-9]){2}A$/, &1.root))

    starting_positions
    |> Enum.map(
      &count_steps(
        &1,
        nodes,
        instructions |> Enum.with_index() |> Enum.at(0),
        instructions
      )
    )
    |> Enum.map(&factor/1)
    |> Enum.reduce(fn fs1, fs2 ->
      Map.merge(fs1, fs2, fn _, p1, p2 -> min(p1, p2) end)
    end)
    |> Enum.reduce(1, fn {num, pow}, acc -> acc * num ** pow end)
  end
end

[raw_instructions, _ | raw_nodes] = AdventOfCode20238.read_file(:real)

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

# AdventOfCode20238.factor(8)
# |> IO.inspect()

# defmodule Part2 do
#   def factor(n), do: factor(n, 2) |> Enum.frequencies()

#   def factor(n, i) when i <= n do
#     if rem(n, i) == 0 do
#       [i | factor(div(n, i), i)]
#     else
#       factor(n, i + 1)
#     end
#   end

#   def factor(_, _), do: []
# end

# %{network: network, dirs: dirs} = Aoc.read_input(full)
# starts = network |> Map.keys() |> Enum.filter(&String.ends_with?(&1, "A"))

# starts
# |> Enum.map(fn start ->
#   Part1.follow_dirs(start, dirs, network, 0, &String.ends_with?(&1, "Z"))
# end)
# |> Enum.map(&Part2.factor/1)
# |> Enum.reduce(fn fs1, fs2 ->
#   Map.merge(fs1, fs2, fn _, p1, p2 -> min(p1, p2) end)
# end)
# |> Enum.reduce(1, fn {num, pow}, acc -> acc * num ** pow end)
