--
--Tabla en la cual se almacenaran las ciudades que se encuentran en la aplicacion parametrizadas
--
CREATE TABLE ub_tciud( 
    CIUD_CIUD                INTEGER         NOT NULL,
    CIUD_DEPA                INTEGER         NOT NULL,
    CIUD_NOMBRE              varchar(150)    NOT NULL,
    CIUD_DESCRIPCION         varchar(150)    NOT NULL,
    CIUD_DEFAULT             varchar(200)    NOT NULL,
    CIUD_CODIGO              varchar(50)     NOT NULL,
    PRIMARY KEY (CIUD_CIUD)
);
