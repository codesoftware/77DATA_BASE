--
--Llave con la tabla de productos
--
ALTER TABLE IN_TPROPAR
ADD FOREIGN KEY (PROPAR_DSKA)
REFERENCES in_tdska(dska_dska)
;

--
--Llave con la tabla de productos
--
ALTER TABLE IN_TPROPAR
ADD FOREIGN KEY (PROPAR_AUCO)
REFERENCES co_tauco(auco_auco)
;
--
--Llave con la tabla de usuarios
--
ALTER TABLE IN_TPROPAR
ADD FOREIGN KEY (PROPAR_TIUS)
REFERENCES us_ttius(tius_tius)
;