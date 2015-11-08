--
--Llave con la cual se controlara los estaods de cada inventario
--
ALTER TABLE IN_TCOPR 
ADD CONSTRAINT COPR_ESTADO_CHK 
CHECK (COPR_ESTADO in ('C','A','X'))
;