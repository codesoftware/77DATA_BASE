CREATE TABLE fa_tfacom (
facom_facom             BIGSERIAL,
facom_fecha             TIMESTAMP NOT NULL,
facom_ferec             TIMESTAMP NOT NULL,
facom_nufac				VARCHAR(200) NOT NULL,
facom_valor				NUMERIC(1000,6) NOT NULL,
facom_vliva				NUMERIC(1000,6) NOT NULL,
facom_vlret				NUMERIC(1000,6) NOT NULL,
facom_rtimg				VARCHAR(1000) NOT NULL,
facom_tprov             BIGSERIAL,
facom_estad             VARCHAR(2),
facom_tius				BIGSERIAL,
facom_sede				BIGSERIAL,
facom_fecre				TIMESTAMP NOT NULL,
 PRIMARY KEY(facom_facom)
);