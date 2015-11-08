--
--Tabla creada para poder realizar el conteo de inventarios (Ejecucion conteo de productos)
--
CREATE TABLE IN_TECOP(
    ECOP_ECOP                   INT                 NOT NULL                ,
    ECOP_COPR                   INT                 NOT NULL                ,
    ECOP_DSKA                   INT                 NOT NULL                ,
    ECOP_VALOR                  INT                 NOT NULL                ,
    ECOP_EXISTENCIAS            INT                 NOT NULL  DEFAULT 0     ,
    ECOP_DIFERENCIA             INT                 NOT NULL  DEFAULT 0     ,
PRIMARY KEY (ECOP_ECOP)
);