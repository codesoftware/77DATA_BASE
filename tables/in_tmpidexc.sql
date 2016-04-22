--
--Tabla temporal
--
CREATE TABLE in_tmpidexc(
    tmpidexc_tmpidexc       BIGSERIAL,
    tmpidexc_codexte        VARCHAR(500)        NOT NULL,
    tmpidexc_ubicaci        VARCHAR(500)        NOT NULL,
    tmpidexc_descrip        VARCHAR(2000)       NOT NULL,
    tmpidexc_categor        NUMERIC(1000,10)    NOT NULL,
    tmpidexc_subcate        NUMERIC(1000,10)    NOT NULL,
    tmpidexc_tipo           NUMERIC(1000,10)    NOT NULL,
    tmpidexc_existencia     NUMERIC(1000,10)    NOT NULL,
    tmpidexc_costo          NUMERIC(1000,10)            ,
    tmpidexc_fecha          TIMESTAMP                   ,
    tmpidexc_usu            BIGINT                      ,
    tmpidexc_dska           BIGINT                      ,
    tmpidexc_codbarr        varchar(50)                 ,
PRIMARY KEY(tmpidexc_tmpidexc)               
);
