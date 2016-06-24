ALTER TABLE fa_tfcprd_tmp
ADD FOREIGN KEY (fcprd_tmp_dska)
REFERENCES in_tdska(dska_dska)
;
ALTER TABLE fa_tfcprd_tmp
ADD FOREIGN KEY (fcprd_tmp_facom)
REFERENCES fa_tfacom_tmp(facom_tmp_facom)
;