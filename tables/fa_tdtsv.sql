-- CREAMOS LA TABLA DESCRIPCION DE HABITACIONES
-- Tabla en la cual se almacenara los datos generales de las habitaciones que se encuentran en el hotel

--DROP TABLE IF EXISTS IN_TDSHA; 

CREATE TABLE fa_tdtsv(
    DTSV_DTSV           BIGSERIAL               NOT NULL                 ,
    DTSV_RVHA           BIGINT                  NOT NULL                 ,
    DTSV_FACT           BIGINT                  NOT NULL                 ,
    DTSV_FECHA          DATE                    NOT NULL   DEFAULT NOW() ,
    DTSV_VALOR_IVA      NUMERIC(1000,10)        NOT NULL                 ,
    DTSV_VALOR_VENTA    NUMERIC(1000,10)        NOT NULL                 ,
    DTSV_VALOR_SV       NUMERIC(1000,10)        NOT NULL                 ,
    DTSV_DESC           INT                     NOT NULL                 ,  -- DESCUENTO
    DTSV_CON_DESC       VARCHAR(1)              NOT NULL   DEFAULT 'N'   ,
    DTSV_VALOR_DESC     NUMERIC(1000,10)        NOT NULL   DEFAULT 0     ,
    DTSV_ESTADO         VARCHAR(1)              NOT NULL   DEFAULT 'A'   , 
    DTSV_COSTO_HAB      NUMERIC(1000,10)                             ,
PRIMARY KEY (DTSV_DTSV)
);