--CREAMOS LA TABLA DE ARQUEOS
--Tabla en la cual se almacenaran los arqueos realizados
--
CREATE TABLE in_tarque(
    arque_arque                       BIGSERIAL         ,
    arque_fecha                       TIMESTAMP         ,
    arque_comen                       VARCHAR(500)      ,
    arque_valorf                      NUMERIC(1000,10)  ,
    arque_valorc                      NUMERIC(1000,10)  ,
    arque_difere                      NUMERIC(1000,10)  ,
    arque_estado                      VARCHAR(1)        ,
    PRIMARY KEY (arque_arque)
);