--
--Tabla de departamentos
--
CREATE TABLE ub_tdepa( 
    DEPA_DEPA                INTEGER         NOT NULL,
    DEPA_PAIS                INTEGER         NOT NULL,
    DEPA_NOMBRE              varchar(150)    NOT NULL,
    DEPA_DESCRIPCION         varchar(150)    NOT NULL,
    DEPA_DEFAULT             varchar(200)    NOT NULL,
    DEPA_CODIGO              varchar(50)     NOT NULL,
    PRIMARY KEY (DEPA_DEPA)
);