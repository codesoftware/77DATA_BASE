ALTER TABLE em_tsede 
ADD CONSTRAINT sede_estado_chk 
CHECK (sede_estado in ('A','I'));