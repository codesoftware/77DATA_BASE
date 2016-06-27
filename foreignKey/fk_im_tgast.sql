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