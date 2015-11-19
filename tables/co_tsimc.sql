--
-- Creacion de la tabla para la simulacion de movimientos contables
--
CREATE TABLE CO_TSIMC(
    SIMC_SIMC                   SERIAL              NOT NULL    ,
    SIMC_TRANS                  INT                 NOT NULL    ,
    SIMC_SBCU                   INT                 NOT NULL    ,
    SIMC_NATURALEZA             VARCHAR(2)          NOT NULL    ,
    SIMC_VALOR                  NUMERIC(15,5)       NOT NULL    , 
PRIMARY KEY (SIMC_SIMC)
);