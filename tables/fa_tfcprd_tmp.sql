CREATE TABLE fa_tfcprd_tmp (
fcprd_tmp_fcprd					BIGSERIAL,
fcprd_tmp_facom					BIGINT,
fcprd_tmp_dska					BIGINT,
fcprd_tmp_cant					INT,
fcprd_tmp_subt					NUMERIC(1000,6),
fcprd_tmp_iva					NUMERIC(1000,6),
fcprd_tmp_inve					VARCHAR(100),
fcprd_tmp_piva					NUMERIC(1000,6),
fcprd_tmp_tota					NUMERIC(1000,6),
fcprd_tmp_cantinve				NUMERIC(1000,6),
fcprd_tmp_esta					VARCHAR(2) DEFAULT 'A',
fcprd_tmp_fech					TIMESTAMP DEFAULT NOW(),
PRIMARY KEY (fcprd_tmp_fcprd)
);