--
-- Creacion de la tabla en la cual se almacenaran los datos de los productos o recetas que se 
-- visualizaran en la pantalla principal de la pantalla de facturacion
--
CREATE TABLE IN_TPPFA(
    PPFA_PPFA                       SERIAL              NOT NULL    ,
    PPFA_CODIGO                     VARCHAR(500)        NOT NULL    ,
    PPFA_TIPO                       VARCHAR(2)          NOT NULL    ,
    PPFA_NOMBRE                     VARCHAR(500)        NOT NULL    ,
    PPFA_POSICION                   INT                 NOT NULL    , 
    PPGA_RUTA_IMG                   VARCHAR(900)        NOT NULL    ,
    PPFA_EXTENSION                  VARCHAR(10)         NOT NULL    ,    
PRIMARY KEY (PPFA_PPFA)
);