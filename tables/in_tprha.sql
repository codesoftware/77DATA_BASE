-- CREAMOS LA TABLA PARAMETRIZACION DE PRECIOS DE SERVICIOS (HABITACIONES)
-- Tabla en la cual se guardaran la parametrizacion de precios.

CREATE TABLE in_tprha(
    prha_prha           BIGSERIAL               NOT NULL        ,
    prha_dsha           BIGINT                  NOT NULL        ,
    prha_precio         numeric(1000,10)        NOT NULL        ,
    prha_tius_crea      BIGINT                  NOT NULL        ,
    prha_tius_update    BIGINT                  NOT NULL        ,
    prha_estado         VARCHAR(1)              NOT NULL   DEFAULT 'A'      ,
    prha_fecha          DATE                    NOT NULL   DEFAULT NOW()    ,
PRIMARY KEY (prha_prha)
);
