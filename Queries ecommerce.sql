USE ecommerce;

-- =========================
-- CLIENTS
-- =========================
INSERT INTO clients (Fname, Minit, Lname, typePerson, identificacao, Address, email) VALUES
('Ana', 'M', 'Silva', 'CPF', '12345678901', 'São Paulo - SP', 'ana@email.com'),
('Bruno', 'A', 'Costa', 'CPF', '98765432100', 'Campinas - SP', 'bruno@email.com'),
('Carlos', NULL, 'Souza', 'CPF', '45678912300', 'Rio de Janeiro - RJ', 'carlos@email.com'),
('Studio', NULL, 'Criativo', 'CNPJ', '11222333000199', 'São Paulo - SP', 'contato@studio.com');

-- =========================
-- SUPPLIER
-- =========================
INSERT INTO supplier (Socialname, CNPJ, contact) VALUES
('Fornecedor Tech LTDA', '99888777000155', '11999990001'),
('Fornecedor Moda SA', '88777666000144', '11999990002');

-- =========================
-- SELLER
-- =========================
INSERT INTO seller (Socialname, CNPJ, contact) VALUES
('Vendedor Eletrônicos', '22333444000188', '11988880001'),
('Vendedor Vestuário', '33444555000177', '11988880002');

-- =========================
-- PRODUCT
-- =========================
INSERT INTO product (Pname, Category, Size, Cor, Descriptions, Plocal, Valor) VALUES
('Notebook', 'Eletronico', NULL, 'Preto', 'Notebook i5', 'A1', 4500.00),
('Smartphone', 'Eletronico', NULL, 'Azul', 'Smartphone 128GB', 'A2', 2800.00),
('Camiseta', 'Vestuario', 'M', 'Branca', 'Camiseta algodão', 'B1', 59.90),
('Sofá', 'Moveis', '3 lugares', 'Cinza', 'Sofá retrátil', 'C3', 3200.00),
('Boneco', 'Brinquedos', NULL, 'Colorido', 'Boneco infantil', 'D1', 89.90);

-- =========================
-- PRODUCT STORAGE
-- =========================
INSERT INTO productStorage (idProduct, quantity, storageLocation) VALUES
(1, 10, 'Depósito A'),
(2, 15, 'Depósito A'),
(3, 50, 'Depósito B'),
(4, 5, 'Depósito C'),
(5, 30, 'Depósito D');

-- =========================
-- STORAGE LOCATION
-- =========================
INSERT INTO storageLocation (idProduct, idProductStorage, location) VALUES
(1, 1, 'Corredor A1'),
(2, 2, 'Corredor A2'),
(3, 3, 'Corredor B1'),
(4, 4, 'Corredor C1'),
(5, 5, 'Corredor D1');

-- =========================
-- PEDIDO
-- =========================
INSERT INTO pedido (idOrdersClient, OrderStatus, OrdersDescription, Frete) VALUES
(1, 'Confirmado', 'Compra de notebook', 25.00),
(2, 'Processando', 'Compra de smartphone e camiseta', 20.00),
(3, 'Entregue', 'Compra de sofá', 50.00),
(4, 'Confirmado', 'Compra corporativa', 40.00);

-- =========================
-- PRODUCT ORDER
-- =========================
INSERT INTO productOrder (idProduct, idOrder, poQuantity, poStatus) VALUES
(1, 1, 1, 'Disponivel'),
(2, 2, 1, 'Disponivel'),
(3, 2, 2, 'Disponivel'),
(4, 3, 1, 'Disponivel'),
(1, 4, 3, 'Disponivel'),
(2, 4, 2, 'Disponivel');

-- =========================
-- PAYMENTS
-- =========================
INSERT INTO payments (idClient, typePayment, limitAvailable) VALUES
(1, 'PIX', NULL),
(2, 'Cartão', 3000.00),
(2, 'Dois Cartões', 5000.00),
(3, 'Boleto', NULL),
(4, 'Cartão', 8000.00);

-- =========================
-- PAYMENT CARD
-- =========================
INSERT INTO payment_card (idPayment, cardNumber, cardHolderName, expirationDate, identification, cardSequence) VALUES
(2, '4111111111111111', 'Bruno Costa', '12/27', '123', 1),
(3, '5555555555554444', 'Bruno Costa', '11/26', '456', 1),
(3, '4111111111111111', 'Bruno Costa', '12/27', '123', 2),
(5, '378282246310005', 'Studio Criativo', '10/28', '999', 1);

-- =========================
-- PRODUCT SELLER
-- =========================
INSERT INTO productSeller (idSeller, idProduct, prodQuantity) VALUES
(1, 1, 5),
(1, 2, 5),
(2, 3, 20),
(2, 5, 10);

--  Listar todos os clientes
SELECT
    idClient,Fname,Lname,typePerson,email
FROM clients;

--  Listar produtos disponíveis
SELECT
    idProduct,Pname,Category,Valor
FROM product;

--  Pedidos com nome do cliente
SELECT
    p.idOrders,
    c.Fname,
    c.Lname,
    p.OrderStatus,
    p.Frete
FROM pedido p
JOIN clients c
    ON p.idOrdersClient = c.idClient;

--  Produtos por pedido
SELECT
    pe.idOrders,
    pr.Pname,
    po.poQuantity
FROM productOrder po
JOIN pedido pe
    ON po.idOrder = pe.idOrders
JOIN product pr
    ON po.idProduct = pr.idProduct;

--  Pagamentos por cliente
SELECT
    c.Fname,
    c.Lname,
    pay.typePayment,
    pay.limitAvailable
FROM payments pay
JOIN clients c
    ON pay.idClient = c.idClient;

--  Total de pagamentos por tipo
SELECT
    typePayment,
    COUNT(*) AS total_pagamentos
FROM payments
GROUP BY typePayment;

--  Clientes que utilizam cartão
SELECT DISTINCT
    c.idClient,
    c.Fname,
    c.Lname
FROM clients c
JOIN payments p
    ON c.idClient = p.idClient
WHERE p.typePayment IN ('Cartão', 'Dois Cartões');

--  Pedidos com mais de um produto
SELECT
    pe.idOrders,
    COUNT(po.idProduct) AS total_produtos
FROM pedido pe
JOIN productOrder po
    ON pe.idOrders = po.idOrder
GROUP BY pe.idOrders
HAVING COUNT(po.idProduct) > 1;

-- Produtos mais vendidos
SELECT
    pr.Pname,
    SUM(po.poQuantity) AS total_vendido
FROM product pr
JOIN productOrder po
    ON pr.idProduct = po.idProduct
GROUP BY pr.Pname
ORDER BY total_vendido DESC;
