--
--Llave con la cual se referencia el producto
--
ALTER TABLE in_tcepr
ADD FOREIGN KEY (cepr_dska)
REFERENCES in_tdska(dska_dska)
;