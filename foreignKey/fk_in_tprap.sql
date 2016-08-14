--
--Llave con la tabla de aportes
--
ALTER TABLE IN_TPRAP
ADD FOREIGN KEY (PRAP_APOR)
REFERENCES em_tapor(apor_apor)
;
--
--Llave con la tabla de productos
--
ALTER TABLE IN_TPRAP
ADD FOREIGN KEY (prap_dska)
REFERENCES in_tdska(dska_dska)
;