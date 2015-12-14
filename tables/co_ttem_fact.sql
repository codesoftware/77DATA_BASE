--
--Tabla temporal para almacenar los datos basicos de los prodtos facturados 
--

CREATE TABLE CO_TTEM_FACT(
    TEM_FACT                       BIGSERIAL                                      ,
    TEM_FACT_TRANS                 INT                 NOT NULL                   ,
    TEM_FACT_DSKA                  INT                 NOT NULL                   ,
    TEM_FACT_CANT                  INT                 NOT NULL                   ,
    TEM_FACT_DCTO                  INT                 NOT NULL                   ,
    TEM_FACT_PRUNI                 NUMERIC(1000,10)    DEFAULT 0                  ,
PRIMARY KEY (TEM_FACT)    
);