ALTER TABLE fa_tfpago
ADD FOREIGN KEY (fpago_tsbcu)
REFERENCES co_tsbcu(sbcu_sbcu)
;
ALTER TABLE fa_tfpago
ADD FOREIGN KEY (fpago_facom)
REFERENCES fa_tfacom(facom_facom)
;