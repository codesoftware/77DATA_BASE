--
--Tabla en la cual registrare los pagos de una remision 
--

CREATE TABLE fa_tpgrm(
    pgrm_pgrm                   BIGINT                  NOT NULL                    ,
    pgrm_clien                  BIGINT                  NOT NULL                    ,
    pgrm_fecha                  TIMESTAMP               NOT NULL DEFAULT now()      ,
    pgrm_fact                   bigint                  NOT NULL                    ,
    pgrm_remi                   bigint                  NOT NULL                    ,
    pgrm_estado                 VARCHAR(2)              NOT NULL                    ,
    pgrm_comprobante            VARCHAR(1000)                                       ,
    pgrm_vlrdeuda               numeric(1000,10)        NOT NULL                    ,
PRIMARY KEY (pgrm_pgrm)
);