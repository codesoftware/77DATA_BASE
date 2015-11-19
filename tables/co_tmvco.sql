--
-- Creacion de la tabla subcuentas fijas por tipo de documento
--
CREATE TABLE CO_TMVCO(
    MVCO_MVCO                   SERIAL              NOT NULL    ,
    MVCO_TRANS                  INT                 NOT NULL    ,
    MVCO_SBCU                   INT                 NOT NULL    ,
    MVCO_NATURALEZA             VARCHAR(2)          NOT NULL    ,
    MVCO_TIDO                   INT                 NOT NULL    , 
    MVCO_VALOR                  NUMERIC(15,5)       NOT NULL    , 
    MVCO_LLADETALLE             VARCHAR(5)          NOT NULL    , 
    MVCO_ID_LLAVE               INT                 NOT NULL    , 
    MVCO_TERCERO                INT                 NOT NULL    , 
    MVCO_TIPO                   INT                 NOT NULL    , 
    MVCO_FECHA                  TIMESTAMP           NOT NULL  DEFAULT now()   , 
PRIMARY KEY (MVCO_MVCO)
);