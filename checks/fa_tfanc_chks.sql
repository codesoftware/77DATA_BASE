ALTER TABLE FA_TFANC 
ADD CONSTRAINT FANC_ESTADO_CHK 
CHECK (FANC_ESTA in ('P','C','U','S','A','R'))
;
