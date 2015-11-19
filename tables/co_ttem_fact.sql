--
--Tabla temporal para almacenar los datos basicos de los prodtos facturados 
--

CREATE TABLE CO_TTEM_FACT(
    TEM_FACT                       serial                                         ,
    TEM_FACT_TRANS                 INT                 NOT NULL                   ,
    TEM_FACT_DSKA                  INT                 NOT NULL                   ,
    TEM_FACT_CANT                  INT                 NOT NULL                   ,
    TEM_FACT_DCTO                  INT                 NOT NULL                   ,
PRIMARY KEY (TEM_FACT)    
);