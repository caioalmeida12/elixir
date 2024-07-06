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
    %Library{id: :rand.uniform(1000), name: name, books: books}
  end

  @spec add_book(t(), Book.t()) :: t()
  def add_book(library, book) do
    updated_books = library.books ++ [book]
    Map.put(library, :books, updated_books)
  end

  @spec remove_book(t(), String.t()) :: t()
  def remove_book(library, book_title) do
    updated_books = Enum.filter(library.books, fn book -> book.title != book_title end)
    Map.put(library, :books, updated_books)
  end

  @spec borrow_book(t(), Book.t()) :: t()
  def borrow_book(library, book) do
    updated_books =
      Enum.map(library.books, fn element ->
        if element.title == book.title, do: Map.put(element, :status, :borrowed), else: element
      end)

    Map.put(library, :books, updated_books)
  end

  @spec return_book(t(), Book.t()) :: t()
  def return_book(library, book) do
    updated_books =
      Enum.map(library.books, fn element ->
        if element.title == book.title, do: Map.put(element, :status, :available), else: element
      end)

    Map.put(library, :books, updated_books)
  end

  @spec search_books(t(), :title | :author, String.t()) :: list(Book.t())
  def search_books(library, field, query) do
    Enum.filter(library.books, &String.contains?(Map.get(&1, field), query))
  end
end
