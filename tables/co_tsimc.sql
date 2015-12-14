--
-- Creacion de la tabla para la simulacion de movimientos contables
--
CREATE TABLE CO_TSIMC(
    SIMC_SIMC                   BIGSERIAL               NOT NULL    ,
    SIMC_TRANS                  INT                     NOT NULL    ,
    SIMC_SBCU                   INT                     NOT NULL    ,
    SIMC_NATURALEZA             VARCHAR(2)              NOT NULL    ,
    SIMC_VALOR                  NUMERIC(1000,10)        NOT NULL    , 
PRIMARY KEY (SIMC_SIMC)
);