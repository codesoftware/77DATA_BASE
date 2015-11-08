--
--Tabla temporal para almacenar los datos basicos de los prodtos facturados 
--

CREATE TABLE co_ttem_fact_rece(
    TEM_FACT_RECE                  serial                                         ,
    TEM_RECE_TRANS                 INT                 NOT NULL                   ,
    TEM_RECE_RECE                  INT                 NOT NULL                   ,
    TEM_RECE_CANT                  INT                 NOT NULL                   ,
    TEM_RECE_DCTO                  INT                 NOT NULL                   ,
PRIMARY KEY (TEM_FACT_RECE)    
);