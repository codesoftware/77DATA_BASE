
-- CREAMOS LA TABLA TIPO USUARIO
-- Tabla en la cual se almacenara los datos de solo los usuarios del sistema

--DROP TABLE IF EXISTS US_TTIUS; 

CREATE TABLE US_TTIUS(
TIUS_TIUS                SERIAL                                    , -- Identificador primario de la tabla
TIUS_PERS                INT              NOT NULL                 , -- Llave foranea que se une con la tabla us_tpers
TIUS_PERF                INT              NOT NULL                 , -- 
TIUS_TIPO_USUARIO        VARCHAR(50)      NOT NULL                 , -- Indica el tipo de usuario de que tiene dentro del sistema (C)Cajero (A) Administrador 
TIUS_USUARIO             VARCHAR(50)      NOT NULL                 , -- Usuario con el cual ingresa al sistema (Unique)
TIUS_FECHA_REGISTRO      TIMESTAMP        NOT NULL DEFAULT NOW()   ,-- Fecha en la cual ingreso al sistema
TIUS_ULTIMO_INGRESO      TIMESTAMP        NOT NULL DEFAULT NOW()   ,-- Fecha del ultimo ingreso al sistema
TIUS_CONTRA_ACT          VARCHAR(50)                               , -- Contraseña activa con la cual ingresa al sistema
TIUS_CONTRA_FUTURA       VARCHAR(50)                               , -- Contraseña con la cual podra entrar al sistema
TIUS_CAMBIO_CONTRA       VARCHAR(1)       NOT NULL DEFAULT('N')    , -- Indica Si el usuario solicito cambio de contraseña (S) si o (N) no
TIUS_ESTADO              VARCHAR(1)       NOT NULL DEFAULT('A')    , -- Estado de el usuario A(activo) I(inactivo)
TIUS_SEDE                INT              NOT NULL                 ,
TIUS_PARAM1              VARCHAR(2000)    ,
TIUS_PARAM2              VARCHAR(2000)    ,
TIUS_PARAM3              VARCHAR(2000)    ,
TIUS_PARAM4              VARCHAR(2000)    , 
PRIMARY KEY (TIUS_TIUS)
);