ALTER TABLE CO_TTIDO 
ADD CONSTRAINT CO_TIDO_ESTADO_CHK 
CHECK (TIDO_ESTADO in ('A','I'));