defmodule SecretHandshake do
  @operations ["wink", "double blink", "close your eyes", "jump"]

  @doc """
  Deciphers the secret handshake for a given decimal.
  """
  def decypher(decimal) do
    binary = Integer.to_string(decimal, 2)

    binary
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.each(&process_bit/1)
  end

  defp process_bit({bit, index}) do
    operation = Enum.at(@operations, index)

    if bit == "1" and operation do
      IO.puts(operation)
    end
  end
end

SecretHandshake.decypher(26)
