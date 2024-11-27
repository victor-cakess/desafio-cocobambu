CREATE DATABASE db_desafio;

USE db_desafio;

CREATE TABLE guestChecks (
    guestCheckId BIGINT PRIMARY KEY,
	chkNum INT,
	opnBusDt DATE,
	opnUTC TIMESTAMP,
	opnLcl TIMESTAMP,
	clsdBusDt DATE,
	clsdUTC TIMESTAMP,
	clsdLcl TIMESTAMP,
	lastTransUTC TIMESTAMP,
	lastTransLcl TIMESTAMP,
	lastUpdatedUTC TIMESTAMP,
	lastUpdatedLcl TIMESTAMP,
	clsdFlag INT,
    gstCnt INT,
	subTtl DECIMAL(10, 2),
	nonTxblSlsTtl DECIMAL(10, 2),
	chkTtl DECIMAL(10, 2),
	dscTtl DECIMAL(10, 2),
	payTtl DECIMAL(10, 2),
	balDueTtl DECIMAL(10, 2),
	rvcNum INT,
	otNum INT,
	ocNum INT,
	tblNum INT,
	tblName VARCHAR(100), 
	empNum INT,
	numSrvcRd INT,
	numChkPrntd INT
);

CREATE TABLE taxes (
    taxNum INT AUTO_INCREMENT PRIMARY KEY,     
    guestCheckId BIGINT NOT NULL,           
    txblSlsTtl DECIMAL(10, 2),              
    taxCollTtl DECIMAL(10, 2),              
    taxRate DECIMAL(5, 2),                     
    type INT,                                  
    FOREIGN KEY (guestCheckId) REFERENCES guestChecks(guestCheckId)
);

CREATE TABLE detailLines (
    guestCheckLineItemId BIGINT PRIMARY KEY,    
    guestCheckId BIGINT NOT NULL,             
    dspTtl DECIMAL(10, 2),                   
    seatNum INT,                           
    rvcNum INT,                              
    dtlOtNum INT,                            
    dtlOcNum INT,                           
    lineNum INT,                             
    dtlId INT,                            
    detailUTC TIMESTAMP,                      
    detailLcl TIMESTAMP,                      
    lastUpdateUTC TIMESTAMP,                 
    lastUpdateLcl TIMESTAMP,                  
    busDt DATE,                                
    wsNum INT,                                
    aggTtl DECIMAL(10, 2),                  
    aggQty DECIMAL(10, 2),                    
    svcRndNum INT,                            
    chkEmpId BIGINT,                          
    chkEmpNum INT,                           
    dspQty DECIMAL(10, 2),
    FOREIGN KEY (guestCheckId) REFERENCES guestChecks(guestCheckId)
);

CREATE TABLE menuItem (
    guestCheckLineItemId BIGINT PRIMARY KEY,   
    miNum INT,                                
    modFlag BOOLEAN,                          
    inclTax DECIMAL(10, 2),                   
    activeTaxes JSON,                         
    prcLvl VARCHAR(50),                      
    FOREIGN KEY (guestCheckLineItemId) REFERENCES detailLines(guestCheckLineItemId)
);

CREATE TABLE discount (
    discountId INT AUTO_INCREMENT PRIMARY KEY, 
    guestCheckLineItemId BIGINT NOT NULL,      
    discountCode VARCHAR(50),                  
    discountValue DECIMAL(10, 2),            
    FOREIGN KEY (guestCheckLineItemId) REFERENCES detailLines(guestCheckLineItemId)
);

CREATE TABLE serviceCharge (
    serviceId INT AUTO_INCREMENT PRIMARY KEY, 
    guestCheckLineItemId BIGINT NOT NULL,     
    serviceCode VARCHAR(50),                 
    serviceValue DECIMAL(10, 2),             
    FOREIGN KEY (guestCheckLineItemId) REFERENCES detailLines(guestCheckLineItemId)
);

CREATE TABLE tenderMedia (
    tenderId INT AUTO_INCREMENT PRIMARY KEY,  
    guestCheckLineItemId BIGINT NOT NULL,     
    mediaType VARCHAR(50),                   
    amountPaid DECIMAL(10, 2),               
    FOREIGN KEY (guestCheckLineItemId) REFERENCES detailLines(guestCheckLineItemId)
);

CREATE TABLE errorCode (
    errorId INT AUTO_INCREMENT PRIMARY KEY,   
    guestCheckLineItemId BIGINT NOT NULL,   
    errorCode VARCHAR(50),                   
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