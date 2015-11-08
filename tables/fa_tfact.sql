-- CREAMOS LA TABLA DESCRIPCION DE HABITACIONES
-- Tabla en la cual se almacenara los datos generales de las habitaciones que se encuentran en el hotel

--DROP TABLE IF EXISTS IN_TDSHA; 

CREATE TABLE FA_TFACT(
    FACT_FACT                INT                NOT NULL                 ,
    FACT_TIUS                INT                NOT NULL                 ,
    FACT_FEC_INI             DATE               NOT NULL  DEFAULT NOW()  ,
    FACT_FEC_CIERRE          DATE                                        ,
    FACT_CLIEN               INT                NOT NULL                 ,
    FACT_VLR_TOTAL           NUMERIC(50,6)      NOT NULL                 ,
    FACT_VLR_IVA             NUMERIC(50,6)      NOT NULL                 ,
    FACT_TIPO_PAGO           VARCHAR(1)         NOT NULL   DEFAULT 'E'   ,
    FACT_ID_VOUCHER          VARCHAR(70)        NOT NULL   DEFAULT 'N/A' ,
    FACT_COMETARIOS          VARCHAR(1)                                  ,
    FACT_ESTADO              VARCHAR(1)         NOT NULL   DEFAULT 'P'   ,
    FACT_NATURALEZA          VARCHAR(2)         NOT NULL   DEFAULT 'E'   ,
    FACT_DEVOLUCION          VARCHAR(1)         NOT NULL   DEFAULT 'N'   ,
    FACT_ORIGINAL            INT                NOT NULL   DEFAULT  0    ,
    FACT_VLR_DCTO            NUMERIC(50,6)      NOT NULL   DEFAULT  0    ,
    FACT_VLR_EFECTIVO        NUMERIC(50,6)      NOT NULL   DEFAULT  0    ,
    FACT_VLR_TARJETA         NUMERIC(50,6)      NOT NULL   DEFAULT  0    ,
    FACT_CIERRE              INT                                         ,
    FACT_SEDE                INT                NOT NULL                 ,
PRIMARY KEY (FACT_FACT)
);