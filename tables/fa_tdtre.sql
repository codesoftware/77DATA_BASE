-- CREAMOS LA TABLA DESCRIPCION DE HABITACIONES
-- Tabla en la cual se almacenara los datos generales de las habitaciones que se encuentran en el hotel

--DROP TABLE IF EXISTS IN_TDSHA; 

CREATE TABLE fa_tdtre(
    DTRE_DTRE               BIGINT              NOT NULL                 ,
    DTRE_RECE               BIGINT              NOT NULL                 ,
    DTRE_FACT               BIGINT              NOT NULL                 ,
    DTRE_FECHA              TIMESTAMP           NOT NULL   DEFAULT NOW() ,
    DTRE_CANT               INT                 NOT NULL                 ,
    DTRE_VLR_RE_TOT         NUMERIC(1000,10)    NOT NULL                 ,
    DTRE_VLR_UNI_RECE       NUMERIC(1000,10)    NOT NULL                 ,
    DTRE_VLR_IVA_TOT        NUMERIC(1000,10)    NOT NULL                 ,
    DTRE_VLR_IVA_UNI        NUMERIC(1000,10)    NOT NULL                 ,
    DTRE_VLR_VENTA_TOT      NUMERIC(1000,10)    NOT NULL                 ,
    DTRE_VLR_VENTA_UNI      NUMERIC(1000,10)    NOT NULL                 ,
    DTRE_VLR_TOTAL          NUMERIC(1000,10)    NOT NULL                 ,
    DTRE_DESC               VARCHAR(1)          NOT NULL                 , --DESCUENTO
    DTRE_CON_DESC           VARCHAR(1)          NOT NULL   DEFAULT 'N'   ,
    DTRE_VALOR_DESC         NUMERIC(1000,10)    NOT NULL   DEFAULT 0     ,
    DTRE_ESTADO             VARCHAR(1)          NOT NULL   DEFAULT 'A'   ,
    DTRE_UTILIDAD           NUMERIC(1000,10)    NOT NULL   DEFAULT 0     ,
PRIMARY KEY (DTRE_DTRE)
);