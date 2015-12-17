-- CREAMOS LA TABLA PARAMETRIZACION DE PRECIOS DE RECETAS O PLATOS
-- Tabla en la cual se guardaran la parametrizacion de precios de las recetas del sistema.

CREATE TABLE in_tprre(
    prre_prre           BIGSERIAL               NOT NULL        ,
    prre_rece           BIGINT                  NOT NULL        ,
    prre_precio         numeric(1000,10)        NOT NULL        ,
    prre_tius_crea      BIGINT                  NOT NULL        ,
    prre_tius_update    BIGINT                  NOT NULL        ,
    prre_estado         VARCHAR(1)           NOT NULL   DEFAULT 'A'      ,
    prre_fecha          DATE                 NOT NULL   DEFAULT NOW()    ,
    prre_sede           BIGINT                  NOT NULL        ,
PRIMARY KEY (prre_prre)
);