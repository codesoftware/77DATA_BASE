--
--Alteraciones para todos los estados de las facturas en el sistema
--
ALTER TABLE FA_TFACT  DROP CONSTRAINT FACT_ESTADO_CHK;
--
ALTER TABLE FA_TFACT 
ADD CONSTRAINT FACT_ESTADO_CHK 
CHECK (FACT_ESTADO in ('P','C','U','S','A','R'))
;
