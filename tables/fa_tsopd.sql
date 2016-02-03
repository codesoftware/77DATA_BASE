CREATE TABLE FA_TSOPD(
    SOPD_SOPD                   BIGSERIAL       NOT NULL                ,
    SOPD_DSKA                   BIGSERIAL       NOT NULL                ,
    SOPD_SOLI                   BIGSERIAL       NOT NULL                ,
	SOPD_CANT                   INT             NOT NULL                ,
PRIMARY KEY (SOPD_SOPD)
);