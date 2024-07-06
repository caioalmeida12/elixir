defmodule LibraryTest do
  use ExUnit.Case
  doctest Library

  alias Library
  alias Book

  describe "create_library/1" do
    test "creates a library with a name and no books" do
      library = Library.create_library("My Library")
      assert library.name == "My Library"
      assert library.books == []
    end
  end

  describe "create_library/2" do
    test "creates a library with a name and a list of books" do
      books = [
        Book.create_book("Elixir for Beginners", "Jane Doe", 2020, :available)
      ]
      library = Library.create_library("My Library", books)
      assert library.name == "My Library"
      assert length(library.books) == 1
      assert Enum.all?(library.books, fn book -> book.__struct__ == Book end)
    end
  end

  describe "add_book/2" do
    test "adds a book to the library" do
      initial_books = [
        Book.create_book("Elixir for Beginners", "Jane Doe", 2020, :available)
      ]
      new_book = Book.create_book("Advanced Elixir", "John Doe", 2021, :available)
      library = Library.create_library("My Library", initial_books)
      updated_library = Library.add_book(library, new_book)

      assert length(updated_library.books) == 2
      assert Enum.any?(updated_library.books, fn book -> book.title == new_book.title end)
    end
  end

  describe "remove_book/2" do
    test "removes a book from the library" do
      initial_books = [
        Book.create_book("Elixir for Beginners", "Jane Doe", 2020, :available),
        Book.create_book("Advanced Elixir", "John Doe", 2021, :available)
      ]
      library = Library.create_library("My Library", initial_books)
      library_after_removal = Library.remove_book(library, "Elixir for Beginners")

      assert length(library_after_removal.books) == 1
      refute Enum.any?(library_after_removal.books, fn book -> book.title == "Elixir for Beginners" end)
    end
  end

  describe "borrow_book/2" do
    test "changes the status of a book to :borrowed" do
      initial_books = [
        Book.create_book("Elixir for Beginners", "Jane Doe", 2020, :available),
        Book.create_book("Advanced Elixir", "John Doe", 2021, :available)
      ]
      library = Library.create_library("My Library", initial_books)
      book_to_borrow = Book.create_book("Elixir for Beginners", "Jane Doe", 2020, :available)
      library_after_borrowing = Library.borrow_book(library, book_to_borrow)

      borrowed_book = Enum.find(library_after_borrowing.books, fn book -> book.title == "Elixir for Beginners" end)
      assert borrowed_book.status == :borrowed

      other_book = Enum.find(library_after_borrowing.books, fn book -> book.title == "Advanced Elixir" end)
      assert other_book.status == :available
    end
  end

  describe "return_book/2" do
    test "changes the status of a book to :available after being borrowed" do
      initial_books = [
        Book.create_book("Elixir for Beginners", "Jane Doe", 2020, :borrowed),
        Book.create_book("Advanced Elixir", "John Doe", 2021, :available)
      ]
      library = Library.create_library("My Library", initial_books)
      book_to_return = Book.create_book("Elixir for Beginners", "Jane Doe", 2020, :borrowed)
      library_after_returning = Library.return_book(library, book_to_return)

      returned_book = Enum.find(library_after_returning.books, fn book -> book.title == "Elixir for Beginners" end)
      assert returned_book.status == :available

      other_book = Enum.find(library_after_returning.books, fn book -> book.title == "Advanced Elixir" end)
      assert other_book.status == :available
    end
  end

  describe "search_books/3" do
    test "finds books by title" do
      books = [
        %Book{title: "Elixir for Beginners", author: "Jane Doe", pub_year: 2020, status: :available},
        %Book{title: "Advanced Elixir", author: "John Doe", pub_year: 2021, status: :available}
      ]
      library = Library.create_library("My Library", books)
      search_results = Library.search_books(library, :title, "Beginners")

      assert length(search_results) == 1
      assert Enum.any?(search_results, fn book -> book.title == "Elixir for Beginners" end)
    end

    test "finds books by author" do
      books = [
        %Book{title: "Elixir for Beginners", author: "Jane Doe", pub_year: 2020, status: :available},
        %Book{title: "Learning Elixir", author: "Jane Doe", pub_year: 2022, status: :available}
      ]
      library = Library.create_library("My Library", books)
      search_results = Library.search_books(library, :author, "Jane Doe")

      assert length(search_results) == 2
      assert Enum.all?(search_results, fn book -> book.author == "Jane Doe" end)
    end
  end
end
