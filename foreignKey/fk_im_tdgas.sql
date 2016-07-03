--
--Referencia con el auxiliar contable que va ha afectar
--
ALTER TABLE im_tdgas
ADD FOREIGN KEY (dgas_auco)
REFERENCES co_tauco(auco_auco)
;
--
--Referencia con la tabla proveedores
--
ALTER TABLE im_tdgas
ADD FOREIGN KEY (dgas_prov)
REFERENCES IN_TPROV(prov_prov)
;