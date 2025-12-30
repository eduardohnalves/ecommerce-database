# ecommerce-database

# 🛒 Banco de Dados – E-commerce

Projeto de banco de dados relacional para um sistema de e-commerce,
desenvolvido com foco em modelagem, integridade referencial e consultas SQL.

## 📦 Estrutura
- Clients
- Product
- Pedido
- Payments
- Payment_Card
- ProductStorage
- Supplier
- Seller
- Tabelas associativas (N:N)

## 🔐 Regras de Negócio
- Clientes PF e PJ (CPF/CNPJ validados)
- Pagamentos via PIX, Boleto, Cartão e Dois Cartões
- Pagamentos com cartão exigem cadastro de cartão
- Controle de estoque separado do produto
- Integridade garantida por chaves estrangeiras

## 🛠️ Tecnologias
- MySQL
- SQL (DDL e DML)
- Modelagem Relacional

## ▶️ Como Executar
1. Execute o script de criação do banco e tabelas
2. Execute o script de inserção de dados fictícios
3. Execute o script de consultas

## 📌 Autor
Eduardo Humberto do Nascimento Alves

