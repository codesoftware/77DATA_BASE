CREATE TABLE fa_timfac (
imfac_imfac             BIGSERIAL,
imfac_fecha             TIMESTAMP NOT NULL DEFAULT NOW(),
imfac_facom             BIGSERIAL NOT NULL,
imfac_nombr				VARCHAR(200) NOT NULL,
imfac_rutai				VARCHAR(200) NOT NULL,
imfac_estad				VARCHAR(200) NOT NULL,
 PRIMARY KEY(imfac_imfac)
);