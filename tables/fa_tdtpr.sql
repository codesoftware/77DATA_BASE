-- CREAMOS LA TABLA DESCRIPCION DE HABITACIONES
-- Tabla en la cual se almacenara los datos generales de las habitaciones que se encuentran en el hotel

--DROP TABLE IF EXISTS IN_TDSHA; 

CREATE TABLE fa_tdtpr(
    DTPR_DTPR               INT              NOT NULL                 ,
    DTPR_DSKA               INT              NOT NULL                 ,
    DTPR_FACT               INT              NOT NULL                 ,
    DTPR_FECHA              TIMESTAMP        NOT NULL   DEFAULT NOW() ,
    DTPR_NUM_PROD           INT              NOT NULL                 ,
    DTPR_CANT               INT              NOT NULL                 ,
    DTPR_VLR_PR_TOT         NUMERIC(50,6)    NOT NULL                 ,
    DTPR_VLR_UNI_PROD       NUMERIC(50,6)    NOT NULL                 ,
    DTPR_VLR_IVA_TOT        NUMERIC(50,6)    NOT NULL                 ,
    DTPR_VLR_IVA_UNI        NUMERIC(50,6)    NOT NULL                 ,
    DTPR_VLR_VENTA_TOT      NUMERIC(50,6)    NOT NULL                 ,
    DTPR_VLR_VENTA_UNI      NUMERIC(50,6)    NOT NULL                 ,
    DTPR_VLR_TOTAL          NUMERIC(50,6)    NOT NULL                 ,
    DTPR_DESC               VARCHAR(1)       NOT NULL                 , --DESCUENTO
    DTPR_CON_DESC           VARCHAR(1)       NOT NULL   DEFAULT 'N'   ,
    DTPR_VALOR_DESC         NUMERIC(50,6)    NOT NULL   DEFAULT 0     ,
    DTPR_ESTADO             VARCHAR(1)       NOT NULL   DEFAULT 'A'   ,
    DTPR_KAPR               INT              NOT NULL   DEFAULT 0     , --Referencia del movimiento de inventario
    DTPR_DEV_KAPR           INT                         DEFAULT 0     , --Devolucion de un producto ya vendido
    DTPR_UTILIDAD           NUMERIC(50,6)    NOT NULL   DEFAULT 0     ,
PRIMARY KEY (DTPR_DTPR)
);




