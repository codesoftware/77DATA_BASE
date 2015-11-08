-- CREAMOS LA TABLA PARAMETRIZACION DE PRECIOS DE PRODUCTOS 
-- Tabla en la cual se guardaran la parametrizacion de precios de los productos del sistema.

CREATE TABLE in_tprpr(
    prpr_prpr           serial               NOT NULL        ,
    prpr_dska           int                  NOT NULL        ,
    prpr_precio         numeric(50,6)        NOT NULL        ,
    prpr_tius_crea      int                  NOT NULL        ,
    prpr_tius_update    int                  NOT NULL        ,
    prpr_estado         VARCHAR(1)           NOT NULL   DEFAULT 'A'      ,
    prpr_fecha          DATE                 NOT NULL   DEFAULT NOW()    ,
    prpr_sede           int                  NOT NULL        ,
PRIMARY KEY (prpr_prpr)
);