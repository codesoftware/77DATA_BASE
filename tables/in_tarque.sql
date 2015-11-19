--CREAMOS LA TABLA DE ARQUEOS
--Tabla en la cual se almacenaran los arqueos realizados
--
CREATE TABLE in_tarque(
arque_arque                       SERIAL,
arque_fecha                       TIMESTAMP,
arque_comen                       VARCHAR(500),
arque_valorf                      NUMERIC(50,6),
arque_valorc                      NUMERIC(50,6),
arque_difere                      NUMERIC(50,6),
arque_estado                      VARCHAR(1),
PRIMARY KEY (arque_arque)

);