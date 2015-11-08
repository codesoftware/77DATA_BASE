-- CREAMOS LA TABLA PARAMETRIZACION DE PRECIOS DE RECETAS O PLATOS
-- Tabla en la cual se guardaran la parametrizacion de precios de las recetas del sistema.

CREATE TABLE in_tprre(
    prre_prre           serial               NOT NULL        ,
    prre_rece           int                  NOT NULL        ,
    prre_precio         numeric(50,6)        NOT NULL        ,
    prre_tius_crea      int                  NOT NULL        ,
    prre_tius_update    int                  NOT NULL        ,
    prre_estado         VARCHAR(1)           NOT NULL   DEFAULT 'A'      ,
    prre_fecha          DATE                 NOT NULL   DEFAULT NOW()    ,
    prre_sede           int                  NOT NULL        ,
PRIMARY KEY (prre_prre)
);