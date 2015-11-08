--
--Llave foranea con la tabla de sedes
--
ALTER TABLE IN_TCOPR
ADD FOREIGN KEY (copr_sede)
REFERENCES em_tsede(sede_sede)
;