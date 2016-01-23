CREATE TABLE co_tretde(
retde_retde   			BIGSERIAL NOT NULL,
retde_veret             BIGSERIAL NOT NULL,
retde_codig				VARCHAR(20),
retde_conce				VARCHAR(2000) NOT NULL,
retde_bauvt				NUMERIC(1000,6),
retde_bpeso				NUMERIC(1000,6),
retde_tarif				NUMERIC(1000,6),
retde_estad				VARCHAR(2),
retde_fecha             TIMESTAMP DEFAULT NOW(),
PRIMARY KEY (retde_retde)
);