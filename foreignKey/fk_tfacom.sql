ALTER TABLE fa_tfacom
ADD FOREIGN KEY (facom_tprov)
REFERENCES in_tprov(prov_prov)
;

ALTER TABLE fa_tfacom
ADD FOREIGN KEY (facom_tius)
REFERENCES us_ttius(tius_tius)
;