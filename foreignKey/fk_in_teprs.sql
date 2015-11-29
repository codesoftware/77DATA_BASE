--
--Llave con la cual se referencia el producto
--
ALTER TABLE in_teprs
ADD FOREIGN KEY (eprs_dska)
REFERENCES in_tdska(dska_dska)
;