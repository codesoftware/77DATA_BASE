--
--Evita que el codigo se repita dentro de la aplicacion
--
ALTER TABLE IN_TCEPR
ADD CONSTRAINT CEPR_DSKA_UNIQUE UNIQUE (cepr_dska)
;
