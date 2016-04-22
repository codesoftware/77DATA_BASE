CREATE TABLE fa_tfanc(
    fanc_fanc                       BIGSERIAL NOT NULL      ,
    fanc_fact                       BIGINT NOT NULL         ,
    fanc_pers_s                     BIGINT                  ,
    fanc_fech_s                     TIMESTAMP               ,
    fanc_come_s                     VARCHAR(2000)           ,
    fanc_pers_a                     BIGINT                  ,
    fanc_fech_a                     TIMESTAMP               ,
    fanc_come_a                     VARCHAR(2000)           ,
    fanc_pers_r                     BIGINT                  ,
    fanc_fech_r                     TIMESTAMP               ,
    fanc_come_r                     VARCHAR(2000)           ,
    fanc_pers_c                     BIGINT                  ,
    fanc_fech_c                     TIMESTAMP               ,
    fanc_ruta_c                     VARCHAR(2000)           ,
    fanc_esta                       VARCHAR(2)              ,
    fanc_id                         int                     ,
PRIMARY KEY(fanc_fanc)
);