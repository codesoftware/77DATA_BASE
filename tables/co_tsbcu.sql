CREATE TABLE CO_TSBCU(
    SBCU_SBCU                   SERIAL                                  ,
    SBCU_CUEN                   INT             NOT NULL                ,
    SBCU_CLAS                   INT             NOT NULL                ,
    SBCU_GRUP                   INT             NOT NULL                ,
    SBCU_ESTADO                 VARCHAR(1)      NOT NULL DEFAULT('A')   ,
    SBCU_NOMBRE                 VARCHAR(50)     NOT NULL                ,
    SBCU_CODIGO                 VARCHAR(10)     NOT NULL                ,
    SBCU_DESCRIPCION            VARCHAR(250)    NOT NULL                ,
    SBCU_NATURALEZA             VARCHAR(1)      NOT NULL DEFAULT('A')   ,
PRIMARY KEY (SBCU_SBCU)
);