-- CREAMOS LA TABLA RELACION FACTURACION DE RECETAS Y KARDEX DE PRODUCTOS
-- Tabla en la cual se almacenara los datos que relacionan la facturacion de una receta con una kardex

--DROP TABLE IF EXISTS IN_TDSHA; 

CREATE TABLE FA_TRRKA(
    RRKA_RRKA               SERIAL           NOT NULL                 ,
    RRKA_DTRE               INT              NOT NULL                 ,
    RRKA_RECE               INT              NOT NULL                 ,
    RRKA_DSKA               INT              NOT NULL                 ,
    RRKA_KAPR               INT              NOT NULL                 ,
    RRKA_FECHA              TIMESTAMP        NOT NULL   DEFAULT NOW() ,
PRIMARY KEY (RRKA_RRKA)
);