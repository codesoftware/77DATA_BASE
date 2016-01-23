CREATE TABLE co_tveret(
veret_veret   			BIGSERIAL,
veret_nombr				VARCHAR(500),
veret_comen				VARCHAR(2000),
veret_finic				TIMESTAMP,
veret_ffina				TIMESTAMP,
veret_estad				VARCHAR(2),
veret_fecha             TIMESTAMP DEFAULT NOW(),
PRIMARY KEY (veret_veret)
);