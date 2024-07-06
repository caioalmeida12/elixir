# Projeto Conversor de Temperatura em Elixir

## Objetivo
Desenvolver um módulo em Elixir que realize a conversão de temperaturas entre Celsius, Fahrenheit e Kelvin.

## Requisitos e Passos para Implementação

### 1. Conversão de Celsius para Fahrenheit e Kelvin
- **Passo 1**: Implementar uma função `celsius_to_fahrenheit(celsius)` que recebe a temperatura em Celsius e retorna a temperatura convertida para Fahrenheit.
- **Passo 2**: Implementar uma função `celsius_to_kelvin(celsius)` que recebe a temperatura em Celsius e retorna a temperatura convertida para Kelvin.

### 2. Conversão de Fahrenheit para Celsius e Kelvin
- **Passo 1**: Implementar uma função `fahrenheit_to_celsius(fahrenheit)` que recebe a temperatura em Fahrenheit e retorna a temperatura convertida para Celsius.
- **Passo 2**: Implementar uma função `fahrenheit_to_kelvin(fahrenheit)` que recebe a temperatura em Fahrenheit e retorna a temperatura convertida para Kelvin.

### 3. Conversão de Kelvin para Celsius e Fahrenheit
- **Passo 1**: Implementar uma função `kelvin_to_celsius(kelvin)` que recebe a temperatura em Kelvin e retorna a temperatura convertida para Celsius.
- **Passo 2**: Implementar uma função `kelvin_to_fahrenheit(kelvin)` que recebe a temperatura em Kelvin e retorna a temperatura convertida para Fahrenheit.

### 4. Testes Unitários
- **Passo 1**: Escrever testes unitários para cada uma das funções de conversão para garantir que estão retornando os valores corretos.
- **Passo 2**: Utilizar o ExUnit, a biblioteca de testes que vem com Elixir, para implementar os testes.

## Desafios Bônus

### Interface de Usuário
- Desenvolver uma interface de usuário simples no terminal que permita ao usuário escolher o tipo de conversão que deseja realizar e inserir o valor da temperatura.

### Histórico de Conversões
- Implementar uma funcionalidade que mantenha um histórico das conversões realizadas durante a sessão atual do usuário.

### Arredondamento
- Adicionar uma opção para o usuário escolher o número de casas decimais para o resultado da conversão.

Este projeto é uma excelente oportunidade para praticar Elixir, focando na manipulação de números e na implementação de lógica de conversão, além de introduzir conceitos de testes unitários e interação com o usuário.