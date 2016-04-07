--
-- Creacion de la tabla para llevar el registro de detalles para las remisiones generadas por el sistema
--
CREATE TABLE in_tdrem(
    drem_drem                   BIGSERIAL               NOT NULL    ,
    drem_remi                   BIGINT                  NOT NULL    ,
    drem_dska                   BIGINT                  NOT NULL    ,
    drem_precio                 NUMERIC(1000,10)        NOT NULL    ,
    drem_cantid                 NUMERIC(1000,10)        NOT NULL    ,
    drem_estado                 varchar(2)                  NOT NULL    , 
    drem_fecha                  TIMESTAMP               NOT NULL  DEFAULT now()     ,
PRIMARY KEY (drem_drem)
);