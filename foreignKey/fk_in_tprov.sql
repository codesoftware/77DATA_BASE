--
--llave foranea de la tabla de retefuente
--
ALTER TABLE in_tprov
ADD FOREIGN KEY (prov_retde)
REFERENCES co_tretde(retde_retde)
;