CREATE TABLE in_tmpidexc(
tmpidexc_tmpidexc        SERIAL,
tmpidexc_codexte        VARCHAR(500)  NOT NULL,
tmpidexc_ubicaci        VARCHAR(500)  NOT NULL,
tmpidexc_descrip        VARCHAR(2000) NOT NULL,
tmpidexc_categor        NUMERIC(15)   NOT NULL,
tmpidexc_subcate        NUMERIC(15)   NOT NULL,
tmpidexc_tipo           NUMERIC(15)   NOT NULL,
tmpidexc_existencia     NUMERIC(15)   NOT NULL,
tmpidexc_costo          NUMERIC(15,5),
tmpidexc_fecha          TIMESTAMP,
tmpidexc_usu            INT,
PRIMARY KEY(tmpidexc_tmpidexc)               
);
