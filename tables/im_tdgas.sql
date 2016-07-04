--
-- Tabla en la cual almacenare el detalle de los gastos de la importacion
--
CREATE TABLE im_tdgas(
    dgas_dgas               BIGSERIAL                               ,
    dgas_gast               bigint                  NOT NULL        ,
    dgas_desc               varchar(1000)           NOT NULL        ,
    dgas_tius               bigint                  NOT NULL        ,
    dgas_valor              NUMERIC(1000,10)        NOT NULL        ,
    dgas_fechaRegi          timestamp           default now()        NOT NULL     ,
    dgas_auco               bigint                  NOT NULL        ,
PRIMARY KEY (dgas_dgas)
);
