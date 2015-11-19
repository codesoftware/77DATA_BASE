-- CREAMOS LA TABLA DESCRIPCION DE HABITACIONES
-- Tabla en la cual se almacenara los datos generales de las habitaciones que se encuentran en el hotel

--DROP TABLE IF EXISTS IN_TDSHA; 

CREATE TABLE IN_TDSHA(
DSHA_DSHA                SERIAL           NOT NULL                 ,
DSHA_NUM_HAB             INT              NOT NULL                 ,
DSHA_FEC_INGRESO         TIMESTAMP        NOT NULL   DEFAULT NOW() ,
DSHA_NUM_MAX_PERS        INT              NOT NULL                 ,
DSHA_NUM_MIN_PERS        INT              NOT NULL                 ,
DSHA_BANO                VARCHAR(1)       NOT NULL                 ,
DSHA_TELEVISON           VARCHAR(1)       NOT NULL                 ,
DSHA_CABLE               VARCHAR(1)       NOT NULL                 ,
DSHA_NUM_CAMAS           INT              NOT NULL                 ,
DSHA_CAMA_AUX            VARCHAR(1)       NOT NULL                 ,
DSHA_ESTADO              VARCHAR(1)       NOT NULL   DEFAULT 'A'   ,
DSHA_DISP_ACTU           VARCHAR(1)       NOT NULL   DEFAULT 'A'   ,
DSHA_IVA                 NUMERIC(10,6)    NOT NULL   DEFAULT  0    ,
PRIMARY KEY (DSHA_DSHA)
);