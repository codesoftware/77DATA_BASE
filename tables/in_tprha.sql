-- CREAMOS LA TABLA PARAMETRIZACION DE PRECIOS DE SERVICIOS (HABITACIONES)
-- Tabla en la cual se guardaran la parametrizacion de precios.

CREATE TABLE in_tprha(
    prha_prha           serial               NOT NULL        ,
    prha_dsha           int                  NOT NULL        ,
    prha_precio         numeric(50,6)        NOT NULL        ,
    prha_tius_crea      int                  NOT NULL        ,
    prha_tius_update    int                  NOT NULL        ,
    prha_estado         VARCHAR(1)           NOT NULL   DEFAULT 'A'      ,
    prha_fecha          DATE                 NOT NULL   DEFAULT NOW()    ,
PRIMARY KEY (prha_prha)
);
