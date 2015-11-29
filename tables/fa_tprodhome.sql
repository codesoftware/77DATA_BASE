CREATE TABLE fa_tprodhome (
prodhome_prodhome     SERIAL NOT NULL,
prodhome_cate        INTEGER NOT NULL,
prodhome_refe        INTEGER NOT NULL,
prodhome_sede        INTEGER NOT NULL,
prodhome_rutai       VARCHAR(500),
prodhome_estado      VARCHAR(2) DEFAULT 'A',
prodhome_nombre      VARCHAR(500),
PRIMARY KEY(prodhome_prodhome)
);
