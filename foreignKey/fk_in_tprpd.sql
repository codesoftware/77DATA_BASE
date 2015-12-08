--
--Llave con la tabla de los productos
--
ALTER TABLE IN_TPRPD
ADD FOREIGN KEY (prpd_prpd)
REFERENCES in_tdska(dska_dska)
;
--
--Llave foranea con la tabla de sedes
--
ALTER TABLE IN_TPRPD
ADD FOREIGN KEY (prpd_sede)
REFERENCES em_tsede(sede_sede)
;