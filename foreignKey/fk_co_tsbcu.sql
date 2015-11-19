--
--Llave relacional entre la subcuenta y la cuenta
--
ALTER TABLE co_tsbcu
ADD FOREIGN KEY (sbcu_cuen)
REFERENCES co_tcuen(cuen_cuen)
;
--
--Llave relacional entre la subcuenta y el grugo
--
ALTER TABLE co_tsbcu
ADD FOREIGN KEY (sbcu_grup)
REFERENCES co_tgrup(grup_grup)
;
--
--Llave relacional entre la subcuenta y la clase
--
ALTER TABLE co_tsbcu
ADD FOREIGN KEY (sbcu_clas)
REFERENCES co_tclas(clas_clas)
;