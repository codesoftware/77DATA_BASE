-- CREAMOS LA TABLA TIPOS DE MOVIMIENTOS DE INVENTARIOS
-- Tabla en la cual se almacenara los tipos de movimientos de inventarios

--DROP TABLE IF EXISTS IN_TMVIN; 

CREATE TABLE IN_TPROV(
PROV_PROV                 SERIAL                      ,
PROV_NOMBRE               VARCHAR(50)    NOT NULL     ,
PROV_NIT                  VARCHAR(40)    NOT NULL     ,
PROV_RAZON_SOCIAL         VARCHAR(50)    NOT NULL     ,
PROV_REPRESENTANTE        VARCHAR(50)    NOT NULL     ,
PROV_TELEFONO             VARCHAR(10)    NOT NULL     ,
PROV_DIRECCION            VARCHAR(50)    NOT NULL     ,
PROV_CELULAR              VARCHAR(15)    NOT NULL     ,
PROV_ESTADO 			  VARCHAR(2)     DEFAULT ('A'),
PRIMARY KEY (PROV_PROV)
);