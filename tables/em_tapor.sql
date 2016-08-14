--
-- Tabla en la cual almacenare los gastos que tiene la importacion
--
CREATE TABLE em_tapor(
    apor_apor               BIGSERIAL                               ,
    apor_codigo             varchar(1000)                       NOT NULL        ,
    apor_desc               varchar(1000)                       NOT NULL        ,
    apor_tius               bigint                              NOT NULL        ,
    apor_fecha              timestamp        default now()      NOT NULL        ,
    apor_valor              numeric(1000,10)                    NOT NULL        ,
    apor_soci               bigint                              NOT NULL        ,
    apor_tran_mvco          bigint                                              ,
    apor_estado             varchar(10)                         NOT NULL        ,
PRIMARY KEY (apor_apor)
);