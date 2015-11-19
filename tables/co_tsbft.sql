--
-- Creacion de la tabla subcuentas fijas por tipo de documento
--
CREATE TABLE CO_TSBFT(
    SBFT_SBFT                   SERIAL              NOT NULL    ,
    SBFT_TIDO                   INT                 NOT NULL    ,
    SBFT_SBCU_CODIGO            VARCHAR(10)         NOT NULL    ,
    SBFT_NATURALEZA             VARCHAR(2)          NOT NULL    ,
    SBFT_PORCENTAJE             INT                 NOT NULL    , 
    SBFT_VISIBLE                VARCHAR(2)          NOT NULL    ,
    SBFT_COMENTARIO             VARCHAR(150)        NOT NULL    ,
PRIMARY KEY (SBFT_SBFT)
);