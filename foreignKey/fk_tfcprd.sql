ALTER TABLE fa_tfcprd
ADD FOREIGN KEY (fcprd_dska)
REFERENCES in_tdska(dska_dska)
;
ALTER TABLE fa_tfcprd
ADD FOREIGN KEY (fcprd_facom)
REFERENCES fa_tfacom(facom_facom)
;