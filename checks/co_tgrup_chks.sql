ALTER TABLE CO_TGRUP
ADD CONSTRAINT CO_ESTADO_CHK 
CHECK (GRUP_ESTADO in ('A','I'));

ALTER TABLE CO_TGRUP 
ADD CONSTRAINT CO_NATURALEZA_CHK 
CHECK (GRUP_NATURALEZA in ('D','C'));