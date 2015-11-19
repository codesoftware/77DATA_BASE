--
--Tabla creada para la generacion de conteos de productos
--
CREATE TABLE IN_TCOPR(
    COPR_COPR                   INT                 NOT NULL                   ,
    COPR_ESTADO                 VARCHAR(1)          NOT NULL DEFAULT('C')      ,
    COPR_TIUS                   INT                 NOT NULL                   ,
    COPR_FECHA                  TIMESTAMP           NOT NULL DEFAULT now()     ,
    COPR_SEDE                   INT                 NOT NULL                   ,
    COPR_FEC_INI                TIMESTAMP                                      ,
    COPR_FEC_FIN                TIMESTAMP                                      ,
    COPR_DESC                   VARCHAR(500)        NOT NULL                   ,
PRIMARY KEY (COPR_COPR)
);