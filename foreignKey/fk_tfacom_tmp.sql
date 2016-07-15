ALTER TABLE fa_tfacom_tmp
ADD FOREIGN KEY (facom_tmp_tprov)
REFERENCES in_tprov(prov_prov)
;

ALTER TABLE fa_tfacom_tmp
ADD FOREIGN KEY (facom_tmp_tius)
REFERENCES us_ttius(tius_tius)
;

ALTER TABLE fa_tfacom_tmp
ADD FOREIGN KEY (facom_tmp_sede)
REFERENCES em_tsede(sede_sede)
;