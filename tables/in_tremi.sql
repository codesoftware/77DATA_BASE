--
-- Creacion de la tabla para llevar el registro de remisiones generadas por el sistema
--
CREATE TABLE in_tremi(
    remi_remi                   BIGSERIAL               NOT NULL    ,
    remi_clien                  BIGINT                  NOT NULL    ,
    remi_pedi                   BIGINT                  NOT NULL    ,
    remi_estado                 VARCHAR(2)              NOT NULL    ,
    remi_fact                   BIGINT                              , 
    remi_tius                   BIGINT                  NOT NULL    , 
    remi_sede                   BIGINT                  NOT NULL    , 
    remi_plazod                 BIGINT                  NOT NULL    , 
    remi_fplazo                 TIMESTAMP               NOT NULL    , 
    remi_venci                  VARCHAR(2)              NOT NULL  default 'N'       ,
    remi_valor                  NUMERIC(1000,10)        NOT NULL    , 
    remi_fecha                  TIMESTAMP               NOT NULL  DEFAULT now()     , 
    remi_pladFac                BIGINT                              ,
    remi_fpladFac               TIMESTAMP                           ,
    remi_fpagoc                 TIMESTAMP                           ,
PRIMARY KEY (remi_remi)
);