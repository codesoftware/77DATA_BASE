CREATE TABLE FA_TSOPD(
    SOPD_SOPD                   BIGSERIAL       NOT NULL                ,
    SOPD_DSKA                   BIGINT          NOT NULL                ,
    SOPD_SOLI                   BIGINT          NOT NULL                ,
	SOPD_CANT                   BIGINT          NOT NULL                ,
    sopd_cenv                   BIGINT                                  ,
    sopd_cbod                   BIGINT                                  ,
    sopd_sede                   BIGINT                                  ,
    sopd_kapr                   BIGINT                                  ,
    sopd_kapr_eg                BIGINT                                  ,
PRIMARY KEY (SOPD_SOPD)
);