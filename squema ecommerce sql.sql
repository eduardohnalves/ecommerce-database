-- DROP database ecommerce;
CREATE DATABASE ecommerce;
USE ecommerce;

-- 
-- CLIENTS
-- 
CREATE TABLE clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(15),
    Minit CHAR(3),
    Lname VARCHAR(20),
    typePerson ENUM ('CPF','CNPJ') NOT NULL,
    identificacao CHAR(14) NOT NULL,
    Address VARCHAR(45) NOT NULL,
    email VARCHAR(45),

    CONSTRAINT unique_identificacao_client UNIQUE (identificacao),

    CONSTRAINT chk_type_document
    CHECK (
        (typePerson = 'CPF'  AND CHAR_LENGTH(identificacao) = 11)
        OR
        (typePerson = 'CNPJ' AND CHAR_LENGTH(identificacao) = 14)
    )
);
TRUNCATE TABLE clients;
ALTER TABLE clients AUTO_INCREMENT = 1;

-- 
-- PRODUCT
-- 
CREATE TABLE product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(15),
    Category ENUM('Eletronico','Vestuario','Brinquedos','Moveis') NOT NULL,
    Size VARCHAR(15),
    Cor VARCHAR(15),
    Descriptions VARCHAR(45),
    Plocal VARCHAR(45) NOT NULL,
    Valor DECIMAL(10,2) NOT NULL
);

-- 
-- PEDIDO
-- 
CREATE TABLE pedido (
    idOrders INT AUTO_INCREMENT PRIMARY KEY,
    idOrdersClient INT NOT NULL,
    OrderStatus ENUM('Cancelado','Processando','Confirmado','Entregue')
        DEFAULT 'Processando',
    OrdersDescription VARCHAR(250),
    Frete DECIMAL(10,2) DEFAULT 10.00,

    CONSTRAINT fk_pedido_client
        FOREIGN KEY (idOrdersClient)
        REFERENCES clients(idClient)
);

-- 
-- PAYMENTS
-- 
CREATE TABLE payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT NOT NULL,
    typePayment ENUM('PIX','Boleto','Cartão','Dois Cartões') NOT NULL,
    limitAvailable DECIMAL(10,2),

    CONSTRAINT fk_payment_client
        FOREIGN KEY (idClient)
        REFERENCES clients(idClient)
);

-- 
-- CADASTRO DE PAGAMENTO (CARTÃO)
-- 
CREATE TABLE payment_card (
    idCard INT AUTO_INCREMENT 
    PRIMARY KEY,
    idPayment INT NOT NULL,
    cardNumber VARCHAR(45) NOT NULL,
    cardHolderName VARCHAR(45) NOT NULL,
    expirationDate VARCHAR(10) NOT NULL,
    identification VARCHAR(14) NOT NULL,
    cardSequence TINYINT NOT NULL COMMENT '1 = primeiro cartão | 2 = segundo cartão',

    CONSTRAINT fk_payment_card_payment
        FOREIGN KEY (idPayment)
        REFERENCES payments (idPayment),

    CONSTRAINT uk_payment_card_sequence
        UNIQUE (idPayment, cardSequence)
);


-- 
-- PRODUCT STORAGE
-- 
CREATE TABLE productStorage (
    idProductStorage INT AUTO_INCREMENT PRIMARY KEY,
    idProduct INT NOT NULL,
    quantity INT DEFAULT 0,
    storageLocation VARCHAR(45) NOT NULL,

    CONSTRAINT fk_storage_product
        FOREIGN KEY (idProduct)
        REFERENCES product(idProduct)
);

-- 
-- SUPPLIER
-- 
CREATE TABLE supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    Socialname VARCHAR(250) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    contact VARCHAR(15) NOT NULL,

    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

-- 
-- SELLER
-- 
CREATE TABLE seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    Socialname VARCHAR(250) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    contact VARCHAR(15) NOT NULL,

    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ)
);

-- 
-- PRODUCT SELLER (N:N)
-- 
CREATE TABLE productSeller (
    idSeller INT,
    idProduct INT,
    prodQuantity INT DEFAULT 1,

    PRIMARY KEY (idSeller, idProduct),

    CONSTRAINT fk_ps_seller
        FOREIGN KEY (idSeller)
        REFERENCES seller(idSeller),

    CONSTRAINT fk_ps_product
        FOREIGN KEY (idProduct)
        REFERENCES product(idProduct)
);

-- 
-- PRODUCT ORDER (N:N)
-- 
CREATE TABLE productOrder (
    idProduct INT,
    idOrder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponivel','Esgotado') DEFAULT 'Disponivel',

    PRIMARY KEY (idProduct, idOrder),

    CONSTRAINT fk_po_product
        FOREIGN KEY (idProduct)
        REFERENCES product(idProduct),

    CONSTRAINT fk_po_order
        FOREIGN KEY (idOrder)
        REFERENCES pedido(idOrders)
);

-- 
-- STORAGE LOCATION
-- 
CREATE TABLE storageLocation (
    idProduct INT,
    idProductStorage INT,
    location VARCHAR(250) NOT NULL,

    PRIMARY KEY (idProduct, idProductStorage),

    CONSTRAINT fk_sl_product
        FOREIGN KEY (idProduct)
        REFERENCES product(idProduct),

    CONSTRAINT fk_sl_storage
        FOREIGN KEY (idProductStorage)
        REFERENCES productStorage(idProductStorage)
);

show tables;