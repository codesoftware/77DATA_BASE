--
--Evita que el codigo se repita dentro de la aplicacion
--
ALTER TABLE IN_TDSKA
ADD CONSTRAINT DSKA_COD_UNIQUE UNIQUE (DSKA_COD)
;
--
-- Evita que cualquier producto sea repetido en el sistema
--
ALTER TABLE IN_TDSKA
ADD CONSTRAINT DSKA_REPITE_PROD_UNIQUE 
UNIQUE (DSKA_MARCA, DSKA_REFE, DSKA_CATE)
;