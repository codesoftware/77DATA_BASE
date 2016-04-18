--
--constraint para la tabla detalle de remisiones el cual garantizara un estado valido
--
ALTER TABLE IN_TDREM
ADD CONSTRAINT DREM_ESTADO_CHK 
CHECK (DREM_ESTADO in ('A','I'))
;