-- CREAMOS LA TABLA PARAMETRIZACION DE PRECIOS DE PRODUCTOS 
-- Tabla en la cual se guardaran la parametrizacion de precios de los productos del sistema.

CREATE TABLE in_tprpr(
    prpr_prpr           BIGSERIAL               NOT NULL                       ,
    prpr_dska           BIGINT                  NOT NULL                       ,
    prpr_precio         numeric(1000,10)        NOT NULL                       ,
    prpr_premsiva       numeric(1000,10)        NOT NULL                       ,
    prpr_tius_crea      BIGINT                  NOT NULL                       ,
    prpr_tius_update    BIGINT                  NOT NULL                       ,
    prpr_estado         VARCHAR(1)              NOT NULL   DEFAULT 'A'         ,
    prpr_fecha          DATE                    NOT NULL   DEFAULT NOW()       ,
    prpr_sede           BIGINT                  NOT NULL                       ,
    prpr_preu           numeric(1000,10)                   DEFAULT 0           ,
    prpr_prec           numeric(1000,10)                   DEFAULT 0           ,
    prpr_prem           numeric(1000,10)                   DEFAULT 0           ,
PRIMARY KEY (prpr_prpr)
);