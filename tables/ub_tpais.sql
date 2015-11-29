--
--Tabla en la cual se almacenaran los paises que tendra parametirzada la aplicacion
--
CREATE TABLE ub_tpais ( 
    PAIS_PAIS                INTEGER         NOT NULL,
    PAIS_NOMBRE              varchar(150)    NOT NULL,
    PAIS_DESCRIPCION         varchar(150)    NOT NULL,
    PAIS_DEFAULT             varchar(200)    NOT NULL,
    PAIS_CODIGO              varchar(50)     NOT NULL,
    PRIMARY KEY (PAIS_PAIS)
);


