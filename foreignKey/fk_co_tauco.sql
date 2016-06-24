--
--Llaave con la cual relaciono la tabla con la subcuenta
--
ALTER TABLE co_tauco
ADD FOREIGN KEY (auco_sbcu)
REFERENCES co_tsbcu(sbcu_sbcu)
;
