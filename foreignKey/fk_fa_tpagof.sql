--
--Llave con la cual relaciono la tabla de la factura de compra
--
ALTER TABLE fa_tpagof
ADD FOREIGN KEY (pagof_facom)
REFERENCES fa_tfacom(facom_facom)
;
--
--Llave con la cual relaciono los auxiliares contables
--
ALTER TABLE fa_tpagof
ADD FOREIGN KEY (pagof_auco)
;
--
--Llave con la cual relaciono el usuario
--
ALTER TABLE fa_tpagof
ADD FOREIGN KEY (pagof_tius)
REFERENCES us_ttius(tius_tius)
;
