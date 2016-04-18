--
--Referencia con la tabla de productos
--
ALTER TABLE in_tdrem
ADD FOREIGN KEY (drem_dska)
REFERENCES in_tdska(dska_dska)
;
--
--Referencia con la tabla de kardex
--
ALTER TABLE in_tdrem
ADD FOREIGN KEY (drem_kapr)
REFERENCES in_tkapr(kapr_kapr)
;