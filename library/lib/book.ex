defmodule Book do
  @type status :: :available | :borrowed
  @type t :: %__MODULE__{
          title: String.t() | nil,
          author: String.t() | nil,
          pub_year: integer() | nil,
          status: status()
        }
  @enforce_keys [:title, :author, :pub_year]
  defstruct title: nil, author: nil, pub_year: nil, status: :available

  @spec create_book(String.t(), String.t(), integer(), status()) :: t()
  def create_book(title, author, pub_year, status) do
    %Book{
      title: title,
      author: author,
      pub_year: pub_year,
      status: status
    }
  end
end
