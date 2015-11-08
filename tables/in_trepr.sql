-- CREAMOS LA TABLA PRODUCTOS RECETAS
-- Tabla en la cual se almacenara los datos de los productos que contiene una receta

--DROP TABLE IF EXISTS IN_TREPR; 

CREATE TABLE IN_TREPR(
    REPR_REPR                   SERIAL              NOT NULL ,
    REPR_RECE                   INT                 NOT NULL ,
    REPR_DSKA                   INT                 NOT NULL ,
    REPR_PROMEDIO               NUMERIC(15,6)       NOT NULL ,
    REPR_ESTADO                 VARCHAR(2)          NOT NULL    DEFAULT 'A'     ,
    REPR_FEC_INGRESO            TIMESTAMP           NOT NULL    DEFAULT NOW()   ,
    REPR_TIUS                   INT                 NOT NULL ,
    REPR_CANTIDAD               INT                 NOT NULL    DEFAULT 1       ,
PRIMARY KEY (REPR_REPR)
);