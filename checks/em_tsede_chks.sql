ALTER TABLE em_tsede 
ADD CONSTRAINT sede_estado_chk 
CHECK (sede_estado in ('A','I'));

ALTER TABLE em_tsede 
ADD CONSTRAINT sede_bodega_chk 
CHECK (sede_bodega in ('S','N'));