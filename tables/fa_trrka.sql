-- CREAMOS LA TABLA RELACION FACTURACION DE RECETAS Y KARDEX DE PRODUCTOS
-- Tabla en la cual se almacenara los datos que relacionan la facturacion de una receta con una kardex

--DROP TABLE IF EXISTS IN_TDSHA; 

CREATE TABLE FA_TRRKA(
    RRKA_RRKA               BIGSERIAL           NOT NULL                 ,
    RRKA_DTRE               BIGINT              NOT NULL                 ,
    RRKA_RECE               BIGINT              NOT NULL                 ,
    RRKA_DSKA               BIGINT              NOT NULL                 ,
    RRKA_KAPR               BIGINT              NOT NULL                 ,
    RRKA_FECHA              TIMESTAMP        NOT NULL   DEFAULT now()    ,
    PRIMARY KEY (RRKA_RRKA)
);