--
--Tabla temporal para almacenar los datos basicos para crear un movimiento contable
--

CREATE TABLE CO_TTEM_MVCO(
    TEM_MVCO_TRANS                 INT                 NOT NULL                   ,
    TEM_MVCO_SBCU                  VARCHAR(10)         NOT NULL                   ,
    TEM_MVCO_VALOR                 VARCHAR(250)        NOT NULL                   ,
    TEM_MVCO_NATURALEZA            VARCHAR(2)          NOT NULL                   
);