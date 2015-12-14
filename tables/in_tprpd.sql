CREATE TABLE IN_TPRPD(
    PRPD_PRPD                   BIGSERIAL                                   ,
    PRPD_DSKA                   INT                 NOT NULL                ,
    PRPD_SEDE                   INT                 NOT NULL                ,
    PRPD_PREU                   NUMERIC(1000,10)    NOT NULL                ,
    PRPD_PREC                   NUMERIC(1000,10)    NOT NULL                ,
    PRPD_PREM                   NUMERIC(1000,10)    NOT NULL                ,
    PRPD_ESTADO                 VARCHAR(2)          NOT NULL                ,
PRIMARY KEY (PRPD_PRPD)
);