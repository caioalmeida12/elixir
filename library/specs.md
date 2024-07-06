# Projeto Sistema de Gerenciamento de Biblioteca em Elixir

## Objetivo
Desenvolver um módulo em Elixir para gerenciar uma biblioteca, permitindo adicionar, remover, emprestar e devolver livros.

## Requisitos e Passos para Implementação

### 1. Estrutura de Dados para Livros
- **Passo 1**: Definir uma estrutura para livros que inclua título, autor, ano de publicação e status (disponível, emprestado).

### 2. Adicionar e Remover Livros
- **Passo 1**: Implementar uma função `add_book(library, book)` que adiciona um livro à biblioteca.
- **Passo 2**: Implementar uma função `remove_book(library, book)` que remove um livro da biblioteca.

### 3. Emprestar e Devolver Livros
- **Passo 1**: Implementar uma função `borrow_book(library, book)` que marca um livro como emprestado.
- **Passo 2**: Implementar uma função `return_book(library, book)` que marca um livro como disponível.

### 4. Pesquisa de Livros
- **Passo 1**: Implementar uma função `search_books(library, query)` que permite pesquisar livros por título ou autor.

### 5. Testes Unitários
- **Passo 1**: Escrever testes unitários para cada uma das funções implementadas, garantindo que a lógica de adicionar, remover, emprestar, devolver e pesquisar livros esteja correta.
- **Passo 2**: Utilizar o ExUnit, a biblioteca de testes que vem com Elixir, para implementar os testes.

## Desafios Bônus

### Interface de Usuário
- Desenvolver uma interface de usuário no terminal para interagir com o sistema de gerenciamento da biblioteca, permitindo realizar todas as operações disponíveis.

### Histórico de Empréstimos
- Implementar uma funcionalidade que mantenha um histórico de todos os empréstimos, incluindo quem emprestou o livro e a data do empréstimo.

### Notificações de Atraso
- Adicionar uma funcionalidade para enviar notificações (simuladas no terminal) para lembretes de livros emprestados que estão atrasados.

### Relatórios
- Implementar a geração de relatórios sobre o estado atual da biblioteca, incluindo a quantidade de livros disponíveis, emprestados e o histórico de empréstimos.

Este projeto oferece uma excelente oportunidade para praticar Elixir, focando na manipulação de estruturas de dados, na implementação de lógica de negócios complexa, além de introduzir conceitos de testes unitários e interação com o usuário.