defmodule BookTest do
  use ExUnit.Case
  doctest Book

  alias Book

  describe "create_book/4" do
	test "creates a book with given details" do
	  title = "Elixir in Action"
	  author = "Saša Jurić"
	  pub_year = 2019
	  status = :available

	  book = Book.create_book(title, author, pub_year, status)

	  assert book.title == title
	  assert book.author == author
	  assert book.pub_year == pub_year
	  assert book.status == status
	end

	test "creates a book with a different status" do
	  title = "Programming Elixir ≥ 1.6"
	  author = "Dave Thomas"
	  pub_year = 2018
	  status = :borrowed

	  book = Book.create_book(title, author, pub_year, status)

	  assert book.title == title
	  assert book.author == author
	  assert book.pub_year == pub_year
	  assert book.status == status
	end
  end
end
