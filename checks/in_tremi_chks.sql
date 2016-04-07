--
--constraint para la tabla remisiones el cual garantizara un estado valido
--
ALTER TABLE in_tremi
ADD CONSTRAINT REMI_ESTADO_CHK 
CHECK (REMI_ESTADO in ('RE','FA'))
;
--
--constraint para la tabla remisiones el cual garantizara un estado vencido valido
--
ALTER TABLE in_tremi
ADD CONSTRAINT remi_venci_CHK 
CHECK (remi_venci in ('S','N'))
;