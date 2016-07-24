--
--Referencia con la tabla sub cuenta
--
ALTER TABLE co_tmvco
ADD FOREIGN KEY (mvco_sbcu)
REFERENCES co_tsbcu(sbcu_sbcu)
;
--
--Referencia con la tabla tipo documento
--
ALTER TABLE co_tmvco
ADD FOREIGN KEY (mvco_tido)
REFERENCES co_ttido(tido_tido)
;
--
--Referencia con la tabla auxiliar contable
--
--ALTER TABLE co_tmvco
--ADD FOREIGN KEY (mvco_auco)
--REFERENCES co_tauco(auco_auco)
--;