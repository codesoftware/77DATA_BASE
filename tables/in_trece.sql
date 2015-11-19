-- CREAMOS LA TABLA RECETAS
-- Tabla en la cual se almacenara los datos de las recetas o platos

--DROP TABLE IF EXISTS IN_TRECE; 

CREATE TABLE IN_TRECE(
    RECE_RECE                   SERIAL              NOT NULL ,
    RECE_CODIGO                 VARCHAR(10)         NOT NULL ,
    RECE_NOMBRE                 VARCHAR(50)         NOT NULL ,
    RECE_DESC                   VARCHAR(150)        NOT NULL ,
    RECE_IVA                    NUMERIC(15,6)       NOT NULL ,
    RECE_ESTADO                 VARCHAR(1)          NOT NULL   DEFAULT 'A'   ,
    RECE_FEC_INGRESO            TIMESTAMP           NOT NULL   DEFAULT NOW() ,
    RECE_PROMEDIO               NUMERIC(15,6)       NOT NULL ,
    RECE_COSTO                  NUMERIC(15,6)       NOT NULL  DEFAULT 0 ,
PRIMARY KEY (RECE_RECE)
);