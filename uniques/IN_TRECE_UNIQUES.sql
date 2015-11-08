--
--Llave con la cual se garantizara el unico codigo de la receta dentro del sistema.
--
ALTER TABLE IN_TRECE
ADD CONSTRAINT RECE_CODIGO_UNIQUE 
UNIQUE (RECE_CODIGO)
;

--
--Llave con la cual se garantizara el unico codigo de la receta dentro del sistema.
--
ALTER TABLE IN_TRECE
ADD CONSTRAINT RECE_NOMBRE_UNIQUE 
UNIQUE (RECE_NOMBRE)
;