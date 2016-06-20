--
-- Creacion de la tabla subcuentas fijas por tipo de documento
--
CREATE TABLE CO_TMVCO(
    MVCO_MVCO                   BIGSERIAL               NOT NULL    ,
    MVCO_TRANS                  BIGINT                  NOT NULL    ,
    MVCO_SBCU                   BIGINT                  NOT NULL    ,
    MVCO_NATURALEZA             VARCHAR(2)              NOT NULL    ,
    MVCO_TIDO                   BIGINT                  NOT NULL    , 
    MVCO_VALOR                  NUMERIC(1000,10)        NOT NULL    , 
    MVCO_LLADETALLE             VARCHAR(200)            NOT NULL    , 
    MVCO_ID_LLAVE               BIGINT                  NOT NULL    , 
    MVCO_TERCERO                BIGINT                  NOT NULL    , 
    MVCO_TIPO                   BIGINT                  NOT NULL    , 
    MVCO_FECHA                  TIMESTAMP               NOT NULL  DEFAULT now()   , 
    MVCO_AUCO                   BIGINT                  default 0,
PRIMARY KEY (MVCO_MVCO)
);