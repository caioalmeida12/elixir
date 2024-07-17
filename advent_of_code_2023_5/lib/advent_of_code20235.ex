defmodule AdventOfCode20235 do
  @string_delimiter "\r\n"

  @type line :: String.t()
  @type file_content :: list(line())

  @spec read_file(String.t()) :: file_content()
  def read_file(path) do
    case File.read(path) do
      {:ok, result} -> result |> String.split(@string_delimiter, trim: true)
      {:error, error} -> IO.inspect(error)
    end
  end
end
