CREATE TABLE FA_TSOLI(
    SOLI_SOLI                   BIGSERIAL                               ,
    SOLI_FECH                   TIMESTAMP       NOT NULL DEFAULT NOW()  ,
    SOLI_TIUS                   BIGINT          NOT NULL                ,
    SOLI_ESTA                   VARCHAR(2)      NOT NULL DEFAULT 'C'    ,
    SOLI_COME                   VARCHAR(200),
    SOLI_SEDE                   BIGINT,
PRIMARY KEY (SOLI_SOLI)
);