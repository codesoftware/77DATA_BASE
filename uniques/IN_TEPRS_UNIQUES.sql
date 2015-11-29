--
--Llave unica con la cual garantizo que no se repita un producto por sede
--
ALTER TABLE in_teprs
ADD CONSTRAINT eprs_sedeprod_unique 
UNIQUE (eprs_dska,eprs_sede)
;