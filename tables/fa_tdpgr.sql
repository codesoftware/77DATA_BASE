--
--Tabla en la cual se almaceran los detalles de los pagos
--
CREATE TABLE fa_tdpgr(
    dpgr_dpgr                   BIGINT                  NOT NULL                    ,
    dpgr_pgrm                   BIGINT                  NOT NULL                    ,
    dpgr_fecha                  TIMESTAMP               NOT NULL DEFAULT now()      ,    
    dpgr_estado                 VARCHAR(2)              NOT NULL                    ,
    dpgr_tipopago               VARCHAR(2)              NOT NULL                    ,
    dpgr_valor                  NUMERIC(1000,10)        NOT NULL
    dpgr_comprobante            VARCHAR(1000)                                       ,
    dpgr_vlrdeuda               NUMERIC(1000,10)        NOT NULL                    ,
    dpgr_mvcot                  BIGINT                  NOT NULL                    ,
PRIMARY KEY (pgrm_pgrm)
);