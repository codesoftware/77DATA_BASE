CREATE TABLE CO_TCLAS(
    CLAS_CLAS                   INT                 NOT NULL                   ,
    CLAS_ESTADO                 VARCHAR(1)          NOT NULL DEFAULT('A')      ,
    CLAS_NOMBRE                 VARCHAR(250)        NOT NULL                   ,
    CLAS_CODIGO                 INT                 NOT NULL                   ,
    CLAS_DESCRIPCION            VARCHAR(1000)       NOT NULL                   ,
    CLAS_NATURALEZA             VARCHAR(1)          NOT NULL DEFAULT('D')      ,
PRIMARY KEY (CLAS_CLAS)
);