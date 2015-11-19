-- CREAMOS LA TABLA TIPOS DE MOVIMIENTOS DE INVENTARIOS
-- Tabla en la cual se almacenara los tipos de movimientos de inventarios

--DROP TABLE IF EXISTS IN_TMVIN; 

CREATE TABLE IN_TMVIN(
    MVIN_MVIN                 SERIAL                      ,
    MVIN_DESCR                VARCHAR(70)    NOT NULL     ,
    MVIN_NATU                 VARCHAR(1)     NOT NULL     ,
    MVIN_USIM                 VARCHAR(20)    NOT NULL     ,
    MVIN_VENTA                VARCHAR(2)     NOT NULL     ,
    MVIN_INICIAL              VARCHAR(2)     NOT NULL     ,
    MVIN_REVFACT              VARCHAR(2)     NOT NULL     ,
    MVIN_COMPRA               VARCHAR(2)     NOT NULL    DEFAULT 'N' ,
    MVIN_PERDIDA              VARCHAR(2)     NOT NULL    DEFAULT 'N' ,
    MVIN_CAMBSEDE_ING         VARCHAR(2)     NOT NULL    DEFAULT 'N' ,
    MVIN_CAMBSEDE_EGR         VARCHAR(2)     NOT NULL    DEFAULT 'N' ,
    MVIN_CORRIGE_ING          VARCHAR(2)     NOT NULL    DEFAULT 'N' ,
PRIMARY KEY (MVIN_MVIN)
);