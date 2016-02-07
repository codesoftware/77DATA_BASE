CREATE TABLE FA_TSOLI(
    SOLI_SOLI                   BIGSERIAL                               ,
    SOLI_FECH                   TIMESTAMP       NOT NULL DEFAULT NOW()  ,
    SOLI_TIUS                   BIGSERIAL       NOT NULL                ,
    SOLI_ESTADO                 VARCHAR(2)      NOT NULL DEFAULT 'C'    ,
PRIMARY KEY (SOLI_SOLI)
);