CREATE TABLE AD_TCIER(
    CIER_CIER                   BIGSERIAL                               ,
    CIER_FECH                   TIMESTAMP       NOT NULL                ,
    CIER_USUA                   INT             NOT NULL                ,
    CIER_VLRI                   NUMERIC(1000,10)   NOT NULL             ,
    CIER_VLRT                   NUMERIC(1000,10)   NOT NULL             ,
    CIER_VLRC                   NUMERIC(1000,10)   NOT NULL             ,
    CIER_SEDE                   INT             NOT NULL                ,
    CIER_ESTADO                 VARCHAR(2)      NOT NULL                ,
PRIMARY KEY (CIER_CIER)
);