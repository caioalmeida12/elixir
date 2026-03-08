defmodule AdventOfCode20251 do
  @spec read_file(:example) :: binary()
  def read_file(:example) do
    File.read!("./lib/example_input.txt")
  end

  @spec read_file() :: binary()
  def read_file() do
    File.read!("./lib/input.txt")
  end

  @spec input_to_string_enum(binary()) :: [binary()]
  def input_to_string_enum(input) do
    String.split(input, "\r\n")
  end

  @spec string_enum_to_tuple_enum(any()) :: list()
  def string_enum_to_tuple_enum(string_enum) do
    Enum.map(string_enum, fn <<dir::binary-size(1), amount::binary>> ->
      {dir, String.to_integer(amount)}
    end)
  end

  # ==========================================
  # PART 1: Basic Position Tracking
  # ==========================================

  @spec process_instruction_p1(nonempty_maybe_improper_list(), {<<_::8>>, integer()}) ::
          nonempty_maybe_improper_list()
  def process_instruction_p1([50], {"L", amount}) do
    next_pos = Integer.mod(50 - amount, 100)
    [next_pos, 50]
  end

  def process_instruction_p1([50], {"R", amount}) do
    next_pos = Integer.mod(50 + amount, 100)
    [next_pos, 50]
  end

  def process_instruction_p1(results, {"L", amount}) do
    [curr_pos | _] = results
    next_pos = Integer.mod(curr_pos - amount, 100)
    [next_pos | results]
  end

  def process_instruction_p1(results, {"R", amount}) do
    [curr_pos | _] = results
    next_pos = Integer.mod(curr_pos + amount, 100)
    [next_pos | results]
  end

  # ==========================================
  # PART 2: Zero Crossing Tracking
  # ==========================================

  @spec process_instruction_p2(nonempty_maybe_improper_list(), {<<_::8>>, integer()}) ::
          nonempty_maybe_improper_list()
  def process_instruction_p2([50], {"L", amount}) do
    next_pos = Integer.mod(50 - amount, 100)
    zeros_count = count_zeros_passed(50, {"L", amount})

    zeros_to_add = if next_pos == 0, do: max(0, zeros_count - 1), else: zeros_count
    zeros_list = List.duplicate(0, zeros_to_add)

    [next_pos] ++ zeros_list ++ [50]
  end

  def process_instruction_p2([50], {"R", amount}) do
    next_pos = Integer.mod(50 + amount, 100)
    zeros_count = count_zeros_passed(50, {"R", amount})

    zeros_to_add = if next_pos == 0, do: max(0, zeros_count - 1), else: zeros_count
    zeros_list = List.duplicate(0, zeros_to_add)

    [next_pos] ++ zeros_list ++ [50]
  end

  def process_instruction_p2(results, {"L", amount}) do
    [curr_pos | _] = results
    next_pos = Integer.mod(curr_pos - amount, 100)
    zeros_count = count_zeros_passed(curr_pos, {"L", amount})

    zeros_to_add = if next_pos == 0, do: max(0, zeros_count - 1), else: zeros_count
    zeros_list = List.duplicate(0, zeros_to_add)

    [next_pos] ++ zeros_list ++ results
  end

  def process_instruction_p2(results, {"R", amount}) do
    [curr_pos | _] = results
    next_pos = Integer.mod(curr_pos + amount, 100)
    zeros_count = count_zeros_passed(curr_pos, {"R", amount})

    zeros_to_add = if next_pos == 0, do: max(0, zeros_count - 1), else: zeros_count
    zeros_list = List.duplicate(0, zeros_to_add)

    [next_pos] ++ zeros_list ++ results
  end

  # ==========================================
  # HELPER FUNCTIONS
  # ==========================================

  @spec count_zeros_passed(any(), {<<_::8>>, any()}) :: integer()
  def count_zeros_passed(0, {"L", amount}), do: Integer.floor_div(amount, 100)
  def count_zeros_passed(curr_pos, {"L", amount}) when amount < curr_pos, do: 0
  def count_zeros_passed(curr_pos, {"L", amount}) when amount == curr_pos, do: 1

  def count_zeros_passed(curr_pos, {"L", amount}) when amount > curr_pos do
    remainder_steps = amount - curr_pos
    full_spins = Integer.floor_div(remainder_steps, 100)

    full_spins + 1
  end

  def count_zeros_passed(curr_pos, {"R", amount}) when amount < 100 - curr_pos, do: 0
  def count_zeros_passed(curr_pos, {"R", amount}) when amount == 100 - curr_pos, do: 1

  def count_zeros_passed(curr_pos, {"R", amount}) when amount > 100 - curr_pos do
    remainder_steps = amount - (100 - curr_pos)

    full_spins = Integer.floor_div(remainder_steps, 100)

    full_spins + 1
  end
end
