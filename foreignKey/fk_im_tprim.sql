ALTER TABLE im_tprim
ADD FOREIGN KEY (prim_impo)
REFERENCES im_timpo(impo_impo)
;
--
--Llave con la tabla de productos
--
ALTER TABLE im_tprim
ADD FOREIGN KEY (prim_dska)
REFERENCES in_tdska(dska_dska)
;