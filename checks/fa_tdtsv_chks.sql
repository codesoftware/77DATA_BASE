ALTER TABLE fa_tdtsv 
ADD CONSTRAINT DTSV_CON_DESC_chk 
CHECK (DTSV_CON_DESC in ('S','N'))
;


ALTER TABLE fa_tdtsv 
ADD CONSTRAINT ddtsv_estado_chk 
CHECK (DTSV_ESTADO in ('A','C'))
;