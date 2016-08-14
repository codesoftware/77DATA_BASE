--
--TABLA DE SOCIOS
--
CREATE TABLE AD_TSOCI(
    SOCI_SOCI           BIGSERIAL                           ,
    SOCI_RAZO           VARCHAR(1000)       NOT NULL        ,
    SOCI_NIT            VARCHAR(100)        NOT NULL        ,
    SOCI_DIVE           VARCHAR(2)          NOT NULL        ,
    SOCI_REPR           VARCHAR(1000)       NOT NULL        ,
    SOCI_DIRE           VARCHAR(1000)       NOT NULL        ,
    SOCI_MPIO           BIGINT                              ,
    SOCI_CIUD           BIGINT                              ,
    SOCI_ESTA           VARCHAR(2)          NOT NULL        ,
    SOCI_USUA           BIGINT              NOT NULL        ,
    SOCI_FCRE           TIMESTAMP           NOT NULL        ,
PRIMARY KEY(SOCI_SOCI)
);