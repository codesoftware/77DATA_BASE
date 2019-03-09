CREATE TABLE fa_tfcprd (
fcprd_fcprd					BIGSERIAL,
fcprd_facom					BIGSERIAL,
fcprd_dska					BIGSERIAL,
fcprd_cant					INT,
fcprd_subt					NUMERIC(1000,6),
fcprd_iva					NUMERIC(1000,6),
fcprd_piva					NUMERIC(1000,6),
fcprd_tota					NUMERIC(1000,6),
fcprd_cantinve				NUMERIC(1000,6),
fcprd_esta					VARCHAR(2) DEFAULT 'A',
fcprd_fech					TIMESTAMP DEFAULT NOW(),
fcprd_inve					VARCHAR(100),
PRIMARY KEY (fcprd_fcprd)
);