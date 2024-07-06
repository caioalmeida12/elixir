defmodule Library do
  require Book
  @type t :: %__MODULE__{
          id: integer() | nil,
          name: String.t() | nil,
          books: list(Book.t()) | nil
        }
  @enforce_keys [:id, :name]
  defstruct id: nil, name: nil, books: nil

  @spec create_library(String.t()) :: t()
  def create_library(name) do
    %Library{id: :rand.uniform(1000), name: name, books: []}
  end

  @spec create_library(String.t(), list(Book.t())) :: t()
  def create_library(name, books) do
    %Library{id: :rand.uniform(1000), name: name, books: books }
  end
end
