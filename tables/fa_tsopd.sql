CREATE TABLE FA_TSOPD(
    SOPD_SOPD                   BIGSERIAL       NOT NULL                ,
    SOPD_DSKA                   BIGINT          NOT NULL                ,
    SOPD_SOLI                   BIGINT          NOT NULL                ,
	SOPD_CANT                   BIGINT          NOT NULL                ,
PRIMARY KEY (SOPD_SOPD)
);