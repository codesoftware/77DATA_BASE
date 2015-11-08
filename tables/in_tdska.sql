-- CREAMOS LA TABLA DESCRIPCION KARDEX
-- Tabla en la cual se almacenara los datos de la descripcion del kardex de cada producto

--DROP TABLE IF EXISTS IN_TDSKA; 

CREATE TABLE IN_TDSKA(
DSKA_DSKA                   SERIAL              NOT NULL ,
DSKA_REFE                   INT                 NOT NULL ,
DSKA_COD                    VARCHAR(10)         NOT NULL ,
DSKA_NOM_PROD               VARCHAR(50)         NOT NULL ,
DSKA_DESC                   VARCHAR(100)        ,
DSKA_IVA                    VARCHAR(1)          ,
DSKA_PORC_IVA               INT                 ,
DSKA_MARCA                  INT                 NOT NULL                 ,
DSKA_ESTADO                 VARCHAR(1)          NOT NULL   DEFAULT 'A'   ,
DSKA_FEC_INGRESO            TIMESTAMP           NOT NULL   DEFAULT NOW() ,
DSKA_CATE                   INT                 NOT NULL                 , 
DSKA_SBCU                   INT                 ,
DSKA_PROV                   INT                 NOT NULL,
PRIMARY KEY (DSKA_DSKA)
);