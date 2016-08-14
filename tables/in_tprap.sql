--
--TABLA DE PRODUCTOS APORTE
--
CREATE TABLE IN_TPRAP(
    PRAP_PRAP           BIGSERIAL                           ,
    PRAP_APOR           BIGINT              NOT NULL        ,
    PRAP_DSKA           BIGINT              NOT NULL        ,
    PRAP_CANT           BIGINT              NOT NULL        ,
    PRAP_COSTO          NUMERIC(1000,10)    NOT NULL        ,
PRIMARY KEY(PRAP_PRAP)
);