CREATE TABLE IN_TAJIC(
    AJIC_AJIC                   BIGSERIAL                                   ,
    AJIC_COPR                   BIGINT              NOT NULL                ,
    AJIC_FECH                   TIMESTAMP           NOT NULL                ,
    AJIC_USUA                   BIGINT              NOT NULL                ,
    AJIC_DSKA                   BIGINT              NOT NULL                ,
    AJIC_PREX                   NUMERIC(1000,10)    NOT NULL                ,
    AJIC_PRAJ                   NUMERIC(1000,10)    NOT NULL                ,
    AJIC_SEDE                   INT                 NOT NULL                ,
    AJIC_ESTA                   varchar(2)          NOT NULL                ,
PRIMARY KEY (AJIC_AJIC)
);