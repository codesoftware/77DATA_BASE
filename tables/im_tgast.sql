--
-- Tabla en la cual almacenare los gastos que tiene la importacion
--
CREATE TABLE im_tgast(
    gast_gast               BIGSERIAL                               ,
    gast_impo               bigint                  NOT NULL        ,
    gast_desc               varchar(1000)           NOT NULL        ,
    gast_tius               bigint                  NOT NULL        ,
    gast_valor              NUMERIC(1000,10)        NOT NULL        ,
    gast_fecha              timestamp               NOT NULL        ,
    gast_fechaRegi          timestamp           default now()        NOT NULL        ,
PRIMARY KEY (gast_gast)
);