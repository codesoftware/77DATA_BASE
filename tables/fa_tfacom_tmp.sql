CREATE TABLE fa_tfacom_tmp (
facom_tmp_facom                 BIGSERIAL NOT NULL,
facom_tmp_fecha                 TIMESTAMP ,
facom_tmp_ferec                 TIMESTAMP ,
facom_tmp_nufac                 VARCHAR(200) ,
facom_tmp_valor                 NUMERIC(1000,6),
facom_tmp_vliva                 NUMERIC(1000,6),
facom_tmp_vlret                 NUMERIC(1000,6),
facom_tmp_rtimg                 VARCHAR(1000),
facom_tmp_tprov                 BIGINT,
facom_tmp_estad                 VARCHAR(2),
facom_tmp_tius                  BIGINT,
facom_tmp_sede                  BIGINT,
facom_tmp_fecre                 TIMESTAMP,
facom_tmp_ajus                  VARCHAR(1000),
facom_tmp_plaz					BIGINT,
facom_tmp_porc					NUMERIC(1000,6),

 PRIMARY KEY(facom_tmp_facom)
);

