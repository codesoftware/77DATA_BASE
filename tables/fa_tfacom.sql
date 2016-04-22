CREATE TABLE fa_tfacom (
facom_facom                 BIGSERIAL,
facom_fecha                 TIMESTAMP NOT NULL,
facom_ferec                 TIMESTAMP NOT NULL,
facom_nufac                 VARCHAR(200) NOT NULL,
facom_valor                 NUMERIC(1000,6) NOT NULL,
facom_vliva                 NUMERIC(1000,6) NOT NULL,
facom_vlret                 NUMERIC(1000,6) NOT NULL,
facom_rtimg                 VARCHAR(1000) NOT NULL,
facom_tprov                 BIGINT,
facom_estad                 VARCHAR(2),
facom_tius                  BIGINT,
facom_sede                  BIGINT,
facom_fecre                 TIMESTAMP NOT NULL,
facom_ajus                  NUMERIC(1000,10) NOT NULL DEFAULT 0,
 PRIMARY KEY(facom_facom)
);