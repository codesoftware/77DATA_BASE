--
--Llave con la cual se garantiza que ningun producto o 
--receta se va ha repetir en la pagina principal de facturacion
--
ALTER TABLE IN_TPPFA
ADD CONSTRAINT PPFA_PROD_UNIQUE 
UNIQUE (PPFA_CODIGO,PPFA_TIPO)
;
--
--Garantiza que no haya un producto del mismo tipo en la misma posicion
--
ALTER TABLE IN_TPPFA
ADD CONSTRAINT PPFA_PROD_POS_UNIQUE 
UNIQUE (PPFA_TIPO,PPFA_POSICION)
;