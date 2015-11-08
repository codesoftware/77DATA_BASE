--
--LLave foranea entre la ejecucion de conteo de productos y la tabla de conteo de productos
--
ALTER TABLE in_tecop
ADD FOREIGN KEY (ecop_copr)
REFERENCES in_tcopr(copr_copr)
;