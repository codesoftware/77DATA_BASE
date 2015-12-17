--
--Tabla creada para poder realizar el conteo de inventarios (Ejecucion conteo de productos)
--
CREATE TABLE IN_TECOP(
    ECOP_ECOP                   BIGINT                 NOT NULL                ,
    ECOP_COPR                   BIGINT                 NOT NULL                ,
    ECOP_DSKA                   BIGINT                 NOT NULL                ,
    ECOP_VALOR                  BIGINT                 NOT NULL                ,
    ECOP_EXISTENCIAS            BIGINT                 NOT NULL  DEFAULT 0     ,
    ECOP_DIFERENCIA             BIGINT                 NOT NULL  DEFAULT 0     ,
PRIMARY KEY (ECOP_ECOP)
);