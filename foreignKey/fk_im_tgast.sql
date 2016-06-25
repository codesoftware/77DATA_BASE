--
--Referencia con la tabla sub cuenta
--
ALTER TABLE im_tgast
ADD FOREIGN KEY (gast_tius)
REFERENCES us_ttius(tius_tius)
;
--
--Referencia con la tabla tipo documento
--
ALTER TABLE im_tgast
ADD FOREIGN KEY (gast_impo)
REFERENCES im_timpo(impo_impo)
;
--
--Referencia con el auxiliar contable que va ha afectar
--
ALTER TABLE im_tgast
ADD FOREIGN KEY (gast_auco)
REFERENCES co_tauco(auco_auco)
;
