-- CREAMOS LA TABLA RESERVA DE HABITACIONES
-- Tabla en la cual se almacenara los datos con los cuales se reservaran las habitaciones en el hotel

--DROP TABLE IF EXISTS IN_TRVHA; 

CREATE TABLE IN_TRVHA(
RVHA_RVHA                SERIAL           NOT NULL                 ,
RVHA_DSHA                INT              NOT NULL                 ,
RVHA_CLIEN               INT              NOT NULL                 ,
RVHA_FECHA               DATE             NOT NULL   DEFAULT NOW() ,
RVHA_FECHA_INI           DATE             NOT NULL                 ,
RVHA_FECHA_FIN           DATE             NOT NULL                 ,
RVHA_NUM_DIAS            INT              NOT NULL                 ,
RVHA_FECHA_VENCI         DATE             NOT NULL                 ,
RVHA_CONFIRMADA          VARCHAR(1)       NOT NULL   DEFAULT 'N'   ,
RVHA_ESTADO              VARCHAR(1)       NOT NULL   DEFAULT 'R'   ,
RVHA_TIUS                INT              NOT NULL                 ,
PRIMARY KEY (RVHA_RVHA)
);