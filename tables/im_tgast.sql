--
-- Tabla en la cual almacenare los gastos que tiene la importacion
--
CREATE TABLE im_tgast(
    gast_gast               BIGSERIAL                               ,
    gast_impo               bigint                  NOT NULL        ,
    gast_desc               varchar(1000)           NOT NULL        ,
    gast_tius               bigint                  NOT NULL        ,
    gast_valor              NUMERIC(1000,10)        NOT NULL        ,
    gast_fecha              NUMERIC(1000,10)        NOT NULL        ,
    gast_fechaRegi          NUMERIC(1000,10)        NOT NULL        ,
PRIMARY KEY (gast_gast)
);