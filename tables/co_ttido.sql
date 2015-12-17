--
-- Creacion de la tabla tipo documento
--
CREATE TABLE CO_TTIDO(
    TIDO_TIDO                   BIGINT              NOT NULL                   ,
    TIDO_ESTADO                 VARCHAR(2)          NOT NULL DEFAULT('A')      ,
    TIDO_NOMBRE                 VARCHAR(500)         NOT NULL                   ,
    TIDO_DESCRIPCION            VARCHAR(500)        NOT NULL                   ,
PRIMARY KEY (TIDO_TIDO)
);