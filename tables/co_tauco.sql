--
--Tabla con la cual se asociaran los auxiliares contables
--
CREATE TABLE CO_TAUCO(
    AUCO_AUCO                   BIGSERIAL                                           ,
    AUCO_SBCU                   BIGINT                      NOT NULL                ,
    AUCO_NOMB                   VARCHAR(1000)               NOT NULL                ,
    AUCO_CODI                   VARCHAR(1000)               NOT NULL                ,
    AUCO_DESCR                  VARCHAR(1000)               NOT NULL DEFAULT('A')   ,
PRIMARY KEY (AUCO_AUCO)
);