--
--Referencia con el auxiliar contable que va ha afectar
--
ALTER TABLE im_tdgas
ADD FOREIGN KEY (dgas_auco)
REFERENCES co_tauco(auco_auco)
;
--
--Llave que referencia el gasto con sus detalles
--
ALTER TABLE im_tdgas
ADD FOREIGN KEY (dgas_gast)
REFERENCES im_tgast(gast_gast)
;