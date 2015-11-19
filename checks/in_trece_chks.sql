--
--Llave con la cual se garantizara que el estado de la receta solo sea activo o inactivo
--
ALTER TABLE IN_TRECE 
ADD CONSTRAINT RECE_ESTADO_CHK 
CHECK (RECE_ESTADO in ('A','I'))
;