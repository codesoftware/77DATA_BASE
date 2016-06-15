--
-- Tabla en la cual almacenare los productos de la importacion
--
CREATE TABLE im_tprim(
    prim_prim               BIGSERIAL                               ,
    prim_impo               bigint                  NOT NULL        ,
    prim_dska               bigint                  NOT NULL        ,
    prim_cant               bigint                  NOT NULL        ,
    prim_vlrDolar           NUMERIC(1000,10)        NOT NULL        ,
    prim_vlrPesTRM          NUMERIC(1000,10)        NOT NULL        ,
    prim_vlrPesTzProm       NUMERIC(1000,10)        NOT NULL        ,
PRIMARY KEY (prim_prim)
);