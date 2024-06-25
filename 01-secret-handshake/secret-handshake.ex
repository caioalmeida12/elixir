decimal = 9

defmodule SecretHandshake do
  require Integer

  def get_order_of_operations do
    ["wink", "double blink", "close your eyes", "jump"]
  end

  def get_length_of_operations do
    length(get_order_of_operations())
  end

  def is_index_valid_operation(ind) do
    length(get_order_of_operations()) - 1 >= ind
  end

  def get_validated_index(ind) do
    case is_index_valid_operation(ind) do
      false ->
        try do
          get_length_of_operations()
          |> rem(ind)
        rescue
          _e in ArithmeticError -> 0
        end

      true ->
        ind
    end
  end

  def get_reverse_order_of_operations do
    get_order_of_operations()
    |> Enum.reverse()
  end

  def is_in_reverse_order_of_operations(ind) do
    cond do
      ind <= 0 -> false
      ind < get_length_of_operations() -> false
      ind |> Integer.floor_div(get_length_of_operations()) |> Integer.is_odd -> true
      true -> false
    end
  end

  def get_word_index(word, enum) do
    Enum.find_index(enum, fn val -> val == word end)
  end

  def get_word_for_index(ind) do
    validated_index = get_validated_index(ind)

    case is_in_reverse_order_of_operations(validated_index) do
      true -> get_reverse_order_of_operations() |> Enum.at(validated_index)
      _ -> get_order_of_operations() |> Enum.at(validated_index)
    end
  end

  def decimal_to_binary(decimal) do
    Integer.to_string(decimal, 2)
  end

  def are_both_truthy_ints(a, b) do
    a == 1 and b == 1
  end

  def bit_value_at_index(str, ind) do
    String.at(str, ind)
  end

  def get_binary_for_word(word, ind) do
    index =
      case is_in_reverse_order_of_operations(ind) do
        true -> word |> get_word_index(get_reverse_order_of_operations())
        _ ->  word |> get_word_index(get_order_of_operations())
      end

    Integer.pow(2, index)
    |> Integer.to_string(2)
    |> String.pad_leading(5, "0")
  end

  def get_binary_for_index(ind) do
    get_word_for_index(ind) |> get_binary_for_word(ind)
  end

  def get_binary_for_decimal(decimal) do
    decimal |> Integer.to_string(2)
  end

  def compare_bit_at_index(a, b, ind) do
    bit_a = a |> String.graphemes |> Enum.at(ind) |> String.to_integer
    bit_b = b |> String.graphemes |> Enum.at(ind) |> String.to_integer

    are_both_truthy_ints(bit_a, bit_b)
  end

  def decypher(decimal) do
    decimal_to_binary(decimal)
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {_val, ind} ->
      a = get_binary_for_index(ind)
      b = get_binary_for_decimal(decimal) |> String.pad_leading(5, "0")

      IO.puts("#{a} : #{b}")

      hit = compare_bit_at_index(a, b, (get_length_of_operations() - get_validated_index(ind)))

      case hit do
        true -> get_word_for_index(ind) |> IO.puts()
        _ -> ""
      end
    end)
  end
end

SecretHandshake.decypher(26)
