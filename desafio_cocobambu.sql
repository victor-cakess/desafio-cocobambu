CREATE DATABASE db_desafio;

USE db_desafio;

CREATE TABLE guestChecks (
    guestCheckId BIGINT PRIMARY KEY, -- Identificador único do pedido (como no JSON).
    chkNum INT,                      -- Número do cheque.
    opnBusDt DATE,                   -- Data de abertura do pedido.
    clsdFlag BOOLEAN,                -- Indicador de fechamento do pedido.
    gstCnt INT,                      -- Número de convidados no pedido.
    subTtl DECIMAL(10, 2),           -- Subtotal do pedido.
    chkTtl DECIMAL(10, 2)            -- Total final do pedido.
);

CREATE TABLE taxes (
    taxNum INT AUTO_INCREMENT PRIMARY KEY,      -- Identificador único do imposto.
    guestCheckId BIGINT NOT NULL,               -- Relaciona ao pedido na tabela guestChecks.
    txblSlsTtl DECIMAL(10, 2),                 -- Total de vendas tributáveis (igual ao JSON).
    taxCollTtl DECIMAL(10, 2),                 -- Total arrecadado em impostos.
    taxRate DECIMAL(5, 2),                    -- Taxa do imposto.
    type INT,                                 -- Tipo de imposto.
    FOREIGN KEY (guestCheckId) REFERENCES guestChecks(guestCheckId)
);

CREATE TABLE detailLines (
    guestCheckLineItemId BIGINT PRIMARY KEY,      -- Identificador único do item (como no JSON).
    guestCheckId BIGINT NOT NULL,             -- Relaciona à tabela guestChecks.
    dspTtl DECIMAL(10, 2),                    -- Total exibido para este item.
    FOREIGN KEY (guestCheckId) REFERENCES guestChecks(guestCheckId)
);

CREATE TABLE menuItem (
    guestCheckLineItemId BIGINT PRIMARY KEY,     -- Relaciona ao item na tabela detailLines.
    miNum INT,                               -- Número do item no menu.
    modFlag BOOLEAN,                         -- Indicador de modificação.
    inclTax DECIMAL(10, 2),                  -- Imposto incluído no preço do item.
    FOREIGN KEY (guestCheckLineItemId) REFERENCES detailLines(guestCheckLineItemId)
);

CREATE TABLE discount (
    discountId INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único do desconto.
    guestCheckLineItemId BIGINT NOT NULL,         -- Relaciona à tabela detailLines.
    discountCode VARCHAR(50),                 -- Código do desconto.
    discountValue DECIMAL(10, 2),             -- Valor do desconto.
    FOREIGN KEY (guestCheckLineItemId) REFERENCES detailLines(guestCheckLineItemId)
);

CREATE TABLE serviceCharge (
    serviceId INT AUTO_INCREMENT PRIMARY KEY,  -- Identificador único da taxa de serviço.
    guestCheckLineItemId BIGINT NOT NULL,         -- Relaciona à tabela detailLines.
    serviceCode VARCHAR(50),                  -- Código da taxa de serviço.
    serviceValue DECIMAL(10, 2),              -- Valor da taxa de serviço.
    FOREIGN KEY (guestCheckLineItemId) REFERENCES detailLines(guestCheckLineItemId)
);

CREATE TABLE tenderMedia (
    tenderId INT AUTO_INCREMENT PRIMARY KEY,  -- Identificador único do pagamento.
    guestCheckLineItemId BIGINT NOT NULL,        -- Relaciona à tabela detailLines.
    mediaType VARCHAR(50),                   -- Tipo de pagamento.
    amountPaid DECIMAL(10, 2),               -- Valor pago.
    FOREIGN KEY (guestCheckLineItemId) REFERENCES detailLines(guestCheckLineItemId)
);

CREATE TABLE errorCode (
    errorId INT AUTO_INCREMENT PRIMARY KEY,   -- Identificador único do erro.
    guestCheckLineItemId BIGINT NOT NULL,        -- Relaciona à tabela detailLines.
    errorCode VARCHAR(50),                   -- Código do erro.
    FOREIGN KEY (guestCheckLineItemId) REFERENCES detailLines(guestCheckLineItemId)
);

-- testes de consistência

SELECT * FROM detailLines;

SELECT 
    gc.guestCheckId,
    gc.chkNum,
    dl.guestCheckLineItemId,
    dl.dspTtl
FROM 
    guestChecks gc
JOIN 
    detailLines dl
ON 
    gc.guestCheckId = dl.guestCheckId;

SELECT 
    gc.guestCheckId,
    gc.chkNum,
    dl.guestCheckLineItemId,
    dl.dspTtl,
    mi.miNum,
    mi.inclTax
FROM 
    guestChecks gc
JOIN 
    detailLines dl ON gc.guestCheckId = dl.guestCheckId
JOIN 
    menuItem mi ON dl.guestCheckLineItemId = mi.guestCheckLineItemId;

SELECT 
    gc.guestCheckId,
    gc.chkNum,
    gc.chkTtl AS total_do_pedido,
    dl.guestCheckLineItemId,
    dl.dspTtl AS total_detalhado,
    mi.miNum AS item_menu,
    mi.inclTax AS imposto_item,
    t.taxNum,
    t.txblSlsTtl AS vendas_tributaveis,
    t.taxCollTtl AS total_impostos,
    t.taxRate AS taxa_imposto
FROM 
    guestChecks gc
JOIN 
    detailLines dl ON gc.guestCheckId = dl.guestCheckId
JOIN 
    menuItem mi ON dl.guestCheckLineItemId = mi.guestCheckLineItemId
JOIN 
    taxes t ON gc.guestCheckId = t.guestCheckId
WHERE 
    gc.guestCheckId = 1122334455;
