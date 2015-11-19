--
--Tabla temporal para almacenar los datos basicos para crear un movimiento contable SIMULACION
--

CREATE TABLE co_ttem_simmvco(
    TEM_SIMMVCO_TRANS                 INT                 NOT NULL                   ,
    TEM_SIMMVCO_SBCU                  VARCHAR(10)         NOT NULL                   ,
    TEM_SIMMVCO_VALOR                 VARCHAR(250)        NOT NULL                   ,
    TEM_SIMMVCO_NATURALEZA            VARCHAR(2)          NOT NULL                   
);