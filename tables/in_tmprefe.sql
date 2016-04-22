CREATE TABLE in_tmprefe(
    tmprefe_tmprefe        BIGSERIAL,
    tmprefe_codexte        VARCHAR(500)      NOT NULL,
    tmprefe_ubicaci        VARCHAR(500)      NOT NULL,
    tmprefe_descrip        VARCHAR(2000)     NOT NULL,
    tmprefe_categor        VARCHAR(500)              ,
    tmprefe_subcate        VARCHAR(500)              ,
    tmprefe_tipo           VARCHAR(100)      NOT NULL,
    tmprefe_existencia     INT NOT NULL              ,
    tmprefe_costo          NUMERIC(1000,5)           ,
    tmprefe_fecha          TIMESTAMP                 ,
    tmprefe_usu            BIGINT                    ,
    tmprefe_codbarr        varchar(1000)             ,
PRIMARY KEY(tmprefe_tmprefe)               
);
