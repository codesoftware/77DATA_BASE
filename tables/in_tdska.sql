-- CREAMOS LA TABLA DESCRIPCION KARDEX
-- Tabla en la cual se almacenara los datos de la descripcion del kardex de cada producto

--DROP TABLE IF EXISTS IN_TDSKA; 

CREATE TABLE IN_TDSKA(
    DSKA_DSKA                   BIGSERIAL               NOT NULL ,
    DSKA_REFE                   BIGINT                  NOT NULL ,
    DSKA_COD                    VARCHAR(10)             NOT NULL ,
    DSKA_NOM_PROD               VARCHAR(500)            NOT NULL ,
    DSKA_DESC                   VARCHAR(500)                     ,
    DSKA_IVA                    VARCHAR(1)                       ,
    DSKA_PORC_IVA               BIGINT                           ,
    DSKA_MARCA                  BIGINT                  NOT NULL                 ,
    DSKA_ESTADO                 VARCHAR(1)              NOT NULL   DEFAULT 'A'   ,
    DSKA_FEC_INGRESO            TIMESTAMP               NOT NULL   DEFAULT NOW() ,
    DSKA_CATE                   BIGINT                  NOT NULL                 , 
    DSKA_SBCU                   BIGINT                                           ,
    DSKA_PROV                   BIGINT                  NOT NULL                 ,
    DSKA_UBICACION              VARCHAR(500)            NOT NULL   DEFAULT 'N/A' ,
    DSKA_COD_EXT                VARCHAR(500)            NOT NULL   DEFAULT 'N/A' ,
	DSKA_BARCOD					VARCHAR(500)            						 ,   
	DSKA_INICONT			    VARCHAR(2)            	           DEFAULT 'N'   ,   
PRIMARY KEY (DSKA_DSKA)
);