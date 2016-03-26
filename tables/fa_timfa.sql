CREATE TABLE fa_timfa(
	imfa_infa		BIGSERIAL 		NOT NULL,
	imfa_fact		BIGINT			NOT NULL,
	imfa_tipo		VARCHAR(2) 		NOT NULL,
	imfa_ruta		VARCHAR(2000) 	NOT NULL,
	imfa_esta		VARCHAR(2)		NOT NULL,
	PRIMARY KEY (imfa_infa)
);