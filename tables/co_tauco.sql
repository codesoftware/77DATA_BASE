--
--Tabla con la cual se asociaran los auxiliares contables
--
CREATE TABLE CO_TAUCO(
    AUCO_AUCO                   BIGSERIAL                                       ,
    AUCO_SBCU                   INT                     NOT NULL                ,
    AUCO_NOMB                   INT                     NOT NULL                ,
    AUCO_CODI                   varchar(1000)           NOT NULL                ,
    AUCO_DESCR                  VARCHAR(1000)           NOT NULL DEFAULT('A')   ,
    AUCO_COD_DIGITO             INT                     NOT NULL                ,
PRIMARY KEY (AUCO_AUCO)
);