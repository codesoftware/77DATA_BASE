--
--Referencia con la tabla sub cuenta
--
ALTER TABLE in_tdrem
ADD FOREIGN KEY (drem_dska)
REFERENCES in_tdska(dska_dska)
;